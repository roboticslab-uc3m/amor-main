//////////////////////////////////////////////////////////////////////////
// 
// This is a configuration file to explain AMOR_API to SWIG
//
// Keep this interface file up-to-date with the latest amor.h interface.

%module amor

%{
/* Includes the header in the wrapper code */
#include "amor.h"
%}

/* Parse the header file to generate wrappers */
#include "amor.h"

%include "typemaps.i"

%apply int* OUTPUT { int* major, int* minor, int* build, int* status };

// http://stackoverflow.com/a/20112840
%apply int* OUTPUT { amor_movement_status* status };

// http://stackoverflow.com/a/5785356
// This tells SWIG to treat double * as a special case
%typemap(in) double * {
  /* Check if is a list */
  if (PyList_Check($input)) {
    int size = PyList_Size($input);
    int i = 0;
    $1 = (double *) malloc((size+1)*sizeof(double));
    for (i = 0; i < size; i++) {
      PyObject *o = PyList_GetItem($input,i);
      if (PyFloat_Check(o))
	$1[i] = PyFloat_AsDouble(PyList_GetItem($input,i));
      else {
	PyErr_SetString(PyExc_TypeError,"list must contain floats");
	free($1);
	return NULL;
      }
    }
    $1[i] = 0;
  } else {
    PyErr_SetString(PyExc_TypeError,"not a list");
    return NULL;
  }
}

// This cleans up the double * array we malloc'd before the function call
%typemap(freearg) double * {
  free((double *) $1);
}

enum amor_movement_status{
    /// AMOR is moving
    AMOR_MOVEMENT_STATUS_MOVING,
    /// Movement is pending
    AMOR_MOVEMENT_STATUS_PENDING,
    /// AMOR reached the requested position
    AMOR_MOVEMENT_STATUS_FINISHED
};

void amor_get_library_version(int* major, int* minor, int* build);
void* amor_connect(char* libraryName, int can_port);
int amor_set_currents(void* handle, double* currents);
//int amor_get_req_currents(void* handle, AMOR_VECTOR7 *currents);
//int amor_get_actual_currents(void* handle, AMOR_VECTOR7 *currents);
int amor_set_voltages(void* handle, double* voltages);
//int amor_get_req_voltages(void* handle, AMOR_VECTOR7 *voltages);
//int amor_get_actual_voltages(void* handle, AMOR_VECTOR7* voltages);
int amor_set_positions(void* handle, double* positions);
//int amor_get_req_positions(void* handle, AMOR_VECTOR7* positions);
//int amor_get_actual_positions(void* handle, AMOR_VECTOR7* positions);
int amor_set_velocities(void* handle, double* velocities);
//int amor_get_req_velocities(void* handle, AMOR_VECTOR7* velocities);
//int amor_get_actual_velocities(void* handle, AMOR_VECTOR7* velocities);
int amor_emergency_stop(void* handle);
int amor_controlled_stop(void* handle);
int amor_release(void* handle);
int amor_get_status(void* handle, int joint, int *status);
//int amor_get_joint_info(void* handle, int joint, AMOR_JOINT_INFO* parameters);
int amor_get_movement_status(void* handle, amor_movement_status* status);
int amor_set_cartesian_velocities(void* handle, double* velocities);
int amor_set_cartesian_positions(void* handle, double* positions);
//int amor_get_cartesian_position(void* handle, AMOR_VECTOR7 &positions);
int amor_open_hand(void* handle);
int amor_close_hand(void* handle);
int amor_stop_hand(void* handle);
unsigned int amor_errno();
const char* amor_error();

