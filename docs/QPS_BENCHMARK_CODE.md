# MongoDB QPS 测试代码说明

## 两种测试模式

`mongo_player_benchmark` 支持两种明确区分的模式：

- `--dispatch sync`：默认模式，多线程并发调用同步 CRUD，测量单条同步 MongoDB
  操作能力；
- `--dispatch async`：业务模拟线程只投递闭包，默认 12 个 MongoDB 工作线程按玩家
  ID 固定路由并执行同步 CRUD，测量异步投递、队列拒绝与最终落库能力。

下文的“同步”调用链仅适用于 `--dispatch sync`。不要把同步模式中的多线程并发误称为
异步投递。

每个工作线程调用 `MongoClient::FindOne` 或 `MongoClient::UpdateOne` 后，必须等待
MongoDB 返回结果或抛出异常，才会开始该线程的下一次操作。代码中没有任务队列、
`std::future`、协程、回调，也没有后台批量持久化工作线程。

```text
RunScenario 创建 N 个 std::thread
  -> 每个线程按 QPS 时间点发起一次 CRUD
  -> MongoClient 获取并发配额和连接池客户端
  -> MongoDB 同步执行 find_one / update_one
  -> 当前线程获得结果后，才处理下一次操作
```

因此：

- `--workers 32` 表示最多 32 个线程并发阻塞等待 MongoDB；
- `MONGO_MAX_IN_FLIGHT=64` 是同步请求的上限和背压保护；
- `mongocxx::pool` 是连接复用，不是异步消息队列；
- 高 QPS 下的 `not_started` 表示时间窗口结束前，线程来不及开始更多同步请求。

## 代码职责划分

| 位置 | 职责 | 是否异步 |
| --- | --- | --- |
| `tests/MongoPlayerBenchmark.cpp` | 解析参数、准备玩家样本、按时间节流、执行同步或异步投递压测、计算 P99、写 CSV | 由 `--dispatch` 决定 |
| `src/MongoClient.cpp` | 连接池、应用侧并发配额、同步 CRUD、错误转换和指标 | 同步 |
| `mongocxx::pool` | 连接池客户端的获取和归还 | 连接复用，不是任务投递 |
| `AsyncMongoDispatcher` | 玩家固定路由、有界内存队列与 MongoDB 工作线程 | 异步投递；工作线程内 CRUD 同步 |
| `docs/PLAYER_ASYNC_PERSISTENCE.md` | 异步玩家持久化的可靠性边界 | 已实现基础分发层 |

## 同步模式的实际调用

`RunScenario` 对每个序号构造玩家 ID 与更新文档，再直接调用：

```cpp
const auto result = client.UpdateOne(
    "player_benchmark", filter.view(), update.view());
```

`UpdateOne` 内部执行 `collection.update_one(...)`，该调用在得到 MongoDB 响应前不会
返回。成功后才更新 `completed` 计数；异常时更新 `failed` 计数。故 QPS 表示“在固定
时间窗口内真正完成的同步 MongoDB 操作数”。

读压测同理，`FindOne` 内部执行 `collection.find_one(...)` 后才返回文档结果。

## 当前指标含义

| 字段 | 含义 |
| --- | --- |
| `target_qps` | 计划的每秒发起速率 |
| `completed` | 在时间窗口内成功完成的同步 CRUD 数量 |
| `failed` | 已发起但返回异常或业务校验失败的数量 |
| `not_started` | 时间结束前尚未开始的计划请求；不是已提交到后台的任务 |
| `actual_qps` | `(completed + failed) / elapsed_seconds` |
| `latency_samples` | 用于 P50/P95/P99 的均匀延迟样本数，长压测上限 100 万 |

严格时间窗口不会在结束后补跑积压请求。因此在 100,000 QPS 场景下，大量
`not_started` 正确反映当前同步模型无法在时限内发起那么多请求，而不是数据静默丢失。

## 与真正异步投递的差异

| 维度 | 当前 QPS 压测 | 真正的玩家异步持久化 |
| --- | --- | --- |
| 调用线程 | 等待 MongoDB 结果 | 入队后立即返回 |
| 内存队列 | 无 | 有界、按 playerId 分片的任务队列 |
| 批量写入 | 无，逐条 `update_one` | 定时或按数量触发 `bulk_write` |
| 顺序控制 | 由单线程顺序调用偶然保证 | 用 `sequence` 和条件更新显式保证 |
| 失败处理 | 当前调用返回异常 | 重试、失败队列、WAL 或可靠消息系统 |
| 适用目标 | 测量单条同步 CRUD 上限 | 减少游戏逻辑线程阻塞、提高合并写吞吐 |

## 异步投递压测

异步模式使用 `--dispatch async`，将 `--workers` 视为业务模拟线程数，
`--mongo-workers` 视为后台 MongoDB 工作线程数：

```powershell
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --dispatch async --mode all --qps 10000 --duration 10 `
  --workers 4 --mongo-workers 12 --queue-per-worker 4096 --players 100000
```

报告中的“投递 QPS”是业务线程成功放入队列的速率；“落库 QPS”是队列排空后实际
完成 MongoDB 操作的速率；“队列拒绝”表示有界队列已满或正在停止。后续仍应增加
同玩家任务合并、`bulk_write`、可靠日志和 `last_sequence` 条件更新。
