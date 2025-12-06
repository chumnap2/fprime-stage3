#pragma once
#include <cstdint>
#include <string>
#include "Fw/Types/BasicTypes.hpp"
#include "Fw/Com/ComTypes.hpp"
#include "Fw/Tlm/TlmChannel.hpp"

class Stage8MotorBridge {
public:
    Stage8MotorBridge();
    ~Stage8MotorBridge();

    void init();
    void run();             // fetch telemetry from Julia
    void stopMotor();       // stop motor safely

    // --- PUBLIC wrappers for testing / C++ access ---
    void enableMotor();                     // sends ENABLE to Julia
    void disableMotor();                    // sends DISABLE to Julia
    void setDuty(float duty);               // send SET_DUTY:x

    uint16_t readRPM();                     // query RPM
    float readCurrent();                    // query current
    float readVoltage();                    // query voltage
    float readTemperature();                // query temperature

private:
    // --- exposed for test ---
    void sendJulia(const std::string &cmd);
    uint16_t getVescRPM();
    float getVescCurrent();
    float getVescVoltage();
    float getVescTemperature();

    void readVescData();
    TELEMETRY_TLM(uint16_t, motor_rpm);
    TELEMETRY_TLM(float, motor_current);
    TELEMETRY_TLM(float, motor_voltage);
    TELEMETRY_TLM(float, motor_temperature);

    static constexpr uint16_t MAX_RPM = 5000;
    static constexpr float MAX_CURRENT = 30.0f;

    uint16_t currentRPM;
    float currentAmps;
    float currentVoltage;
    float currentTemp;

    // TCP helper functions
    float queryJulia(const std::string &cmd);
};
