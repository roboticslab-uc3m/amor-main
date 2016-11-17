YARP_PREPARE_DEVICE(YarpAmorControlboard TYPE teo::YarpAmorControlboard INCLUDE YarpAmorControlboard.hpp WRAPPER controlboardwrapper2)

IF (NOT SKIP_YarpAmorControlboard)

SET(CMAKE_MODULE_PATH ${AMOR_MAIN_MODULE_PATH} ${CMAKE_MODULE_PATH})
FIND_PACKAGE(YARP REQUIRED)
FIND_PACKAGE(AMOR REQUIRED)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${AMOR_MAIN_INCLUDE_DIRS} ${YARP_INCLUDE_DIRS} ${AMOR_INCLUDE_DIRS})

YARP_ADD_PLUGIN(YarpAmorControlboard YarpAmorControlboard.hpp DeviceDriverImpl.cpp IControlLimitsImpl.cpp IControlModeImpl.cpp IEncodersImpl.cpp IEncodersTimedImpl.cpp IPositionImpl.cpp IPosition2Impl.cpp IVelocityImpl.cpp IVelocity2Impl.cpp)
TARGET_LINK_LIBRARIES(YarpAmorControlboard ${YARP_LIBRARIES} ${AMOR_LIBRARIES})

INSTALL(TARGETS YarpAmorControlboard DESTINATION lib)
 
SET(AMOR_MAIN_INCLUDE_DIRS ${AMOR_MAIN_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "appended header dirs")
SET(AMOR_MAIN_LIBRARIES ${AMOR_MAIN_LIBRARIES} YarpAmorControlboard BasicCartesianControl CACHE INTERNAL "appended libraries")

ENDIF (NOT SKIP_YarpAmorControlboard)
