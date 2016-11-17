CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

# Start a project.
PROJECT(AMOR)

### options: cpp libraries
OPTION(ENABLE_AmorYarp "Choose if you want to compile AmorYarp" TRUE)

### options: force default
OPTION(ENABLE_AmorYarp_BasicCartesianControl "Enable/disable compilation of AmorYarp_BasicCartesianControl" TRUE)
OPTION(ENABLE_AmorYarp_CartesianControlServer "Enable/disable compilation of AmorYarp_CartesianControlServer" TRUE)
OPTION(ENABLE_AmorYarp_CartesianControlClient "Enable/disable compilation of AmorYarp_CartesianControlClient" TRUE)

# ColorDebug options.
OPTION(ColorDebug_FULL_FILE "Choose if you want to compile with CD_FULL_FILE" FALSE)
IF (ColorDebug_FULL_FILE)
    ADD_DEFINITIONS(-DCD_FULL_FILE)
ENDIF (ColorDebug_FULL_FILE)

OPTION(ColorDebug_HIDE_ERROR "Choose if you want to compile with CD_HIDE_ERROR" FALSE)
IF (ColorDebug_HIDE_ERROR)
    ADD_DEFINITIONS(-DCD_HIDE_ERROR)
ENDIF (ColorDebug_HIDE_ERROR)

OPTION(ColorDebug_HIDE_WARNING "Choose if you want to compile with CD_HIDE_WARNING" FALSE)
IF (ColorDebug_HIDE_WARNING)
    ADD_DEFINITIONS(-DCD_HIDE_WARNING)
ENDIF (ColorDebug_HIDE_WARNING)

OPTION(ColorDebug_HIDE_SUCCESS "Choose if you want to compile with CD_HIDE_SUCCESS" FALSE)
IF (ColorDebug_HIDE_SUCCESS)
    ADD_DEFINITIONS(-DCD_HIDE_SUCCESS)
ENDIF (ColorDebug_HIDE_SUCCESS)

OPTION(ColorDebug_HIDE_INFO "Choose if you want to compile with CD_HIDE_INFO" FALSE)
IF (ColorDebug_HIDE_INFO)
    ADD_DEFINITIONS(-DCD_HIDE_INFO)
ENDIF (ColorDebug_HIDE_INFO)

OPTION(ColorDebug_HIDE_DEBUG "Choose if you want to compile with CD_HIDE_DEBUG" FALSE)
IF (ColorDebug_HIDE_DEBUG)
    ADD_DEFINITIONS(-DCD_HIDE_DEBUG)
ENDIF (ColorDebug_HIDE_DEBUG)

# Set module path.
SET(AMOR_MAIN_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
LIST(APPEND CMAKE_MODULE_PATH ${AMOR_MAIN_MODULE_PATH})

# Set variables for config file.
SET(AMOR_MAIN_INCLUDE_DIRS CACHE INTERNAL "appended header dirs" FORCE)
SET(AMOR_MAIN_LINK_DIRS CACHE INTERNAL "appended link dirs" FORCE)
SET(AMOR_MAIN_LIBRARIES CACHE INTERNAL "appended libraries" FORCE)

# Set location for binary output.
SET(LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/lib")
SET(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}/bin")

# Define subdirectories.
ADD_SUBDIRECTORY("libraries")
ADD_SUBDIRECTORY("programs")

# Export variables.
SET(AMOR_MAIN_LINK_DIRS ${AMOR_MAIN_LINK_DIRS} "${LIBRARY_OUTPUT_PATH}")

# Configure AMORConfig.cmake.
CONFIGURE_FILE("${CMAKE_SOURCE_DIR}/cmake/template/AMOR_MAINConfig.cmake.in"
               "${CMAKE_BINARY_DIR}/AMOR_MAINConfig.cmake" @ONLY)

# Configure and create uninstall target.
CONFIGURE_FILE("${CMAKE_SOURCE_DIR}/cmake/template/AMOR_MAINConfigUninstall.cmake.in"
               "${CMAKE_BINARY_DIR}/AMOR_MAINConfigUninstall.cmake" IMMEDIATE @ONLY)

ADD_CUSTOM_TARGET(uninstall
    COMMAND ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_BINARY_DIR}/AMOR_MAINConfigUninstall.cmake")
