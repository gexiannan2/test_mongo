cmake_minimum_required(VERSION 3.21)

project(MongoStandalone VERSION 1.0.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
    add_compile_options(/utf-8)
endif()

include(cmake/MongoVendorSource.cmake)
mongo_standalone_prepare_vendored_mongo()

add_library(mongo_standalone
    src/AsyncMongoDispatcher.cpp
    src/MongoClient.cpp
    src/MongoConfig.cpp
    src/PlayerMongoStorage.cpp
)
target_include_directories(mongo_standalone PUBLIC include)
target_link_libraries(mongo_standalone PUBLIC mongocxx_static)

if(MSVC)
    target_compile_options(mongo_standalone PRIVATE /W4 /permissive- /utf-8)
else()
    target_compile_options(mongo_standalone PRIVATE -Wall -Wextra -Wpedantic)
endif()

add_executable(mongo_demo src/main.cpp)
target_link_libraries(mongo_demo PRIVATE mongo_standalone)

include(CTest)
if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
