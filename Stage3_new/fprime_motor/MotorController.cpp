#include "fprime_motor/MotorController.hpp"
#include "Fw/Log/LogString.hpp"

namespace fprime_motor {

  MotorController::MotorController(const char* compName)
  : MotorControllerComponentBase(compName),
    motorEnabled(false),
    targetRPM(0.0f) {}

  void MotorController::ENABLE_MOTOR_cmdHandler(FwOpcodeType opCode, U32 cmdSeq) {
    this->motorEnabled = true;
    this->log_ACTIVITY_LO_MotorEnabled();
    this->cmdResponse_out(opCode, cmdSeq, Fw::CmdResponse::OK);
  }

  void MotorController::DISABLE_MOTOR_cmdHandler(FwOpcodeType opCode, U32 cmdSeq) {
    this->motorEnabled = false;
    this->log_ACTIVITY_LO_MotorDisabled();
    this->cmdResponse_out(opCode, cmdSeq, Fw::CmdResponse::OK);
  }

  void MotorController::SET_TARGET_RPM_cmdHandler(FwOpcodeType opCode, U32 cmdSeq, F32 target) {
    this->targetRPM = target;
    this->log_ACTIVITY_LO_TargetRPMSet(target);
    this->cmdResponse_out(opCode, cmdSeq, Fw::CmdResponse::OK);
  }

}
