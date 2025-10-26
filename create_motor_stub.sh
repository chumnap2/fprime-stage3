#!/bin/bash

# Directory for VESC stubs
VESC_DIR=~/fprime/Stage3/VESC
mkdir -p "$VESC_DIR"

# Create MotorController.hpp
cat > "$VESC_DIR/MotorController.hpp" << 'EOF'
#pragma once
#include <cstdint>
#include <iostream>

class MotorController {
public:
    MotorController() = default;

    // Initialize motor controller (stub)
    void init() {
        std::cout << "[MotorController] init() called\n";
    }

    // Run test sequence (stub)
    void test() {
        std::cout << "[MotorController] test() called\n";
    }

    // Optional: add more VESC methods later
    void setDuty(float duty) {
        std::cout << "[MotorController] setDuty(" << duty << ")\n";
    }

    float getCurrent() {
        std::cout << "[MotorController] getCurrent()\n";
        return 0.0f;
    }
};
EOF

echo "✅ MotorController.hpp stub created in $VESC_DIR"
