class UI{
  //available ui modes
  //STANDBY
  //STARTUP / INIT
  //CHOOSE_PORT
  //CTR
  //PQ
  
  //Plots
  //TODO move these to plot class?
  //CTR plots
  Plot ctrPlotPressure = new Plot();
  Plot ctrPlotTemperature = new Plot();
  Plot ctrPlotAltitude = new Plot();
  Plot ctrPlotBatVoltage = new Plot();
  Plot ctrPlotBatCurrent = new Plot();

  //PQ plots
  Plot pqPlotPressure = new Plot();
  Plot pqPlotTemperature = new Plot();
  Plot pqPlotAltitude = new Plot();
  Plot pqPlotBatVoltage = new Plot();
  Plot pqPlotBatCurrent = new Plot();

  Plot pqPlotRotRateX = new Plot();
  Plot pqPlotRotRateY = new Plot();
  Plot pqPlotRotRateZ = new Plot();

  Plot pqPlotAccelX = new Plot();
  Plot pqPlotAccelY = new Plot();
  Plot pqPlotAccelZ = new Plot();

  Plot pqPlotMagFieldX = new Plot();
  Plot pqPlotMagFieldY = new Plot();
  Plot pqPlotMagFieldZ = new Plot();
  //gnss
  //solar panel voltage
  
  boolean ready(){
    return port_chosen; //TODO add future tests
  }
  
  void drawUILayout(){    
    strokeWeight(stroke_weight*2);
    fill(ui_color); stroke(ui_color);
    line(width*0.13, 0, width*0.13, height);
  }
  
  void initButtons(){
    button_active_mode_PORT = new Button(width*0.01, height*0.01, width*0.11, height*0.06, button_normColor, button_highLightColor, "PORT", button_fontColor);
    button_active_mode_CTR = new Button(width*0.01, height*0.08, width*0.11, height*0.06, button_normColor, button_highLightColor, "CTR", button_fontColor);
    button_ui_mode_PQ = new Button(width*0.01, height*0.15, width*0.11, height*0.06, button_normColor, button_highLightColor, "PQ", button_fontColor);
    button_RESTART = new Button(width*0.01, height*0.92, width*0.11, height*0.06, red, pink, "RESTART", button_fontColor);
  }
  
  void updateButtons(){
    button_active_mode_PORT.drawMe();
    button_RESTART.drawMe();
    button_active_mode_CTR.drawMe();
    button_ui_mode_PQ.drawMe();
  }
  
  void restart(){
    button_ports_initialized = false;
    if(port_opened){
      port.clear();
      port.stop();
    }
    port_chosen = false;
    port_opened = false;
    LOS_ctr = false;
    LOS_pq = false;
    button_active_mode_PORT.active = true;
    button_active_mode_PORT.normColor = button_normColor;
    buffer.clear();
    //data_buffer.clear();
    
    Arrays.fill(ctrPlotAltitude.data, 0);
  }
  
  String checkPressed(){
    if(button_active_mode_PORT.pressed) return "PORT";
    if(button_active_mode_CTR.pressed) return "CTR";
    if(button_ui_mode_PQ.pressed) return "PQ";
    
    if(button_RESTART.pressed) restart();
    
    return ui_mode;
  }
  
  void updatePlotArray(Frame frame){
    if(frame.ctrTelemetry != null && frame.type == Frame.Type.CTR_TELEMETRY){
      ctrPlotAltitude.updateArray(new_frame.ctrTelemetry.altitude);
      ctrPlotTemperature.updateArray(new_frame.ctrTelemetry.temperature);
      ctrPlotPressure.updateArray(new_frame.ctrTelemetry.pressure);
      ctrPlotBatVoltage.updateArray(new_frame.ctrTelemetry.batteryVoltage);
      ctrPlotBatCurrent.updateArray(new_frame.ctrTelemetry.batteryCurrent);
    }
    
    if(frame.pqTelemetry != null && frame.type == Frame.Type.PQ_TELEMETRY){
      pqPlotAltitude.updateArray(new_frame.pqTelemetry.altitude);
      pqPlotTemperature.updateArray(new_frame.pqTelemetry.temperature);
      pqPlotPressure.updateArray(new_frame.pqTelemetry.pressure);
      pqPlotBatVoltage.updateArray(new_frame.pqTelemetry.batteryVoltage);
      pqPlotBatCurrent.updateArray(new_frame.pqTelemetry.batteryCurrent);
    }
  }
  
