#include "PID.hpp"
int PID::compute(double target, double current) {
    double error = target - current;
    integral += error;
    double derivative = error - prevError;
    prevError = error;
    return static_cast<int>(kp*error + ki*integral + kd*derivative);
}
