include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(orocos_kdl QUIET)
find_or_build_package(YARP QUIET)
find_or_build_package(ROBOTICSLAB_YARP_DEVICES QUIET) # proximity sensors

ycm_ep_helper(ROBOTICSLAB_KINEMATICS_DYNAMICS TYPE GIT
              STYLE GITHUB
              REPOSITORY roboticslab-uc3m/kinematics-dynamics.git
              TAG master
              DEPENDS "orocos_kdl;YARP;ROBOTICSLAB_YARP_DEVICES")
