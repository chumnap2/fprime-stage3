#!/bin/bash
# Patch Stage3 OS-layer for safe MotorTask loop
set -e

STAGE3_DIR=~/fprime/Stage3
CHIBIOS_DIR="$STAGE3_DIR/ChibiOs"

# ---------------------------
# 1️⃣ Task.hpp & Task.cpp
# ---------------------------
cat > "$CHIBIOS_DIR/Task.hpp" << 'EOF'
#pragma once
#include <functional>
#include <thread>
#include <atomic>
#include <chrono>
#include <iostream>

class Task {
private:
    std::thread worker;
    std::atomic<bool> running{false};
public:
    Task() = default;

    // Start a function in a separate thread
    void start(std::function<void()> func) {
        running = true;
        worker = std::thread([this, func]() {
            func();
        });
    }

    // Stop the task
    void stop() {
        running = false;
        if(worker.joinable()) worker.join();
    }

    bool isRunning() const { return running; }
};
EOF

cat > "$CHIBIOS_DIR/Task.cpp" << 'EOF'
#include "Task.hpp"
// Nothing else needed; logic is in header
EOF

# ---------------------------
# 2️⃣ Time.hpp & Time.cpp
# ---------------------------
cat > "$CHIBIOS_DIR/Time.hpp" << 'EOF'
#pragma once
#include <cstdint>
#include <chrono>

class Time {
public:
    static uint64_t now_ms() {
        auto now = std::chrono::steady_clock::now().time_since_epoch();
        return std::chrono::duration_cast<std::chrono::milliseconds>(now).count();
    }

    static void sleep_ms(uint64_t ms) {
        std::this_thread::sleep_for(std::chrono::milliseconds(ms));
    }
};
EOF

cat > "$CHIBIOS_DIR/Time.cpp" << 'EOF'
#include "Time.hpp"
// All implemented in header
EOF

# ---------------------------
# 3️⃣ Queue.hpp & Queue.cpp
# ---------------------------
cat > "$CHIBIOS_DIR/Queue.hpp" << 'EOF'
#pragma once
#include <optional>
#include <array>
#include <mutex>

template<typename T, int N>
class Queue {
private:
    std::array<T, N> buffer;
    int head = 0;
    int tail = 0;
    int count = 0;
    std::mutex mtx;

public:
    bool push(const T& val) {
        std::lock_guard<std::mutex> lock(mtx);
        if(count >= N) return false;
        buffer[tail] = val;
        tail = (tail + 1) % N;
        count++;
        return true;
    }

    std::optional<T> pop() {
        std::lock_guard<std::mutex> lock(mtx);
        if(count == 0) return std::nullopt;
        T val = buffer[head];
        head = (head + 1) % N;
        count--;
        return val;
    }

    int size() const { return count; }
};
EOF

cat > "$CHIBIOS_DIR/Queue.cpp" << 'EOF'
#include "Queue.hpp"
// Template class; nothing else needed
EOF

# ---------------------------
# 4️⃣ main.cpp example
# ---------------------------
cat > "$STAGE3_DIR/main.cpp" << 'EOF'
#include "ChibiOs/Task.hpp"
#include "ChibiOs/Time.hpp"
#include "VESC_Min/src/MotorTask.hpp"
#include <iostream>

int main() {
    MotorTask motorTask;

    Task t;
    t.start([&]() {
        while(true) {
            motorTask.start();  // MotorTask loop
            Time::sleep_ms(10); // cooperative delay to reduce CPU usage
        }
    });

    // Keep main alive while task runs
    while(t.isRunning()) {
        Time::sleep_ms(100);
    }

    return 0;
}
EOF

echo "✅ Stage3 Task/Time/Queue/Main stubs patched for safe MotorTask execution."
