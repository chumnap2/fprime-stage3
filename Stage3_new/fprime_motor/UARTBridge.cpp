#include "fprime_motor/UARTBridge.hpp"
#include "Fw/Types/BasicTypes.hpp"
#include <cstring>

namespace fprime_motor {

  UARTBridge::UARTBridge(const char* compName)
  : UARTBridgeComponentBase(compName) {}

  void UARTBridge::uartRead_handler(NATIVE_INT_TYPE portNum, Fw::Buffer& buffer) {
    const uint8_t* data = buffer.getData();
    const size_t len = buffer.getSize();
    std::vector<uint8_t> bytes(data, data + len);

    this->parsePacket(bytes);
  }

  void UARTBridge::parsePacket(const std::vector<uint8_t>& data) {
    // ⚠️ Simple placeholder parser: expects [RPM, Current, Voltage] as 3 floats (12 bytes)
    if (data.size() < 12) return;

    float rpm, current, voltage;
    std::memcpy(&rpm,     &data[0],  4);
    std::memcpy(&current, &data[4],  4);
    std::memcpy(&voltage, &data[8],  4);

    // Publish telemetry channels
    Fw::ParamFloat rpmParam(rpm);
    Fw::ParamFloat currentParam(current);
    Fw::ParamFloat voltageParam(voltage);

    this->rpmOut_out(0, rpmParam);
    this->currentOut_out(0, currentParam);
    this->voltageOut_out(0, voltageParam);
  }

}
