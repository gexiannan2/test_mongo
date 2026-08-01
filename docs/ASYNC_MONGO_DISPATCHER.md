# AsyncMongoDispatcher 使用说明

`AsyncMongoDispatcher` 用于把 MongoDB 同步 CRUD 从业务线程移到固定的 MongoDB
工作线程。默认创建 12 个工作线程，每个线程有独立、有界 FIFO 队列。

它适合“玩家移动期间只更新内存状态；每秒定时保存一次玩家快照”的场景。

## 执行模型

```text
游戏线程
  -> 构造不可变 PlayerSnapshot
  -> dispatcher.Post(playerId, 闭包)
  -> 立即继续游戏逻辑

固定 MongoDB 工作线程 playerId % workerCount
  -> 从自己的 FIFO 队列取闭包
  -> 闭包内同步执行 MongoClient::UpdateOne
  -> 记录完成、失败、排队、拒绝指标
```

同一 `playerId` 始终投递到同一工作线程，因此**已接受任务**按 FIFO 顺序执行。不同
玩家可在不同 MongoDB 工作线程并行执行。

## 初始化

应用启动时创建一个长期存活的分发器，不要在每次保存时重复创建：

```cpp
#include "mongo_standalone/AsyncMongoDispatcher.h"

auto config = mongo_standalone::MongoConfig::FromEnvironment();

mongo_standalone::AsyncMongoDispatcher dispatcher(
    config,
    {
        .workerCount = 12,
        .maxQueuedTasksPerWorker = 4096,
    },
    [](std::int64_t playerId, std::exception_ptr error) {
        // 此回调运行在 MongoDB 工作线程；只记录日志或投递回游戏线程。
        // 不要在这里直接修改非线程安全的玩家对象。
    });
```

总排队容量约为 `workerCount * maxQueuedTasksPerWorker`。队列已满或正在关闭时，
`Post` 立即返回 `false`，不会等待 MongoDB。

## 每秒定时保存玩家

业务线程必须捕获**值语义快照**，不能让异步闭包持有 `Player` 裸指针、引用或 BSON
`document::view`。玩家可能在 MongoDB 工作线程执行前下线、销毁或被下一帧修改。

```cpp
struct PlayerSnapshot {
    std::int64_t id;
    std::uint64_t sequence;
    std::string name;
    std::int32_t level;
    double x;
    double y;
    double z;
};

void SavePlayerEverySecond(
    mongo_standalone::AsyncMongoDispatcher& dispatcher,
    const Player& player)
{
    const PlayerSnapshot snapshot = player.MakeSnapshot();
    const bool accepted = dispatcher.Post(
        snapshot.id,
        [snapshot](mongo_standalone::MongoClient& mongo) {
            bsoncxx::builder::basic::document filter;
            filter.append(bsoncxx::builder::basic::kvp("_id", snapshot.id));

            bsoncxx::builder::basic::document fields;
            fields.append(
                bsoncxx::builder::basic::kvp("name", snapshot.name),
                bsoncxx::builder::basic::kvp("level", snapshot.level),
                bsoncxx::builder::basic::kvp(
                    "position",
                    bsoncxx::builder::basic::make_document(
                        bsoncxx::builder::basic::kvp("x", snapshot.x),
                        bsoncxx::builder::basic::kvp("y", snapshot.y),
                        bsoncxx::builder::basic::kvp("z", snapshot.z))),
                bsoncxx::builder::basic::kvp(
                    "last_sequence", static_cast<std::int64_t>(snapshot.sequence)));
            bsoncxx::builder::basic::document update;
            update.append(bsoncxx::builder::basic::kvp("$set", fields.extract()));

            mongo.UpdateOne("players", filter.view(), update.view(), true);
        });

    if (!accepted) {
        // 记录背压；普通位置状态可下一秒重试，关键资产不能静默丢弃。
    }
}
```

上例中的单次 `UpdateOne` 在 MongoDB 工作线程内仍是同步的；异步的是业务线程到
MongoDB 工作线程的投递过程。

通用 `Post()` 的闭包会延后执行，因此不能捕获 `Player&`、临时对象引用、已经可能析构的
`this` 或裸指针。应像示例一样捕获值语义快照；错误回调会由多个 MongoDB 工作线程并发
调用，回调内访问共享状态时必须自行同步。

## 指标与关闭

```cpp
const auto metrics = dispatcher.Metrics();
// posted、completed、failed、rejected、queued、active

// 先停止业务投递，再请求调度器拒绝新任务并排空已有任务。
dispatcher.RequestStop();
if (!dispatcher.WaitForIdle(std::chrono::seconds(10))) {
    // 记录仍未排空的任务；不要把关键资产数据直接丢弃。
}
dispatcher.Stop();
```

`RequestStop()` 可安全地从任务或错误回调中调用，只请求停止，不等待线程回收。
`Stop()` 先拒绝新任务，再排空已接受任务并等待工作线程退出；若从 MongoDB 工作线程
调用，它同样只请求停止以避免自身 `join`。调度器对象的销毁必须由外部线程执行。单个
MongoDB 请求的最长阻塞时间仍受 `MONGO_SOCKET_TIMEOUT_MS` 等连接配置限制。

## 当前边界

- 已实现：异步投递、12 线程默认值、玩家固定路由、每线程 FIFO、有界队列、背压拒绝、
  错误回调、排空等待和运行指标。
- 未实现：同一玩家任务合并、`bulk_write`、任务持久化/WAL、重启恢复、成功回调回投游戏
  线程、分布式可靠消息队列。
- 关键资产（货币、交易、充值、发奖）不能只放在内存闭包队列中；应使用事务或可靠日志后
  再确认业务成功。

集成测试目标为 `mongo_async_dispatch_tests`：验证 12 线程亲和性、同玩家 FIFO、实际
MongoDB 落库以及队列已满时的拒绝行为。

## QPS 验证命令

`mongo_player_benchmark` 的异步模式会创建业务模拟线程和独立的 MongoDB 工作线程。
CSV 同时记录投递、队列拒绝、落库和排空时间：

```powershell
.\build\vs2026-x64-d\tests\Release\mongo_player_benchmark.exe `
  --dispatch async --mode all --qps 10000 --duration 10 --warmup 2 `
  --workers 4 --mongo-workers 12 --queue-per-worker 4096 `
  --players 100000 --report .\results\player-async.csv
```
