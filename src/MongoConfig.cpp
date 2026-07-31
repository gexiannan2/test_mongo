#include "mongo_standalone/MongoConfig.h"

#include <cstdlib>
#include <stdexcept>

namespace mongo_standalone {
namespace {

std::string ReadEnvironment(const char* name, const std::string& fallback)
{
#ifdef _WIN32
    char* value = nullptr;
    std::size_t length = 0;
    if (_dupenv_s(&value, &length, name) != 0 || value == nullptr)
    {
        return fallback;
    }
    const std::string result = *value == '\0' ? fallback : value;
    std::free(value);
    return result;
#else
    const char* value = std::getenv(name);
    return value == nullptr || *value == '\0' ? fallback : value;
#endif
}

std::chrono::milliseconds ReadTimeout()
{
    const std::string value = ReadEnvironment("MONGO_TEST_TIMEOUT_MS", "3000");
    try
    {
        return std::chrono::milliseconds(std::stoll(value));
    }
    catch (const std::exception&)
    {
        throw std::invalid_argument("MONGO_TEST_TIMEOUT_MS 必须是整数");
    }
}

} // namespace

MongoConfig MongoConfig::FromEnvironment()
{
    MongoConfig config;
    config.uri = ReadEnvironment("MONGO_TEST_URI", config.uri);
    config.database = ReadEnvironment("MONGO_TEST_DATABASE", config.database);
    const auto timeout = ReadTimeout();
    config.serverSelectionTimeout = timeout;
    config.connectTimeout = timeout;
    config.socketTimeout = timeout;
    config.Validate();
    return config;
}

void MongoConfig::Validate() const
{
    if (uri.empty())
    {
        throw std::invalid_argument("MongoDB URI 不能为空");
    }
    if (database.empty())
    {
        throw std::invalid_argument("MongoDB 数据库名不能为空");
    }
    if (serverSelectionTimeout.count() <= 0 ||
        connectTimeout.count() <= 0 ||
        socketTimeout.count() <= 0)
    {
        throw std::invalid_argument("MongoDB 超时必须大于 0");
    }
}

std::string MongoConfig::EffectiveUri() const
{
    Validate();
    std::string result = uri;
    const char separator = result.find('?') == std::string::npos ? '?' : '&';
    result += separator;
    result += "serverSelectionTimeoutMS=" + std::to_string(serverSelectionTimeout.count());
    result += "&connectTimeoutMS=" + std::to_string(connectTimeout.count());
    result += "&socketTimeoutMS=" + std::to_string(socketTimeout.count());
    return result;
}

} // namespace mongo_standalone
