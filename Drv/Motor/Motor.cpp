#include "Motor.hpp"

Motor::Motor() : rpm(0) {}

void Motor::startMotor() {
    rpm = 1000; // example
}

void Motor::stopMotor() {
    rpm = 0;
}

U32 Motor::getRPM() const {
    return rpm;
}
