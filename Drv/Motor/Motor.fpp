component Motor {
    input:
        CmdPort startMotor();
        CmdPort stopMotor();
    output:
        TelemetryPort rpm;   # report current RPM
}
