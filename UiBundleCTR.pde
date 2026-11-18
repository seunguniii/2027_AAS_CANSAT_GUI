class UiBundleCTR{
  Plot ctrPlotPressure = new Plot();
  Plot ctrPlotTemperature = new Plot();
  Plot ctrPlotAltitude = new Plot();
  Plot ctrPlotBatVoltage = new Plot();
  Plot ctrPlotBatCurrent = new Plot();
  
  Plot3 ctrPlotAtt = new Plot3();
  Plot3 ctrPlotRotRate = new Plot3();
  Plot3 ctrPlotAccel = new Plot3();
  
  Renderer ctrRenderer = new Renderer();

  
  void update(Frame frame){
    if(frame.ctrTelemetry == null || frame.type != Frame.Type.CTR_TELEMETRY) return;
    
    ctrPlotAltitude.updateArray(new_frame.ctrTelemetry.altitude);
      
    ctrPlotTemperature.updateArray(new_frame.ctrTelemetry.temperature);
    ctrPlotPressure.updateArray(new_frame.ctrTelemetry.pressure);
      
    ctrPlotBatVoltage.updateArray(new_frame.ctrTelemetry.batteryVoltage);
    ctrPlotBatCurrent.updateArray(new_frame.ctrTelemetry.batteryCurrent);
      
    ctrPlotAccel.updateArray(new_frame.ctrTelemetry.accel[0],
                             new_frame.ctrTelemetry.accel[1],
                             new_frame.ctrTelemetry.accel[2]);
      
    ctrPlotAtt.updateArray(new_frame.ctrTelemetry.attitude[0],
                           new_frame.ctrTelemetry.attitude[1],
                           new_frame.ctrTelemetry.attitude[2]);
                                 
    ctrPlotRotRate.updateArray(new_frame.ctrTelemetry.rotRate[0],
                               new_frame.ctrTelemetry.rotRate[1],
                               new_frame.ctrTelemetry.rotRate[2]);
  }
  
  void init(){
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
    ctrPlotBatVoltage.init(margin_scale, graph_XY_bv, graph_size, 0, 10);
    ctrPlotBatCurrent.init(margin_scale, graph_XY_bc, graph_size, 0, 10);
    ctrPlotAccel.init(margin_scale, graph_XY_acc, graph_size, -1, 1);
   
    //4th column from the right
    float [] graph_size_large = {(width - 10)*0.25, (height - 10)*0.5};
    float [] graph_XY_att = {margin_scale[0]*width + 0.15*width, margin_scale[3]*height};
    
    ctrRenderer.initCTR(60, 60, 2.75, 5);
    ctrRenderer.initPlot(margin_scale, graph_XY_att, graph_size_large);
  }
  
  
  void plotAttitudeCTR(color plot_color_0){
    float roll = ctrPlotAtt.data0[0];
    float pitch = ctrPlotAtt.data1[0];
    float yaw = ctrPlotAtt.data2[0];
    ctrRenderer.frameAttitude("Attitude");
    ctrRenderer.plotAttitude(roll, pitch, yaw, plot_color_0);
  }
  void plot(color plot_color_0, color plot_color_1, color plot_color_2){
    textFont(sans_serif);
    ctrPlotAltitude.plotFrame("Altitude [m]");
    ctrPlotAltitude.plot(plot_color_0);
    
    ctrPlotTemperature.plotFrame("Temperature [*C]");
    ctrPlotTemperature.plot(plot_color_0);
    ctrPlotPressure.plotFrame("Pressure [Pa]");
    ctrPlotPressure.plot(plot_color_0);
    
    ctrPlotBatVoltage.plotFrame("Bat. Voltage [V]");
    ctrPlotBatVoltage.plot(plot_color_0);
    ctrPlotBatCurrent.plotFrame("Bat. Current [mA]");
    ctrPlotBatCurrent.plot(plot_color_0);
    
    ctrPlotAccel.plotFrame("Acceleration [m/s2]");
    ctrPlotAccel.plot(plot_color_0, plot_color_1, plot_color_2);
    
    plotAttitudeCTR(plot_color_0);
  }
}
