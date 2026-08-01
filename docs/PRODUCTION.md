# MongoDB 生产化基线

本工程的 `MongoClient` 已使用 C++20 的 `mongocxx::pool`。每次同步 CRUD
请求从池中独占一个客户端；业务代码可安全地在多个线程中共享同一个
`MongoClient` 实例。应用侧使用 `MONGO_MAX_IN_FLIGHT` 做背压，超过上限且在
`MONGO_WAIT_QUEUE_TIMEOUT_MS` 内无法获取配额时会快速返回 `MongoError`。

这只是客户端基础能力。只有完成下列部署和压测验收后，才能称为生产可用。

## 1. 副本集、认证与网络边界

使用三个独立故障域的 MongoDB 节点；每个节点启用认证、内部 keyfile 和
WiredTiger journal。配置模板见 `deploy/replica-set/mongod-node.conf.template`，
副本集初始化脚本见 `deploy/replica-set/init-replica-set.js`。

不要提交密码、keyfile 或证书。由部署系统把它们以受限文件或密钥管理服务注入。
业务账号应仅拥有所需数据库和集合的最小权限。

当前版本面向受信任、隔离的内网，驱动以 `ENABLE_SSL=OFF` 编译，默认不启用 TLS，
也不引入 OpenSSL。若连接会跨越不可信网络、跨机房公网链路，或合规明确要求传输加密，
必须重新以 TLS 支持构建驱动，并在部署中设置 `MONGO_TLS=true` 与
`MONGO_REQUIRE_TLS=true`。

生产程序必须显式设置以下环境变量。URI 中的三个主机必须是可用的副本集节点，
不要带 `directConnection=true`。

```powershell
$env:MONGO_ENV = "production"
$env:MONGO_URI = "mongodb://APP_USER:URL_ENCODED_PASSWORD@mongo-01.internal.example:27017,mongo-02.internal.example:27017,mongo-03.internal.example:27017/?replicaSet=rs0&authSource=admin"
$env:MONGO_DATABASE = "game"
$env:MONGO_TLS = "false"
$env:MONGO_REQUIRE_TLS = "false"
$env:MONGO_WRITE_CONCERN = "majority"
$env:MONGO_JOURNAL = "true"
$env:MONGO_RETRY_WRITES = "true"
$env:MONGO_MAX_POOL_SIZE = "64"
$env:MONGO_MIN_POOL_SIZE = "8"
$env:MONGO_MAX_IN_FLIGHT = "128"
$env:MONGO_WAIT_QUEUE_TIMEOUT_MS = "200"
$env:MONGO_WRITE_CONCERN_TIMEOUT_MS = "5000"
```

`MONGO_ENV=production` 会拒绝单节点直连、无认证 URI、非 majority 写关注和未启用
journal 的配置。`MONGO_REQUIRE_TLS=true` 会额外拒绝未启用 TLS 的配置，避免将跨网络
部署的安全参数误带到线上。

## 2. 压测验收

使用 `Release|x64`，至少 100,000 名玩家，先预热再连续运行 10 到 30 分钟。
`--report` 会输出可导入 Excel 或监控系统的 CSV，其中包含实际 QPS 与 P50/P95/P99。
压测严格在指定时长结束；过载而未能在窗口内开始的请求会记录为 `not_started`。长压测
的延迟样本上限为 100 万条，P50/P95/P99 基于均匀采样计算。

```powershell
# 终端 A：持续采集 mongod 的 CPU、内存、磁盘 IOPS/响应时间/队列。
powershell -ExecutionPolicy Bypass -File .\scripts\collect_mongodb_metrics.ps1 `
  -DurationSeconds 600 -OutputPath .\results\mongod-metrics.csv

# 终端 B：同一时段压测业务 MongoClient；先分别验证读和写，再运行混合业务流量。
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --mode write --qps 100000 --warmup 60 --duration 600 --workers 64 --players 100000 `
  --report .\results\player-write.csv

.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --mode read --qps 100000 --warmup 60 --duration 600 --workers 64 --players 100000 `
  --report .\results\player-read.csv
```

验收时同时保存 MongoDB 日志、`serverStatus()`、压测 CSV 和系统指标 CSV。重点看：

- 实际 QPS 是否达到目标，背压拒绝和失败是否为零或在明确预算内；
- P99 是否满足游戏请求的延迟预算，并观察 10 分钟后是否持续恶化；
- CPU 是否长期接近饱和，磁盘响应时间和队列是否上升；
- `majority + journal` 写入下的性能，而不是单机 `w=1` 的性能；
- 热数据与冷数据的读取比例、批量写入与单条写入、网络抖动和主从切换后的恢复。

单条同步 CRUD 通常不能在单个 MongoDB 副本集上稳定达到 100,000 QPS。若实际目标
仍为 100,000 QPS，应将可合并的玩家更新批量化，放入持久化异步队列，并根据分片键
设计进行分片；之后重新以真实写关注和故障切换场景验收。
