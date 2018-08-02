cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(AMOR_MAIN LANGUAGES NONE)

# Pick up our CMake modules.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake
                              ${CMAKE_SOURCE_DIR}/cmake/ycm-modules)

# Uses YCM's unmerged ExternalProject.cmake module, which handles an
# additional CONFIGURE_SOURCE_DIR option (see Buildorocos_kdl.cmake).
set(YCM_USE_CMAKE_PROPOSED ON)

# Bootstrap YCM. Keep it compatible with cmake_minimum_required().
include(YCMBootstrap)

# Superbuild phase.
include(FindOrBuildPackage)

# Pull remote packages if not found on system.
find_or_build_package(AMOR_API)
find_or_build_package(AMOR_CONFIGURATION_FILES)
find_or_build_package(AMOR_OPENRAVE_MODELS)
find_or_build_package(ROBOTICSLAB_DEVELOPER_MANUAL)
find_or_build_package(ROBOTICSLAB_INSTALLATION_GUIDES)
find_or_build_package(ROBOTICSLAB_KINEMATICS_DYNAMICS)
find_or_build_package(ROBOTICSLAB_OPENRAVE_YARP_PLUGINS)
find_or_build_package(ROBOTICSLAB_VISION)
find_or_build_package(ROBOTICSLAB_YARP_DEVICES)

# Prepare install/ directory (might be empty).
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/install)

# Install downloaded packages.
install(DIRECTORY ${CMAKE_BINARY_DIR}/install/
        DESTINATION ${CMAKE_INSTALL_PREFIX})

# Configure and create uninstall target.
include(AddUninstallTarget)