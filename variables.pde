//protocol
static final int SYNC_0 = 0xAA;
static final int SYNC_1 = 0x55;

static final int FRAME_TYPE_SIZE = 1;
static final int MSG_HEADER_SIZE = 8;

static final int CRC_SIZE = 2;

static final int PQ_TELEMETRY_FRAME_SIZE = 141;
static final int CTR_TELEMETRY_FRAME_SIZE = 141;
static final int CMD_FRAME_SIZE = 100; //TODO

//port comm
Serial port;
String port_name;
boolean port_chosen = false;
boolean port_opened = false;

static final int PORT_CHECK_INTERVAL = 1000;
static int last_port_check = -1000;

//frame receive/parsing
Frame new_frame = new Frame();

static ArrayList<Integer> buffer = new ArrayList<Integer>();  
static int frame_size;

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

//plot
static final int data_buffer = 1000;
Renderer pqRenderer = new Renderer();
Renderer ctrRenderer = new Renderer();


//ui
UI ui = new UI();
PFont consolas;
PFont arial;
PFont italic;
PFont sans_serif;

static String ui_mode = "STANDBY"; //consider enum

int stroke_weight = 2;

Button [] button_ports;
boolean button_ports_initialized = false;

Button button_active_mode_PORT;
Button button_active_mode_CTR;
Button button_active_mode_PQ;
Button button_active_mode_CMD;
Button button_RESTART;

final color black = color(0);
final color grey = color(125);
final color light_grey = color(200, 200, 200);
final color white = color(255);

final color red = color(255, 0, 0);
final color green = color(0, 255, 0);
final color blue = color(0, 0, 255);

final color dark_red = color(150, 0, 0);
final color dark_green = color(0, 150, 0);
final color dark_blue = color(0, 0, 150);

final color bluish_light_grey = color(200, 200, 205);
final color pink = color(255, 125, 125);
final color magenta = color(255, 60, 220);
final color orange = color(255, 170, 40);
final color yellow = color(255, 230, 50);
final color cyan = color(0, 220, 255);
final color purple = color(210, 90, 255);

color background_color = light_grey;
color font_color = black;
color button_normColor = black;
color button_highlightColor = grey;
color button_fontColor = white;
color ui_color = black;
color plot_color_0 = dark_green;
color plot_color_1 = dark_blue;
color plot_color_2 = dark_red;

color render_top_color = cyan;
color render_front_color = magenta;
color render_back_color = orange;

//miscellaneous
String LOGO0 = "     ____     _____________    ______  _____   ______ _____  _______";
String LOGO1 = "    /  _  \\  /_    __/     | /` ____/ /     \\/`      |     \\/  ____7";
String LOGO2 = "   /  / \\  \\   7  / / ./|  |/  C___  / /`7  /  /`7  / /`7  /  /___";
String LOGO3 = "  /  /  /  /  /  / /  L_|  |\\____  \\/  L/  /  / /  /  L/  /   ___/";
String LOGO4 = " / ./  /  /  / ./ /  ___   |    /  /  ___ /  / /  /     _/  ./";
String LOGO5 = "/  L__/  /__/  L_/  /   |  |---`  /  /   /  /_/  /  /\\  V   L____";
String LOGO6 = "\\_______/L______/__/    L__|____*`\\_/    \\______^__/  \\__\\______/";
