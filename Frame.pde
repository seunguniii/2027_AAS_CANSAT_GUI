static class Frame{
  Type type;
  MsgHeader header;
  int[] payload;
  int crc;
  
  Telemetry.CTR ctrTelemetry;
  Telemetry.PQ pqTelemetry;
  
  Frame(){};
  
  enum Type{
    CTR_TELEMETRY(0, CTR_TELEMETRY_FRAME_SIZE),
    PQ_TELEMETRY(1, PQ_TELEMETRY_FRAME_SIZE),
    
    CMD(2, CMD_FRAME_SIZE),
    
    UNKNOWN(-1, 0);
  
  
    final int value;
    final int size;
  
    Type(int value, int size){
      this.value = value;
      this.size = size;
    }
    
    static Type fromValue(int value){
      for(Type type: values()){
        if(type.value == value) return type;
      }
      return UNKNOWN;
    }
    
    int getSize(){
      return size;
    }
  }
  
  
  static Frame parseFrame(ArrayList<Integer> buffer){
    Frame frame = new Frame();
    while(buffer.size() >= 3){ //sync bytes + type byte
      if(buffer.get(0) != SYNC_0 || buffer.get(1) != SYNC_1){ 
        buffer.remove(0);
        continue;
      }
      println("\n\nFRAME RECEIVED");
      println("Full Frame: \n" + buffer);
    
      frame.type = Frame.Type.fromValue(buffer.get(2));
      if(frame.type == Frame.Type.UNKNOWN){
        println("Unknown frame type. Skipping frame.\n");
        buffer.remove(0);
        continue;
      }
    
      frame_size = frame.type.getSize();
      if(buffer.size() < frame_size) break;
      int[] packet = new int[frame_size];
      for(int i = 0; i < frame_size; i++){packet[i] = buffer.get(i);}
      for(int i = 0; i < frame_size; i++){buffer.remove(0);}
    
      frame.parseHeader(packet);
      frame.parseCRC(packet);
      if(!CRC16.verify(packet, 2, packet.length - 2)){
        println("Invalid CRC. Corrupted packet. Skipping frame.\nf");
        continue;
      }    
      frame.parsePayload(packet);
    
      println("size = " + packet.length);
      println("sync = " + hex(packet[0], 2) + " " + hex(packet[1], 2));
      println("type = " + frame.type);
    
      frame.printParsedHeader();    
      frame.printParsedPayload();
    
    
      println("CRC = " + hex(frame.crc, 4));
    }
    return frame;
  }
  
  void parseHeader(int[] packet){
    header = new MsgHeader();
    header.txMCU = MCU.Type.fromValue(packet[3]);
    header.txNode = Node.Type.fromValue(packet[4]);
    header.rxMCU = MCU.Type.fromValue(packet[5]);
    header.rxNode = Node.Type.fromValue(packet[6]);
    
    header.msgType = Msg.Type.fromValue(readUInt16LE(packet, 7));
    header.msgLength = readUInt16LE(packet, 9);
  }
  
  void parseCRC(int[] packet){
    int offset = packet.length - CRC_SIZE;
    crc = readUInt16LE(packet, offset);
  }
  
  void parsePayload(int[] packet){
    payload = new int[this.header.msgLength];
    for(int i = 0; i < this.header.msgLength; i++){
      payload[i] = packet[11+i];
    }
    
    if(!CRC16.verify(payload, 0, payload.length)){
      println("[parsePayload] Invalid CRC. Payload corrupted. Skipping frame.\n");
      return;
    }
    
    switch(type){
      case CTR_TELEMETRY:
        count_gs_telem_ctr++;
        time_last_telem_ctr_ctr = time_curr_telem_ctr_ctr;
        ctrTelemetry = Telemetry.CTR.parseTelemetry(payload);
        time_curr_telem_ctr_ctr = ctrTelemetry.missionTime;
        time_telem_ctr_gs = current_time;
        break;
        
      case PQ_TELEMETRY:
        count_gs_telem_pq++;
        time_last_telem_pq_pq = time_curr_telem_pq_pq;
        pqTelemetry = Telemetry.PQ.parseTelemetry(payload);
        time_curr_telem_pq_pq = pqTelemetry.missionTime;
        time_telem_pq_gs = current_time;
        break;
      
      //case CMD:
      //  TODO
      //  break;
      
      default:
        println("[parsePayload] Unknown frame type. Skipping frame.\n");
        break;
    }    
    count_gs = count_gs_telem_ctr + count_gs_telem_pq;
    count_net_true = count_ctr_telem_ctr + count_pq_telem_pq;
  }
  void printParsedHeader(){
    println("\nHeader");
    println("tx MCU = " + header.txMCU);
    println("tx node = " + header.txNode);
    println("rx MCU = " + header.rxMCU);
    println("rx node = " + header.txNode);    
    println("msgType = " + header.msgType);
    println("msgLength = " + header.msgLength);
  }  
  
  void printParsedPayload(){
    println("\nPayload");
    switch(type){
      case CTR_TELEMETRY:
        println("ID = " + ctrTelemetry.ID);
        println("Mission Time = " + ctrTelemetry.missionTime);
        println("Packet Count = " + ctrTelemetry.packetCount);
        println("Command Count = " + ctrTelemetry.commandCount);
    
        println("Mode = " + ctrTelemetry.mode);
        println("State = " + ctrTelemetry.state);
        println("Mechanism State = " + ctrTelemetry.mechState);
    
        println("Altitude = " + ctrTelemetry.altitude);
        println("Pressure = " + ctrTelemetry.pressure);
        println("Temperature = " + ctrTelemetry.temperature);
        println("BAT Voltage = " + ctrTelemetry.batteryVoltage);
        println("BAT Current = " + ctrTelemetry.batteryCurrent);
    
        println("Command Echo = " + ctrTelemetry.cmdEcho);
    
        println("Telemetry CRC = " + hex(ctrTelemetry.crc, 4));
        break;
        
      case PQ_TELEMETRY:
        println("ID = " + pqTelemetry.ID);
        println("Mission Time = " + pqTelemetry.missionTime);
        println("Packet Count = " + pqTelemetry.packetCount);
        println("Command Count = " + pqTelemetry.commandCount);
    
        println("Mode = " + pqTelemetry.mode);
        println("Mechanism State = " + pqTelemetry.mechState);
    
        println("Altitude = " + pqTelemetry.altitude);
        println("Pressure = " + pqTelemetry.pressure);
        println("Temperature = " + pqTelemetry.temperature);
        println("BAT Voltage = " + pqTelemetry.batteryVoltage);
        println("BAT Current = " + pqTelemetry.batteryCurrent);
        println("Rotation Rate = (" + pqTelemetry.rotRate[0] + ", " + pqTelemetry.rotRate[1] + ", " + pqTelemetry.rotRate[2] + ")");
        println("Acceleration = (" + pqTelemetry.accel[0] + ", " + pqTelemetry.accel[1] + ", " + pqTelemetry.accel[2] + ")");
        println("Magnetic Field = (" + pqTelemetry.mag[0] + ", " + pqTelemetry.mag[1] + ", " + pqTelemetry.mag[2] + ")");
        println("GNSS Time = " + pqTelemetry.gnssTime);
        println("GNSS position = (" + pqTelemetry.gnssPos[0] + ", " + pqTelemetry.gnssPos[1] + ", " + pqTelemetry.gnssPos[2] + ")");
        println("GNSS # of Satellites = " + pqTelemetry.gnssSats);
        println("SP1 Voltage = " + pqTelemetry.solar1);
        println("SP2 Voltage = " + pqTelemetry.solar2);
    
        println("Command Echo = " + pqTelemetry.cmdEcho);
        println("Image Stabilization = " + pqTelemetry.imageStabilization);
        println("Science Experiment = " + pqTelemetry.scienceExp);
    
        println("Telemetry CRC = " + hex(pqTelemetry.crc, 4));
        break;
      
      default:
        println("[printParsedPayload] Unknown frame type. Skipping frame.\n");
        break;
    }
  }
      
}
