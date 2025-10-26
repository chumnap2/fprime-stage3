#include "Task.hpp"

void Task::start(std::function<void()> func) {
    func(); // run immediately; can replace with ChibiOS thread later
}
