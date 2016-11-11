IF (ENABLE_AmorYarp)

    FIND_PACKAGE(YARP REQUIRED)
    INCLUDE_DIRECTORIES(${YARP_INCLUDE_DIRS})
    LIST(APPEND CMAKE_MODULE_PATH ${YARP_MODULE_PATH})
    INCLUDE(YarpPlugin)
     
    SET(AMOR_MAIN_LIBRARIES ${AMOR_MAIN_LIBRARIES} AmorYarp CACHE INTERNAL "appended libraries") 
    
    yarp_begin_plugin_library(AmorYarp)
    
    ADD_SUBDIRECTORY(BasicCartesianControl)
    ADD_SUBDIRECTORY(CartesianControlServer)
    ADD_SUBDIRECTORY(CartesianControlClient)
    
    yarp_end_plugin_library(AmorYarp)
    
    INSTALL(TARGETS AmorYarp DESTINATION lib)

ENDIF (ENABLE_AmorYarp)
