#ifndef FPRIME_MOTORCONTROLLER_HPP
#define FPRIME_MOTORCONTROLLER_HPP

#include "fprime_motor/MotorControllerComponentAc.hpp"

namespace fprime_motor {

  class MotorController : public MotorControllerComponentBase {
  public:
    explicit MotorController(const char* compName);
    ~MotorController() override = default;

  PRIVATE:
    void ENABLE_MOTOR_cmdHandler(FwOpcodeType opCode, U32 cmdSeq) override;
    void DISABLE_MOTOR_cmdHandler(FwOpcodeType opCode, U32 cmdSeq) override;
    void SET_TARGET_RPM_cmdHandler(FwOpcodeType opCode, U32 cmdSeq, F32 target) override;

  private:
    bool motorEnabled;
    F32 targetRPM;
  };

}

#endif
