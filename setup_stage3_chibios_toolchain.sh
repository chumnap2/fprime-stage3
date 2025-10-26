#!/bin/bash
# setup_stage3_chibios_toolchain.sh
# Author: chumnap thach
# Date: 2025-09-24
# Description: Minimal CMake toolchain for Stage3 + STM32F4 + ChibiOS HAL

set -e

TOOLCHAIN_FILE=~/fprime/Stage3/Toolchain/arm-chibios.cmake
mkdir -p $(dirname "$TOOLCHAIN_FILE")

cat > "$TOOLCHAIN_FILE" << 'EOF'
# Minimal STM32F4 + ChibiOS Toolchain for CMake

SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR arm)

# Cross compiler
SET(CMAKE_C_COMPILER   arm-none-eabi-gcc)
SET(CMAKE_CXX_COMPILER arm-none-eabi-g++)
SET(CMAKE_OBJCOPY      arm-none-eabi-objcopy)
SET(CMAKE_SIZE         arm-none-eabi-size)

# Common compiler flags
SET(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall")
SET(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++17")

# Linker flags
SET(CMAKE_EXE_LINKER_FLAGS "-T${CMAKE_SOURCE_DIR}/STM32F4XX.ld -Wl,--gc-sections")

# Disable Cube HAL
SET(STM32_USE_CUBE_HAL OFF)
EOF

echo "✅ CMake toolchain for Stage3 + STM32 + ChibiOS HAL created at:"
echo "   $TOOLCHAIN_FILE"
