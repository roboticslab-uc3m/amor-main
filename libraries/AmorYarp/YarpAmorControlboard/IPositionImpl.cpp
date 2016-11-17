// -*- mode:C++; tab-width:4; c-basic-offset:4; indent-tabs-mode:nil -*-

#include "YarpAmorControlboard.hpp"

// ------------------- IPositionControl Related --------------------------------

bool teo::YarpAmorControlboard::getAxes(int *ax) {
    CD_INFO("\n");
    *ax = axes;
    CD_INFO("Reporting %d axes are present\n", *ax);
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::setPositionMode() {
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::positionMove(int j, double ref) {  // encExposed = ref;
    CD_INFO("\n");
    if ((unsigned int)j>axes) {
        fprintf(stderr,"[FakeControlboardOR] error: axis index more than axes.\n");
        return false;
    }

    AMOR_VECTOR7 refs;

    for (unsigned int i = 0; i < AMOR_NUM_JOINTS; i++) {
        if (i == j)
            refs[i] = ref * 180 / 3.14159;
        else
            refs[i] = 0;
    }

    return amor_set_positions(handle, refs) == AMOR_SUCCESS;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::positionMove(const double *refs) {  // encExposed = refs;
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::relativeMove(int j, double delta) {
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::relativeMove(const double *deltas) {  // encExposed = deltas + encExposed
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::checkMotionDone(int j, bool *flag) {
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::checkMotionDone(bool *flag) {
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::setRefSpeed(int j, double sp) {
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::setRefSpeeds(const double *spds) {
    CD_INFO("\n");
    bool ok = true;
    for(unsigned int i=0;i<axes;i++)
        ok &= setRefSpeed(i,spds[i]);
    return ok;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::setRefAcceleration(int j, double acc) {
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::setRefAccelerations(const double *accs) {
    CD_INFO("\n");
    bool ok = true;
    for(unsigned int i=0;i<axes;i++)
        ok &= setRefAcceleration(i,accs[i]);
    return ok;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::getRefSpeed(int j, double *ref) {
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::getRefSpeeds(double *spds) {
    CD_INFO("\n");
    bool ok = true;
    for(unsigned int i=0;i<axes;i++)
        ok &= getRefSpeed(i,&spds[i]);
    return ok;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::getRefAcceleration(int j, double *acc) {
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::getRefAccelerations(double *accs) {
    CD_INFO("\n");
    bool ok = true;
    for(unsigned int i=0;i<axes;i++)
        ok &= getRefAcceleration(i,&accs[i]);
    return ok;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::stop(int j) {
    CD_INFO("NOTHING TO DO\n");
    return true;
}

// -----------------------------------------------------------------------------

bool teo::YarpAmorControlboard::stop() {
    CD_INFO("\n");
    bool ok = true;
    for(unsigned int i=0;i<axes;i++)
        ok &= stop(i);
    return ok;
}

// -----------------------------------------------------------------------------

