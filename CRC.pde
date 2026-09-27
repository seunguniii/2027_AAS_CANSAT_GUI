static class CRC16{
  static int calculate(int[] data, int offset, int length){
    int crc = 0xFFFF; //onboard logic is 16bit, processing works around 32bit
    for(int i = offset; i < offset + length; i++){
      crc ^= (data[i] & 0xFF) << 8;
      
      for(int bit = 0; bit < 8; bit++){
        if((crc & 0x8000) != 0) crc = ((crc << 1) ^ 0x1021) & 0xFFFF;
        else crc = (crc << 1) & 0xFFFF;
      }
    }
    return crc;
  }
  
  static boolean verify(int[] data, int offset, int length){    
    int received = readUInt16LE(data, offset + length - CRC_SIZE);
    int calculated = calculate(data, offset, length - CRC_SIZE);
    
    return received == calculated;
  }
}
