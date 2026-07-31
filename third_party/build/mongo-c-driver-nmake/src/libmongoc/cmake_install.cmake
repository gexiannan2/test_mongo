# Install script for directory: E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc

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
          
            # Installation of pkg-config for target mongoc_shared
            message(STATUS "Generating pkg-config file: mongoc2.pc")
            file(READ [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/_pkgconfig/mongoc_shared-release-for-install.txt]] content)
            # Insert the install prefix:
            string(REPLACE "%INSTALL_PLACEHOLDER%" "${CMAKE_INSTALL_PREFIX}" content "${content}")
            # Write it before installing again. Lock the file to sync with parallel installs.
            file(LOCK [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongoc_shared-pkg-config-tmp.txt.lock]] GUARD PROCESS)
            file(WRITE [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongoc_shared-pkg-config-tmp.txt]] "${content}")
        
        
    
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE RENAME "mongoc2.pc" FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongoc_shared-pkg-config-tmp.txt")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
          
            # Installation of pkg-config for target mongoc_static
            message(STATUS "Generating pkg-config file: mongoc2-static.pc")
            file(READ [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/_pkgconfig/mongoc_static-release-for-install.txt]] content)
            # Insert the install prefix:
            string(REPLACE "%INSTALL_PLACEHOLDER%" "${CMAKE_INSTALL_PREFIX}" content "${content}")
            # Write it before installing again. Lock the file to sync with parallel installs.
            file(LOCK [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongoc_static-pkg-config-tmp.txt.lock]] GUARD PROCESS)
            file(WRITE [[E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongoc_static-pkg-config-tmp.txt]] "${content}")
        
        
    
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE RENAME "mongoc2-static.pc" FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongoc_static-pkg-config-tmp.txt")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongoc2.lib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY OPTIONAL FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongoc2.dll.lib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE SHARED_LIBRARY FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongoc2.dll")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/mongoc-2.3.3/mongoc" TYPE FILE FILES
    "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/src/mongoc/mongoc-config.h"
    "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/src/mongoc/mongoc-version.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-apm.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-bulk-operation.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-bulkwrite.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-change-stream.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-client.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-client-pool.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-client-side-encryption.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-collection.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-cursor.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-database.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-error.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-flags.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-find-and-modify.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-gridfs.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-gridfs-bucket.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-gridfs-file.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-gridfs-file-page.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-gridfs-file-list.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-handshake.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-host-list.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-init.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-iovec.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-log.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-macros.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-oidc-callback.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-opcode.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-optional.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-prelude.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-read-concern.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-read-prefs.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-server-api.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-server-description.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-client-session.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-sleep.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-socket.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-stream-tls-openssl.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-stream.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-stream-buffered.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-stream-file.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-stream-gridfs.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-stream-socket.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-structured-log.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-topology-description.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-uri.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-version-functions.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-write-concern.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-rand.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-stream-tls.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-ssl.h"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/src/libmongoc/src/mongoc/mongoc-bulkwrite.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/mongoc-2.3.3/mongoc-targets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/mongoc-2.3.3/mongoc-targets.cmake"
         "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/CMakeFiles/Export/3e6ef2058ae16cf119a32c8533545804/mongoc-targets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/mongoc-2.3.3/mongoc-targets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/mongoc-2.3.3/mongoc-targets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/mongoc-2.3.3" TYPE FILE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/CMakeFiles/Export/3e6ef2058ae16cf119a32c8533545804/mongoc-targets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/mongoc-2.3.3" TYPE FILE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/CMakeFiles/Export/3e6ef2058ae16cf119a32c8533545804/mongoc-targets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/mongoc-2.3.3" TYPE FILE FILES
    "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongocConfig.cmake"
    "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/mongocConfigVersion.cmake"
    )
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake/src/libmongoc/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
