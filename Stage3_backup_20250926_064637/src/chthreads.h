typedef unsigned int tprio_t;
#define NORMALPRIO ((tprio_t)128)
#define THD_WORKING_AREA(name, size) char name[size]
#define chThdCreateStatic(wa, sz, prio, fn, arg) ((void*)0)
#define chThdSleepMilliseconds(ms) ((void)0)

static THD_WORKING_AREA(waMotorThread, 256);
static void MotorThread(void *arg) { (void)arg; while(1) {} }
