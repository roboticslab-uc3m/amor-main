cmake_minimum_required(VERSION 2.6)

SET(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR} ${CMAKE_MODULE_PATH})

find_package(AMOR_API REQUIRED)
include_directories(${AMOR_API_INCLUDE_DIRS})
link_libraries(${AMOR_API_LIBRARIES})

set(CREATE_PYTHON FALSE CACHE BOOL "Create Python interface")

find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})
message(STATUS "${SWIG_USE_FILE}")
set(MIN_SWIG_VERSION "1.3.29")

if("${SWIG_VERSION}" VERSION_LESS "${MIN_SWIG_VERSION}")
    message( FATAL_ERROR "Please update your SWIG. Current version: ${SWIG_VERSION}. "
                        "The minimum required version is: ${MIN_SWIG_VERSION}")
endif()

set_source_files_properties(amor.i PROPERTIES CPLUSPLUS ON)

if(CREATE_PYTHON)
    set(CMAKE_SWIG_OUTDIR "${CMAKE_BINARY_DIR}")
    set(CMAKE_SWIG_FLAGS "-Wall;-module;amor;-threads")
    set(CREATE_PYTHON_VERSION "" CACHE STRING "Control python version used, if you wish." )

    find_package(PythonLibs ${CREATE_PYTHON_VERSION})
    include_directories(${PYTHON_INCLUDE_PATH})
    link_libraries(${PYTHON_LIBRARY})

    # In Windows it seems necessary to declare explictly the link directory.
    if(WIN32)
        get_filename_component(PYTHON_DIR ${PYTHON_LIBRARY} PATH)
        link_directories(${PYTHON_DIR})
    endif()

    swig_add_module(amor python amor.i)

    # Uncomment if we want a debug version of the library.
    #add_definitions(-DPy_DEBUG)

    # Installation path is determined reliably on most platforms using distutils.
    find_package(PythonInterp ${CREATE_PYTHON_VERSION})

    set(PYTHON_COMMAND "from distutils import sysconfig"
                       "print(sysconfig.get_python_lib(1,0,prefix='${CMAKE_INSTALL_PREFIX}'))")

    execute_process(COMMAND ${PYTHON_EXECUTABLE} 
                    -c "${PYTHON_COMMAND}"
                    OUTPUT_VARIABLE PYTHON_INSTDIR
                    OUTPUT_STRIP_TRAILING_WHITESPACE)

    install(FILES ${CMAKE_BINARY_DIR}/amor.py ${CMAKE_BINARY_DIR}/_amor.so 
            DESTINATION ${PYTHON_INSTDIR})

    if(WIN32)
        # Check if we have a target called _amor as SWIG_ADD_MODULE
        # will currently give. If not, we're probably in the distant
        # future, and we'd best not meddle.
        get_target_property(amor_lib_location _amor LOCATION)

        if(amor_lib_location)
            set_target_properties(_amor PROPERTIES SUFFIX ".pyd")
        endif()    
    endif()
endif()

