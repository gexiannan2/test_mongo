#pragma once

#include "mongo_standalone/MongoConfig.h"

#include <bsoncxx/document/value.hpp>
#include <bsoncxx/document/view_or_value.hpp>
#include <mongocxx/client.hpp>
#include <mongocxx/collection.hpp>
#include <mongocxx/database.hpp>

#include <cstdint>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace mongo_standalone {

struct UpdateResult
{
    std::int64_t matchedCount = 0;
    std::int64_t modifiedCount = 0;
    bool upserted = false;
};

struct DeleteResult
{
    std::int64_t deletedCount = 0;
};

class MongoClient final
{
public:
    explicit MongoClient(MongoConfig config);

    void Ping();
    bool InsertOne(std::string_view collection, bsoncxx::document::view_or_value document);
    std::optional<bsoncxx::document::value> FindOne(
        std::string_view collection,
        bsoncxx::document::view_or_value filter);
    std::vector<bsoncxx::document::value> Find(
        std::string_view collection,
        bsoncxx::document::view_or_value filter);
    UpdateResult UpdateOne(
        std::string_view collection,
        bsoncxx::document::view_or_value filter,
        bsoncxx::document::view_or_value update,
        bool upsert = false);
    UpdateResult UpdateMany(
        std::string_view collection,
        bsoncxx::document::view_or_value filter,
        bsoncxx::document::view_or_value update,
        bool upsert = false);
    DeleteResult DeleteOne(
        std::string_view collection,
        bsoncxx::document::view_or_value filter);
    DeleteResult DeleteMany(
        std::string_view collection,
        bsoncxx::document::view_or_value filter);
    std::int64_t Count(
        std::string_view collection,
        bsoncxx::document::view_or_value filter);

private:
    mongocxx::collection Collection(std::string_view name);

    MongoConfig config_;
    mongocxx::client client_;
    mongocxx::database database_;
};

} // namespace mongo_standalone

