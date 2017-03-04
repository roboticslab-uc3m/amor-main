// -*- mode:C++; tab-width:4; c-basic-offset:4; indent-tabs-mode:nil -*-

#include "CartesianServer.h"

/************************************************************************/
CartesianServer::CartesianServer() { }

/************************************************************************/
bool CartesianServer::configure(ResourceFinder &rf) {

    ConstString controller = DEFAULT_CONTROLLER;
    ConstString prefix = DEFAULT_PREFIX;
    ConstString movjLocal = DEFAULT_MOVJ_LOCAL;
    ConstString movjRemote = DEFAULT_MOVJ_REMOTE;
    csStatus = new int;
    *csStatus = 0;

    printf("--------------------------------------------------------------\n");
    if (rf.check("help")) {
        printf("CartesianServer options:\n");
        printf("\t--help (this help)\t--from [file.ini]\t--context [path]\n");
        printf("\t--controller (cartesian controller device, default: \"%s\")\n",controller.c_str());
        printf("\t--prefix (port name prefix, default: \"%s\")\n",prefix.c_str());
        printf("\t--movjLocal (port we open to connect for movj, default: \"%s\")\n",movjLocal.c_str());
        printf("\t--movjRemote (port to whom we connect for movj, default: \"%s\")\n",movjRemote.c_str());
        // Do not exit: let last layer exit so we get help from the complete chain.
    }

    if (rf.check("controller")) controller = rf.find("controller").asString();
    if (rf.check("prefix")) prefix = rf.find("prefix").asString();
    if (rf.check("movjRemote")) movjRemote = rf.find("movjRemote").asString();
    if (rf.check("movjLocal")) movjLocal = rf.find("movjLocal").asString();
    printf("CartesianServer using controller: %s,  prefix: %s.\n",controller.c_str(),prefix.c_str());
    printf("CartesianServer using movjLocal: %s, movjRemote: %s.\n",movjLocal.c_str(),movjRemote.c_str());

    //------------------------------CARTESIAN--------------------------------//
    /*Property options;
    options.fromString(rf.toString());  // Get rf stuff to the cartesian device
    options.put("device",controller);
    cartesianDevice.open(options);
    if (!cartesianDevice.isValid()) {
        printf("[error] Class instantiation not worked.\n\n");
        printf("Be sure CMake \"ENABLE_RlPlugins_cartesianbot\" variable is set \"ON\"\n");
        printf("\"SKIP_cartesianbot is set\" --> should be --> \"ENABLE_cartesianbot is set\"\n\n");
        return false;
    }
    bool ok = cartesianDevice.view(icart);
    if (!ok) {
        fprintf(stderr, "[CartesianServer] warning: Problems acquiring cartesian interface.\n");
        return false;
    } else printf("[CartesianServer] success: Acquired cartesian interface.\n");*/

    //--------------------------------JOINT----------------------------------//
    Property robotOptions;
    robotOptions.fromString(rf.toString());  // Get rf stuff to the module
    robotOptions.put("device","controlboardwrapper2");
    robotOptions.put("subdevice","yarpamorcontrolboard");
    robotOptions.put("remote",movjRemote);
    robotOptions.put("local",movjLocal);
    robotDevice.open(robotOptions);
    if (!robotDevice.isValid()) {
        printf("[error] Class instantiation not worked.\n\n");
        printf("[error] movjRemote not valid, has a remotely accessible device been open?\n\n");
        return false;
    }
    bool ok2 = robotDevice.view(ipos) && robotDevice.view(imode);
    if (!ok2) {
        fprintf(stderr, "[CartesianServer] warning: Problems acquiring robot interfaces.\n");
        return false;
    } else printf("[CartesianServer] success: Acquired robot interfaces.\n");

    //---------------------CONFIGURE PORTs------------------------
    xResponder.setPositionInterface(ipos);
    xResponder.setCartesianInterface(icart);
    xResponder.setControlModeInterface(imode);
    xResponder.setCsStatus(csStatus);
    ConstString xRpcServerStr(prefix);
    xRpcServerStr += "/cartesianServer/rpc:i";
    xRpcServer.open(xRpcServerStr);
    xRpcServer.setReader(xResponder);
    xPort.setPositionInterface(ipos);
    xPort.setCartesianInterface(icart);
    xPort.setControlModeInterface(imode);
    xPort.setCsStatus(csStatus);
    ConstString xPortStr(prefix);
    xPortStr += "/cartesianServer/command:i";
    xPort.open(xPortStr);
    xPort.useCallback();
    return true;
}

/************************************************************************/
bool CartesianServer::updateModule() {
    // printf("Alive\n");
    return true;
}

/************************************************************************/
bool CartesianServer::interruptModule() {
    xRpcServer.interrupt();
    xPort.disableCallback();
    cartesianDevice.close();
    xRpcServer.close();
    xPort.close();
    delete csStatus;
    csStatus = 0;
    return true;
}

/************************************************************************/

