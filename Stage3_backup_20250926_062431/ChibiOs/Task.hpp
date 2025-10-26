#pragma once
#include <functional>

class Task {
public:
    Task() = default;
    void start(std::function<void()> func) { func(); }
};
