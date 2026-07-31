#pragma once

#include <chrono>
#include <string>

namespace mongo_standalone {

struct MongoConfig
{
    std::string uri = "mongodb://127.0.0.1:27017/?directConnection=true";
    std::string database = "dbserver_mongo_test";
    std::chrono::milliseconds serverSelectionTimeout{3000};
    std::chrono::milliseconds connectTimeout{3000};
    std::chrono::milliseconds socketTimeout{3000};

    static MongoConfig FromEnvironment();
    void Validate() const;
    std::string EffectiveUri() const;
};

} // namespace mongo_standalone

