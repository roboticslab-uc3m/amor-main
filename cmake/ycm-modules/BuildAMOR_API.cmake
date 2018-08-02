include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET) # cartesianRate program

ycm_ep_helper(AMOR_API TYPE GIT
              STYLE GITHUB
              REPOSITORY roboticslab-uc3m/amor-api.git
              TAG master
              DEPENDS YARP
              CMAKE_CACHE_ARGS "-DENABLE_udev_rules:BOOL=OFF")
