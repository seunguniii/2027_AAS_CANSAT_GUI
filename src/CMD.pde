static class CMD{
  enum CTR{
    INIT(0),
    
    UNKNOWN(-1);
  
    final int value;
    CTR(int value){this.value = value;}
    
    static CTR fromValue(int value){
      for(CTR ctr: values()){if(ctr.value == value) return ctr;}
      return UNKNOWN;
    }
  }
  
  
  enum PQ{
    INIT(0),
    
    IMG_STAB(50),
    
    SCI_EXP(100),
    
    UNKNOWN(-1);
  
    final int value;
    PQ(int value){this.value = value;}
    static PQ fromValue(int value){
      for(PQ pq: values()){if(pq.value == value) return pq;}
      return UNKNOWN;
    }
  }
}
