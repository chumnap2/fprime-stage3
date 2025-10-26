# arm-gcc-toolchain.cmake for STM32F4 (bare-metal)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Compiler paths
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# Prevent CMake from trying to run executables (no host system)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# MCU flags (adjust as needed)
set(MCU_FLAGS "-mcpu=cortex-m4 -mthumb -ffunction-sections -fdata-sections")

set(CMAKE_C_FLAGS_INIT "${MCU_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${MCU_FLAGS} -fno-exceptions -fno-rtti")
set(CMAKE_ASM_FLAGS_INIT "${MCU_FLAGS}")

# Linker script placeholder (must exist in project root or path)
set(LINKER_SCRIPT "stm32_flash.ld")

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--gc-sections -nostartfiles -Wl,-T,${LINKER_SCRIPT}")
