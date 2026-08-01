#include "mongo_standalone/PlayerMongoStorage.h"

#include <bsoncxx/builder/basic/array.hpp>
#include <bsoncxx/builder/basic/document.hpp>
#include <bsoncxx/builder/basic/kvp.hpp>

#include <stdexcept>
#include <utility>

namespace mongo_standalone {
namespace {

using bsoncxx::builder::basic::array;
using bsoncxx::builder::basic::document;
using bsoncxx::builder::basic::kvp;
using bsoncxx::builder::basic::make_document;

void SaveSnapshot(MongoClient& client, const std::string& collection,
                  const PlayerSnapshot& snapshot)
{
    document filter;
    filter.append(kvp("_id", snapshot.id));

    array skills;
    for (const auto& skill : snapshot.skills)
    {
        skills.append(make_document(
            kvp("skill_id", skill.skillId),
            kvp("level", skill.level)));
    }

    document fields;
    fields.append(
        kvp("name", snapshot.name),
        kvp("level", snapshot.level),
        kvp("position", make_document(
            kvp("map_id", snapshot.position.mapId),
            kvp("x", snapshot.position.x),
            kvp("y", snapshot.position.y),
            kvp("z", snapshot.position.z))),
        kvp("attributes", make_document(
            kvp("hp", snapshot.attributes.hp),
            kvp("mp", snapshot.attributes.mp),
            kvp("attack", snapshot.attributes.attack))),
        kvp("skills", skills.extract()),
        kvp("settings", make_document(kvp("auto_pick", snapshot.autoPick))),
        kvp("last_sequence", static_cast<std::int64_t>(snapshot.sequence)));
    document update;
    update.append(kvp("$set", fields.extract()));

    const auto result = client.UpdateOne(collection, filter.view(), update.view(), true);
    if (result.matchedCount != 1 && !result.upserted)
    {
        throw std::runtime_error("玩家异步快照没有匹配或写入文档");
    }
}

} // namespace

PlayerMongoStorage::PlayerMongoStorage(
    MongoConfig config,
    PlayerMongoStorageOptions options,
    AsyncMongoDispatcher::ErrorHandler errorHandler)
    : collection_(std::move(options.collection)),
      dispatcher_(std::move(config), options.dispatcher, std::move(errorHandler))
{
    if (collection_.empty())
    {
        throw std::invalid_argument("玩家 MongoDB 集合名不能为空");
    }
}

bool PlayerMongoStorage::PostSave(PlayerSnapshot snapshot)
{
    const std::int64_t playerId = snapshot.id;
    return dispatcher_.Post(
        playerId,
        [collection = collection_, snapshot = std::move(snapshot)](MongoClient& client) {
            SaveSnapshot(client, collection, snapshot);
        });
}

bool PlayerMongoStorage::WaitForIdle(std::chrono::milliseconds timeout)
{
    return dispatcher_.WaitForIdle(timeout);
}

void PlayerMongoStorage::RequestStop()
{
    dispatcher_.RequestStop();
}

void PlayerMongoStorage::Stop()
{
    dispatcher_.Stop();
}

AsyncMongoDispatcherMetrics PlayerMongoStorage::Metrics() const noexcept
{
    return dispatcher_.Metrics();
}

} // namespace mongo_standalone
