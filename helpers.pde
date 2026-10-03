//VARIABLES
static ArrayList<Integer> buffer = new ArrayList<Integer>();  
static int frame_size;
static int frame_count = 0;
int first_packet_id;

static int data_buffer = 1000;

//FUNCTIONS

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
