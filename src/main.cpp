#include "mongo_standalone/MongoClient.h"
#include "mongo_standalone/MongoConfig.h"

#include <bsoncxx/builder/basic/document.hpp>
#include <bsoncxx/builder/basic/kvp.hpp>

#include <chrono>
#include <exception>
#include <iostream>
#include <string>

namespace {

using bsoncxx::builder::basic::document;
using bsoncxx::builder::basic::kvp;

std::string UniqueId()
{
    const auto value = std::chrono::steady_clock::now().time_since_epoch().count();
    return "mongo_demo_" + std::to_string(value);
}

int WriteRead()
{
    auto config = mongo_standalone::MongoConfig::FromEnvironment();
    mongo_standalone::MongoClient client(config);
    client.Ping();

    const std::string id = UniqueId();
    document filter;
    filter.append(kvp("_id", id));
    client.DeleteOne("crud_cases", filter.view());

    document input;
    input.append(kvp("_id", id), kvp("name", "MongoStandalone"), kvp("counter", 1));
    if (!client.InsertOne("crud_cases", input.view()))
    {
        throw std::runtime_error("插入没有返回结果");
    }

    const auto inserted = client.FindOne("crud_cases", filter.view());
    if (!inserted || inserted->view()["name"].get_string().value != "MongoStandalone")
    {
        throw std::runtime_error("插入后查询校验失败");
    }

    document setFields;
    setFields.append(kvp("name", "MongoStandaloneUpdated"));
    document incrementFields;
    incrementFields.append(kvp("counter", 2));
    document update;
    update.append(kvp("$set", setFields.extract()), kvp("$inc", incrementFields.extract()));

    const auto updated = client.UpdateOne("crud_cases", filter.view(), update.view());
    if (updated.matchedCount != 1 || updated.modifiedCount != 1)
    {
        throw std::runtime_error("更新结果校验失败");
    }

    const auto afterUpdate = client.FindOne("crud_cases", filter.view());
    if (!afterUpdate ||
        afterUpdate->view()["name"].get_string().value != "MongoStandaloneUpdated" ||
        afterUpdate->view()["counter"].get_int32().value != 3)
    {
        throw std::runtime_error("更新后查询校验失败");
    }

    if (client.DeleteOne("crud_cases", filter.view()).deletedCount != 1 ||
        client.FindOne("crud_cases", filter.view()).has_value())
    {
        throw std::runtime_error("删除校验失败");
    }

    std::cout << "MongoDB write-read smoke test passed\n";
    return 0;
}

} // namespace

int main(int argc, char* argv[])
{
    try
    {
        const std::string command = argc > 1 ? argv[1] : "write-read";
        if (command == "write-read")
        {
            return WriteRead();
        }

        auto config = mongo_standalone::MongoConfig::FromEnvironment();
        mongo_standalone::MongoClient client(config);

        if (command == "ping")
        {
            client.Ping();
            std::cout << "MongoDB ping passed\n";
            return 0;
        }
        std::cerr << "Usage: mongo_demo [ping|write-read]\n";
        return 2;
    }
    catch (const std::exception& error)
    {
        std::cerr << "MongoDB validation failed: " << error.what() << '\n';
        return 1;
    }
}
