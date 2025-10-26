#ifndef CHCONF_H
#define CHCONF_H

/*
 * Minimal ChibiOS kernel settings
 */

#define CH_CFG_USE_REGISTRY        FALSE
#define CH_CFG_USE_WAITEXIT        FALSE
#define CH_CFG_USE_SEMAPHORES      FALSE
#define CH_CFG_USE_MUTEXES         FALSE
#define CH_CFG_USE_CONDVARS        FALSE
#define CH_CFG_USE_EVENTS          FALSE
#define CH_CFG_USE_MESSAGES        FALSE
#define CH_CFG_NO_IDLE_THREAD      FALSE
#define CH_CFG_TIME_QUANTUM        1
#define CH_CFG_ST_FREQUENCY        1000
#define CH_CFG_MEMCORE_SIZE        8192

#endif /* CHCONF_H */
