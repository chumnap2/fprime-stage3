#!/bin/bash
# Navigate to the MotorBridge directory
cd ~/fprime/Stage8MotorBridge/Components/MotorBridge

# Create CmdPort.fpp
cat > CmdPort.fpp <<EOL
include "Fw/Types.fpp"
module Fw {
  port CmdPort {
    input data: U32;
  }
}
EOL

# Create LogTextPort.fpp
cat > LogTextPort.fpp <<EOL
include "Fw/Types.fpp"
module Fw {
  port LogTextPort {
    output text: String;
  }
}
EOL

# Update MotorBridge.fpp to reference these local ports
cat > MotorBridge.fpp <<EOL
include "CmdPort.fpp"
include "LogTextPort.fpp"

module Components {
  active component MotorBridge {
    input port cmdIn: Fw.CmdPort
    output port statusOut: Fw.LogTextPort
  }
}
EOL

echo "Minimal FPP files created: CmdPort.fpp, LogTextPort.fpp, and updated MotorBridge.fpp"
