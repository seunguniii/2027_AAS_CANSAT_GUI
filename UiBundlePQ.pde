class UiBundlePQ{
  Plot pqPlotPressure = new Plot();
  Plot pqPlotTemperature = new Plot();
  Plot pqPlotAltitude = new Plot();
  Plot pqPlotBatVoltage = new Plot();
  Plot pqPlotBatCurrent = new Plot();

  Plot3 pqPlotAtt = new Plot3();
  Plot3 pqPlotRotRate = new Plot3();
  Plot3 pqPlotAccel = new Plot3();
  PlotPlanar pqPlotGNSS = new PlotPlanar();
  //TODO gnss sat num
  
  Plot3 pqPlotMag = new Plot3();
  Plot pqPlotSP0 = new Plot();
  Plot pqPlotSP1 = new Plot();
  
  Renderer pqRenderer = new Renderer();
  
  void update(Frame frame){
    if(frame.pqTelemetry == null || frame.type != Frame.Type.PQ_TELEMETRY) return;
   
    pqPlotAltitude.updateArray(new_frame.pqTelemetry.altitude);
      
    pqPlotTemperature.updateArray(new_frame.pqTelemetry.temperature);
    pqPlotPressure.updateArray(new_frame.pqTelemetry.pressure);
      
    pqPlotBatVoltage.updateArray(new_frame.pqTelemetry.batteryVoltage);
    pqPlotBatCurrent.updateArray(new_frame.pqTelemetry.batteryCurrent);
      
    pqPlotAccel.updateArray(new_frame.pqTelemetry.accel[0],
                            new_frame.pqTelemetry.accel[1],
                            new_frame.pqTelemetry.accel[2]);
      
    pqPlotAtt.updateArray(new_frame.pqTelemetry.attitude[0],
                          new_frame.pqTelemetry.attitude[1],
                          new_frame.pqTelemetry.attitude[2]);
                                 
    pqPlotRotRate.updateArray(new_frame.pqTelemetry.rotRate[0],
                              new_frame.pqTelemetry.rotRate[1],
                              new_frame.pqTelemetry.rotRate[2]);
                                
      
    pqPlotMag.updateArray(new_frame.pqTelemetry.mag[0],
                          new_frame.pqTelemetry.mag[1],
                          new_frame.pqTelemetry.mag[2]);
                            
    pqPlotGNSS.updateArray(new_frame.pqTelemetry.gnssPos[0],
                           new_frame.pqTelemetry.gnssPos[1]);
                                 
    pqPlotSP0.updateArray(new_frame.pqTelemetry.solar0);
    pqPlotSP1.updateArray(new_frame.pqTelemetry.solar1);
  }
  
  void init(){
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
    pqPlotAccel.init(margin_scale, graph_XY_acc, graph_size, 0, 90);
    
    //3rd column from the right
    float [] graph_XY_sp0 = {margin_scale[0]*width + 0.4*width, margin_scale[3]*height};
    float [] graph_XY_sp1 = {margin_scale[0]*width + 0.4*width, margin_scale[3]*height + 0.333*height};
    float [] graph_XY_mag = {margin_scale[0]*width + 0.4*width, margin_scale[3]*height + 0.666*height};
    pqPlotSP0.init(margin_scale, graph_XY_sp0, graph_size, 0, 5);
    pqPlotSP1.init(margin_scale, graph_XY_sp1, graph_size, 0, 5);
    pqPlotMag.init(margin_scale, graph_XY_mag, graph_size, 0, 90);
    
    //4th column from the right
    float [] graph_size_large = {(width - 10)*0.25, (height - 10)*0.5};
    float [] graph_size_large_square = {(width - 10)*0.25, (width - 10)*0.25};
    float [] graph_XY_att = {margin_scale[0]*width + 0.15*width, margin_scale[3]*height};
    float [] graph_XY_GNSS = {margin_scale[0]*width + 0.15*width, margin_scale[3]*height + 0.5*height};
    pqPlotGNSS.init(margin_scale, graph_XY_GNSS, graph_size_large_square, 40, -82, 3);
    pqRenderer.initPQ(8, 12, 1.4);
    pqRenderer.initPlot(margin_scale, graph_XY_att, graph_size_large);
  }
  
  void plotAttitudePQ(color plot_color_0){
    float roll = pqPlotRotRate.data0[0];
    float pitch = pqPlotRotRate.data1[0];
    float yaw = pqPlotRotRate.data2[0];
    pqRenderer.frameAttitude("Attitude");
    pqRenderer.plotAttitude(roll, pitch, yaw, plot_color_0);
  }
  void plot(color plot_color_0, color plot_color_1, color plot_color_2){
    textFont(sans_serif);
    pqPlotAltitude.plotFrame("Altitude [m]");
    pqPlotAltitude.plot(plot_color_0);
    
    pqPlotTemperature.plotFrame("Temperature [*C]");
    pqPlotTemperature.plot(plot_color_0);
    pqPlotPressure.plotFrame("Pressure [Pa]");
    pqPlotPressure.plot(plot_color_0);
    
    pqPlotBatVoltage.plotFrame("Bat. Voltage [V]");
    pqPlotBatVoltage.plot(plot_color_0);
    pqPlotBatCurrent.plotFrame("Bat. Current [A]");
    pqPlotBatCurrent.plot(plot_color_0);
    
    pqPlotAccel.plotFrame("Acceleration [m/s2]");
    pqPlotAccel.plot(plot_color_0, plot_color_1, plot_color_2);
    
    pqPlotSP0.plotFrame("SP0 Volatge [V]");
    pqPlotSP0.plot(plot_color_0);
    
    pqPlotSP1.plotFrame("SP1 Volatge [V]");
    pqPlotSP1.plot(plot_color_0);
    
    pqPlotMag.plotFrame("Mag. Field [G]");
    pqPlotMag.plot(plot_color_0, plot_color_1, plot_color_2);
    
    plotAttitudePQ(plot_color_0);
    pqPlotGNSS.plotFrame("GNSS Position [Lon, Lat]");
    pqPlotGNSS.plot(plot_color_0);
  }
}
