#!/bin/bash
# motor_control.sh — safe start/stop/log for motor_control
# Author: chumnap
# Date: 2025-10-01
# Description: Launches motor_control daemon, handles PID/logs, and allows stop/status/log.

BIN="$HOME/fprime/Stage3/minimal_chibios/motor_control/build/motor_control"
PID_FILE="$HOME/fprime/Stage3/minimal_chibios/motor_control/motor.pid"
LOG_FILE="$HOME/fprime/Stage3/minimal_chibios/motor_control/motor.log"

case "$1" in
    start)
        shift
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "Motor already running with PID $(cat "$PID_FILE")"
            exit 0
        fi
        mkdir -p "$(dirname "$LOG_FILE")"
        touch "$LOG_FILE"
        nohup "$BIN" --daemon "$@" > "$LOG_FILE" 2>&1 &
        echo $! > "$PID_FILE"
        echo "Motor started as daemon (PID $(cat "$PID_FILE")). Logs -> $LOG_FILE"
        ;;
    stop)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            kill $(cat "$PID_FILE")
            rm -f "$PID_FILE"
            echo "Motor stopped."
        else
            echo "No motor daemon running."
        fi
        ;;
    status)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "Motor running (PID $(cat "$PID_FILE"))"
        else
            echo "Motor not running."
        fi
        ;;
    log)
        tail -f "$LOG_FILE"
        ;;
    *)
        echo "Usage: $0 {start|stop|status|log} [options]"
        ;;
esac
