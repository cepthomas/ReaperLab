
cmake_minimum_required(VERSION 3.10)

project(reaper_xyz_extension VERSION 0.1.0 LANGUAGES CXX)

message(STATUS "sdk path: $ENV{REAPER_SDK_PATH}")

set(SOURCES
    main.cpp
    )

# If we are not on Windows, we need to use SWELL
if (NOT WIN32)
    list(APPEND SOURCES $ENV{REAPER_SDK_PATH}/sdk/WDL/swell/swell-modstub-generic.cpp)
endif()

add_library(reaper_xyz_extension SHARED ${SOURCES})

target_include_directories(reaper_xyz_extension
    PRIVATE
    $ENV{REAPER_SDK_PATH}/sdk
    $ENV{REAPER_SDK_PATH}/WDL
    )

# If we use SWELL, we want to use the SWELL which REAPER provides itself
if (NOT WIN32)
    target_compile_definitions(reaper_xyz_extension PRIVATE SWELL_PROVIDED_BY_APP)
endif()

# REAPER loads plugins only if they start with reaper_, not libreaper_ (so we need to strip "lib" prefix)
SET_TARGET_PROPERTIES(reaper_xyz_extension PROPERTIES PREFIX "")

# We want strict C++-11
target_compile_features(reaper_xyz_extension PRIVATE cxx_std_11)
set_target_properties(reaper_xyz_extension PROPERTIES CXX_EXTENSIONS OFF)