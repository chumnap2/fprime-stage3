# Makefile for Stage3_test

CC      = arm-none-eabi-g++
CFLAGS  = -mcpu=cortex-m4 -mthumb -O2 -ffreestanding -Wall -std=c++17 \
          -Isrc -Isrc/stubs -Isrc/cfg -Isrc/license -Isrc/common/portability/include -Isrc/cfg -Isrc/license -Isrc/common/portability/include -Isrc/cfg -Isrc/license -Isrc/common/portability/include -Isrc/cfg -Isrc/license -Isrc/common/portability/include -Isrc/cfg -Isrc/license -Isrc/common/portability/include -Isrc/cfg -Isrc/common/portability/include -Isrc/common/portability/include -Isrc/license -Isrc/rt/include -Isrc/hal/include -Isrc/ports/STM32/STM32F4xx \
          -Isrc/startup/ARMCMx/compilers/GCC

LDFLAGS = -T stm32_flash.ld -nostartfiles
OBJS    = build/main.o
TARGET  = Stage3_test.elf

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@ $(LDFLAGS)

build/%.o: src/%.cpp
	@mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf build $(TARGET) Stage3_test.hex Stage3_test.bin
CXXFLAGS += -Isrc -Isrc/stubs
