vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO GuanceCloud/datakit-cpp
  REF ba0973b138ec95afe7753663e33334ab6c0f1ff7
  SHA512 a3a040df76f7a7b29f8534bcb1dd1c037d644543caba4e715d1dab878bcd34b9fe8dae162b69afc5bf201d2d99d2be313a133119636c0f8a2bc65680375f9e30
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

  CONFIGURE_ENVIRONMENT_VARIABLES
        BUILD_FROM_VCPKG=TRUE
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
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    file(GLOB libs "${SOURCE_PATH}/lib/x86_64/*")
    file(COPY ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  endif()
endif()
#endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")


# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)