#!/bin/bash
# patch_stage3_chibios_only.sh
# Author: chumnap thach
# Date: 2025-09-24
# Description: Patch Stage3 to use ChibiOS HAL only for STM32 + VESC integration

set -e

STAGE3_DIR=~/fprime/Stage3
CHIBIOS_DIR=$STAGE3_DIR/ChibiOs

echo "✅ Patching Stage3 for STM32 + ChibiOS HAL only..."

# Create ChibiOS HAL stubs
mkdir -p "$CHIBIOS_DIR"

# -------------------------------
# Task.hpp
cat > "$CHIBIOS_DIR/Task.hpp" << 'EOF'
#pragma once
#include <functional>

class Task {
public:
    Task() = default;
    void start(std::function<void()> func);
};
EOF

# Task.cpp
cat > "$CHIBIOS_DIR/Task.cpp" << 'EOF'
#include "Task.hpp"

void Task::start(std::function<void()> func) {
    func(); // run immediately; can replace with ChibiOS thread later
}
EOF

# -------------------------------
# Semaphore.hpp
cat > "$CHIBIOS_DIR/Semaphore.hpp" << 'EOF'
#pragma once
#include <mutex>
#include <condition_variable>
#include <chrono>

class Semaphore {
private:
    int count;
    std::mutex mtx;
    std::condition_variable cv;

public:
    Semaphore(int init = 0) : count(init) {}
    void signal() {
        std::unique_lock<std::mutex> lock(mtx);
        count++;
        cv.notify_one();
    }
    bool wait(int timeout_ms = -1) {
        std::unique_lock<std::mutex> lock(mtx);
        if(timeout_ms < 0) {
            cv.wait(lock, [this](){ return count > 0; });
        } else {
            if(!cv.wait_for(lock, std::chrono::milliseconds(timeout_ms),
                            [this](){ return count > 0; }))
                return false;
        }
        count--;
        return true;
    }
};
EOF

# -------------------------------
# Queue.hpp
cat > "$CHIBIOS_DIR/Queue.hpp" << 'EOF'
#pragma once
#include <array>
#include <optional>

template<typename T, int N>
class Queue {
private:
    std::array<T, N> buffer;
    int head = 0;
    int tail = 0;
    int count = 0;

public:
    bool push(const T& val) {
        if(count >= N) return false;
        buffer[tail] = val;
        tail = (tail + 1) % N;
        count++;
        return true;
    }
    std::optional<T> pop() {
        if(count <= 0) return std::nullopt;
        T val = buffer[head];
        head = (head + 1) % N;
        count--;
        return val;
    }
};
EOF

# -------------------------------
# Time.hpp
cat > "$CHIBIOS_DIR/Time.hpp" << 'EOF'
#pragma once
#include <cstdint>

class Time {
public:
    static uint64_t now_ms() {
        return 0; // stub for STM32; replace with ChibiOS HAL time if needed
    }
};
EOF

# -------------------------------
# Os.hpp
cat > "$STAGE3_DIR/Os.hpp" << 'EOF'
#pragma once
#include "ChibiOs/Semaphore.hpp"
#include "ChibiOs/Queue.hpp"
#include "ChibiOs/Task.hpp"
#include "ChibiOs/Time.hpp"
EOF

echo "✅ Stage3 patched for STM32 + ChibiOS HAL only!"
