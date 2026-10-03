import processing.serial.*;

Serial port;
PFont font;
Plot ctrPlotPressure = new Plot();
Plot ctrPlotTemperature = new Plot();
Frame new_frame = new Frame();

void setup() {
  port = new Serial(this, "COM4", 115200); //windows
  //port = new Serial(this, "/dev/ttyACM0", 115200); //linux
  
  size(1920, 1000);
  background(0);
  
  font = createFont("Consolas", 30, true);
  textFont(font);
  
  //plot setup
  float [] margin_scale = {0.03, 0.0, 0.03, 0.03};
  float [] graph_XY_p = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height};
  float [] graph_size = {(width - 10)*0.2, (height - 10)*0.5};
  ctrPlotPressure.init(margin_scale, graph_XY_p, graph_size, 0, 150000);
  
  float [] graph_XY_C = {margin_scale[0]*width + 0.8*width, margin_scale[3]*height + 0.5*height};
  ctrPlotTemperature.init(margin_scale, graph_XY_C, graph_size, 24, 27);
}

void draw() {
  while (port.available() > 0) {
    buffer.add(port.read());
  }
  
  Frame parsed_frame = Frame.parseFrame(buffer);
  if(parsed_frame != null && parsed_frame.ctrTelemetry != null){
    new_frame = parsed_frame;
  }
  
  background(0);
  if(new_frame.ctrTelemetry != null){
    ctrPlotPressure.updateArray(new_frame.ctrTelemetry.pressure);
    ctrPlotTemperature.updateArray(new_frame.ctrTelemetry.temperature);
    ctrPlotPressure.plot("Pressure");
    ctrPlotTemperature.plot("Temperature");
  }
}
