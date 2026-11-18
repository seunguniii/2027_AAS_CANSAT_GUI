static class CMD{
  enum Verb{
    START(2),
    STOP(3),
    KILL(5),
    REBOOT(7),
    
    CALIBRATE(11),
    
    ENABLE(13),
    ACTIVATE(17),
    
    SEND(19),
    
    UNKNOWN(-1);
    
    final int value;
  
    Verb(int value){
      this.value = value;
    }
    
    static Verb fromValue(int value){
      for(Verb verb: values()){
        if(verb.value == value) return verb;
      }
      return UNKNOWN;
    }
  };
  
  enum Noun{
    TASK(30),
    MCU(5),
    
    IMU(11),
    ALTITUDE(22),
    CLOCK(33),
    
    FLIGHTMODE(221),
    MECHANISM(17),
    
    SIMALT(19),  //simulated altitude data
    
    UNKNOWN(-1);
    
    final int value;
  
    Noun(int value){
      this.value = value;
    }
    
    static Noun fromValue(int value){
      for(Noun noun: values()){
        if(noun.value == value) return noun;
      }
      return UNKNOWN;
    }
  };
  
  MCU rxMCU;
  Node rxNode;
  int sq_num;
  Verb verb;
  Noun noun;
  int param;
  
  CMD(MCU rxMCU, Node rxNode, int sq_num, Verb verb, Noun noun, int param){
    this.rxMCU = rxMCU;
    this.rxNode = rxNode;
    this.sq_num = sq_num;
    this.verb = verb;
    this.noun = noun;
    this.param = param;
  }
  
  static class ACK{
    Verb verb;
    Noun noun;
    int param;
    
    ACK(Verb verb, Noun noun, int param){
      this.verb = verb;
      this.noun = noun;
      this.param = param;
    }
  }
  
  boolean validVerbNoun(CMD cmd){
    return (cmd != null && cmd.verb != null && cmd.noun != null && 
            cmd.verb.value > 0 && cmd.noun.value > 0 &&
            cmd.noun.value % cmd.verb.value == 0);
  }
  
  void send(CMD cmd){
    
  }
}
