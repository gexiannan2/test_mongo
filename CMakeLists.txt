cmake_minimum_required(VERSION 3.21)

# 本目录可直接作为 svc_game3d 的子目录加入构建图：
# add_subdirectory(third_party/mongo_player_storage)
project(MongoPlayerStorage VERSION 1.0.0 LANGUAGES CXX)

# 玩家异步持久化层要求 C++20；C Driver 会在下方按需启用 C 语言。
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
    add_compile_options(/utf-8)
endif()

set(_mongo_c_driver_version "2.3.3")
set(_mongo_cxx_driver_version "4.4.1")
set(_mongo_vendor_root "${CMAKE_CURRENT_LIST_DIR}/third_party/src")
set(_mongo_c_driver_source "${_mongo_vendor_root}/mongo-c-driver")
set(_mongo_cxx_driver_source "${_mongo_vendor_root}/mongo-cxx-driver")

if(NOT EXISTS "${_mongo_c_driver_source}/CMakeLists.txt")
    message(FATAL_ERROR "缺少 MongoDB C Driver ${_mongo_c_driver_version} 源码。")
endif()
if(NOT EXISTS "${_mongo_cxx_driver_source}/CMakeLists.txt")
    message(FATAL_ERROR "缺少 MongoDB C++ Driver r${_mongo_cxx_driver_version} 源码。")
endif()

file(STRINGS "${_mongo_c_driver_source}/VERSION_CURRENT"
    _mongo_c_driver_source_version LIMIT_COUNT 1)
if(NOT _mongo_c_driver_source_version STREQUAL _mongo_c_driver_version)
    message(FATAL_ERROR
        "MongoDB C Driver 源码版本应为 ${_mongo_c_driver_version}，实际为 ${_mongo_c_driver_source_version}。")
endif()

# 驱动源码会被当前工程直接编译。关闭不属于游戏服运行时的能力，以减小构建图。
enable_language(C)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(ENABLE_STATIC ON CACHE STRING "仅构建 MongoDB C Driver 静态目标" FORCE)
set(ENABLE_SHARED OFF CACHE BOOL "不构建 MongoDB C Driver 动态库" FORCE)
set(ENABLE_TESTS OFF CACHE BOOL "不构建 MongoDB 驱动上游测试" FORCE)
set(ENABLE_EXAMPLES OFF CACHE BOOL "不构建 MongoDB 驱动上游示例" FORCE)
set(ENABLE_MAN_PAGES OFF CACHE BOOL "不构建 MongoDB 驱动文档" FORCE)
set(ENABLE_HTML_DOCS OFF CACHE BOOL "不构建 MongoDB 驱动文档" FORCE)
set(ENABLE_UNINSTALL OFF CACHE BOOL "不生成 MongoDB 驱动卸载目标" FORCE)
set(ENABLE_SNAPPY OFF CACHE STRING "不启用 Snappy" FORCE)
set(ENABLE_ZSTD OFF CACHE STRING "不启用 Zstd" FORCE)
set(ENABLE_ZLIB BUNDLED CACHE STRING "使用 C Driver 自带 zlib 源码" FORCE)
set(ENABLE_SSL OFF CACHE STRING "受信任内网不启用 TLS" FORCE)
set(ENABLE_SASL OFF CACHE STRING "不启用 SASL" FORCE)
set(ENABLE_SRV OFF CACHE BOOL "不解析 mongodb+srv" FORCE)
set(ENABLE_CLIENT_SIDE_ENCRYPTION OFF CACHE STRING "不启用客户端字段加密" FORCE)
set(ENABLE_MONGODB_AWS_AUTH OFF CACHE STRING "不启用 MongoDB AWS 认证" FORCE)
set(MONGOC_MINIMAL_BUILD ON CACHE BOOL "只构建 C Driver 运行时目标" FORCE)
set(MONGOCXX_MINIMAL_BUILD ON CACHE BOOL "只构建 C++ Driver 运行时目标" FORCE)

# 不让两个上游驱动把自己的测试、示例和打包目标导入 svc_game3d。
set(_mongo_saved_build_testing "${BUILD_TESTING}")
set(BUILD_TESTING OFF)

set(BUILD_VERSION "${_mongo_c_driver_version}")
add_subdirectory("${_mongo_c_driver_source}" "${CMAKE_CURRENT_BINARY_DIR}/_mongo_vendor/mongo-c-driver" EXCLUDE_FROM_ALL)

set(BUILD_SHARED_LIBS OFF)
set(BUILD_SHARED_AND_STATIC_LIBS OFF)
set(BUILD_SHARED_LIBS_WITH_STATIC_MONGOC OFF)
set(BUILD_VERSION "${_mongo_cxx_driver_version}")
set(ENABLE_ABI_TAG_IN_LIBRARY_FILENAMES OFF)
set(ENABLE_ABI_TAG_IN_PKGCONFIG_FILENAMES OFF)
add_subdirectory("${_mongo_cxx_driver_source}" "${CMAKE_CURRENT_BINARY_DIR}/_mongo_vendor/mongo-cxx-driver" EXCLUDE_FROM_ALL)
set(BUILD_TESTING "${_mongo_saved_build_testing}")

if(NOT TARGET mongoc_static OR NOT TARGET mongocxx_static OR NOT TARGET bsoncxx_static)
    message(FATAL_ERROR "MongoDB 驱动源码目标创建失败。")
endif()

# INTERFACE 目标不生成本模块自己的 lib/a：业务源码由最终消费者（svc_game3d 或测试）直接编译。
add_library(mongo_player_storage INTERFACE)
target_sources(mongo_player_storage INTERFACE
    "${CMAKE_CURRENT_LIST_DIR}/src/AsyncMongoDispatcher.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/MongoClient.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/MongoConfig.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/PlayerMongoStorage.cpp"
)
target_include_directories(mongo_player_storage INTERFACE
    "${CMAKE_CURRENT_LIST_DIR}/include"
)
target_compile_features(mongo_player_storage INTERFACE cxx_std_20)
target_link_libraries(mongo_player_storage INTERFACE mongocxx_static)

# 本模块测试默认不影响 svc_game3d；独立验证时显式传入 ON。
option(MONGO_PLAYER_STORAGE_BUILD_TESTS "构建玩家 MongoDB 异步持久化测试" OFF)
if(MONGO_PLAYER_STORAGE_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
