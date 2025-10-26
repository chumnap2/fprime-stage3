# Minimal ChibiOS platform for F'

# Target setup
set(CMAKE_SYSTEM_NAME Generic)
set(FPRIME_PLATFORM minimal_chibios CACHE INTERNAL "F' platform identifier")
set(CMAKE_SYSTEM_PROCESSOR arm)

# Compilers
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# CPU & build options
set(CPU_FLAGS "-mcpu=cortex-m4 -mthumb")
set(COMMON_FLAGS "-ffunction-sections -fdata-sections -fno-exceptions -fno-rtti -Os -Wall -Wextra -g")
set(CMAKE_C_FLAGS_INIT   "${CPU_FLAGS} ${COMMON_FLAGS} -std=c11")
set(CMAKE_CXX_FLAGS_INIT "${CPU_FLAGS} ${COMMON_FLAGS} -std=c++17")

# Linker options
set(CMAKE_EXE_LINKER_FLAGS_INIT "${CPU_FLAGS} -nostartfiles -Wl,--gc-sections -specs=nosys.specs")

# Disable host link tests
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Toolchain environment output
message(STATUS "Using Minimal ChibiOS Toolchain for ARM Cortex-M4")
message(STATUS "C compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "Flags: ${CMAKE_CXX_FLAGS_INIT}")
