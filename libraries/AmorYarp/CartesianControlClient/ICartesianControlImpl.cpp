// -*- mode:C++; tab-width:4; c-basic-offset:4; indent-tabs-mode:nil -*-

#include "../../AmorYarp/CartesianControlClient/CartesianControlClient.hpp"

// ------------------- ICartesianControl Related ------------------------------------

bool teo::CartesianControlClient::stat(int &state, std::vector<double> &x)
{
    yarp::os::Bottle cmd, response;

    cmd.addVocab(VOCAB_CC_STAT);

    rpcClient.write(cmd,response);

    state = response.get(0).asVocab();
    x.resize(response.size()-1);
    for(size_t i=0; i<response.size()-1; i++)
        x[i] = response.get(i+1).asDouble();
    return true;
}

// -----------------------------------------------------------------------------

bool teo::CartesianControlClient::inv(const std::vector<double> &xd, std::vector<double> &q)
{
    yarp::os::Bottle cmd, response;

    cmd.addVocab(VOCAB_CC_INV);
    for(size_t i=0; i<xd.size(); i++)
        cmd.addDouble(xd[i]);

    rpcClient.write(cmd,response);

    if( response.get(0).isVocab() )
    {
        if( response.get(0).asVocab() == VOCAB_FAILED )
        {
            return false;
        }
    }

    for(size_t i=0; i<response.size(); i++)
        q.push_back(response.get(i).asDouble());

    return true;
}

// -----------------------------------------------------------------------------

bool teo::CartesianControlClient::movj(const std::vector<double> &xd)
{
    yarp::os::Bottle cmd, response;

    cmd.addVocab(VOCAB_CC_MOVJ);
    for(size_t i=0; i<xd.size(); i++)
        cmd.addDouble(xd[i]);

    rpcClient.write(cmd,response);

    if( response.get(0).isVocab() )
    {
        if( response.get(0).asVocab() == VOCAB_FAILED )
        {
            return false;
        }
    }

    return true;
}

// -----------------------------------------------------------------------------

bool teo::CartesianControlClient::relj(const std::vector<double> &xd)
{
    yarp::os::Bottle cmd, response;

    cmd.addVocab(VOCAB_CC_RELJ);
    for(size_t i=0; i<xd.size(); i++)
        cmd.addDouble(xd[i]);

    rpcClient.write(cmd,response);

    if( response.get(0).isVocab() )
    {
        if( response.get(0).asVocab() == VOCAB_FAILED )
        {
            return false;
        }
    }

    return true;
}

// -----------------------------------------------------------------------------

bool teo::CartesianControlClient::movl(const std::vector<double> &xd)
{
    yarp::os::Bottle cmd, response;

    cmd.addVocab(VOCAB_CC_MOVL);
    for(size_t i=0; i<xd.size(); i++)
        cmd.addDouble(xd[i]);

    rpcClient.write(cmd,response);

    if( response.get(0).isVocab() )
    {
        if( response.get(0).asVocab() == VOCAB_FAILED )
        {
            return false;
        }
    }

    return true;
}

// -----------------------------------------------------------------------------

bool teo::CartesianControlClient::movv(const std::vector<double> &xdotd)
{
    yarp::os::Bottle cmd, response;

    cmd.addVocab(VOCAB_CC_MOVV);
    for(size_t i=0; i<xdotd.size(); i++)
        cmd.addDouble(xdotd[i]);

    rpcClient.write(cmd,response);

    if( response.get(0).isVocab() )
    {
        if( response.get(0).asVocab() == VOCAB_FAILED )
        {
            return false;
        }
    }

    return true;
}

// -----------------------------------------------------------------------------

bool teo::CartesianControlClient::gcmp()
{
    yarp::os::Bottle cmd, response;

    cmd.addVocab(VOCAB_CC_GCMP);

    rpcClient.write(cmd,response);

    if( response.get(0).asVocab() == VOCAB_FAILED )
    {
        return false;
    }

    return true;
}

// -----------------------------------------------------------------------------

bool teo::CartesianControlClient::forc(const std::vector<double> &td)
{
    yarp::os::Bottle cmd, response;

    cmd.addVocab(VOCAB_CC_FORC);
    for(size_t i=0; i<td.size(); i++)
        cmd.addDouble(td[i]);

    rpcClient.write(cmd,response);

    if( response.get(0).isVocab() )
    {
        if( response.get(0).asVocab() == VOCAB_FAILED )
        {
            return false;
        }
    }

    return true;
}

// -----------------------------------------------------------------------------

bool teo::CartesianControlClient::stopControl()
{
    yarp::os::Bottle cmd, response;

    cmd.addVocab(VOCAB_CC_STOP);

    rpcClient.write(cmd,response);

    if( response.get(0).asVocab() == VOCAB_FAILED )
    {
        return false;
    }

    return true;
}

// -----------------------------------------------------------------------------
