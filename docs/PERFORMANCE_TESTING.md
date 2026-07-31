# MongoDB 玩家读写性能测试指南

本文说明 `mongo_player_benchmark` 的同步直连和异步投递两种测试方式。两者使用相同的
玩家文档、`_id` 查询与 `update_one` 更新逻辑，因此可以用于观察业务线程阻塞、排队和
MongoDB 最终落库能力的差异。

## 0. 测试前检查

必须使用 `Release|x64` 版本；Debug 的性能数据没有参考价值。默认可执行文件为：

```powershell
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe
```

确认本机 MongoDB 已监听默认端口：

```powershell
netstat -ano | findstr :27017
```

建议使用独立的压测数据库，并预先创建结果目录：

```powershell
$env:MONGO_URI = "mongodb://127.0.0.1:27017/?directConnection=true"
$env:MONGO_DATABASE = "dbserver_mongo_benchmark"
New-Item -ItemType Directory -Force .\results | Out-Null
```

> **数据影响**：程序只操作 `MONGO_DATABASE` 中的 `player_benchmark` 集合。若该集合的
> 文档数量与 `--players` 不一致，程序会清空该集合并重新写入样本；写压测也会更新其中的
> 玩家数据。请勿把业务真实数据放入此集合或此压测数据库。

建议先执行完整测试集，验证驱动、连接池和异步分发器可用：

```powershell
ctest --preset windows-vs2026-x64-release --output-on-failure
```

## 1. 两种模式的含义

| 参数 | 业务线程做什么 | MongoDB 工作线程 | 适合回答的问题 |
| --- | --- | --- | --- |
| `--dispatch sync` | 直接调用 CRUD，并等待 MongoDB 响应 | 没有额外任务线程 | 单条同步 CRUD 在指定并发下能达到多少 QPS？ |
| `--dispatch async` | 将闭包投递后立即继续 | `--mongo-workers` 个固定线程取队列任务并同步 CRUD | 业务线程能否不阻塞？队列会否积压、拒绝？最终落库能力是多少？ |

异步模式并不等于 MongoDB 驱动的单条操作本身异步：闭包在 MongoDB 工作线程中仍会
同步等待 `find_one` 或 `update_one` 返回。它把等待从游戏业务线程移到后台工作线程。

## 2. 同步 CRUD 压测

同步模式是默认模式。下面命令按 1,000、10,000、100,000 QPS 依次测试写和读；每档先
预热 2 秒、正式采样 10 秒，并分别写入 CSV。

```powershell
# 1,000 QPS：基础稳定性与连接配置验收
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --dispatch sync --mode all --qps 1000 --duration 10 --warmup 2 `
  --workers 8 --players 100000 --report .\results\sync-1000.csv

# 10,000 QPS：常规负载
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --dispatch sync --mode all --qps 10000 --duration 10 --warmup 2 `
  --workers 8 --players 100000 --report .\results\sync-10000.csv

# 100,000 QPS：单机单条 CRUD 的饱和点观察
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --dispatch sync --mode all --qps 100000 --duration 10 --warmup 2 `
  --workers 32 --players 100000 --report .\results\sync-100000.csv
```

同步模式下，“已投递”与“成功 + 失败”相等，因为调用线程只有在同步 CRUD 返回后才会进入
下一次请求。重点判读：

- `落库`（CSV 的 `actual_qps`）接近 `目标 QPS`，且 `失败=0`、`未启动` 很少，说明该
  档位能在严格时间窗口内完成；
- `未启动` 很多，说明固定时间窗口结束前工作线程没有来得及开始这些请求，是同步往返
  等待导致的饱和信号；
- P99 或最大延迟明显上升，即使 QPS 尚能达到目标，也说明已接近排队拐点；
- `客户端指标`中的`背压拒绝`大于 0，说明应用侧 `MONGO_MAX_IN_FLIGHT` 或连接池等待
  已成为限制，需连同相关环境变量记录下来。

## 3. 异步投递压测

异步模式建议先固定 4 个业务模拟线程和 12 个 MongoDB 工作线程。每个玩家依照
`playerId % 12` 固定路由，同一玩家已接受任务在同一 FIFO 队列顺序执行。

```powershell
# 1,000 QPS：验证异步路径、读写闭包和排空流程
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --dispatch async --mode all --qps 1000 --duration 10 --warmup 2 `
  --workers 4 --mongo-workers 12 --queue-per-worker 4096 `
  --players 100000 --drain-timeout 30 --report .\results\async-1000.csv

