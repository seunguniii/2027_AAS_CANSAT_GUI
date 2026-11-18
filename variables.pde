//port comm
Serial port;
String port_name;
boolean port_chosen = false;
boolean port_opened = false;
String [] port_list = Serial.list();

static ArrayList<Integer> buffer = new ArrayList<Integer>();  
static int frame_size;

static Frame latest_ctr_frame = null;
static Frame latest_pq_frame = null;

boolean telem_streaming = false;

String telem_stream_source = "";
String telem_stream_format = "";

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

static final long LOS_threshold_ctr = 1000; //[ms], 1s, TODO
static long time_last_telem_ctr_ctr = 0;
static long time_curr_telem_ctr_ctr = 1001;
static long time_telem_ctr_gs = 0;
static boolean LOS_ctr = false;

static final long LOS_threshold_pq = 1000; //[ms], 1s, TODO
static long time_last_telem_pq_pq = 0;
static long time_curr_telem_pq_pq = 1001;
static long time_telem_pq_gs = 0;
static boolean LOS_pq = false;

//keyboard
String KEYBOARD_BUFFER = "";
String KEYBOARD_INPUT = "";

UI ui;
Frame new_frame;
Frame cmd_frame;

PFont consolas;
PFont arial;
PFont italic;
PFont sans_serif;

final int stroke_weight = 2;

//colors
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

//miscellaneous
final String LOGO0 = "     ____     _____________    ______  _____   ______ _____  _______";
final String LOGO1 = "    /  _  \\  /_    __/     | /` ____/ /     \\/`      |     \\/  ____7";
final String LOGO2 = "   /  / \\  \\   7  / / ./|  |/  C___  / /`7  /  /`7  / /`7  /  /___";
final String LOGO3 = "  /  /  /  /  /  / /  L_|  |\\____  \\/  L/  /  / /  /  L/  /   ___/";
final String LOGO4 = " / ./  /  /  / ./ /  ___   |    /  /  ___ /  / /  /     _/  ./";
final String LOGO5 = "/  L__/  /__/  L_/  /   |  |---`  /  /   /  /_/  /  /\\  V   L____";
final String LOGO6 = "\\_______/L______/__/    L__|____*`\\_/    \\______^__/  \\__\\______/";
