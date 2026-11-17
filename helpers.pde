//HELPER FUNCTIONS

//uint32 little endian
static long readUInt32LE(int[] data, int offset){
  return (data[offset] & 0xFFL) | ((data[offset + 1] & 0xFFL) << 8) |
         ((data[offset + 2] & 0xFFL) << 16) | ((data[offset + 3] & 0xFFL) << 24);
}

//uint16 little endian
static int readUInt16LE(int[] data, int offset){
  return (data[offset] & 0xFF) | ((data[offset + 1] & 0xFF) << 8);
}

//uint8 little endian(no effect)
static int readUInt8LE(int[] data, int offset){
  return data[offset] & 0xFF;
}

//float little endian
static float readFloatLE(int[] data, int offset){
  return Float.intBitsToFloat((int)readUInt32LE(data, offset));
}

void printLOGO(){
  println(LOGO0);
  println(LOGO1);
  println(LOGO2);
  println(LOGO3);
  println(LOGO4);
  println(LOGO5);
  println(LOGO6);
}


void keyPressed(){
  if(key == CODED)
    return;
    
  switch(key){
    case(BACKSPACE):
      if(KEYBOARD_BUFFER.length() > 0)
        KEYBOARD_BUFFER = KEYBOARD_BUFFER.substring(0, KEYBOARD_BUFFER.length() - 1);
      break;
       
    case(RETURN):
    case(ENTER):
      if(ui.mode.equals("CONSOLE")){
        ui.console.KEYBOARD_INPUT = KEYBOARD_BUFFER; ui.console.console(ui.console.KEYBOARD_INPUT);
        KEYBOARD_BUFFER = "";
        break;
      }
    default:
      KEYBOARD_BUFFER += key;
  }
}
