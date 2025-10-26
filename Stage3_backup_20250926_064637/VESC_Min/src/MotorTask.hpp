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
