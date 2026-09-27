static class Msg{
  enum Type{
    IMU(0),
    BAROMETER(1),
    POWER_MONITOR(2),
    MAGNETOMETER(3),
    GNSS(4),
    
    CTR_TELEMETRY(60),
    PQ_TELEMETRY(61),
    
    CTR_CMD(100),
    PQ_CMD(101),
    PQ_IMG_STB(102),
    PQ_SCI_EXP(103),
    
    TEST(200),
    
    UNKNOWN(-1);
    
    
    final int value;
  
    Type(int value){
      this.value = value;
    }
    
    static Type fromValue(int value){
      for(Type type: values()){
        if(type.value == value) return type;
      }
      return UNKNOWN;
    }
  }
}
