#include "Stage8MotorBridge.hpp"
#include <iostream>

int main() {
    Stage8MotorBridge bridge;
    bridge.init();

    bridge.enableMotor();
    bridge.setDuty(0.5);

    std::cout << "[C++] RPM=" << bridge.readRPM()
              << " Current=" << bridge.readCurrent()
              << " Voltage=" << bridge.readVoltage()
              << " Temp=" << bridge.readTemperature() << "\n";

    bridge.setDuty(0.0);
    bridge.disableMotor();

    return 0;
}
