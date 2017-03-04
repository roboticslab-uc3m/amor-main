YARP_PREPARE_DEVICE(yarpamorcontrolboard TYPE teo::YarpAmorControlboard INCLUDE YarpAmorControlboard.hpp WRAPPER controlboardwrapper2)

IF (NOT SKIP_YarpAmorControlboard)

SET(CMAKE_MODULE_PATH ${AMOR_MAIN_MODULE_PATH} ${CMAKE_MODULE_PATH})
FIND_PACKAGE(YARP REQUIRED)
FIND_PACKAGE(AMOR REQUIRED)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${AMOR_MAIN_INCLUDE_DIRS} ${YARP_INCLUDE_DIRS} ${AMOR_INCLUDE_DIRS})
LINK_DIRECTORIES(${AMOR_LINK_DIRS})

YARP_ADD_PLUGIN(yarpamorcontrolboard YarpAmorControlboard.hpp DeviceDriverImpl.cpp IControlLimitsImpl.cpp IControlModeImpl.cpp IEncodersImpl.cpp IEncodersTimedImpl.cpp IPositionImpl.cpp IPosition2Impl.cpp IVelocityImpl.cpp IVelocity2Impl.cpp)
TARGET_LINK_LIBRARIES(yarpamorcontrolboard ${YARP_LIBRARIES} ${AMOR_LIBRARIES})

INSTALL(TARGETS yarpamorcontrolboard DESTINATION lib)
 
SET(AMOR_MAIN_INCLUDE_DIRS ${AMOR_MAIN_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "appended header dirs")
SET(AMOR_MAIN_LINK_DIRS ${AMOR_MAIN_LINK_DIRS} ${AMOR_LINK_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "appended library dirs")
SET(AMOR_MAIN_LIBRARIES ${AMOR_MAIN_LIBRARIES} AmorYarp yarpamorcontrolboard CACHE INTERNAL "appended libraries")

ENDIF (NOT SKIP_YarpAmorControlboard)
