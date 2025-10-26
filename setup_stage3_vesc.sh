#!/bin/bash
# Stage3 + VESC Integration Template
# Author: chumnap thach
# Date: $(date +"%Y-%m-%d")

STAGE3_DIR=~/fprime/Stage3

# -------------------------------
# Create directories
mkdir -p "$STAGE3_DIR/VESC"
mkdir -p "$STAGE3_DIR/ChibiOs"
mkdir -p "$STAGE3_DIR/Toolchain"

# -------------------------------
# ChibiOs OS-layer files
cat > "$STAGE3_DIR/ChibiOs/Semaphore.hpp" << 'EOF'
#pragma once
#include <mutex>
#include <condition_variable>

class Semaphore {
private:
    int count;
    std::mutex mtx;
    std::condition_variable cv;

public:
    Semaphore(int init = 0) : count(init) {}
    void signal() { std::unique_lock<std::mutex> lock(mtx); count++; cv.notify_one(); }
    bool wait(int timeout_ms = -1) { return true; /* stub */ }
};
EOF

cat > "$STAGE3_DIR/ChibiOs/Queue.hpp" << 'EOF'
#pragma once
#include <array>
#include <optional>

template<typename T, int N>
class Queue {
private:
    std::array<T, N> buffer;
    int head = 0, tail = 0, count = 0;
public:
    bool push(const T& val) { if(count>=N) return false; buffer[tail]=val; tail=(tail+1)%N; count++; return true; }
    std::optional<T> pop() { if(count==0) return std::nullopt; T val=buffer[head]; head=(head+1)%N; count--; return val; }
};
EOF

cat > "$STAGE3_DIR/ChibiOs/Task.hpp" << 'EOF'
#pragma once
#include <functional>

class Task {
public:
    void start(std::function<void()> func) { func(); }
};
EOF

cat > "$STAGE3_DIR/ChibiOs/Time.hpp" << 'EOF'
#pragma once
#include <cstdint>
class Time {
public:
    static uint64_t now_ms() { return 0; } // stub
};
EOF

# -------------------------------
# VESC files
cat > "$STAGE3_DIR/VESC/PID.hpp" << 'EOF'
#pragma once
class PID {
private:
    double kp, ki, kd;
    double integral = 0, prevError = 0;
public:
    PID(double p, double i, double d) : kp(p), ki(i), kd(d) {}
    int compute(double target, double current);
};
EOF

cat > "$STAGE3_DIR/VESC/PID.cpp" << 'EOF'
#include "PID.hpp"
int PID::compute(double target, double current) {
    double error = target - current;
    integral += error;
    double derivative = error - prevError;
    prevError = error;
    return static_cast<int>(kp*error + ki*integral + kd*derivative);
}
EOF

cat > "$STAGE3_DIR/VESC/MotorController.hpp" << 'EOF'
#pragma once
#include "PID.hpp"
#include "ChibiOs/Time.hpp"

class MotorController {
private:
    PID motorPID;
    int targetRPM;
public:
    MotorController() : motorPID(1.0,0.0,0.0), targetRPM(0) {}
    void setTarget(int rpm) { targetRPM = rpm; }
    void loop();
    int readMotorRPM();
    void setMotorPWM(int pwm);
};
EOF

cat > "$STAGE3_DIR/VESC/MotorController.cpp" << 'EOF'
#include "MotorController.hpp"
#include <iostream>

void MotorController::loop() {
    int currentRPM = readMotorRPM();
    int pwm = motorPID.compute(targetRPM, currentRPM);
    setMotorPWM(pwm);
}

int MotorController::readMotorRPM() { return 0; /* stub */ }
void MotorController::setMotorPWM(int pwm) { std::cout << "PWM: " << pwm << std::endl; }
EOF

# -------------------------------
# Stage3 main.cpp
cat > "$STAGE3_DIR/main.cpp" << 'EOF'
#include "ChibiOs/Task.hpp"
#include "VESC/MotorController.hpp"

MotorController motor;

int main() {
    Task motorTask([](){
        while(true) {
            motor.loop();
            // add delay here if needed
        }
    });
    motorTask.start();
    return 0;
}
EOF

# -------------------------------
# Stage3 CMakeLists.txt
cat > "$STAGE3_DIR/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.20)
project(Stage3)

set(CMAKE_CXX_STANDARD 17)

# VESC source
set(VESC_SRC
    VESC/PID.cpp
    VESC/MotorController.cpp
)

add_executable(Stage3_test
    main.cpp
    ${VESC_SRC}
)

target_include_directories(Stage3_test PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)
EOF

echo "✅ Stage3 + VESC template created in $STAGE3_DIR"
