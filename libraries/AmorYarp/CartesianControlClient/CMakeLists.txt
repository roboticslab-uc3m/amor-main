YARP_PREPARE_DEVICE(CartesianControlClient TYPE teo::CartesianControlClient INCLUDE CartesianControlClient.hpp)

IF (NOT SKIP_CartesianControlClient)

SET(CMAKE_MODULE_PATH ${AMOR_MAIN_MODULE_PATH} ${CMAKE_MODULE_PATH})
FIND_PACKAGE(YARP REQUIRED)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${AMOR_MAIN_INCLUDE_DIRS})

YARP_ADD_PLUGIN(CartesianControlClient CartesianControlClient.hpp DeviceDriverImpl.cpp ICartesianControlImpl.cpp)
TARGET_LINK_LIBRARIES(CartesianControlClient ${YARP_LIBRARIES})
INSTALL(TARGETS CartesianControlClient DESTINATION lib)

SET(AMOR_MAIN_INCLUDE_DIRS ${AMOR_MAIN_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "appended header dirs")
SET(AMOR_MAIN_LIBRARIES ${AMOR_MAIN_LIBRARIES} AmorYarp CartesianControlClient CACHE INTERNAL "appended libraries")

ENDIF (NOT SKIP_CartesianControlClient)
