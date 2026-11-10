class UI{
  //available ui modes
  //STANDBY
  //PORT
  //CTR
  //PQ
  
  //Plots
  //TODO move these to a plot class?
  //CTR plots
  Plot ctrPlotPressure = new Plot();
  Plot ctrPlotTemperature = new Plot();
  Plot ctrPlotAltitude = new Plot();
  Plot ctrPlotBatVoltage = new Plot();
  Plot ctrPlotBatCurrent = new Plot();
  
  Plot ctrPlotRotRateR = new Plot();
  Plot ctrPlotRotRateP = new Plot();
  Plot ctrPlotRotRateY = new Plot();
  
  Plot ctrPlotAccelX = new Plot();
  Plot ctrPlotAccelY = new Plot();
  Plot ctrPlotAccelZ = new Plot();

  //PQ plots
  Plot pqPlotPressure = new Plot();
  Plot pqPlotTemperature = new Plot();
  Plot pqPlotAltitude = new Plot();
  Plot pqPlotBatVoltage = new Plot();
  Plot pqPlotBatCurrent = new Plot();

  Plot pqPlotRotRateR = new Plot();
  Plot pqPlotRotRateP = new Plot();
  Plot pqPlotRotRateY = new Plot();

  Plot pqPlotAccelX = new Plot();
  Plot pqPlotAccelY = new Plot();
  Plot pqPlotAccelZ = new Plot();

  Plot pqPlotMagFieldX = new Plot();
  Plot pqPlotMagFieldY = new Plot();
  Plot pqPlotMagFieldZ = new Plot();
  
  Plot pqPlotGNSSLon = new Plot();
  Plot pqPlotGNSSLat = new Plot();
  Plot pqPlotGNSSAlt = new Plot();
  
  Plot pqPlotSP0 = new Plot();
  Plot pqPlotSP1 = new Plot();
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
    button_active_mode_PORT = new Button(width*0.01, height*0.01, width*0.11, height*0.06, button_normColor, button_highlightColor, "PORT", button_fontColor);
    button_active_mode_CTR = new Button(width*0.01, height*0.08, width*0.11, height*0.06, button_normColor, button_highlightColor, "CTR", button_fontColor);
    button_active_mode_PQ = new Button(width*0.01, height*0.15, width*0.11, height*0.06, button_normColor, button_highlightColor, "PQ", button_fontColor);
    button_active_mode_CMD = new Button(width*0.01, height*0.22, width*0.11, height*0.06, button_normColor, button_highlightColor, "CMD", button_fontColor);
    button_RESTART = new Button(width*0.01, height*0.92, width*0.11, height*0.06, red, pink, "RESTART", button_fontColor);
  }
  
  void updateButtons(){
    button_active_mode_PORT.drawMe();
    button_RESTART.drawMe();
    button_active_mode_CTR.drawMe();
    button_active_mode_PQ.drawMe();
    button_active_mode_CMD.drawMe();
    
    if(ui_mode == "PORT") button_active_mode_PORT.normColor = button_highlightColor;
    else button_active_mode_PORT.normColor = button_normColor;
    
    if(ui_mode == "CTR") button_active_mode_CTR.normColor = button_highlightColor;
    else button_active_mode_CTR.normColor = button_normColor;
    
    if(ui_mode == "PQ") button_active_mode_PQ.normColor = button_highlightColor;
    else button_active_mode_PQ.normColor = button_normColor;   
    
    if(ui_mode == "CMD") button_active_mode_CMD.normColor = button_highlightColor;
    else button_active_mode_CMD.normColor = button_normColor;
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
    if(button_active_mode_PQ.pressed) return "PQ";
    if(button_active_mode_CMD.pressed) return "CMD";
    
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
      
      ctrPlotAccelX.updateArray(new_frame.ctrTelemetry.accel[0]);
      ctrPlotAccelY.updateArray(new_frame.ctrTelemetry.accel[1]);
      ctrPlotAccelZ.updateArray(new_frame.ctrTelemetry.accel[2]);
      
      ctrPlotRotRateR.updateArray(new_frame.ctrTelemetry.rotRate[0]);
      ctrPlotRotRateP.updateArray(new_frame.ctrTelemetry.rotRate[1]);
      ctrPlotRotRateY.updateArray(new_frame.ctrTelemetry.rotRate[2]);
    }
    
    if(frame.pqTelemetry != null && frame.type == Frame.Type.PQ_TELEMETRY){
      pqPlotAltitude.updateArray(new_frame.pqTelemetry.altitude);
      
      pqPlotTemperature.updateArray(new_frame.pqTelemetry.temperature);
      pqPlotPressure.updateArray(new_frame.pqTelemetry.pressure);
      
      pqPlotBatVoltage.updateArray(new_frame.pqTelemetry.batteryVoltage);
      pqPlotBatCurrent.updateArray(new_frame.pqTelemetry.batteryCurrent);
      
      pqPlotAccelX.updateArray(new_frame.pqTelemetry.accel[0]);
      pqPlotAccelY.updateArray(new_frame.pqTelemetry.accel[1]);
      pqPlotAccelZ.updateArray(new_frame.pqTelemetry.accel[2]);
      
      pqPlotRotRateR.updateArray(new_frame.pqTelemetry.rotRate[0]);
      pqPlotRotRateP.updateArray(new_frame.pqTelemetry.rotRate[1]);
      pqPlotRotRateY.updateArray(new_frame.pqTelemetry.rotRate[2]);
      
      pqPlotMagFieldX.updateArray(new_frame.pqTelemetry.mag[0]);
      pqPlotMagFieldY.updateArray(new_frame.pqTelemetry.mag[1]);
      pqPlotMagFieldZ.updateArray(new_frame.pqTelemetry.mag[2]);
      
      pqPlotSP0.updateArray(new_frame.pqTelemetry.solar0);
      pqPlotSP1.updateArray(new_frame.pqTelemetry.solar1);
    }
  }
  
  //CTR
  void initPlotCTR(){
    float [] margin_scale = {0.01, 0.01, 0.03, 0.03}; //left right top bottom
  
    //right column
    float [] graph_size = {(width - 10)*0.2, (height - 10)*0.333};
    float [] graph_XY_alt = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height};
    float [] graph_XY_C = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height + 0.333*height};
    float [] graph_XY_p = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height + 0.666*height};
    ctrPlotAltitude.init(margin_scale, graph_XY_alt, graph_size, 0, 200);
    ctrPlotTemperature.init(margin_scale, graph_XY_C, graph_size, 20, 30);
    ctrPlotPressure.init(margin_scale, graph_XY_p, graph_size, 100000, 110000);
  
    //left column
    float [] graph_XY_bv = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height};
    float [] graph_XY_bc = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height + 0.333*height};
    float [] graph_XY_acc = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height + 0.666*height};
    ctrPlotBatVoltage.init(margin_scale, graph_XY_bv, graph_size, 0, 5);
    ctrPlotBatCurrent.init(margin_scale, graph_XY_bc, graph_size, 0, 3);
    ctrPlotAccelX.init(margin_scale, graph_XY_acc, graph_size, 0, 90);
    ctrPlotAccelY.init(margin_scale, graph_XY_acc, graph_size, 0, 90);
    ctrPlotAccelZ.init(margin_scale, graph_XY_acc, graph_size, 0, 90);
   
    //4th column from the right
    float [] graph_size_large = {(width - 10)*0.25, (height - 10)*0.5};
    float [] graph_XY_att = {margin_scale[0]*width + 0.15*width, margin_scale[3]*height};
    
    ctrRenderer.initCTR(120, 20, 2.75, 5);
    ctrRenderer.initPlot(margin_scale, graph_XY_att, graph_size_large);
  }
  
  void plotCTR(){
    textFont(sans_serif);
    ctrPlotAltitude.plotFrame("Altitude [m]");
    ctrPlotAltitude.plot(plot_color_0);
    
    ctrPlotTemperature.plotFrame("Temperature [C]");
    ctrPlotTemperature.plot(plot_color_0);
    ctrPlotPressure.plotFrame("Pressure [Pa]");
    ctrPlotPressure.plot(plot_color_0);
    
    ctrPlotBatVoltage.plotFrame("Bat. Voltage [V]");
    ctrPlotBatVoltage.plot(plot_color_0);
    ctrPlotBatCurrent.plotFrame("Bat. Current [A]");
    ctrPlotBatCurrent.plot(plot_color_0);
    
    ctrPlotAccelX.plotFrame("Acceration [m/s2]");
    ctrPlotAccelX.plot(plot_color_0);
    ctrPlotAccelY.plot(plot_color_1);
    ctrPlotAccelZ.plot(plot_color_2);
    
    plotAttitudeCTR();
  }
  
  float roll = 0; float pitch = 0; float yaw = 0;
  void plotAttitudeCTR(){
    //float roll = ctrPlotRotRateR.data[data_buffer - 1];
    //float pitch = ctrPlotRotRateP.data[data_buffer - 1];
    //float yaw = ctrPlotRotRateY.data[data_buffer - 1];
    roll += 0.01; pitch += 0.01; yaw += 0.01;
    ctrRenderer.frameAttitude("Attitude");
    ctrRenderer.plotAttitude(roll, pitch, yaw);
  }
  
  //PQ
  void initPlotPQ(){
    float [] margin_scale = {0.01, 0.01, 0.03, 0.03}; //left right top bottom
  
    float [] graph_size = {(width - 10)*0.2, (height - 10)*0.333};
    
    //1st column from the right  
    float [] graph_XY_alt = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height};
    float [] graph_XY_C = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height + 0.333*height};
    float [] graph_XY_p = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height + 0.666*height};
    pqPlotAltitude.init(margin_scale, graph_XY_alt, graph_size, 0, 200);
    pqPlotTemperature.init(margin_scale, graph_XY_C, graph_size, 10, 27);
    pqPlotPressure.init(margin_scale, graph_XY_p, graph_size, 100200, 110000);
  
    //2nd column from the right
    float [] graph_XY_bv = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height};
    float [] graph_XY_bc = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height + 0.333*height};
    float [] graph_XY_acc = {margin_scale[0]*width + 0.6*width, margin_scale[3]*height + 0.666*height};
    pqPlotBatVoltage.init(margin_scale, graph_XY_bv, graph_size, 0, 5);
    pqPlotBatCurrent.init(margin_scale, graph_XY_bc, graph_size, 0, 3);
    
    pqPlotAccelX.init(margin_scale, graph_XY_acc, graph_size, 0, 90);
    pqPlotAccelY.init(margin_scale, graph_XY_acc, graph_size, 0, 90);
    pqPlotAccelZ.init(margin_scale, graph_XY_acc, graph_size, 0, 90);
    
    //3rd column from the right
    float [] graph_XY_sp0 = {margin_scale[0]*width + 0.4*width, margin_scale[3]*height};
    float [] graph_XY_sp1 = {margin_scale[0]*width + 0.4*width, margin_scale[3]*height + 0.333*height};
    float [] graph_XY_mag = {margin_scale[0]*width + 0.4*width, margin_scale[3]*height + 0.666*height};
    pqPlotSP0.init(margin_scale, graph_XY_sp0, graph_size, 0, 5);
    pqPlotSP1.init(margin_scale, graph_XY_sp1, graph_size, 0, 5);
    
    pqPlotMagFieldX.init(margin_scale, graph_XY_mag, graph_size, 0, 90);
    pqPlotMagFieldY.init(margin_scale, graph_XY_mag, graph_size, 0, 90);
    pqPlotMagFieldZ.init(margin_scale, graph_XY_mag, graph_size, 0, 90);
    
    //4th column from the right
    float [] graph_size_large = {(width - 10)*0.25, (height - 10)*0.5};
    float [] graph_XY_att = {margin_scale[0]*width + 0.15*width, margin_scale[3]*height};
    //float [] graph_XY_GNSS = {margin_scale[0]*width + 0.15*width, margin_scale[3]*height + 0.5*height};
    
    pqRenderer.initPQ(8, 12, 1.4);
    pqRenderer.initPlot(margin_scale, graph_XY_att, graph_size_large);
  }
  
  void plotPQ(){
    textFont(sans_serif);
    pqPlotAltitude.plotFrame("Altitude [m]");
    pqPlotAltitude.plot(plot_color_0);
    
    pqPlotTemperature.plotFrame("Temperature [C]");
    pqPlotTemperature.plot(plot_color_0);
    pqPlotPressure.plotFrame("Pressure [Pa]");
    pqPlotPressure.plot(plot_color_0);
    
    pqPlotBatVoltage.plotFrame("Bat. Voltage [V]");
    pqPlotBatVoltage.plot(plot_color_0);
    pqPlotBatCurrent.plotFrame("Bat. Current [A]");
    pqPlotBatCurrent.plot(plot_color_0);
    
    pqPlotAccelX.plotFrame("Acceration [m/s2]");
    pqPlotAccelX.plot(plot_color_0);
    pqPlotAccelY.plot(plot_color_1);
    pqPlotAccelZ.plot(plot_color_2);
    
    pqPlotSP0.plotFrame("SP0 Volatge [V]");
    pqPlotSP0.plot(plot_color_0);
    
    pqPlotSP1.plotFrame("SP1 Volatge [V]");
    pqPlotSP1.plot(plot_color_0);
    
    pqPlotMagFieldX.plotFrame("Mag. Field [G]");
    pqPlotMagFieldX.plot(plot_color_0);
    pqPlotMagFieldZ.plot(plot_color_1);
    pqPlotMagFieldY.plot(plot_color_2);
    
    plotAttitudePQ();
  }
  
  void plotAttitudePQ(){
    //float roll = ctrPlotRotRateR.data[data_buffer - 1];
    //float pitch = ctrPlotRotRateP.data[data_buffer - 1];
    //float yaw = ctrPlotRotRateY.data[data_buffer - 1];
    roll += 0.01; pitch += 0.01; yaw += 0.01;
    pqRenderer.frameAttitude("Attitude");
    pqRenderer.plotAttitude(roll, pitch, yaw);
  }
  
  
  void drawLOS(boolean LOS){
    if(LOS){
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
  
  void drawUIModeDisplay(){
    //button_
  }
  
  void drawCMDDisplay(){
    
  }
  
  void drawPORTDisplay(){
    textFont(sans_serif);
    String [] port_list = Serial.list();
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
        button_active_mode_PORT.normColor = button_active_mode_PORT.highlightColor;
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
