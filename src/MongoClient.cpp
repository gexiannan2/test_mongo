#include "mongo_standalone/MongoClient.h"

#include "mongo_standalone/MongoError.h"

#include <bsoncxx/builder/basic/document.hpp>
#include <bsoncxx/builder/basic/kvp.hpp>
#include <mongocxx/exception/exception.hpp>
#include <mongocxx/instance.hpp>
#include <mongocxx/options/update.hpp>
#include <mongocxx/uri.hpp>

#include <stdexcept>
#include <string>
#include <utility>

namespace mongo_standalone {
namespace {

mongocxx::instance& DriverInstance()
{
    static mongocxx::instance instance;
    return instance;
}

template <typename Function>
auto Execute(const char* operation, Function&& function) -> decltype(function())
{
    try
    {
        return function();
    }
    catch (const mongocxx::exception& error)
    {
        throw MongoError(operation, error.code().value(), error.what());
    }
    catch (const std::exception& error)
    {
        throw MongoError(operation, 0, error.what());
    }
}

void ValidateCollection(std::string_view name)
{
    if (name.empty())
    {
        throw std::invalid_argument("MongoDB 集合名不能为空");
    }
}

} // namespace

MongoClient::MongoClient(MongoConfig config)
    : config_(std::move(config)),
      client_((DriverInstance(), mongocxx::uri{config_.EffectiveUri()})),
      database_(client_[config_.database])
{
}

void MongoClient::Ping()
{
    Execute("ping", [this]() {
        bsoncxx::builder::basic::document command;
        command.append(bsoncxx::builder::basic::kvp("ping", 1));
        database_.run_command(command.view());
    });
}

mongocxx::collection MongoClient::Collection(std::string_view name)
{
    ValidateCollection(name);
    return database_[std::string(name)];
}

bool MongoClient::InsertOne(
    std::string_view collection,
    bsoncxx::document::view_or_value document)
{
    return Execute("insert_one", [this, collection, document = std::move(document)]() mutable {
        const auto result = Collection(collection).insert_one(std::move(document));
        return result.has_value();
    });
}

std::optional<bsoncxx::document::value> MongoClient::FindOne(
    std::string_view collection,
    bsoncxx::document::view_or_value filter)
{
    return Execute("find_one", [this, collection, filter = std::move(filter)]() mutable {
        return Collection(collection).find_one(std::move(filter));
    });
}

std::vector<bsoncxx::document::value> MongoClient::Find(
    std::string_view collection,
    bsoncxx::document::view_or_value filter)
{
    return Execute("find", [this, collection, filter = std::move(filter)]() mutable {
        std::vector<bsoncxx::document::value> documents;
        auto cursor = Collection(collection).find(std::move(filter));
        for (const auto& document : cursor)
        {
            documents.emplace_back(document);
        }
        return documents;
    });
}

UpdateResult MongoClient::UpdateOne(
    std::string_view collection,
    bsoncxx::document::view_or_value filter,
    bsoncxx::document::view_or_value update,
    bool upsert)
{
    return Execute("update_one", [this, collection, filter = std::move(filter),
                                   update = std::move(update), upsert]() mutable {
        mongocxx::options::update options;
        options.upsert(upsert);
        const auto result =
            Collection(collection).update_one(std::move(filter), std::move(update), options);
        if (!result)
        {
            return UpdateResult{};
        }
        return UpdateResult{
            static_cast<std::int64_t>(result->matched_count()),
            static_cast<std::int64_t>(result->modified_count()),
            result->upserted_id().has_value()};
    });
}

UpdateResult MongoClient::UpdateMany(
    std::string_view collection,
    bsoncxx::document::view_or_value filter,
    bsoncxx::document::view_or_value update,
    bool upsert)
{
    return Execute("update_many", [this, collection, filter = std::move(filter),
                                    update = std::move(update), upsert]() mutable {
        mongocxx::options::update options;
        options.upsert(upsert);
        const auto result =
            Collection(collection).update_many(std::move(filter), std::move(update), options);
        if (!result)
        {
            return UpdateResult{};
        }
        return UpdateResult{
            static_cast<std::int64_t>(result->matched_count()),
            static_cast<std::int64_t>(result->modified_count()),
            result->upserted_id().has_value()};
    });
}

DeleteResult MongoClient::DeleteOne(
    std::string_view collection,
    bsoncxx::document::view_or_value filter)
{
    return Execute("delete_one", [this, collection, filter = std::move(filter)]() mutable {
        const auto result = Collection(collection).delete_one(std::move(filter));
        return DeleteResult{
            result ? static_cast<std::int64_t>(result->deleted_count()) : 0};
    });
}

DeleteResult MongoClient::DeleteMany(
    std::string_view collection,
    bsoncxx::document::view_or_value filter)
{
    return Execute("delete_many", [this, collection, filter = std::move(filter)]() mutable {
        const auto result = Collection(collection).delete_many(std::move(filter));
        return DeleteResult{
            result ? static_cast<std::int64_t>(result->deleted_count()) : 0};
    });
}

std::int64_t MongoClient::Count(
    std::string_view collection,
    bsoncxx::document::view_or_value filter)
{
    return Execute("count_documents", [this, collection, filter = std::move(filter)]() mutable {
        return Collection(collection).count_documents(std::move(filter));
    });
}

} // namespace mongo_standalone

