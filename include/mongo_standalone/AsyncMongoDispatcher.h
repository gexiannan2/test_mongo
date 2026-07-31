#pragma once

#include "mongo_standalone/MongoClient.h"
#include "mongo_standalone/MongoConfig.h"

#include <atomic>
#include <chrono>
#include <condition_variable>
#include <cstddef>
#include <cstdint>
#include <exception>
#include <functional>
#include <memory>
#include <mutex>
#include <vector>

namespace mongo_standalone {

struct AsyncMongoDispatcherOptions
{
    std::size_t workerCount = 12;
    std::size_t maxQueuedTasksPerWorker = 4096;
};

struct AsyncMongoDispatcherMetrics
{
    std::uint64_t posted = 0;
    std::uint64_t completed = 0;
    std::uint64_t failed = 0;
    std::uint64_t rejected = 0;
    std::uint64_t queued = 0;
    std::uint64_t active = 0;
};

class AsyncMongoDispatcher final
{
public:
    using Task = std::function<void(MongoClient&)>;
    using ErrorHandler = std::function<void(std::int64_t playerId, std::exception_ptr error)>;

    AsyncMongoDispatcher(
        MongoConfig config,
        AsyncMongoDispatcherOptions options = {},
        ErrorHandler errorHandler = {});
    ~AsyncMongoDispatcher();

    AsyncMongoDispatcher(const AsyncMongoDispatcher&) = delete;
    AsyncMongoDispatcher& operator=(const AsyncMongoDispatcher&) = delete;
    AsyncMongoDispatcher(AsyncMongoDispatcher&&) = delete;
    AsyncMongoDispatcher& operator=(AsyncMongoDispatcher&&) = delete;

    // 按玩家固定路由；同一玩家的已接受任务在同一工作线程内 FIFO 执行。
    bool Post(std::int64_t playerId, Task task);

    // 等待所有已接受任务完成。超时时返回 false，不会丢弃队列中的任务。
    bool WaitForIdle(std::chrono::milliseconds timeout);

    // 停止接收新任务，并排空已接受任务后回收工作线程。
    void Stop();

    AsyncMongoDispatcherMetrics Metrics() const noexcept;

private:
    class Worker;

    void RunWorker(Worker& worker) noexcept;
    std::size_t WorkerIndex(std::int64_t playerId) const noexcept;

    MongoConfig config_;
    AsyncMongoDispatcherOptions options_;
    ErrorHandler errorHandler_;
    std::unique_ptr<MongoClient> client_;
    std::vector<std::unique_ptr<Worker>> workers_;

    std::atomic<bool> stopping_{false};
    std::atomic<std::uint64_t> posted_{0};
    std::atomic<std::uint64_t> completed_{0};
    std::atomic<std::uint64_t> failed_{0};
    std::atomic<std::uint64_t> rejected_{0};
    std::atomic<std::uint64_t> queued_{0};
    std::atomic<std::uint64_t> active_{0};

    mutable std::mutex lifecycleMutex_;
    bool stopped_ = false;
    mutable std::mutex idleMutex_;
    std::condition_variable idleCondition_;
};

} // namespace mongo_standalone