  //CTR
  void initPlotCTR(){
    float [] margin_scale = {0.01, 0.01, 0.03, 0.03}; //left right top bottom
  
    //right column
    float [] graph_size_r = {(width - 10)*0.2, (height - 10)*0.5};
    float [] graph_XY_alt = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height};
    float [] graph_XY_C = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height + 0.5*height};
    ctrPlotAltitude.init(margin_scale, graph_XY_alt, graph_size_r, 0, 200);
    ctrPlotTemperature.init(margin_scale, graph_XY_C, graph_size_r, 20, 30);
    //ctrPlotTemperature.init(margin_scale, graph_XY_C, graph_size_r, 100, -100);
  
    //left column
    float [] graph_XY_p = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height};
    float [] graph_XY_bv = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height + 0.333*height};
    float [] graph_XY_bc = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height + 0.666*height};
    float [] graph_size_l = {(width - 10)*0.2, (height - 10)*0.333};
    ctrPlotPressure.init(margin_scale, graph_XY_p, graph_size_l, 100000, 110000);
    ctrPlotBatVoltage.init(margin_scale, graph_XY_bv, graph_size_l, 0, 5);
    ctrPlotBatCurrent.init(margin_scale, graph_XY_bc, graph_size_l, 0, 3);
  }
  
  void plotCTR(){
    ctrPlotAltitude.plot("Altitude [m]");
    ctrPlotTemperature.plot("Temperature [C]");
    ctrPlotPressure.plot("Pressure [Pa]");
    ctrPlotBatVoltage.plot("Bat. Voltage [V]");
    ctrPlotBatCurrent.plot("Bat. Current [A]");
  }
  
  
  //PQ
  void initPlotPQ(){
    float [] margin_scale = {0.01, 0.01, 0.03, 0.03}; //left right top bottom
  
    //right column
    float [] graph_size_r = {(width - 10)*0.2, (height - 10)*0.5};
    float [] graph_XY_alt = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height};
    float [] graph_XY_C = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height + 0.5*height};
    pqPlotAltitude.init(margin_scale, graph_XY_alt, graph_size_r, 0, 200);
    pqPlotTemperature.init(margin_scale, graph_XY_C, graph_size_r, 10, 27);
  
    //left column
    float [] graph_XY_p = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height};
    float [] graph_XY_bv = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height + 0.333*height};
    float [] graph_XY_bc = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height + 0.666*height};
    float [] graph_size_l = {(width - 10)*0.2, (height - 10)*0.333};
    pqPlotPressure.init(margin_scale, graph_XY_p, graph_size_l, 100200, 110000);
    pqPlotBatVoltage.init(margin_scale, graph_XY_bv, graph_size_l, 0, 5);
    pqPlotBatCurrent.init(margin_scale, graph_XY_bc, graph_size_l, 0, 3);
  }
  void plotPQ(){
    pqPlotAltitude.plot("Altitude [m]");
    pqPlotTemperature.plot("Temperature [C]");
    pqPlotPressure.plot("Pressure [Pa]");
    pqPlotBatVoltage.plot("Bat. Voltage [V]");
    pqPlotBatCurrent.plot("Bat. Current [A]");
  }
  
  void drawLOS(boolean LOS){
    if(LOS){
      strokeWeight(stroke_weight*8);
      fill(white); stroke(red);
      rect(width*0.2, height*0.2, width*0.6, height*0.6);
      fill(red); textSize(height*0.5);
      text("LOS", width*0.28, height*0.67);
    }else{}
  }
  
  void drawSTANDBYDisplay(){
    fill(font_color); textSize(height*0.3);
    text("STANDBY", width*0.25, height*0.57);
  }
  
  void drawUIModeDisplay(){
    //button_
  }
  
  void drawPORTDisplay(){
    String [] port_list = Serial.list();
    if(port_list.length == 0){
      fill(red); textSize(height*0.05);
      text("No port found", width*0.15, height*0.15);
    }
    else {
      button_ports = new Button[port_list.length];
      for(int i = 0; i < port_list.length; i++){
        button_ports[i] = new Button(width*0.15, height*0.15 + height*0.07*i, width*0.2, height*0.06, button_normColor, button_highLightColor, port_list[i], button_fontColor);
      }
    }
    
    fill(font_color); textSize(height*0.07);
    text("Choose port:", width*0.15, height*0.07);
    for(int i = 0; i < port_list.length; i++){
      button_ports[i].update();
      button_ports[i].drawMe();
      if(button_ports[i].pressed){
        port_name = port_list[i];
        button_active_mode_PORT.normColor = button_active_mode_PORT.highLightColor;
        button_active_mode_PORT.active = false;
        port_chosen = true;
      }
    }
  }
  
  void drawCTRDisplay(){
    plotCTR();
    drawLOS(LOS_ctr);
  }
  
  void drawPQDisplay(){
    plotPQ();
    drawLOS(LOS_pq);
  }
}
