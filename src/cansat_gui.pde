import processing.serial.*;

Serial port;

void setup() {
  port = new Serial(this, "/dev/ttyACM1", 115200);
}

void draw() {
  while (port.available() > 0) {
    buffer.add(port.read());
  }
  
  while(buffer.size() >= 3){ //sync bits + type bit
    if(buffer.get(0) != SYNC_0 || buffer.get(1) != SYNC_1){ 
      buffer.remove(0);
      continue;
    }
    frame_count++;
    println("\n\nFRAME RECEIVED");
    println("Frame Count: " + frame_count + "\n");
    println("Full Frame: \n" + buffer);
    Frame frame = new Frame();
    
    frame.type = Frame.Type.fromValue(buffer.get(2));
    if(frame.type == Frame.Type.UNKNOWN){
      println("Unknown frame type. Skipping frame.\n");
      buffer.remove(0);
      continue;
    }
    
    frame_size = frame.type.getSize();
    if(buffer.size() < frame_size) break;
    int[] packet = new int[frame_size];
    for(int i = 0; i < frame_size; i++){packet[i] = buffer.get(i);}
    for(int i = 0; i < frame_size; i++){buffer.remove(0);}
    
    frame.parseHeader(packet);
    frame.parseCRC(packet);
    if(!CRC16.verify(packet, 2, packet.length - 2)){
      println("Invalid CRC. Corrupted packet. Skipping frame.\nf");
      continue;
    }    
    frame.parsePayload(packet);
    
    println("size = " + packet.length);
    println("sync = " + hex(packet[0], 2) + " " + hex(packet[1], 2));
    println("type = " + frame.type);
    
    frame.printParsedHeader();    
    frame.printParsedPayload();
    
    
    
    println("CRC = " + hex(frame.crc, 4));
  }
}
