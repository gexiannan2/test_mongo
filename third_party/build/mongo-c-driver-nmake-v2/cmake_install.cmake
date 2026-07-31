# Install script for directory: E:/u3d/MongoStandalone/third_party/src/mongo-c-driver

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
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE DIRECTORY FILES "")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/common/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libbson/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/libmongoc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/src/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/mongo-c-driver/2.3.3" TYPE FILE FILES
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/COPYING"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/NEWS"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/README.rst"
    "E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/THIRD_PARTY_NOTICES"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
      function(__generate_uninstall)
        set(UNINSTALL_IS_WIN32 "1")
        set(UNINSTALL_WRITE_FILE "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/uninstall.cmd")
        set(UNINSTALL_SCRIPT_SELF "share/mongo-c-driver/2.3.3/uninstall.cmd")
        include("E:/u3d/MongoStandalone/third_party/src/mongo-c-driver/build/cmake/GenerateUninstaller.cmake")
    endfunction()
    __generate_uninstall()
    
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/mongo-c-driver/2.3.3" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE FILES "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/uninstall.cmd")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "E:/u3d/MongoStandalone/third_party/build/mongo-c-driver-nmake-v2/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
