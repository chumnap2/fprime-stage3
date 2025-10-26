# ============================================================
#   Minimal ChibiOS toolchain configuration for F´ (Cortex-M)
# ============================================================

# ----- Target setup -----
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_NAME Generic CACHE INTERNAL "Cross compiling target")
set(FPRIME_PLATFORM minimal_chibios CACHE INTERNAL "F' platform identifier")
set(CMAKE_SYSTEM_PROCESSOR arm)

# ----- Compilers -----
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# ----- CPU & build options -----
set(CPU_FLAGS "-mcpu=cortex-m4 -mthumb")

set(COMMON_FLAGS "-ffunction-sections -fdata-sections -fno-exceptions -fno-rtti -Os -Wall -Wextra -g")

set(CMAKE_C_FLAGS_INIT   "${CPU_FLAGS} ${COMMON_FLAGS} -std=c11")
set(CMAKE_CXX_FLAGS_INIT "${CPU_FLAGS} ${COMMON_FLAGS} -std=c++17")

# ----- Linker options -----
# -nostartfiles: we provide our own startup code
# -specs=nosys.specs: disables system calls (_sbrk, _exit, etc.)
# -Wl,--gc-sections: removes unused code
set(CMAKE_EXE_LINKER_FLAGS_INIT
    "${CPU_FLAGS} -nostartfiles -Wl,--gc-sections -specs=nosys.specs"
)

# Optional: if you have a linker script (edit path)
#set(CMAKE_EXE_LINKER_FLAGS_INIT
#    "${CMAKE_EXE_LINKER_FLAGS_INIT} -T ${CMAKE_SOURCE_DIR}/link.ld"
#)

# ----- Disable host link tests -----
# Prevents CMake from trying to link a host-based executable
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# ----- Toolchain environment output -----
message(STATUS "Using Minimal ChibiOS Toolchain for ARM Cortex-M4")
message(STATUS "C compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "Flags: ${CMAKE_CXX_FLAGS_INIT}")
