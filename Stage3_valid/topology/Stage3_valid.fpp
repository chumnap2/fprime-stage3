module Stage3_valid {

  topology Stage3Topology {

    # Basic system components
    instance cmdDisp: Svc.CmdDispatcher base id 0x0100
    instance eventLogger: Svc.EventLogger base id 0x0200
    instance tlm: Svc.TlmChan base id 0x0300
    instance rateGroupDriver: Svc.RateGroupDriver base id 0x0400

  }

}
