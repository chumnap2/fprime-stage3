arm-none-eabi-g++ \
  -I/home/chumnap/fprime/Stage3/minimal_chibios/src/stubs \
  -I/home/chumnap/fprime/Stage3/minimal_chibios/src \
  -I/home/chumnap/fprime/Stage3/minimal_chibios/src/cfg \
  -mcpu=cortex-m4 -mthumb -O2 -ffunction-sections -fdata-sections \
  -Wall -Wextra -fno-exceptions -fno-rtti \
  -c /home/chumnap/fprime/Stage3/minimal_chibios/src/main.cpp \
  -o /home/chumnap/fprime/Stage3/minimal_chibios/build/main.o

