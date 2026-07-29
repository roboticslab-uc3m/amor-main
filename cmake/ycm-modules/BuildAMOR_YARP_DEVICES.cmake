include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YCM QUIET)
find_or_build_package(YARP QUIET)
find_or_build_package(ROBOTICSLAB_KINEMATICS_DYNAMICS QUIET)

ycm_ep_helper(AMOR_YARP_DEVICES TYPE GIT
              STYLE GITHUB
              REPOSITORY roboticslab-uc3m/amor-yarp-devices.git
              TAG master
              DEPENDS "YCM;YARP;ROBOTICSLAB_KINEMATICS_DYNAMICS")
