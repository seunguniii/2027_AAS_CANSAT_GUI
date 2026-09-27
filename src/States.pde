enum FlightMode{
  FLIGHT(0),
  SIMULATION(1),
  
  UNKNOWN(-1);
  
  final int value;
  
  FlightMode(int value){
    this.value = value;
  }
    
  static FlightMode fromValue(int value){
    for(FlightMode mode: values()){
      if(mode.value == value) return mode;
    }
    return UNKNOWN;
  }
}

enum CTR_OpState{
  LAUNCH_PAD(0),
  ASCENT(1),
  APOGEE(2),
  PQ_RELEASE(3),
  
  UNKNOWN(-1);
  
  final int value;
  
  CTR_OpState(int value){
    this.value = value;
  }
  
  static CTR_OpState fromValue(int value){
    for(CTR_OpState state: values()){
      if(state.value == value) return state;
    }
    return UNKNOWN;
  }
}
