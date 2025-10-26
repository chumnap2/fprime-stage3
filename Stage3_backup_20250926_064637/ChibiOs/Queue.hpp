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
        if(count == 0) return std::nullopt;
        T val = buffer[head];
        head = (head + 1) % N;
        count--;
        return val;
    }
    int size() const { return count; }
};
