add_executable(mongo_tests MongoCrudTest.cpp)
target_link_libraries(mongo_tests PRIVATE mongo_standalone)

add_executable(mongo_async_dispatch_tests MongoAsyncDispatcherTest.cpp)
target_link_libraries(mongo_async_dispatch_tests PRIVATE mongo_standalone)

add_executable(mongo_player_benchmark MongoPlayerBenchmark.cpp)
target_link_libraries(mongo_player_benchmark PRIVATE mongo_standalone mongo::mongocxx_shared)

if(MSVC)
    target_compile_options(mongo_tests PRIVATE /W4 /permissive- /utf-8)
    target_compile_options(mongo_async_dispatch_tests PRIVATE /W4 /permissive- /utf-8)
    target_compile_options(mongo_player_benchmark PRIVATE /W4 /permissive- /utf-8)
else()
    target_compile_options(mongo_tests PRIVATE -Wall -Wextra -Wpedantic)
    target_compile_options(mongo_async_dispatch_tests PRIVATE -Wall -Wextra -Wpedantic)
    target_compile_options(mongo_player_benchmark PRIVATE -Wall -Wextra -Wpedantic)
endif()

if(WIN32)
    add_custom_command(TARGET mongo_tests POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_RUNTIME_DLLS:mongo_tests>
            $<TARGET_FILE_DIR:mongo_tests>
        COMMAND_EXPAND_LISTS
    )
endif()

if(WIN32)
    add_custom_command(TARGET mongo_async_dispatch_tests POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_RUNTIME_DLLS:mongo_async_dispatch_tests>
            $<TARGET_FILE_DIR:mongo_async_dispatch_tests>
        COMMAND_EXPAND_LISTS
    )
endif()

if(WIN32)
    add_custom_command(TARGET mongo_player_benchmark POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_RUNTIME_DLLS:mongo_player_benchmark>
            $<TARGET_FILE_DIR:mongo_player_benchmark>
        COMMAND_EXPAND_LISTS
    )
endif()

add_test(NAME mongo.crud COMMAND mongo_tests)
set_tests_properties(mongo.crud PROPERTIES TIMEOUT 45 LABELS "integration;mongodb")

add_test(NAME mongo.async_dispatch COMMAND mongo_async_dispatch_tests)
set_tests_properties(mongo.async_dispatch PROPERTIES TIMEOUT 45 LABELS "integration;mongodb;async")

add_test(NAME mongo.smoke COMMAND mongo_demo write-read)
set_tests_properties(mongo.smoke PROPERTIES TIMEOUT 20 LABELS "smoke;mongodb")
