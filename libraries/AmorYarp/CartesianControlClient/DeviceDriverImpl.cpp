// -*- mode:C++; tab-width:4; c-basic-offset:4; indent-tabs-mode:nil -*-

#include "../../AmorYarp/CartesianControlClient/CartesianControlClient.hpp"

// ------------------- DeviceDriver Related ------------------------------------

bool teo::CartesianControlClient::open(yarp::os::Searchable& config) {

    std::string local = config.check("cartesianLocal",yarp::os::Value(DEFAULT_CARTESIAN_LOCAL),"cartesianLocal").asString();
    std::string remote = config.check("cartesianRemote",yarp::os::Value(DEFAULT_CARTESIAN_REMOTE),"cartesianRemote").asString();

    local += "/rpc:c";
    rpcClient.open(local);

    remote += "/rpc:s";

    int tries = 0;
    while(tries++ < 10)
    {
        yarp::os::Network::connect(local,remote);
        if( rpcClient.getOutputCount() > 0) break;
        CD_DEBUG("Wait to connect to remote, try %d...\n",tries);
        yarp::os::Time::delay(0.5);
    }

    if (tries == 11)
    {
        CD_ERROR("Timeout on connect to remote!\n");
        return false;
    }

    CD_SUCCESS("Connected to remote.\n");

    return true;
}

// -----------------------------------------------------------------------------

bool teo::CartesianControlClient::close()
{
    rpcClient.close();
    return true;
}

// -----------------------------------------------------------------------------
