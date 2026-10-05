//protocol
static final int SYNC_0 = 0xAA;
static final int SYNC_1 = 0x55;

static final int FRAME_TYPE_SIZE = 1;
static final int MSG_HEADER_SIZE = 8;

static final int CRC_SIZE = 2;

static final int PQ_TELEMETRY_FRAME_SIZE = 141;
static final int CTR_TELEMETRY_FRAME_SIZE = 141;
static final int CMD_FRAME_SIZE = 100; //TODO
static final int MAX_FRAME_SIZE = 141;


//frame receive/parsing
Serial port;
Frame new_frame = new Frame();

static ArrayList<Integer> buffer = new ArrayList<Integer>();  
static int frame_size;
static int data_buffer = 500;

//received counters
static int count_gs_telem_ctr = 0;
static int count_gs_telem_pq = 0;
static int count_gs = 0;

//actual counters, based on telemetry
static int count_ctr_telem_ctr = 0;
static int count_pq_telem_pq = 0;
static int count_net_true = 0;

//sent counters for cmd's from gs
static int count_tx_cmd = 0;


//LOS check
static long current_time = 0;

static long LOS_threshold_ctr = 1000; //[ms], 1s, TODO
static long time_last_telem_ctr_ctr = 0;
static long time_curr_telem_ctr_ctr = 1001;
static long time_telem_ctr_gs = 0;
static boolean LOS_ctr = false;

static long LOS_threshold_pq = 1000; //[ms], 1s, TODO
static long time_last_telem_pq_pq = 0;
static long time_curr_telem_pq_pq = 1001;
static long time_telem_pq_gs = 0;
static boolean LOS_pq = false;


//ui
UI ui = new UI();
PFont font;

static String ui_mode = "STANDBY"; //consider enum

int stroke_weight = 2;

Button button_ui_mode_CTR;
Button button_ui_mode_PQ;

color grey = color(125);
color black = color(0);
color white = color(255);
color green = color(0, 255, 0);
color red = color(255, 0, 0);
color dark_green = color(0, 150, 0);
