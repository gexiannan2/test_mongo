#pragma once

#include "AsyncMongoDispatcher.h"

#include <chrono>
#include <cstdint>
#include <string>
#include <vector>

namespace mongo_standalone {

struct PlayerPosition
{
    std::int32_t mapId = 0;
    double x = 0.0;
    double y = 0.0;
    double z = 0.0;
};

struct PlayerAttributes
{
    std::int32_t hp = 0;
    std::int32_t mp = 0;
    std::int32_t attack = 0;
};

struct PlayerSkill
{
    std::int32_t skillId = 0;
    std::int32_t level = 0;
};

struct PlayerSnapshot
{
    std::int64_t id = 0;
    std::uint64_t sequence = 0;
    std::string name;
    std::int32_t level = 0;
    PlayerPosition position;
    PlayerAttributes attributes;
    std::vector<PlayerSkill> skills;
    bool autoPick = false;
};

struct PlayerMongoStorageOptions
{
    std::string collection = "players";
    AsyncMongoDispatcherOptions dispatcher;
};

// 面向游戏业务的玩家快照异步持久化门面。
class PlayerMongoStorage final
{
public:
    PlayerMongoStorage(
        MongoConfig config,
        PlayerMongoStorageOptions options = {},
        AsyncMongoDispatcher::ErrorHandler errorHandler = {});

    PlayerMongoStorage(const PlayerMongoStorage&) = delete;
    PlayerMongoStorage& operator=(const PlayerMongoStorage&) = delete;
    PlayerMongoStorage(PlayerMongoStorage&&) = delete;
    PlayerMongoStorage& operator=(PlayerMongoStorage&&) = delete;

    // 传入值语义快照；成功入队返回 true，队列满或停服时返回 false。
    bool PostSave(PlayerSnapshot snapshot);

    bool WaitForIdle(std::chrono::milliseconds timeout);
    void RequestStop();
    void Stop();
    AsyncMongoDispatcherMetrics Metrics() const noexcept;

private:
    std::string collection_;
    AsyncMongoDispatcher dispatcher_;
};

} // namespace mongo_standalone
