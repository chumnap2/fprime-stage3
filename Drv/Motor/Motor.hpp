#pragma once
#include "Fw/Types/BasicTypes.hpp"
#include "Fw/Com/ComBuffer.hpp"

class Motor {
public:
    Motor();
    void startMotor();
    void stopMotor();
    U32 getRPM() const;
private:
    U32 rpm;
};
