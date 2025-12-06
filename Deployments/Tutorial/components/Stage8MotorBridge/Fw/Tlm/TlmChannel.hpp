#pragma once
#include <iostream>
#define TELEMETRY_TLM(type, name)
#define tlmWrite_motorRPM(val) std::cout << "TLM RPM: " << val << "\n";
#define tlmWrite_motorCurrent(val) std::cout << "TLM Current: " << val << "\n";
#define tlmWrite_motorVoltage(val) std::cout << "TLM Voltage: " << val << "\n";
#define tlmWrite_motorTemperature(val) std::cout << "TLM Temperature: " << val << "\n";
#define log_WARNING_motorSafetyLimitExceeded(rpm, current) std::cout << "WARNING: RPM=" << rpm << " Current=" << current << "\n";
