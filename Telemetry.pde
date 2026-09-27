static class Telemetry{
  static class CTR{
    String ID;
    long missionTime;
    int packetCount;
    int commandCount;
    
    FlightMode mode;
    CTR_OpState state;
    String mechState; //for hex representation TODO fall back to int if that's easier
    
    float altitude;
    float pressure;
    float temperature;
    float batteryVoltage;
    float batteryCurrent;
    
    CMD.CTR cmdEcho;
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
      telemetry.mechState = hex(payload[16] & 0xFF, 2);
      
      telemetry.altitude = readFloatLE(payload, 17);
      telemetry.pressure = readFloatLE(payload, 21);
      telemetry.temperature = readFloatLE(payload, 25);
      telemetry.batteryVoltage = readFloatLE(payload, 29);
      telemetry.batteryCurrent = readFloatLE(payload, 33);
      
      telemetry.cmdEcho = CMD.CTR.fromValue(payload[37] & 0xFF);
      telemetry.crc = readUInt16LE(payload, 38);
      
      return telemetry;      
    }
  }
  
  static class PQ{
    String ID;
    long missionTime;
    int packetCount;
    int commandCount;
    
    FlightMode mode;
    String mechState; //for hex representation TODO fall back to int if that's easier
    
    float altitude;
    float pressure;
    float temperature;
    float batteryVoltage;
    float batteryCurrent;
    
    float[] rotRate = new float[3];
    float[] accel = new float[3];
    float[] mag = new float[3];
    
    long gnssTime;
    float[] gnssPos = new float[3];
    int gnssSats;
    
    float solar1;
    float solar2;
    
    CMD.PQ cmdEcho;
    CMD.PQ imageStabilization;
    CMD.PQ scienceExp;
    
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
      telemetry.mechState = hex(payload[16] & 0xFF, 4);
      
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
      
      telemetry.solar1 = readFloatLE(payload, 89);
      telemetry.solar2 = readFloatLE(payload, 93);
      
      telemetry.cmdEcho = CMD.PQ.fromValue(payload[97] & 0xFF);
      telemetry.imageStabilization = CMD.PQ.fromValue(payload[98] & 0xFF);
      telemetry.scienceExp = CMD.PQ.fromValue(payload[99] & 0xFF);
      
      telemetry.crc = readUInt16LE(payload, 100);
      
      return telemetry;      
    }
  }
}
