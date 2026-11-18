static class Telemetry{
  static class CTR{
    String ID;
    long missionTime;
    int packetCount;
    int commandCount;
    
    FlightMode mode;
    CTR_OpState state;
    int mechState;
    int taskState;
    
    float altitude;
    float pressure;
    float temperature;
    float batteryVoltage;
    float batteryCurrent;
    
    float[] attitude = new float[3];
    float[] rotRate = new float[3];
    float[] accel = new float[3];
    
    int sensorState;
    
    CMD.ACK cmdRx = new CMD.ACK(CMD.Verb.UNKNOWN, CMD.Noun.UNKNOWN, 0);
    int rxResult;
    CMD.ACK cmdExec = new CMD.ACK(CMD.Verb.UNKNOWN, CMD.Noun.UNKNOWN, 0);
    
    int crc;
    
    CTR(){};
    
    static CTR parseTelemetry(int[] payload){
      CTR telemetry = new CTR();
      
      char[] id = new char[6];
      for(int i = 0; i < 6; i ++){id[i] = (char)payload[i];}
      telemetry.ID = new String(id).replace("\0", "");
      
      telemetry.missionTime = readUInt32LE(payload, 6);
      telemetry.packetCount = readUInt16LE(payload, 10);
      telemetry.commandCount = readUInt16LE(payload, 12);
      
      telemetry.mode = FlightMode.fromValue(payload[14] & 0xFF);
      telemetry.state = CTR_OpState.fromValue(payload[15] & 0xFF);
      telemetry.mechState = payload[16];
      telemetry.taskState = readUInt16LE(payload, 17); //TODO
      
      telemetry.altitude = readFloatLE(payload, 18);
      telemetry.pressure = readFloatLE(payload, 22);
      telemetry.temperature = readFloatLE(payload, 26);
      telemetry.batteryVoltage = readFloatLE(payload, 30);
      telemetry.batteryCurrent = readFloatLE(payload, 34);
      for(int i = 0; i < 3; i++){
        telemetry.attitude[i] = readFloatLE(payload, 38 + i*4);
        telemetry.rotRate[i] = readFloatLE(payload, 50 + i*4);
        telemetry.accel[i] = readFloatLE(payload, 62 + i*4);
      }
      telemetry.sensorState = readUInt16LE(payload, 74);
      
      //telemetry.cmdRx = readUInt16LE(payload, 75); //TODO rewrite to read CMD structure
      telemetry.rxResult = readUInt8LE(payload, 83);
      //telemetry.cmdExec = readUInt16LE(payload, 84); //TODO rewrite to read CMD structure
      
      telemetry.crc = readUInt16LE(payload, 126);
      
      return telemetry;      
    }
  }
  
  static class PQ{
    String ID;
    long missionTime;
    int packetCount;
    int commandCount;
    
    FlightMode mode;
    int mechState;
    
    float altitude;
    float pressure;
    float temperature;
    float batteryVoltage;
    float batteryCurrent;
    
    float[] attitude = new float[3];
    float[] rotRate = new float[3];
    float[] accel = new float[3];
    float[] mag = new float[3];
    
    long gnssTime;
    float[] gnssPos = new float[3];
    int gnssSats;
    
    float solar0;
    float solar1;
    
    int cmdEcho;
    int imageStabilization;
    int scienceExp;
    
    int crc;
    
    PQ(){};
    
    static PQ parseTelemetry(int[] payload){
      PQ telemetry = new PQ();
      
      char[] id = new char[6];
      for(int i = 0; i < 6; i ++){id[i] = (char)payload[i];}
      telemetry.ID = new String(id).replace("\0", "");
      
      telemetry.missionTime = readUInt32LE(payload, 6);
      telemetry.packetCount = readUInt16LE(payload, 10);
      telemetry.commandCount = readUInt16LE(payload, 12);
      
      telemetry.mode = FlightMode.fromValue(payload[14] & 0xFF);
      telemetry.mechState = payload[16];
      
      telemetry.altitude = readFloatLE(payload, 16);
      telemetry.pressure = readFloatLE(payload, 20);
      telemetry.temperature = readFloatLE(payload, 24);
      telemetry.batteryVoltage = readFloatLE(payload, 28);
      telemetry.batteryCurrent = readFloatLE(payload, 32);
      
      for(int i = 0; i < 3; i++){
        telemetry.rotRate[i] = readFloatLE(payload, 36 + i*4);
        telemetry.accel[i] = readFloatLE(payload, 48 + i*4);
        telemetry.mag[i] = readFloatLE(payload, 60 + i*4);
        telemetry.gnssPos[i] = readFloatLE(payload, 76 + i*4);
      }
      
      telemetry.gnssTime = readUInt32LE(payload, 72);
      telemetry.gnssSats = payload[88] & 0xFF;
      
      telemetry.solar0 = readFloatLE(payload, 89);
      telemetry.solar1 = readFloatLE(payload, 93);
      
      telemetry.cmdEcho = readUInt16LE(payload, 97);
      telemetry.imageStabilization = readUInt16LE(payload, 98);
      telemetry.scienceExp = readUInt16LE(payload, 99);
      
      telemetry.crc = readUInt16LE(payload, 100);
      
      return telemetry;      
    }
  }
}
