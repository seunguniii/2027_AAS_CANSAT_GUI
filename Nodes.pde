static class Node{
  enum Type{
    IMU(50),
    BAROMETER(51),
    POWER_MONITOR(52),
    MAGNETOMETER(53),
    GNSS(54),
    
    MAIN(0),
    TELEMETRY(1),
    
    HEADER_TEST(200),
    MSG_LOCAL_NODE0_TEST(201),
    MSG_LOCAL_NODE1_TEST(202),
    MSG_ESPNOW_TEST(203),
    
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
