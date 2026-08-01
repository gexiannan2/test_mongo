# MongoStandalone

与 `DBServer` 业务隔离的 MongoDB C++ 访问与本地 CRUD 验证工程。
MongoDB C Driver 与 C++ Driver 均以仓库内源码直接编译为静态目标；不使用 vcpkg、
不依赖预编译 MongoDB DLL/SO。

当前内网版本固定关闭 MongoDB 驱动 TLS、SASL、SRV、测试、示例与文档目标，不引入
OpenSSL。MongoDB 驱动源码只在构建阶段生成内部静态目标，最终游戏服不需要分发
MongoDB 的 DLL 或 SO。

依赖版本：

- mongo-cxx-driver r4.4.1
- mongo-c-driver 2.3.3
- C++20

第三方目录只保留可复现构建所需的固定源码快照：

```text
third_party/
└── src/
    ├── mongo-c-driver/      2.3.3
    └── mongo-cxx-driver/    r4.4.1
```

版本来源与提交信息见 `third_party/README.md`。仓库不保存驱动的预编译安装树或
驱动仓库自身的 Git 元数据。

## 构建

```powershell
cmake --preset windows-vs2026-x64
cmake --build --preset windows-vs2026-x64-release
ctest --preset windows-vs2026-x64-release
```

若 Visual Studio 2026 Insiders 未被系统自动识别，直接执行
`scripts\generate_vs2026_solution.cmd` 生成解决方案。

配置完成后，`build/vs2026-x64-d/` 会生成 `MongoStandalone.slnx`。这是 CMake
4.2 的 Visual Studio 2026 生成器使用的新解决方案格式，可直接在 Visual Studio
2026 中打开，并以 `Release|x64` 构建。

Linux x64 直接使用仓库内的驱动源码构建静态目标：

```bash
sudo apt-get update
sudo apt-get install -y build-essential cmake
cmake --preset linux-gcc-x64
cmake --build --preset linux-gcc-x64-release
ctest --preset linux-gcc-x64-release
```

`ctest` 是 MongoDB 集成测试，执行前需确保 `127.0.0.1:27017` 上已有可连接的
MongoDB 服务。仅验证离线编译时执行前两条命令即可。

默认连接：

```text
mongodb://127.0.0.1:27017/?directConnection=true
```

可通过环境变量覆盖：

```powershell
$env:MONGO_URI = "mongodb://127.0.0.1:27017/?directConnection=true"
$env:MONGO_DATABASE = "dbserver_mongo_test"
$env:MONGO_MAX_POOL_SIZE = "32"
$env:MONGO_MIN_POOL_SIZE = "4"
$env:MONGO_MAX_IN_FLIGHT = "64"
$env:MONGO_WAIT_QUEUE_TIMEOUT_MS = "200"
```

手工验证：

```powershell
.\build\vs2026-x64-d\Release\mongo_demo.exe ping
.\build\vs2026-x64-d\Release\mongo_demo.exe write-read
```

## 玩家读写性能测试

`mongo_player_benchmark` 使用隔离集合 `player_benchmark`，按给定的玩家文档
结构准备样本数据，并分别测试更新写和按 `_id` 查询读。不会清理其他集合。

默认命令会依次测试 1,000、10,000、100,000 QPS，每档读写各持续 10 秒。基准程序
与业务代码共用 `MongoClient` 连接池实现，而非单独的压测连接方式：

```powershell
.\scripts\build_player_benchmark_vs2026.cmd
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe
```

建议先使用较短时长完成环境检查，再执行完整压测：

```powershell
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe --qps 1000 --duration 3
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe --mode write --qps 100000 --duration 10 --workers 16
```

异步投递模式会让业务模拟线程把闭包投递到固定的 MongoDB 工作线程：

```powershell
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --dispatch async --mode all --qps 10000 --duration 10 `
  --workers 4 --mongo-workers 12 --queue-per-worker 4096 --players 100000
```

同步/异步的分档命令、CSV 字段、验收标准、数据影响和服务端指标采集见
[PERFORMANCE_TESTING.md](docs/PERFORMANCE_TESTING.md)。

输出中的“实际 QPS”低于目标值，说明当前客户端、网络或 MongoDB 无法在限定时间
完成请求；P95/P99 延迟突增可用于定位排队、磁盘写入确认或服务端负载导致的长尾。
性能数据必须使用 `Release|x64`，不要使用 Debug 配置。

## 生产化配置与长压测

`MongoClient` 是线程安全的连接池门面。每个请求独占一个池中客户端，连接池等待
由 `MONGO_WAIT_QUEUE_TIMEOUT_MS` 限制，应用层并发由 `MONGO_MAX_IN_FLIGHT` 背压
限制；可通过 `MongoClient::Metrics()` 获取提交、完成、失败、拒绝和活动请求计数。

生产环境必须使用三节点副本集、认证、`majority + journal` 写关注。TLS 由网络边界决定：
当前受信任内网保持关闭；跨网段、跨机房或有合规要求时才重新以 TLS 构建驱动并设置
`MONGO_TLS=true`、`MONGO_REQUIRE_TLS=true`。完整部署模板、环境变量和 10～30 分钟压测命令
见 [PRODUCTION.md](docs/PRODUCTION.md)。

## 玩家异步投递

`AsyncMongoDispatcher` 提供默认 12 个 MongoDB 工作线程、按 `playerId` 固定路由、
有界队列与背压拒绝。业务线程投递不可变玩家快照后即可继续执行；MongoDB 工作线程
再同步落库。使用方式与可靠性边界见 [ASYNC_MONGO_DISPATCHER.md](docs/ASYNC_MONGO_DISPATCHER.md)。

内网游戏服直接编译本模块源码、使用 `PlayerMongoStorage` 异步落地玩家快照的最小接入方式见
[SVC_GAME3D_INTEGRATION.md](docs/SVC_GAME3D_INTEGRATION.md)。
