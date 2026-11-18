class UI{
  PApplet parent;
  String mode;
  final color font_color = black;
  
  color plot_color_0 = dark_green;
  color plot_color_1 = dark_blue;
  color plot_color_2 = dark_red;

  color background_color = light_grey;
  color button_normColor = black;
  color button_highlightColor = grey;
  color button_fontColor = white;
  color main_color = black;
  
  UiBundleCTR ctrBundle = new UiBundleCTR();
  UiBundlePQ pqBundle = new UiBundlePQ();

  Button button_active_mode_PORT;
  Button button_active_mode_PLT_CTR;
  Button button_active_mode_PLT_PQ;
  Button button_active_mode_CMD;
  Button button_active_mode_CONSOLE;
  Button button_RESTART;
  Console console;
  
  Button [] button_ports;
  boolean button_ports_initialized = false;
  UI(PApplet parent){
    this.parent = parent;
    console = new Console(parent);
  }
  
  boolean ready(){
    return port_opened; //TODO add future tests
  }
  
  void drawUILayout(){    
    strokeWeight(stroke_weight*2);
    fill(main_color); stroke(main_color);
    line(width*0.13, 0, width*0.13, height);
  }
  
  void initButtons(){
    button_active_mode_PORT = new Button(width*0.01, height*0.01, width*0.11, height*0.06, button_normColor, button_highlightColor, "PORT", button_fontColor);
    button_active_mode_PLT_CTR = new Button(width*0.01, height*0.08, width*0.11, height*0.06, button_normColor, button_highlightColor, "PLT CTR", button_fontColor);
    button_active_mode_PLT_PQ = new Button(width*0.01, height*0.15, width*0.11, height*0.06, button_normColor, button_highlightColor, "PLT PQ", button_fontColor);
    button_active_mode_CMD = new Button(width*0.01, height*0.22, width*0.11, height*0.06, button_normColor, button_highlightColor, "CMD", button_fontColor);
    button_active_mode_CONSOLE = new Button(width*0.01, height*0.29, width*0.11, height*0.06, button_normColor, button_highlightColor, "CONSOLE", button_fontColor);
    button_RESTART = new Button(width*0.01, height*0.92, width*0.11, height*0.06, red, pink, "RESTART", button_fontColor);
  }
  
  void initPlots(){
    ctrBundle.init();
    pqBundle.init();
  }
  
  
  String checkPressed(){
    String pressed = ui.mode;
    if(button_active_mode_PORT.pressed) pressed = "PORT";
    if(button_active_mode_PLT_CTR.pressed) pressed =  "CTR";
    if(button_active_mode_PLT_PQ.pressed) pressed = "PQ";
    if(button_active_mode_CMD.pressed) pressed =  "CMD";
    if(button_active_mode_CONSOLE.pressed) pressed = "CONSOLE";

    if(button_RESTART.pressed) restart();
    
    if(mode.equals(pressed)) return mode;
    KEYBOARD_BUFFER = "";
    return pressed;
  }  
  void updateButtons(){
    button_active_mode_PORT.drawMe();
    button_RESTART.drawMe();
    button_active_mode_PLT_CTR.drawMe();
    button_active_mode_PLT_PQ.drawMe();
    button_active_mode_CMD.drawMe();
    button_active_mode_CONSOLE.drawMe();
    
    if(mode == "PORT") button_active_mode_PORT.normColor = button_highlightColor;
    else button_active_mode_PORT.normColor = button_normColor;
    
    if(mode == "CTR") button_active_mode_PLT_CTR.normColor = button_highlightColor;
    else button_active_mode_PLT_CTR.normColor = button_normColor;
    
    if(mode == "PQ") button_active_mode_PLT_PQ.normColor = button_highlightColor;
    else button_active_mode_PLT_PQ.normColor = button_normColor;   
    
    if(mode == "CMD") button_active_mode_CMD.normColor = button_highlightColor;
    else button_active_mode_CMD.normColor = button_normColor;
    
    if(mode == "CONSOLE") button_active_mode_CONSOLE.normColor = button_highlightColor;
    else button_active_mode_CONSOLE.normColor = button_normColor;
    mode = checkPressed();
  }
  
  void updatePlots(Frame frame){
    ctrBundle.update(frame);
    pqBundle.update(frame);
  }
  
  void restart(){
    button_ports_initialized = false;
    
    if(port_opened){
      port.clear();
      port.stop();
    }
    port_chosen = false;
    port_opened = false;
    port_list = new String[0];
    
    LOS_ctr = false;
    LOS_pq = false;
    
    button_active_mode_PORT.active = true;
    button_active_mode_PORT.normColor = button_normColor;
    
    buffer.clear();
    
    console.CONSOLE_LINES = new String[console.MAX_CONSOLE_LINES];
    KEYBOARD_BUFFER = "";
    
    //reset data buffer & serial readings <- serial reading how?
  }
  
  void drawLOS(boolean LOS){
    boolean draw = (millis() / 500) % 2 == 0;
    if(LOS && draw){
      strokeWeight(stroke_weight*8);
      fill(white); stroke(red);
      rect(width*0.2, height*0.2, width*0.6, height*0.6);
      fill(red); textFont(consolas); textSize(height*0.5); 
      text("LOS", width*0.28, height*0.67);
    }else{}
  }
  
  void drawSTANDBYDisplay(){
    fill(font_color); 
    textFont(consolas); textSize(height*0.03);
    text(LOGO0, width*0.25, height*0.4);
    text(LOGO1, width*0.25, height*0.43);
    text(LOGO2, width*0.25, height*0.46);
    text(LOGO3, width*0.25, height*0.49);
    text(LOGO4, width*0.25, height*0.52);
    text(LOGO5, width*0.25, height*0.55);
    text(LOGO6, width*0.25, height*0.58);
  }
  
  void drawCMDDisplay(){
    return; //TODO
  }
  
  void drawConsoleDisplay(){
    String cursor = (millis() / 500) % 2 == 0 ? "_" : "";
    float marginx = width*0.005; float marginy = height*0.01;
    stroke(white); strokeWeight(7);
    fill(black); rect(width*0.15, height*0.1, width*0.83, height*0.875 + marginy);
    textFont(arial); fill(font_color); textSize(height*0.07);
    text("Console", width*0.15, height*0.07);
    textFont(consolas); fill(console.font_color); textSize(height*0.025);
    text(console.CONSOLE_TAG + KEYBOARD_BUFFER + cursor, width*0.15 + marginx, height*0.95);
    float lineHeight = height*0.025;
    for (int i = console.MAX_CONSOLE_LINES - 1; i >= 0; i--) {
      try{text(console.CONSOLE_LINES[console.MAX_CONSOLE_LINES - 1-i], width*0.15+marginx, 0.95*height - (i+1)*lineHeight);}
      catch(RuntimeException e){}
    }
  }
  
  void drawPORTDisplay(){
    textFont(arial);
    port_list = Serial.list();
    if(port_list.length == 0){
      fill(red); textSize(height*0.05);
      text("No port found", width*0.15, height*0.15);
    }
    else {
      button_ports = new Button[port_list.length];
      for(int i = 0; i < port_list.length; i++){
        button_ports[i] = new Button(width*0.15, height*0.15 + height*0.07*i, width*0.2, height*0.06, button_normColor, button_highlightColor, port_list[i], button_fontColor);
      }
    }
    
    fill(font_color); textSize(height*0.07);
    text("Choose port:", width*0.15, height*0.07);
    for(int i = 0; i < port_list.length; i++){
      button_ports[i].update();
      button_ports[i].drawMe();
      if(button_ports[i].pressed){
        port_name = port_list[i];
        button_active_mode_PORT.active = false;
        port_chosen = true;
      }
    }
  }
  
  void drawCTRDisplay(){
    ctrBundle.plot(plot_color_0, plot_color_1, plot_color_2);
    drawLOS(LOS_ctr);
  }
  
  void drawPQDisplay(){
    pqBundle.plot(plot_color_0, plot_color_1, plot_color_2);
    drawLOS(LOS_pq);
  }
}
