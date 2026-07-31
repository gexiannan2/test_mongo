# 玩家数据异步持久化分析

## 结论

当前工程已实现 `AsyncMongoDispatcher`：业务线程可以按 `playerId` 投递闭包到固定的
MongoDB 工作线程，并在任务真正落库前立即返回。默认使用 12 个工作线程，每个线程
有独立、有界 FIFO 队列。

`MongoClient` 自身仍是同步 CRUD。异步的是“业务线程 -> MongoDB 工作线程”的投递；
MongoDB 工作线程从队列取任务后，仍同步等待 MongoDB 返回结果。

目前存在的并发能力是：

- `AsyncMongoDispatcher` 按 `playerId % workerCount` 固定路由任务；
- 每个 MongoDB 工作线程串行处理自己的 FIFO 队列；
- `MongoClient` 使用 `mongocxx::pool`，让多个工作线程安全地共享客户端门面；
- 每个 CRUD 请求独占一个连接池客户端，并在请求结束后归还；
- `MONGO_MAX_IN_FLIGHT` 限制同时进入 MongoDB 的请求数；
- `MONGO_WAIT_QUEUE_TIMEOUT_MS` 到期后快速失败，避免请求无限排队；
- 压测程序用多个 `std::thread` 并发发起**同步**读写请求。

因此，业务保存路径可以是“异步投递 + MongoDB 工作线程内同步 CRUD”。
`mongo_player_benchmark` 默认 `--dispatch sync` 测试直接同步 CRUD，设置
`--dispatch async` 后可测试异步分发器的投递与落库能力。

## 当前执行过程

以一次 `UpdateOne` 玩家写入为例，当前调用链如下：

```text
业务线程
  -> MongoClient::UpdateOne
     -> RequestGuard 获取应用并发配额
     -> mongocxx::pool::acquire 获取一个连接
     -> collection.update_one 发送请求并同步等待 MongoDB 响应
     -> 记录完成或失败指标
     -> 归还连接和应用并发配额
  -> 返回 UpdateResult 或抛出 MongoError
```

`RequestGuard` 不是后台任务。它只是在同步请求开始前取得两个有限资源：应用并发
配额和 MongoDB 连接。连接池耗尽时，调用线程仍会等待到超时；应用并发满时，调用
线程会收到背压错误。

压测程序的 `RunScenario` 会创建多个工作线程。每个工作线程按照目标 QPS 的时间点
调用 `MongoClient::FindOne` 或 `MongoClient::UpdateOne`，因此它能模拟很多玩家同时
访问数据库，但每个工作线程里的单次操作依旧是同步等待。

## 为什么业务线程不应直接同步写入

角色移动、属性变更、自动拾取等通常发生在游戏逻辑线程。若每次变更都直接同步写
MongoDB，逻辑线程会受网络、磁盘和副本集确认延迟影响；当数据库变慢时，大量线程
会阻塞，最终使游戏帧和登录、战斗流程出现抖动。

更适合的模型是内存状态优先、持久化异步化：

```text
游戏逻辑线程
  -> 更新 PlayerState 内存状态并递增 sequence
  -> 提交 PlayerSaveTask 到有界队列
  -> 立即继续游戏逻辑

按 playerId 分片的持久化工作线程
  -> 合并同一玩家的旧任务，仅保留最新状态
  -> 定时或达到批量阈值后批量写 MongoDB
  -> 成功后更新已持久化 sequence；失败后按策略重试或转入失败队列
```

推荐将玩家 ID 按 `hash(playerId) % shardCount` 路由到固定分片。这样同一玩家总由同一
分片顺序处理，不同玩家仍可并行落库。

## 推荐任务结构和幂等写入

每个异步写任务至少应包含：

```cpp
struct PlayerSaveTask {
    std::int64_t playerId;
    std::uint64_t sequence;
    PlayerSnapshot snapshot;
    std::chrono::steady_clock::time_point enqueuedAt;
};
```

`sequence` 是防止乱序覆盖的关键。MongoDB 文档应保留 `last_sequence`，写入时用条件
过滤器拒绝旧任务：

