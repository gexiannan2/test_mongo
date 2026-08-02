# Mongo 玩家异步持久化模块

供 `svc_game3d` 直接以源码方式编译的 MongoDB 玩家数据异步落地模块。

保留内容：

- 玩家快照异步投递：`AsyncMongoDispatcher`、`PlayerMongoStorage`。
- MongoDB 客户端配置与连接池：`MongoClient`、`MongoConfig`。
- `mongo-c-driver 2.3.3` 与 `mongo-cxx-driver r4.4.1` 固定源码。
- CRUD、异步派发和 QPS 基准测试。

在 `svc_game3d` 的 `CMakeLists.txt` 中接入：

```cmake
add_subdirectory(third_party/mongo_player_storage)
target_link_libraries(svc_game3d PRIVATE mongo_player_storage)
```

`mongo_player_storage` 是 INTERFACE 源码目标，模块业务 `.cpp` 会直接编译进
`svc_game3d`。不使用 vcpkg、`find_package(mongocxx)`、预编译 MongoDB DLL、SO、LIB
或 A；MongoDB 驱动的内部静态目标仅存在于构建过程，最终无需随游戏服发布。

默认关闭 TLS、SASL、SRV、压缩、上游驱动测试/示例/文档，面向受信任内网。

独立运行本模块测试：

```bash
cmake -S . -B build -DMONGO_PLAYER_STORAGE_BUILD_TESTS=ON
cmake --build build --config Release
ctest --test-dir build --output-on-failure
```
