#ifndef FPRIME_UARTBRIDGE_HPP
#define FPRIME_UARTBRIDGE_HPP

#include "fprime_motor/UARTBridgeComponentAc.hpp"
#include "Fw/Buffer.hpp"
#include <vector>
#include <cstdint>

namespace fprime_motor {

  class UARTBridge : public UARTBridgeComponentBase {
  public:
    explicit UARTBridge(const char* compName);
    ~UARTBridge() override = default;

  PRIVATE:
    void uartRead_handler(NATIVE_INT_TYPE portNum, Fw::Buffer& buffer) override;

  private:
    void parsePacket(const std::vector<uint8_t>& data);
  };

}

#endif