```javascript
filter = {
  _id: playerId,
  last_sequence: { $lt: sequence }
}

update = {
  $set: {
    name: snapshot.name,
    level: snapshot.level,
    position: snapshot.position,
    attributes: snapshot.attributes,
    skills: snapshot.skills,
    settings: snapshot.settings,
    last_sequence: sequence
  }
}
```

网络超时后，客户端无法仅凭异常判断 MongoDB 是否已经完成写入。持久化端应采用
“至少一次投递 + 幂等写入”：允许重试同一个任务，由 `playerId + sequence` 保证旧任务
不会覆盖新状态。不要把“刚好一次写入”建立在网络异常不会发生的假设上。

## 队列、批量与背压策略

异步队列必须是有界队列，不能因为 MongoDB 故障而无限增长。建议的首版策略：

- 队列总长度：按可接受内存和最大玩家变更速率设定，例如先从 50,000 个任务开始；
- 分片数：例如 16；持久化工作线程数从 4～8 开始压测，不应超过连接池上限；
- 合并：队列中同一玩家只保留最新快照，旧任务被新任务替换；
- 批量：累计 100～1,000 个不同玩家，或等待 5～20 ms 后使用 `bulk_write` 提交；
- 背压：队列接近上限时优先合并可覆盖的存档任务；仍无法入队时拒绝低优先级写入，
  绝不静默丢弃货币、付费、交易等关键事务；
- 关闭：停止接收新任务，等待有时限地刷新队列；超时后把未完成任务写入可靠外部日志。

`MongoClient` 当前的 `MONGO_MAX_IN_FLIGHT` 仍然应保留。它限制的是持久化工作线程
实际访问 MongoDB 的并发数；它不能替代业务层的玩家保存队列。

## 数据可靠性分级

不同类型的玩家数据不应使用相同的异步策略：

| 数据类型 | 建议策略 | 是否允许仅内存排队 |
| --- | --- | --- |
| 位置、朝向、临时状态 | 合并后定时异步保存 | 通常允许 |
| 等级、背包、技能 | 带 sequence 的异步批量保存 | 短时允许，需监控积压 |
| 货币、充值、交易、发奖 | 事务化或可靠消息日志后再确认业务成功 | 不允许仅依赖内存队列 |

关键资产数据需要更强的“先持久化、后确认”语义，必要时使用 MongoDB 事务、可靠消息
队列或追加式 WAL。普通状态可用异步合并换取更高吞吐，但必须能接受进程崩溃窗口内
尚未落库的数据风险。

## 监控与验收指标

在现有 `MongoClient::Metrics()` 的提交、完成、失败、背压拒绝、活动请求之外，异步
队列还应暴露：

- 每个分片的队列长度、最老任务等待时间、合并数量和丢弃数量；
- 每批写入数量、批处理耗时、重试次数、失败队列数量；
- `last_sequence` 落后内存最新 sequence 的差值；
- 应用重启时未刷新任务数量；
- MongoDB P95/P99、`majority + journal` 写确认延迟和副本集故障切换期间的积压。

验收标准不应只看平均 QPS：在 10～30 分钟持续负载和一次主节点切换下，队列长度应
能够回落，关键任务不能丢失，普通玩家状态的持久化延迟必须落在业务可接受范围内。

## 后续实施顺序

1. 已完成 `AsyncMongoDispatcher`：有界队列、按 playerId 分片、固定工作线程和指标。
2. 实现同一玩家任务合并，并定时/按数量触发批量 `bulk_write`。
3. 给玩家文档和任务加入 `last_sequence`，实现条件更新和安全重试。
4. 将位置类低优先级状态先迁移到异步保存；货币、交易等关键数据保持可靠确认路径。
5. 接入 `majority + journal` 的三节点副本集，进行长压测、进程重启和主从切换测试。

当前分发器是内存队列；进程崩溃时未执行的闭包会丢失。关键数据在引入可靠日志或消息
队列前，仍不能仅依赖异步内存投递。
