# MongoStandalone

与 `DBServer` 业务隔离的 MongoDB C++ 访问与本地 CRUD 验证工程。

依赖版本：

- mongo-cxx-driver r4.4.1
- mongo-c-driver 2.3.3
- C++17

## 构建

```powershell
cmd /c '"C:\Program Files\Microsoft Visual Studio\18\Insiders\VC\Auxiliary\Build\vcvars64.bat" && powershell -ExecutionPolicy Bypass -File scripts\bootstrap_mongodb.ps1'
cmake --preset windows-vs2026-x64
cmake --build --preset windows-vs2026-x64-release
ctest --preset windows-vs2026-x64-release
```

若 Visual Studio 2026 Insiders 未被系统自动识别，直接执行
`scripts\generate_vs2026_solution.cmd` 生成解决方案。

配置完成后，`build/vs2026-x64-d/` 会生成 `MongoStandalone.slnx`。这是 CMake
4.2 的 Visual Studio 2026 生成器使用的新解决方案格式，可直接在 Visual Studio
2026 中打开，并以 `Release|x64` 构建。

默认连接：

```text
mongodb://127.0.0.1:27017/?directConnection=true
```

可通过环境变量覆盖：

```powershell
$env:MONGO_TEST_URI = "mongodb://127.0.0.1:27017/?directConnection=true"
$env:MONGO_TEST_DATABASE = "dbserver_mongo_test"
$env:MONGO_TEST_TIMEOUT_MS = "3000"
```

手工验证：

```powershell
.\build\vs2026-x64-d\Release\mongo_demo.exe ping
.\build\vs2026-x64-d\Release\mongo_demo.exe write-read
```

## 玩家读写性能测试

`mongo_player_benchmark` 使用隔离集合 `player_benchmark`，按给定的玩家文档
结构准备样本数据，并分别测试更新写和按 `_id` 查询读。不会清理其他集合。

默认命令会依次测试 1,000、10,000、100,000 QPS，每档读写各持续 10 秒：

```powershell
.\scripts\build_player_benchmark_vs2026.cmd
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe
```

建议先使用较短时长完成环境检查，再执行完整压测：

```powershell
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe --qps 1000 --duration 3
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe --mode write --qps 100000 --duration 10 --workers 16
```

输出中的“实际 QPS”低于目标值，说明当前客户端、网络或 MongoDB 无法在限定时间
完成请求；P95/P99 延迟突增可用于定位排队、磁盘写入确认或服务端负载导致的长尾。
性能数据必须使用 `Release|x64`，不要使用 Debug 配置。
