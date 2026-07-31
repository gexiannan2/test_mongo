# Install script for directory: E:/u3d/MongoStandalone/third_party/src/mongo-cxx-driver/src/bsoncxx/cmake

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "E:/u3d/MongoStandalone/third_party/mongodb")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY OPTIONAL FILES "E:/u3d/MongoStandalone/third_party/build/mongo-cxx-driver-nmake-v3/src/bsoncxx/bsoncxx1-v1-rhs-md.lib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE SHARED_LIBRARY FILES "E:/u3d/MongoStandalone/third_party/build/mongo-cxx-driver-nmake-v3/src/bsoncxx/bsoncxx1-v1-rhs-md.dll")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bsoncxx-4.4.1/bsoncxx_targets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bsoncxx-4.4.1/bsoncxx_targets.cmake"
         "E:/u3d/MongoStandalone/third_party/build/mongo-cxx-driver-nmake-v3/src/bsoncxx/cmake/CMakeFiles/Export/8e97c5eb078b13731ba830e31105509a/bsoncxx_targets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bsoncxx-4.4.1/bsoncxx_targets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bsoncxx-4.4.1/bsoncxx_targets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/bsoncxx-4.4.1" TYPE FILE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-cxx-driver-nmake-v3/src/bsoncxx/cmake/CMakeFiles/Export/8e97c5eb078b13731ba830e31105509a/bsoncxx_targets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/bsoncxx-4.4.1" TYPE FILE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-cxx-driver-nmake-v3/src/bsoncxx/cmake/CMakeFiles/Export/8e97c5eb078b13731ba830e31105509a/bsoncxx_targets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/bsoncxx-4.4.1" TYPE FILE FILES
    "E:/u3d/MongoStandalone/third_party/build/mongo-cxx-driver-nmake-v3/src/bsoncxx/cmake/bsoncxxConfigVersion.cmake"
    "E:/u3d/MongoStandalone/third_party/build/mongo-cxx-driver-nmake-v3/src/bsoncxx/cmake/bsoncxxConfig.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE RENAME "libbsoncxx1.pc" FILES "E:/u3d/MongoStandalone/third_party/build/mongo-cxx-driver-nmake-v3/src/bsoncxx/cmake/libbsoncxx1-v1-rhs-md.pc")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "E:/u3d/MongoStandalone/third_party/build/mongo-cxx-driver-nmake-v3/src/bsoncxx/cmake/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
