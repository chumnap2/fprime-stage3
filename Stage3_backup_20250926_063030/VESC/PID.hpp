#pragma once
class PID {
private:
    double kp, ki, kd;
    double integral = 0, prevError = 0;
public:
    PID(double p, double i, double d) : kp(p), ki(i), kd(d) {}
    int compute(double target, double current);
};
