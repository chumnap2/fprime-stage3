#!/bin/bash
BIN="$HOME/fprime/Stage3/minimal_chibios/motor_control/build/motor_control"
MOTOR_BIN="$HOME/fprime/Stage3/minimal_chibios/motor_control/motor_control"
PID_FILE="$HOME/fprime/Stage3/minimal_chibios/motor_control/motor.pid"
LOG_FILE="$HOME/fprime/Stage3/minimal_chibios/motor_control/motor.log"

case "$1" in
  start)
    shift
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
      echo "Motor daemon already running with PID $(cat $PID_FILE)"
      exit 0
    fi
    nohup "$MOTOR_BIN" --daemon "$@" > "$LOG_FILE" 2>&1 &
    echo $! > "$PID_FILE"
    echo "Motor started as daemon (PID $(cat $PID_FILE)). Logs -> $LOG_FILE"
    ;;
  log)
    tail -f "$LOG_FILE"
    ;;
  status)
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
      echo "Motor daemon running with PID $(cat $PID_FILE)"
    else
      echo "No motor daemon running."
    fi
    ;;
  stop)
    if [ -f "$PID_FILE" ]; then
      kill $(cat "$PID_FILE") && rm -f "$PID_FILE"
      echo "Motor stopped."
    else
      echo "No PID file, motor not running?"
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|status|log}"
    ;;
esac
