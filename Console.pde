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
                            + CONSOLE_TAB + "cmd | telem | port | restart";

  String HELP_TELEM = CONSOLE_TAB + "telem: Shows received telemetry packet.\n"
                    + CONSOLE_TAB + "SYNTAX: telem [VERB] [NOUN] [PARAM]\n"
                    + CONSOLE_TAB + "VERB: Mandatory field. \n"
                    + CONSOLE_TAB + "      show ~ displays latest recieved telemetry packet.\n"
                    + CONSOLE_TAB + "      stream ~ streams received telemetry packets.\n"
                    + CONSOLE_TAB + "NOUN: Mandatory filed.\n"
                    + CONSOLE_TAB + "      CTR ~ display telemetry from container.\n"
                    + CONSOLE_TAB + "      PQ ~ display telemetry from pocketqube.\n"
                    + CONSOLE_TAB + "PARAM: Mandatory field. \n"
                    + CONSOLE_TAB + "        raw ~ displays raw packet\n"
                    + CONSOLE_TAB + "        parsed ~ displays parsed packet\n"
                    + CONSOLE_TAB + "EXAMPLE: telem raw stream CTR ~ streams raw telemetry packets from container.\n";
                    
  String HELP_CMD = CONSOLE_TAB + "cmd: Sends command to cansats.\n";

  String HELP_PORT = CONSOLE_TAB + "port: Choose port to receive packets.\n"
                   + CONSOLE_TAB + "      The port connected with GCS ESP32 should be chosen.\n"
                    + CONSOLE_TAB + "SYNTAX: port [VERB] [PARAM]\n"
                    + CONSOLE_TAB + "VERB: Mandatory field. \n"
                    + CONSOLE_TAB + "      list ~ displays all available ports. No additional arguments needed.\n"
                    + CONSOLE_TAB + "      choose ~ choose a port for packet receiving.\n"
                    + CONSOLE_TAB + "PARAM: Mandatory filed for \"choose\".\n"
                    + CONSOLE_TAB + "       [Port Name] ~ name of the port to shoose\n"
                    + CONSOLE_TAB + "EXAMPLE: port choose /dev/ttyACM0 ~ choose port /dev/ttyACM0 to receive packets.\n";

  String FULL_HELP = HELP_LIST_COMMANDS + "\n\n" + HELP_CMD + "\n\n" + HELP_TELEM + "\n\n" + HELP_PORT;
  
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
  
  void console(String string){
    appendConsole(CONSOLE_TAG + string);
    String[] parts = string.trim().split("\\s+", 2);
    String command = parts[0];
    String remaining = parts.length > 1 ? parts[1] : "";
  
    switch(command){
      case(""):
        appendConsole("");
        break;
      
      case("help"):
        appendConsole(FULL_HELP);
        break;
      
      case("restart"):
        ui.restart();
        appendConsole(CONSOLE_TAB + "[INFO] GUI restarted.");
        break;
    
      case("port"):
        port_list = Serial.list();
        String[] arg_parts_ports = remaining.trim().split("\\s+", 2);
        String verb_ports = arg_parts_ports[0];
        String arg_remaining_ports = arg_parts_ports.length > 1? arg_parts_ports[1] : "";
        switch(verb_ports){
          case(""):
            appendConsole(CONSOLE_TAB + "[ERROR] " + command + " needs an argument.");
            appendConsole(HELP_PORT);
            break;
          case("list")://port list
            if(!arg_remaining_ports.equals("")){
              appendConsole(CONSOLE_TAB + "[ERROR] Unexpected argument:" + arg_remaining_ports); 
              break;
            }
            if(port_list.length < 1){
              appendConsole(CONSOLE_TAB + "[INFO] No port found.");
              break;
            }
            appendConsole(CONSOLE_TAB + "[INFO] Full port list:");
            for(int i = 0; i < port_list.length; i++){
              appendConsole(CONSOLE_TAB + "       "  + port_list[i] + "\n");
            }
            break;
          case("choose")://port choose
            String[] arg_remaining_parts_choose_ports = arg_remaining_ports.trim().split("\\s+", 2);
            String noun_choose_ports = arg_remaining_parts_choose_ports[0];
            int i = 0;
            for(; i < port_list.length; i++){
              if(noun_choose_ports.equals(port_list[i])){
                port_name = port_list[i];
                port_chosen = true;
                try{port = new Serial(parent, port_name, 115200);}
                catch(RuntimeException e){port_list = new String[0]; break;}
                port_opened = true;
                appendConsole(CONSOLE_TAB + "[INFO] Port set to: " + noun_choose_ports);
                break;
              }
            }
            if(i >= port_list.length)
              appendConsole(CONSOLE_TAB + "[ERROR] Couldn't find port: " + noun_choose_ports);
            break;
          
          default://port [wrong verb]
            appendConsole(CONSOLE_TAB + "[ERROR] " + verb_ports + ": wrong argument.");
            break;
        }//port verb end
        break;
        //port end
      
      default:
        appendConsole(CONSOLE_TAB + command + ": command not found"); 
    }
  }
}
