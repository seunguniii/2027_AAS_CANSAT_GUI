import processing.serial.*;

void setup() {
  ui_mode = "STARTUP";
  size(1920, 1000);
  background(255);
  
  printArray(Serial.list()); //list all ports, choose ground station esp
  
  port = new Serial(this, "COM4", 115200); //windows
  //port = new Serial(this, "/dev/ttyACM0", 115200); //linux
  
  //font = createFont("Consolas", 30, true);
  //textFont(font);
  
  ui.initPlotCTR();
  ui.initPlotPQ();
  ui.initButtons();
  
  ui_mode = "STANDBY";
}

void draw() {
  current_time = millis();
  //parse packet
  while (port.available() > 0) {buffer.add(port.read());}
  
  Frame parsed_frame = Frame.parseFrame(buffer);
  if(parsed_frame != null && parsed_frame.ctrTelemetry != null)
    new_frame = parsed_frame;
  
      
  //check LOS
  LOS_ctr = (time_curr_telem_ctr_ctr - time_last_telem_ctr_ctr > LOS_threshold_ctr
             || current_time - time_telem_ctr_gs > LOS_threshold_ctr)? true:false;
  LOS_pq = (time_curr_telem_pq_pq - time_last_telem_pq_pq > LOS_threshold_pq
            || current_time - time_telem_pq_gs > LOS_threshold_pq)? true:false;

  //draw
  background(255);
  
  ui.updateButtons();
  ui_mode = ui.checkMode();
  ui.updatePlotArray(new_frame);
  switch(ui_mode){
    case("STANDBY"):
      //TODO
      break;
      
    case("CTR"):
      ui.drawCTRDisplay();
      break;
      
    case("PQ"):
      ui.drawPQDisplay();
      break;
      
    default:
      break;
  }
}
