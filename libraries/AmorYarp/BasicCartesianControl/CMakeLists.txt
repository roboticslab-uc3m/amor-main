YARP_PREPARE_DEVICE(BasicCartesianControl TYPE teo::BasicCartesianControl INCLUDE BasicCartesianControl.hpp WRAPPER CartesianControlServer)

IF (NOT SKIP_BasicCartesianControl)

SET(CMAKE_MODULE_PATH ${AMOR_MAIN_MODULE_PATH} ${CMAKE_MODULE_PATH})
FIND_PACKAGE(YARP REQUIRED)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${AMOR_MAIN_INCLUDE_DIRS})

YARP_ADD_PLUGIN(BasicCartesianControl BasicCartesianControl.hpp DeviceDriverImpl.cpp ICartesianControlImpl.cpp RateThreadImpl.cpp)
TARGET_LINK_LIBRARIES(BasicCartesianControl ${YARP_LIBRARIES} ${AMOR_MAIN_LIBRARIES})
INSTALL(TARGETS BasicCartesianControl DESTINATION lib)
 
SET(AMOR_MAIN_INCLUDE_DIRS ${AMOR_MAIN_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "appended header dirs")
SET(AMOR_MAIN_LIBRARIES ${AMOR_MAIN_LIBRARIES} AmorYarp BasicCartesianControl CACHE INTERNAL "appended libraries")

ENDIF (NOT SKIP_BasicCartesianControl)
