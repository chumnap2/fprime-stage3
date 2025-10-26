module fprime_motor {

  @ Component bridging UART data between F´ and VESC-like device
  passive component UARTBridge {

    # UART input from driver
    input port uartRead: Fw.BufferReceive

    # UART output to driver
    output port uartWrite: Fw.BufferSend

    # Link to motor controller for telemetry
    output port rpmOut: Fw.PrmSet
    output port currentOut: Fw.PrmSet
    output port voltageOut: Fw.PrmSet
  }

}
