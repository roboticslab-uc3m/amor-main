//////////////////////////////////////////////////////////////////////////
// 
// This is a configuration file to explain AMOR_API to SWIG

%module amor

%{
/* Includes the header in the wrapper code */
#include "RobotManager.hpp"
%}

/* Parse the header file to generate wrappers */
%include "RobotManager.hpp"

%{
#include <yarp/dev/all.h>
rd::RobotManager *viewRobotManager(yarp::dev::PolyDriver& d)
{
    rd::RobotManager *result;
    d.view(result);
    return result;
}
%}
extern rd::RobotManager *viewRobotManager(yarp::dev::PolyDriver& d);

