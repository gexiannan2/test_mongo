include(CMakeFindDependencyMacro)
find_dependency(mongoc 2.3.3)
find_dependency(bsoncxx 4..)
include("${CMAKE_CURRENT_LIST_DIR}/mongocxx_targets.cmake")
