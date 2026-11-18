static class MCU{
  enum Type{
    PQ(0),
    CTR(1),
    GS(2),
    
    TEST(200),
    
    ESP0(201),
    ESP1(202),
    ESP_CAM_0(203),
    ESP_CAM_1(204),
    
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
    
    static Type fromName(String name){
      switch(name){
        case("PQ"):  return PQ;
        case("CTR"): return CTR;
        case("GS"): return GS;
        
        case("TEST"): return TEST;
        case("ESP0"): return ESP0;
        case("ESP1"): return ESP1;
        case("ESP_CAM_0"): return ESP_CAM_0;
        case("ESP_CAM_1"): return ESP_CAM_1;
        
        default: return UNKNOWN;
      }
    }
  }
}


static class Node{
  enum Type{
    SUPER(0),
    
    TELEM(11),
    SENSOR(12),
    CMD_RELAY(13),
    MECH(14),
    
    LOGGER(20),
    
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
    
    static Type fromName(String name){
      switch(name){
        case("SUPER"): return SUPER;
        
        case("TELEM"): return TELEM;
        case("SENSOR"): return SENSOR;
        case("CMD_RELAY"): return CMD_RELAY;
        case("MECH"): return MECH;
        
        case("LOGGER"): return LOGGER;
        
        default: return UNKNOWN;
      }
    }
  }
}
