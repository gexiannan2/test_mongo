# Install script for directory: E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libbson

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

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE PROGRAM FILES
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140_1.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140_2.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140_atomic_wait.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140_codecvt_ids.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/vcruntime140_1.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/vcruntime140.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/concrt140.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140_1.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140_2.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140_atomic_wait.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/msvcp140_codecvt_ids.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/vcruntime140_1.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/vcruntime140.dll"
    "C:/Program Files/Microsoft Visual Studio/18/Insiders/VC/Redist/MSVC/14.51.36231/x64/Microsoft.VC145.CRT/concrt140.dll"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE DIRECTORY FILES "")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bson2.lib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/bson_static-targets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/bson_static-targets.cmake"
         "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/CMakeFiles/Export/080ef203c0c1b5dc808ba5f8ae27a5fd/bson_static-targets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/bson_static-targets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/bson_static-targets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3" TYPE FILE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/CMakeFiles/Export/080ef203c0c1b5dc808ba5f8ae27a5fd/bson_static-targets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3" TYPE FILE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/CMakeFiles/Export/080ef203c0c1b5dc808ba5f8ae27a5fd/bson_static-targets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
          
            # Installation of pkg-config for target bson_static
            message(STATUS "Generating pkg-config file: bson2-static.pc")
            file(READ [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/_pkgconfig/bson_static-release-for-install.txt]] content)
            # Insert the install prefix:
            string(REPLACE "%INSTALL_PLACEHOLDER%" "${CMAKE_INSTALL_PREFIX}" content "${content}")
            # Write it before installing again. Lock the file to sync with parallel installs.
            file(LOCK [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bson_static-pkg-config-tmp.txt.lock]] GUARD PROCESS)
            file(WRITE [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bson_static-pkg-config-tmp.txt]] "${content}")
        
        
    
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE RENAME "bson2-static.pc" FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bson_static-pkg-config-tmp.txt")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY OPTIONAL FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bson2.dll.lib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE SHARED_LIBRARY FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bson2.dll")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/bson_shared-targets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/bson_shared-targets.cmake"
         "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/CMakeFiles/Export/080ef203c0c1b5dc808ba5f8ae27a5fd/bson_shared-targets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/bson_shared-targets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/bson_shared-targets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3" TYPE FILE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/CMakeFiles/Export/080ef203c0c1b5dc808ba5f8ae27a5fd/bson_shared-targets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3" TYPE FILE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/CMakeFiles/Export/080ef203c0c1b5dc808ba5f8ae27a5fd/bson_shared-targets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
          
            # Installation of pkg-config for target bson_shared
            message(STATUS "Generating pkg-config file: bson2.pc")
            file(READ [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/_pkgconfig/bson_shared-release-for-install.txt]] content)
            # Insert the install prefix:
            string(REPLACE "%INSTALL_PLACEHOLDER%" "${CMAKE_INSTALL_PREFIX}" content "${content}")
            # Write it before installing again. Lock the file to sync with parallel installs.
            file(LOCK [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bson_shared-pkg-config-tmp.txt.lock]] GUARD PROCESS)
            file(WRITE [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bson_shared-pkg-config-tmp.txt]] "${content}")
        
        
    
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE RENAME "bson2.pc" FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bson_shared-pkg-config-tmp.txt")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/bson-2.3.3" TYPE DIRECTORY FILES
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libbson/src/"
    "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/src/"
    FILES_MATCHING REGEX "/[^/]*\\.h$" REGEX "/[^/]*\\-private\\.h$" EXCLUDE REGEX "/jsonsl$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/00-mongo-platform-targets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/00-mongo-platform-targets.cmake"
         "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/CMakeFiles/Export/080ef203c0c1b5dc808ba5f8ae27a5fd/00-mongo-platform-targets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/00-mongo-platform-targets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3/00-mongo-platform-targets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3" TYPE FILE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/CMakeFiles/Export/080ef203c0c1b5dc808ba5f8ae27a5fd/00-mongo-platform-targets.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/bson-2.3.3" TYPE FILE FILES
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libbson/etc/bsonConfig.cmake"
    "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/bsonConfigVersion.cmake"
    )
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
