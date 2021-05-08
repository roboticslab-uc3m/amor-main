include(YCMEPHelper)


ycm_ep_helper(AMOR_API TYPE GIT
              STYLE GITHUB
              REPOSITORY roboticslab-uc3m/amor-api.git
              TAG master
              CMAKE_CACHE_ARGS "-DENABLE_udev_rules:BOOL=OFF")
