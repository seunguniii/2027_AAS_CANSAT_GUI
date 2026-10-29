//HELPER FUNCTIONS

//Little endian

//uint32 little endian
static long readUInt32LE(int[] data, int offset){
  return (data[offset] & 0xFFL) | ((data[offset + 1] & 0xFFL) << 8) |
         ((data[offset + 2] & 0xFFL) << 16) | ((data[offset + 3] & 0xFFL) << 24);
}

//uint16 little endian
static int readUInt16LE(int[] data, int offset){
  return (data[offset] & 0xFF) | ((data[offset + 1] & 0xFF) << 8);
}

//float little endian
static float readFloatLE(int[] data, int offset){
  return Float.intBitsToFloat((int)readUInt32LE(data, offset));
}

void updateSerialConnection(){
  int now = millis();
  
  if(now - last_port_check < PORT_CHECK_INTERVAL) return;
  last_port_check = now;
  
  boolean port_exists = false;
  
  if(port_name != null && !port_name.isEmpty()){
    for(String available_port : Serial.list()){
      if(available_port.equals(port_name)){
        port_exists = true;
        break;
      }
    }
  }
  
  if(port_opened && port == null || !port_exists || !port.active()){
    println("Serial Disconnected"); //TODO make graphic
    
    try{if(port != null) port.stop();}
    catch(RuntimeException e){
      println("Error closing port: " + e.getMessage());
    }
    
    port = null;
    port_opened = false;
    buffer.clear();
  }
}
