#ifndef _MCUCONF_H_
#define _MCUCONF_H_

/* Match STM32F4xx family */
#define STM32F4XX
#define STM32F4xx_MCUCONF     TRUE
#define STM32F407xx           TRUE   /* Pick a concrete part */

/* Basic clocks */
#define STM32_VDD             330
#define STM32_HSECLK          8000000
#define STM32_LSECLK          32768
#define STM32_RTCSEL_LSE      TRUE

#endif /* _MCUCONF_H_ */
