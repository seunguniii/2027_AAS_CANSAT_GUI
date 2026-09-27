static class MsgHeader{
  MCU.Type txMCU;
  Node.Type txNode;
  MCU.Type rxMCU;
  Node.Type rxNode;
  
  Msg.Type msgType;
  int msgLength;
  
  MsgHeader(){}
}
