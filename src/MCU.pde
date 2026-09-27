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
  }
}
