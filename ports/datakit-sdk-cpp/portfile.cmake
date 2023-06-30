vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO GuanceCloud/datakit-cpp
  REF 4e818e3eb923ae6757dcce1d05b0c643bca82e56
  SHA512 18bbed70fb37bfa62669806a8c62af210c0a0cd5aed828398e77e11338f99f4483446bd5aec74041824d84b0898da16770210e62ac530be7dd93e3f87342b001
  HEAD_REF develop
)

if(VCPKG_TARGET_IS_WINDOWS)
  set(VCPKG_TARGET_ARCHITECTURE x64)
  set(VCPKG_CRT_LINKAGE dynamic)
  set(VCPKG_LIBRARY_LINKAGE dynamic)
  set(VCPKG_CXX_FLAGS "/std:c++17 /EHa")
  set(VCPKG_C_FLAGS "/GL /Gw /GS-")
endif()

#set(VCPKG_BUILD_TYPE release)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}/src"
  PROJECT_NAME ft-sdk
  WINDOWS_USE_MSBUILD
  OPTIONS
	  -DBUILD_FROM_VCPKG=TRUE
)
vcpkg_install_cmake()

file(GLOB headers "${SOURCE_PATH}/src/datakit-sdk-cpp/ft-sdk/Include/*.h")
file(COPY ${headers} DESTINATION "${CURRENT_PACKAGES_DIR}/include/datakit-sdk-cpp")


#if (__UNDEFINED)
if(VCPKG_TARGET_IS_WINDOWS)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
      message(STATUS "copying debug")
      file(COPY "${SOURCE_PATH}/datakit_sdk_redist/debug/lib/ft-sdkd.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
      file(COPY "${SOURCE_PATH}/datakit_sdk_redist/debug/lib/ft-sdkd.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
    #else()
      message(STATUS "copying release")
      file(COPY "${SOURCE_PATH}/datakit_sdk_redist/release/lib/ft-sdk.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
      file(COPY "${SOURCE_PATH}/datakit_sdk_redist/release/lib/ft-sdk.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
    #endif()
  endif()
elseif(VCPKG_TARGET_IS_LINUX)
  message(STATUS "copying release:" VCPKG_TARGET_ARCHITECTURE)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(_ARCH_ "x86_64")
  elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(_ARCH_ "aarch64")
  endif()
  
  file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Debug/lib/${_ARCH_}/libft-sdk.so" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
  #file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Release/lib/${_ARCH_}/libft-sdk.a" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  file(COPY "${SOURCE_PATH}/datakit_sdk_redist/Release/lib/${_ARCH_}/libft-sdk.so" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
endif()
#endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")


# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)