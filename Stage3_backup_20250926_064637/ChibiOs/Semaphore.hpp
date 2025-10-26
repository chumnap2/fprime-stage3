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
            cv.wait(lock, [this]{ return count > 0; });
            count--;
            return true;
        } else {
            if(!cv.wait_for(lock, std::chrono::milliseconds(timeout_ms), [this]{ return count > 0; }))
                return false;
            count--;
            return true;
        }
    }
};
