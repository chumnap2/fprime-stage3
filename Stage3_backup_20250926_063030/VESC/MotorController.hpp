#pragma once
#include <cstdint>
#include <iostream>

class MotorController {
public:
    MotorController() = default;

    void init() {
        std::cout << "[MotorController] init() called\n";
    }

    void test() {
        std::cout << "[MotorController] test() called\n";
    }

    void setDuty(float duty) {
        std::cout << "[MotorController] setDuty(" << duty << ")\n";
    }

    float getCurrent() {
        std::cout << "[MotorController] getCurrent()\n";
        return 0.0f;
    }
};
