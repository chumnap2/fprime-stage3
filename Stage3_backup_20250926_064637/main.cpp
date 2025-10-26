#include "ChibiOs/Task.hpp"
#include "VESC/MotorController.hpp"
#include <iostream>

int main() {
    std::cout << "✅ Stage3 main.cpp stub running\n";

    // Create motor controller instance
    MotorController motor;

    // Initialize and test motor
    motor.init();
    motor.test();

    // Create a task using ChibiOs stub
    Task motorTask;
    motorTask.start([&]() {
        std::cout << "🔹 Motor task running\n";
        motor.setDuty(0.5f);
        float current = motor.getCurrent();
        std::cout << "Motor current: " << current << "\n";
    });

    std::cout << "✅ Stage3 main.cpp stub finished\n";
    return 0;
}