# 10,000 QPS：观察队列是否开始积压
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --dispatch async --mode all --qps 10000 --duration 10 --warmup 2 `
  --workers 4 --mongo-workers 12 --queue-per-worker 4096 `
  --players 100000 --drain-timeout 30 --report .\results\async-10000.csv

# 100,000 QPS：观察投递能力、队列背压与最终落库上限
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --dispatch async --mode all --qps 100000 --duration 10 --warmup 2 `
  --workers 4 --mongo-workers 12 --queue-per-worker 4096 `
  --players 100000 --drain-timeout 60 --report .\results\async-100000.csv
```

异步模式需要同时看三组指标，不能只看投递速度：

| 控制台/CSV 字段 | 含义 | 合格判读 |
| --- | --- | --- |
| `投递` / `accepted / submission_seconds` | 业务线程成功放入内存队列的速率 | 接近目标值仅说明业务线程未阻塞，不代表已写入 MongoDB。 |
| `落库` / `actual_qps` | 从开始投递到队列排空为止的实际完成速率 | 应结合 `成功`、`失败` 判断 MongoDB 最终处理能力。 |
| `队列拒绝` / `rejected` | 队列已满或分发器停止而未接受的任务数 | 非关键位置数据可合并到下一次快照；关键资产数据不能静默丢弃。 |
| `排空` / `drain_seconds` | 业务线程停止投递后，后台完成已接受任务所需的时间 | 长时间持续增大表示生产中队列会积压；为 0 只表示该档位有余量。 |
| `P99` | 从投递开始到后台 CRUD 完成的端到端延迟样本 | 包含排队时间；应与同步 P99 对比，而非只看数据库调用耗时。 |

异步结果的基本验收条件是：`已投递 = 成功 + 失败`、`失败 = 0`、`队列拒绝 = 0`，且
`排空`在可接受时间内完成。若 100,000 QPS 时投递接近目标、落库较低、排空变长或出现
拒绝，说明业务线程已成功脱离阻塞，但后台 MongoDB 落库能力仍然不足；下一步应考虑
同玩家快照合并、`bulk_write`、副本集/分片，而不是盲目继续增加工作线程。

## 4. 同一条件下如何横向比较

同步与异步只能在下列条件一致时比较：

- 相同 MongoDB 版本、数据库、集合、玩家数和索引；
- 相同 `MONGO_MAX_POOL_SIZE`、`MONGO_MAX_IN_FLIGHT`、写关注和网络条件；
- 相同目标 QPS、预热时间、正式时长及读/写模式；
- 每档至少重复 3 次，记录中位数和最差 P99，而不是只保留一次最好结果。

两种模式关注点不同：同步模式以“业务调用完成 QPS 和同步延迟”为主；异步模式以“业务
投递 QPS、最终落库 QPS、拒绝数、排空时间和端到端延迟”为主。异步投递可以保护游戏
线程，却不能凭空提高 MongoDB 的单条写入上限。

## 5. 长压测与服务端指标

短压测确认每个档位后，应在目标档位运行 10～30 分钟，同时另开 PowerShell 采集
`mongod` 的 CPU、私有工作集、磁盘 IOPS、磁盘响应时间与磁盘队列长度：

```powershell
.\scripts\collect_mongodb_metrics.ps1 `
  -DurationSeconds 600 -IntervalSeconds 1 `
  -OutputPath .\results\mongod-async-100000.csv
```

采集开始后，在另一个终端运行上面的压测命令。分析时将基准 CSV 与指标 CSV 按时间对照：

- CPU 持续接近满载且 P99 上升：优先检查 MongoDB 服务端 CPU 或请求调度；
- 磁盘响应时间、队列长度升高且写入 P99 上升：优先检查写关注、日志盘和存储介质；
- 异步 `排空`持续增加而 CPU/磁盘未满：检查每玩家路由是否倾斜、连接池上限及队列容量；
- 只在写入出现瓶颈：分别记录 `w=1` 与生产 `majority + journal` 的结果，不能混用。

## 6. CSV 字段速查

每个 `--report` 文件包含 `mode`（`read` 或 `write`）、`dispatch`（`sync` 或 `async`）
以及下列核心字段：

```text
target_qps, accepted, rejected, completed, failed, not_started,
submission_seconds, drain_seconds, elapsed_seconds, actual_qps,
p50_us, p95_us, p99_us, max_us
```

请将原始 CSV 保存在 `results/`，并把机器配置、MongoDB 配置、环境变量、命令与结论
追加到 `tests/BENCHMARK_RESULTS.md`，以便不同轮次可以追溯和复现。
