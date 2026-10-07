vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    message(FATAL_ERROR "guance-windows-native currently supports only x64-windows")
endif()

if(DEFINED ENV{GUANCE_WINDOWS_NATIVE_SOURCE_PATH} AND
   NOT "$ENV{GUANCE_WINDOWS_NATIVE_SOURCE_PATH}" STREQUAL "")
    file(TO_CMAKE_PATH "$ENV{GUANCE_WINDOWS_NATIVE_SOURCE_PATH}" SOURCE_PATH)
    if(NOT EXISTS "${SOURCE_PATH}/src/Guance.Windows.Native/CMakeLists.txt")
        message(FATAL_ERROR
            "GUANCE_WINDOWS_NATIVE_SOURCE_PATH does not point to the repository root")
    endif()
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO GuanceCloud/datakit-windows-desktop
        REF "vcpkg_0.1.0-alpha.10"
        SHA512 6fffc8b6ea938a551107760e60c8cb5183c1fc3618a28b61a2c1faa14d404a7a957b53a318a31b3dd9de696926bf1f5ea7d4b0ab2db67d909cb6bbc118f68ab8
        HEAD_REF main)
endif()

set(GUANCE_WINDOWS_NATIVE_BUILD_ELECTRON_BRIDGE OFF)
set(GUANCE_WINDOWS_NATIVE_BUILD_DIAGNOSTICS OFF)
set(GUANCE_WINDOWS_NATIVE_BUILD_REPLAY OFF)
if("diagnostics" IN_LIST FEATURES)
    set(GUANCE_WINDOWS_NATIVE_BUILD_DIAGNOSTICS ON)
endif()
if("replay" IN_LIST FEATURES)
    set(GUANCE_WINDOWS_NATIVE_BUILD_REPLAY ON)
endif()
if("electron-bridge" IN_LIST FEATURES)
    message(WARNING "electron-bridge is deprecated; use the npm Windows runtime for new Electron Full Mode applications. Mixed Mode continues to use vcpkg.")
    set(GUANCE_WINDOWS_NATIVE_BUILD_ELECTRON_BRIDGE ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/src/Guance.Windows.Native"
    OPTIONS
        -DBUILD_SHARED_LIBS=ON
        -DBUILD_TESTING=OFF
        -DGUANCE_WINDOWS_NATIVE_SDK_VERSION=0.1.0-alpha.10
        -DGUANCE_WINDOWS_NATIVE_BUILD_ELECTRON_BRIDGE=${GUANCE_WINDOWS_NATIVE_BUILD_ELECTRON_BRIDGE}
        -DGUANCE_WINDOWS_NATIVE_BUILD_DIAGNOSTICS=${GUANCE_WINDOWS_NATIVE_BUILD_DIAGNOSTICS}
        -DGUANCE_WINDOWS_NATIVE_BUILD_REPLAY=${GUANCE_WINDOWS_NATIVE_BUILD_REPLAY}
        -DGUANCE_WINDOWS_NATIVE_STAGE_RUNTIME=OFF)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(
    PACKAGE_NAME GuanceWindowsNative
    CONFIG_PATH lib/cmake/GuanceWindowsNative)
vcpkg_copy_pdbs()
if("electron-bridge" IN_LIST FEATURES)
    vcpkg_copy_tools(
        TOOL_NAMES guance_windows_electron_bridge
        AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright)
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
