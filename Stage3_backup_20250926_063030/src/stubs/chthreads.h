#pragma once
#include <stdint.h>
typedef void* tprio_t;
#define NORMALPRIO ((tprio_t)128)
#define THD_WORKING_AREA(name, size) char name[size]
#define chThdCreateStatic(wa, size, prio, func, arg) ((void)0)
#define chThdSleepMilliseconds(ms) ((void)0)
