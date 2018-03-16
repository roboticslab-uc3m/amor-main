cmake_minimum_required(VERSION 2.8.9 FATAL_ERROR)

project(AMOR_MAIN)

# Pick up our CMake modules.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake
                              ${CMAKE_SOURCE_DIR}/cmake/ycm-modules)

# Bootstrap YCM. Stick to v0.2.2 because of:
# https://github.com/robotology/ycm/issues/118
# ...and to keep YCM itself compatible with cmake_minimum_required().
set(YCM_TAG v0.2.2)
include(YCMBootstrap)

# Add main contents.
add_subdirectory(share)

# Configure and create uninstall target.
include(AddUninstallTarget)
