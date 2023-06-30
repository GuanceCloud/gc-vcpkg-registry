vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO GuanceCloud/datakit-cpp
  REF f7492b853b7372c7fedde73aab010bbced20c177
  SHA512 cc4db0bbf769fbe2fd959bc0b293f26ca0afeb5559c2d4eed39796fa38a1d8b95108a0bfe2eb1501ed6d0ce0c35ff6e066b4efe7c67994ea0ea4ad4561446380
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