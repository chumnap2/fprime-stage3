#!/bin/bash

# Navigate to your Stage8MotorBridge folder
cd ~/Stage8MotorBridge-FPrime/Components/Stage8MotorBridge || exit

# Create stub directories
mkdir -p Fw/Types Fw/Com Fw/Tlm

# Create BasicTypes.hpp stub
cat > Fw/Types/BasicTypes.hpp <<EOL
#pragma once
using NATIVE_INT_TYPE = int;
EOL

# Create ComTypes.hpp stub
cat > Fw/Com/ComTypes.hpp <<EOL
#pragma once
// Empty stub for testing
EOL

# Create TlmChannel.hpp stub
cat > Fw/Tlm/TlmChannel.hpp <<EOL
#pragma once
#include <iostream>
#define TELEMETRY_TLM(type, name)
#define tlmWrite_motorRPM(val) std::cout << "TLM RPM: " << val << "\\n";
#define tlmWrite_motorCurrent(val) std::cout << "TLM Current: " << val << "\\n";
#define log_WARNING_motorSafetyLimitExceeded(rpm, current) std::cout << "WARNING: RPM=" << rpm << " Current=" << current << "\\n";
EOL

echo "Stub headers created successfully."
