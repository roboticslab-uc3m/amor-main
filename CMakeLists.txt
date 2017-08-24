cmake_minimum_required(VERSION 2.8.9)

project(AMOR)

# Pick up our CMake modules.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Add main contents.
add_subdirectory(share)

# Configure and create uninstall target.
include(AddUninstallTarget)
