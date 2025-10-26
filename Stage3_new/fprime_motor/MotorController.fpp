module fprime_motor {

  @ Component providing bridge between F´ and VESC over UART
  active component MotorController {

    # ----------------------------------------------------------------------
    # Ports
    # ----------------------------------------------------------------------

    @ UART communication to motor driver (e.g., VESC)
    output port uartWrite: Fw.BufferSend

    @ UART incoming data
    input port uartRead: Fw.BufferReceive

    @ Log and event output
    output port log: Fw.Log
    output port events: Fw.LogEvent

    # ----------------------------------------------------------------------
    # Commands
    # ----------------------------------------------------------------------

    @ Enable motor output
    async command ENABLE_MOTOR()

    @ Disable motor output
    async command DISABLE_MOTOR()

    @ Set target RPM
    async command SET_TARGET_RPM(target: F32)

    # ----------------------------------------------------------------------
    # Telemetry Channels
    # ----------------------------------------------------------------------

    telemetry RPM: F32
    telemetry Current: F32
    telemetry Voltage: F32

    # ----------------------------------------------------------------------
    # Events
    # ----------------------------------------------------------------------

    @ Indicates motor enabled
    event MotorEnabled()

    @ Indicates motor disabled
    event MotorDisabled()

    @ Reports target RPM setpoint
    event TargetRPMSet(target: F32)
  }

}
