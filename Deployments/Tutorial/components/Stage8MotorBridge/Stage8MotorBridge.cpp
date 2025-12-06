#include "Stage8MotorBridge.hpp"
#include <iostream>
#include <string>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sstream>
#include <cstdlib>

Stage8MotorBridge::Stage8MotorBridge()
: currentRPM(0), currentAmps(0.0f), currentVoltage(0.0f), currentTemp(0.0f) {}

Stage8MotorBridge::~Stage8MotorBridge() {}

void Stage8MotorBridge::init() {
    std::cout << "Stage8MotorBridge initialized\n";
}

void Stage8MotorBridge::run() {
    readVescData();
}

void Stage8MotorBridge::enableMotor() {
    sendJulia("ENABLE");
}

void Stage8MotorBridge::disableMotor() {
    sendJulia("DISABLE");
}

void Stage8MotorBridge::setDuty(float duty) {
    sendJulia("SET_DUTY:" + std::to_string(duty));
}

uint16_t Stage8MotorBridge::readRPM() {
    return getVescRPM();
}

float Stage8MotorBridge::readCurrent() {
    return getVescCurrent();
}

float Stage8MotorBridge::readVoltage() {
    return getVescVoltage();
}

float Stage8MotorBridge::readTemperature() {
    return getVescTemperature();
}

// ----------------- Private methods remain unchanged -------------------
float Stage8MotorBridge::queryJulia(const std::string &cmd) {
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        std::cerr << "[C++] Socket creation failed\n";
        return -1;
    }

    sockaddr_in serv_addr{};
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(5050);
    inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr);

    if (connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) < 0) {
        std::cerr << "[C++] Connection to Julia failed\n";
        close(sock);
        return -1;
    }

    std::string line = cmd + "\n";
    send(sock, line.c_str(), line.size(), 0);

    char buffer[128] = {0};
    int n = read(sock, buffer, sizeof(buffer) - 1);
    close(sock);

    if (n <= 0) {
        return -1;
    }

    try {
        return std::stof(buffer);
    } catch (...) {
        std::cerr << "[C++] Bad response: " << buffer << std::endl;
        return -1;
    }
}


//----------------------------------------------------------
uint16_t Stage8MotorBridge::getVescRPM() {
    return static_cast<uint16_t>(queryJulia("CURRENT_RPM?"));
}

void Stage8MotorBridge::readVescData() {
    currentRPM = getVescRPM();
    currentAmps = getVescCurrent();
    currentVoltage = getVescVoltage();
    currentTemp = getVescTemperature();

    tlmWrite_motorRPM(currentRPM);
    tlmWrite_motorCurrent(currentAmps);
    tlmWrite_motorVoltage(currentVoltage);
    tlmWrite_motorTemperature(currentTemp);

    if(currentRPM > MAX_RPM || currentAmps > MAX_CURRENT) {
        log_WARNING_motorSafetyLimitExceeded(currentRPM, currentAmps);
        stopMotor();
    }
}

void Stage8MotorBridge::stopMotor() {
    sendJulia("SET_DUTY:0.0");
    std::cout << "Motor stopped via Julia server\n";
}

float Stage8MotorBridge::getVescCurrent() {
    return queryJulia("CURRENT_CURRENT?");
}

float Stage8MotorBridge::getVescVoltage() {
    return queryJulia("CURRENT_VOLTAGE?");
}

