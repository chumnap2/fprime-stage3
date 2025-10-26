#!/bin/bash
# Stage3 + Minimal VESC Motor Control Integration
set -e

STAGE3_DIR=~/fprime/Stage3
VESC_MIN_DIR="$STAGE3_DIR/VESC_Min"
VESC_SRC_DIR="$STAGE3_DIR/VESC_Min/src"

# 1️⃣ Create directories
mkdir -p "$VESC_SRC_DIR"
echo "✅ Created VESC minimal integration directories."

# 2️⃣ Create placeholder MotorController.cpp
cat > "$VESC_SRC_DIR/MotorController.cpp" << 'EOF'
// Minimal VESC motor control stub
#include "MotorController.hpp"
#include <iostream>

void MotorController::init() {
    std::cout << "[MotorController] Init stub.\n";
}

void MotorController::loop() {
    // Example: stub loop
    std::cout << "[MotorController] Loop running...\n";
}
EOF

# 3️⃣ Create header file
cat > "$VESC_SRC_DIR/MotorController.hpp" << 'EOF'
#pragma once
#include <cstdint>

class MotorController {
public:
    void init();
    void loop();
};
EOF

# 4️⃣ Add a minimal Task wrapper in Stage3 main.cpp style
cat > "$VESC_SRC_DIR/MotorTask.hpp" << 'EOF'
#pragma once
#include "MotorController.hpp"
#include <functional>

class MotorTask {
private:
    MotorController motor;
public:
    void start() {
        motor.init();
        // simple infinite loop (simulate RTOS task)
        while(true) {
            motor.loop();
        }
    }
};
EOF

# 5️⃣ Confirm
echo "✅ Minimal VESC motor control setup complete in $VESC_MIN_DIR"
echo "You can now #include \"VESC_Min/src/MotorController.hpp\" in Stage3 and call MotorTask."
