#include "MotorController.hpp"
#include "ch.h"
#include "hal.h"
#include <stdio.h>

void MotorController::init() {
    // Initialize motor hardware here
    // Example: start PWM, configure GPIO
    // For simulation, just print
    chprintf((BaseSequentialStream*)&SD1, "MotorController initialized.\r\n");
}

void MotorController::runTest() {
    // Simple test loop: toggle motor GPIO or print
    static bool state = false;
    state = !state;
    chprintf((BaseSequentialStream*)&SD1, "Motor state: %s\r\n", state ? "ON" : "OFF");
}
