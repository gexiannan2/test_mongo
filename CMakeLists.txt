cmake_minimum_required(VERSION 3.21)

project(MongoStandalone VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
    add_compile_options(/utf-8)
endif()

find_package(mongocxx 4.4 CONFIG REQUIRED)
find_package(bsoncxx 4.4 CONFIG REQUIRED)

add_library(mongo_standalone
    src/MongoClient.cpp
    src/MongoConfig.cpp
)
target_include_directories(mongo_standalone PUBLIC include)
target_link_libraries(mongo_standalone PUBLIC mongo::mongocxx_shared)

if(MSVC)
    target_compile_options(mongo_standalone PRIVATE /W4 /permissive- /utf-8)
else()
    target_compile_options(mongo_standalone PRIVATE -Wall -Wextra -Wpedantic)
endif()

add_executable(mongo_demo src/main.cpp)
target_link_libraries(mongo_demo PRIVATE mongo_standalone)

if(WIN32)
    add_custom_command(TARGET mongo_demo POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_RUNTIME_DLLS:mongo_demo>
            $<TARGET_FILE_DIR:mongo_demo>
        COMMAND_EXPAND_LISTS
    )
endif()

include(CTest)
if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
