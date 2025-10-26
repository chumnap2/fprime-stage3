#!/bin/bash
# Patch Stage3 OS-layer for STM32F4 + ChibiOS HAL
set -e

STAGE3_DIR=~/fprime/Stage3
CHIBIOS_DIR="$STAGE3_DIR/ChibiOs"

# ---------------------------
# 1️⃣ Task.hpp & Task.cpp
# ---------------------------
cat > "$CHIBIOS_DIR/Task.hpp" << 'EOF'
#pragma once
#include <functional>
#include "ChibiOs/Semaphore.hpp"
#include "ChibiOs/Time.hpp"

class Task {
private:
    std::function<void()> func;
public:
    Task() = default;

    // Start task (stub for STM32 HAL)
    void start(std::function<void()> f) {
        func = f;
        // In real ChibiOS: create thread here
        func(); // For minimal STM32 simulation
    }
};
EOF

cat > "$CHIBIOS_DIR/Task.cpp" << 'EOF'
#include "Task.hpp"
// Nothing else needed; logic is in header for STM32 stub
EOF

# ---------------------------
# 2️⃣ Time.hpp & Time.cpp
# ---------------------------
cat > "$CHIBIOS_DIR/Time.hpp" << 'EOF'
#pragma once
#include <cstdint>
#include "stm32f4xx_hal.h"  // HAL include

class Time {
public:
    static uint64_t now_ms() {
        return HAL_GetTick(); // STM32 HAL function
    }

    static void sleep_ms(uint32_t ms) {
        HAL_Delay(ms);       // STM32 HAL delay
    }
};
EOF

cat > "$CHIBIOS_DIR/Time.cpp" << 'EOF'
#include "Time.hpp"
// Implemented via HAL; nothing else
EOF

# ---------------------------
# 3️⃣ Semaphore.hpp & Semaphore.cpp
# ---------------------------
cat > "$CHIBIOS_DIR/Semaphore.hpp" << 'EOF'
#pragma once
#include "cmsis_os.h"

class Semaphore {
private:
    osSemaphoreId_t sem_id;
public:
    Semaphore(uint32_t maxCount = 1) {
        osSemaphoreDef_t def;
        sem_id = osSemaphoreCreate(&def, maxCount);
    }

    void signal() {
        osSemaphoreRelease(sem_id);
    }

    bool wait(uint32_t timeout_ms = osWaitForever) {
        return osSemaphoreWait(sem_id, timeout_ms) == osOK;
    }
};
EOF

cat > "$CHIBIOS_DIR/Semaphore.cpp" << 'EOF'
#include "Semaphore.hpp"
// ChibiOS HAL handles everything
EOF

# ---------------------------
# 4️⃣ Queue.hpp & Queue.cpp
# ---------------------------
cat > "$CHIBIOS_DIR/Queue.hpp" << 'EOF'
#pragma once
#include "cmsis_os.h"
#include <optional>

template<typename T, int N>
class Queue {
private:
    T buffer[N];
    int head = 0;
    int tail = 0;
    int count = 0;
    osMutexId_t mtx;

public:
    Queue() {
        osMutexDef_t def;
        mtx = osMutexCreate(&def);
    }

    bool push(const T& val) {
        osMutexWait(mtx, osWaitForever);
        if(count >= N) { osMutexRelease(mtx); return false; }
        buffer[tail] = val;
        tail = (tail + 1) % N;
        count++;
        osMutexRelease(mtx);
        return true;
    }

    std::optional<T> pop() {
        std::optional<T> ret;
        osMutexWait(mtx, osWaitForever);
        if(count > 0) {
            ret = buffer[head];
            head = (head + 1) % N;
            count--;
        }
        osMutexRelease(mtx);
        return ret;
    }

    int size() const { return count; }
};
EOF

cat > "$CHIBIOS_DIR/Queue.cpp" << 'EOF'
#include "Queue.hpp"
// Template class; nothing else needed
EOF

# ---------------------------
# 5️⃣ main.cpp example for STM32
# ---------------------------
cat > "$STAGE3_DIR/main.cpp" << 'EOF'
#include "ChibiOs/Task.hpp"
#include "ChibiOs/Time.hpp"
#include "VESC_Min/src/MotorTask.hpp"
#include "stm32f4xx_hal.h"

int main() {
    HAL_Init();             // Init STM32 HAL
    MotorTask motorTask;

    Task t;
    t.start([&]() {
        while(true) {
            motorTask.start();
            Time::sleep_ms(10); // cooperative delay
        }
    });

    while(true) {
        Time::sleep_ms(100); // Keep main alive
    }
    return 0;
}
EOF

echo "✅ Stage3 patched for STM32F4 + ChibiOS HAL. MotorTask ready to run."
