#!/bin/bash
# Build and prepare Stage3 for STM32
set -e

STAGE3_DIR=~/fprime/Stage3
BUILD_DIR="$STAGE3_DIR/build-stm32"
TOOLCHAIN_FILE="$STAGE3_DIR/Toolchain/arm-gcc.cmake"
ELF_FILE="Stage3_test"
BIN_FILE="Stage3_test.bin"
HEX_FILE="Stage3_test.hex"

# Create/clean build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
rm -rf ./*

# Build Stage3
echo "🔧 Configuring Stage3..."
cmake "$STAGE3_DIR" -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" -DCMAKE_BUILD_TYPE=Release
echo "🏗 Building Stage3..."
make -j$(nproc)

# Convert ELF to BIN and HEX
echo "📦 Generating binary files..."
arm-none-eabi-objcopy -O binary "$ELF_FILE" "$BIN_FILE"
arm-none-eabi-objcopy -O ihex "$ELF_FILE" "$HEX_FILE"

# Show resulting files
ls -lh "$ELF_FILE" "$BIN_FILE" "$HEX_FILE"

echo "✅ Stage3 build and binary preparation complete!"
