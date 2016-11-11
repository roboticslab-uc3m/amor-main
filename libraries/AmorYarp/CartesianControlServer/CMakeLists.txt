YARP_PREPARE_DEVICE(CartesianControlServer TYPE teo::CartesianControlServer INCLUDE CartesianControlServer.hpp WRAPPER CartesianControlServer)

IF (NOT SKIP_CartesianControlServer)

SET(CMAKE_MODULE_PATH ${TEO_MODULE_PATH} ${CMAKE_MODULE_PATH})
FIND_PACKAGE(YARP REQUIRED)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${AMOR_MAIN_INCLUDE_DIRS})

YARP_ADD_PLUGIN(CartesianControlServer CartesianControlServer.hpp CartesianControlServer.cpp DeviceDriverImpl.cpp)
TARGET_LINK_LIBRARIES(CartesianControlServer ${YARP_LIBRARIES})
INSTALL(TARGETS CartesianControlServer DESTINATION lib)

SET(AMOR_MAIN_INCLUDE_DIRS ${AMOR_MAIN_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "appended header dirs")
SET(AMOR_MAIN_LIBRARIES ${AMOR_MAIN_LIBRARIES} AmorYarp CartesianControlServer CACHE INTERNAL "appended libraries")

ENDIF (NOT SKIP_CartesianControlServer)
