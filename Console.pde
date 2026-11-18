class Console{
  PApplet parent;
  color font_color = green;

  String KEYBOARD_BUFFER = "";
  String KEYBOARD_INPUT = "";
  final int MAX_CONSOLE_LINES = 32;
  String[] CONSOLE_LINES = new String[MAX_CONSOLE_LINES];

  String CONSOLE_TAG = "GCS>> ";
  String CONSOLE_TAB = "      ";


  String HELP_LIST_COMMANDS = CONSOLE_TAB + "All commands:\n"
                            + CONSOLE_TAB + "cmd | telem | port | restart\n\n"
                            + CONSOLE_TAB + "cmd    | Send command to CANSAT system(s).\n"
                            + CONSOLE_TAB + "-------+----------------------------------\n"
                            + CONSOLE_TAB + "telem  | Dislay received telemetry packet.\n"
                            + CONSOLE_TAB + "-------+----------------------------------\n"
                            + CONSOLE_TAB + "port   | Choose port ot receive packets.\n"
                            + CONSOLE_TAB + "-------+----------------------------------\n"
                            + CONSOLE_TAB + "restart| Restart GUI.\n";

  String HELP_TELEM = CONSOLE_TAB + "telem: Display received telemetry packet.\n\n"
                    + CONSOLE_TAB + "-------+---------------------------------------------------------------------\n"
                    + CONSOLE_TAB + "SYNTAX | telem [VERB] [NOUN] [PARAM]\n"
                    + CONSOLE_TAB + "-------+---------------------------------------------------------------------\n"
                    + CONSOLE_TAB + "VERB   | Mandatory field. \n"
                    + CONSOLE_TAB + "       | disp ~ displays latest recieved telemetry packet.\n"
                    + CONSOLE_TAB + "       | stream ~ streams received telemetry packets.\n"
                    + CONSOLE_TAB + "-------+---------------------------------------------------------------------\n"
                    + CONSOLE_TAB + "NOUN   | Mandatory field.\n"
                    + CONSOLE_TAB + "       | CTR ~ display telemetry from container.\n"
                    + CONSOLE_TAB + "       | PQ ~ display telemetry from pocketqube.\n"
                    + CONSOLE_TAB + "-------+---------------------------------------------------------------------\n"
                    + CONSOLE_TAB + "PARAM  | Mandatory field. \n"
                    + CONSOLE_TAB + "       | raw ~ displays raw packet\n"
                    + CONSOLE_TAB + "       | parsed ~ displays parsed packet\n"
                    + CONSOLE_TAB + "-------+---------------------------------------------------------------------\n"
                    + CONSOLE_TAB + "EXAMPLE| telem stream CTR raw ~ streams raw telemetry packets from container.\n"
                    + CONSOLE_TAB + "-------+---------------------------------------------------------------------\n";
                    
  String HELP_CMD = CONSOLE_TAB + "cmd: Send command to CANSAT system(s).\n\n"
                  + CONSOLE_TAB + "SYNTAX | cmd [rxMCU] [VERB] [NOUN] [PARAM]\n"
                  + CONSOLE_TAB + "-------+-----------------------------------------------------\n"
                  + CONSOLE_TAB + "rxMCU  | Mandatory field.\n"
                  + CONSOLE_TAB + "       | MCU to receive command. CTR or PQ.\n"
                  + CONSOLE_TAB + "-------+-----------------------------------------------------\n"
                  + CONSOLE_TAB + "VERB   | Mandatory field.\n"
                  + CONSOLE_TAB + "       | 'verb' field of command. Refer to command handbook.\n"
                  + CONSOLE_TAB + "-------+-----------------------------------------------------\n"
                  + CONSOLE_TAB + "NOUN   | Mandatory field.\n"
                  + CONSOLE_TAB + "       | 'noun' field of command. Refer to command handbook.\n"
                  + CONSOLE_TAB + "-------+-----------------------------------------------------\n"
                  + CONSOLE_TAB + "PARAM  | Optional field.\n"
                  + CONSOLE_TAB + "       | 'param' field of command. Refer to command handbook.\n"
                  + CONSOLE_TAB + "-------+-----------------------------------------------------\n"
                  + CONSOLE_TAB + "EXAMPLE| cmd CTR ENABLE SIMUALTION\n"
                  + CONSOLE_TAB + "-------+-----------------------------------------------------\n";

  String HELP_PORT = CONSOLE_TAB + "port: Choose port to receive packets.\n\n"
                   + CONSOLE_TAB + "      The port connected with GCS ESP32 should be chosen.\n"
                   + CONSOLE_TAB + "SYNTAX | port [VERB] [PARAM]\n"
                   + CONSOLE_TAB + "-------+------------------------------------------------------------------------\n"
                   + CONSOLE_TAB + "VERB   | Mandatory field. \n"
                   + CONSOLE_TAB + "       | list ~ displays all available ports. No additional arguments needed.\n"
                   + CONSOLE_TAB + "       | open ~ oepn a port for packet receiving.\n"
                   + CONSOLE_TAB + "-------+------------------------------------------------------------------------\n"
                   + CONSOLE_TAB + "PARAM  | Mandatory filed for \"choose\".\n"
                   + CONSOLE_TAB + "       | [Port Name] ~ name of the port to shoose\n"
                   + CONSOLE_TAB + "-------+------------------------------------------------------------------------\n"
                   + CONSOLE_TAB + "EXAMPLE| port choose /dev/ttyACM0 ~ choose port /dev/ttyACM0 to receive packets.\n"
                   + CONSOLE_TAB + "-------+------------------------------------------------------------------------\n";
  
  Console(PApplet parent){
    this.parent = parent;
  }
  
  void appendLine(String line) {
    for (int i = 0; i < MAX_CONSOLE_LINES - 1; i++) {
      CONSOLE_LINES[i] = CONSOLE_LINES[i + 1];
    }
    CONSOLE_LINES[MAX_CONSOLE_LINES - 1] = line;
  }

  void appendConsole(String message) {
    if (message == null || message.length() == 0) return;
    String[] lines = message.split("\\r\\n|\\n|\\r");
    for (String line : lines) {
      appendLine(line);
    }
  }
  
  
  //console command parser
  class ParsedCommand {
    String name;
    String args;

    ParsedCommand(String name, String args) {
      this.name = name;
      this.args = args;
    }
  }
  ParsedCommand parseCommand(String input) {
    String trimmed = input == null ? "" : input.trim();

    if (trimmed.isEmpty()) return new ParsedCommand("", "");
    String[] parts = trimmed.split("\\s+", 2);

    return new ParsedCommand(parts[0], parts.length > 1 ? parts[1] : "");
  }
  //command cmd
  void handleCMD(String args){
    if(args.equals("")){
      appendConsole(CONSOLE_TAB + "[ERROR] cmd needs an argument.");
      appendConsole(HELP_CMD);
      return;
    }
    if(args.equals("help")){
      appendConsole(HELP_CMD);
      return;
    }
    String[] fields = args.split("\\s+");
    
    //three args
    if (fields.length != 3 && fields.length != 4) {
      appendConsole(CONSOLE_TAB + "[ERROR] Invalid syntax.\n");
      appendConsole(HELP_TELEM);
      return;
    }

    String rxMCU_string = fields[0];
    String verb_string = fields[1];
    String noun_string = fields[2];
    if(fields.length == 4){
      String param_string = fields[3];
      int param = -1;
    
      try{
        param = Integer.valueOf("param_string");
      }catch(RuntimeException e){
        appendConsole(CONSOLE_TAB + "[ERROR] Parameter should be an integer.");
        return;
      }
    }
    
    int sq_num;
  }
  //end command cmd-----------------------------------------------------------------
  
  
 
  //command telem-------------------------------------------------------------------
  void showTelemetryFrame(Frame frame, String format) {
    switch(format) {
      case "raw":
        String output = "Raw Frame:";
        for (int value : frame.rawFrame) { //TODO why warning?
          output += (hex(value, 2) + " ");
        }
        appendConsole(CONSOLE_TAB + output.toString());
        break;

      case "parsed":
        //TODO
        break;
    }
  }
  void displayTelemetry(String source, String format) {
    Frame frame = null;
    switch(source) {
      case "CTR":
        frame = latest_ctr_frame;
        break;
      case "PQ":
        frame = latest_pq_frame;
        break;
    }
    if (frame == null) {
      appendConsole(CONSOLE_TAB + "[WARN] No " + source + " telemetry received yet.");
      return;
    }
    showTelemetryFrame(frame, format);
  }
  
  void handleTelem(String args) {
    String trimmed = args.trim();

    if(trimmed.isEmpty()) {
      appendConsole(CONSOLE_TAB + "[ERROR] telem requires an argument.");
      appendConsole(HELP_TELEM);
      return;
    }

    String[] fields = trimmed.split("\\s+");

    //telem stop
    if (fields.length == 1 && fields[0].equals("stop")) {
      telem_streaming = false;
      appendConsole(CONSOLE_TAB + "[INFO] Telemetry stream stopped.");
      return;
    }

    if(fields[0].equals("help")){
      appendConsole(HELP_TELEM);
      return;
    }

    //three args
    if (fields.length != 3) {
      appendConsole(CONSOLE_TAB + "[ERROR] Invalid syntax.\n");
      appendConsole(HELP_TELEM);
      return;
    }

    String action = fields[0].toLowerCase();
    String source = fields[1].toUpperCase();
    String format = fields[2].toLowerCase();

    //validate action
    if (!action.equals("disp") && !action.equals("stream")) {
      appendConsole(CONSOLE_TAB + "[ERROR] Invalid action: " + action);
      appendConsole(HELP_TELEM);
      return;
    }

    //validate source
    if(!source.equals("CTR") && !source.equals("PQ")) {
      appendConsole(CONSOLE_TAB + "[ERROR] Invalid telemetry source: " + source);
      appendConsole(HELP_TELEM);
      return;
    }

    //validate format
    if (!format.equals("raw") && !format.equals("parsed")) {
      appendConsole(CONSOLE_TAB + "[ERROR] Invalid format: " + format);
      appendConsole(HELP_TELEM);
      return;
    }

    switch(action) {
      case "disp":
        displayTelemetry(source, format);
        break;

      case "stream":
        telem_streaming = true;
        telem_stream_source = source;
        telem_stream_format = format;

        appendConsole(CONSOLE_TAB + "[INFO] Streaming " + source + " telemetry (" + format + ").");
        break;
    }
  }
  //end command telem-------------------------------------------------------------------------------
  
  
  //command port------------------------------------------------------------------------------------
  void listPorts(String args) {
    if (!args.isEmpty()) {
      appendConsole(CONSOLE_TAB + "[ERROR] Unexpected argument: " + args);
      return;
    }
    if (port_list.length < 1) {
      appendConsole(CONSOLE_TAB + "[INFO] No port found.");
      return;
    }

    appendConsole(CONSOLE_TAB + "[INFO] Full port list:");
    for (String p : port_list) {appendConsole(CONSOLE_TAB + "       " + p + "\n");}
  }
  void openPort(String requestedPort) {
    requestedPort = requestedPort.trim();
    if(requestedPort.isEmpty()) {
      appendConsole(CONSOLE_TAB + "[ERROR] Missing port name.");
      appendConsole(HELP_PORT);
      return;
    }

    for(String candidate : port_list){
      if (!requestedPort.equals(candidate)) continue;
      try{
        Serial newPort = new Serial(parent, candidate, 115200);

        port = newPort;
        port_name = candidate;
        port_chosen = true;
        port_opened = true;
        
        appendConsole(CONSOLE_TAB + "[INFO] Port set to: " + port_name);
      }catch(RuntimeException e){
        appendConsole(CONSOLE_TAB + "[ERROR] Failed to open port: " + requestedPort);
        appendConsole(CONSOLE_TAB + "[ERROR] " + e.getMessage());
      }
      return;
    }
    appendConsole(CONSOLE_TAB + "[ERROR] Couldn't find port: " + requestedPort);
  }
  void handlePort(String input) {
  port_list = Serial.list();
  ParsedCommand cmd = parseCommand(input);
  
  switch(cmd.name) {
    case "":
      appendConsole(CONSOLE_TAB + "[ERROR] port needs an argument.");
    case "help":
      appendConsole(HELP_PORT);
      break;

    case "list":
      listPorts(cmd.args);
      break;

    case "open":
      openPort(cmd.args);
      break;

    default:
      appendConsole(CONSOLE_TAB + "[ERROR] " + cmd.name + ": wrong argument.");
      break;
    }
  }  
  //end command port------------------------------------------------------------
  
  
  //console.main----------------------------------------------------------------
  void console(String input) {
  appendConsole(CONSOLE_TAG + input);

  ParsedCommand cmd = parseCommand(input);

  switch(cmd.name) {
    case "":
      appendConsole("");
      break;
      
    case "clr":   
      CONSOLE_LINES = new String[MAX_CONSOLE_LINES];
      KEYBOARD_BUFFER = "";
      break;

    case "cmd":
      handleCMD(cmd.args);
      break;

    case "telem":
      handleTelem(cmd.args);
      break;

    case "help":
      appendConsole(HELP_LIST_COMMANDS);
      break;

    case "restart":
      ui.restart();
      appendConsole(CONSOLE_TAB + "[INFO] GUI restarted.");
      break;

    case "port":
      handlePort(cmd.args);
      break;

    default:
      appendConsole(CONSOLE_TAB + cmd.name + ": command not found");
      break;
    }
  }//console()
}
