import java.util.Arrays;
import processing.serial.*;

void setup() {
  printLOGO();
  println("\nUI Startup...");
  
  println("Initializing UI...");
  size(1920, 1000);
  consolas = createFont("Consolas", 30, true);
  arial = createFont("Arial", 30, true);
  italic = createFont("Italic", 30, true);
  sans_serif = createFont("SansSerif", 30, true);
  
  ui = new UI(this);
  //console = new Console(this);
  new_frame = new Frame();
  
  ui.initPlots();
  ui.initButtons();
  println("UI initialization complete.");
  ui.mode = "STANDBY";
  println("UI Standby");
}
int k = 0;
void draw() {
  background(ui.background_color);
  current_time = millis();
  
  //force port chose at startup
  if(!ui.ready()){
    //ui_mode = "UI_MODE";
  }
  
  if(port_chosen && port_opened){
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
  }
  
  //ui
  ui.updateButtons();
  //ui_mode = ui.checkPressed();
  ui.updatePlots(new_frame);
  ui.drawUILayout();
  switch(ui.mode){
    case("STANDBY"):
      ui.drawSTANDBYDisplay();
      break;
      
    case("PORT"):
      ui.drawPORTDisplay();
      if(port_chosen && !port_opened){
        try{
          port = new Serial(this, port_name, 9600);
          port_opened = true;
          ui.mode = "STANDBY";
        }
        catch(RuntimeException e){port_list = new String[0];}
      }
      break;
    
    case("CTR"):
      ui.drawCTRDisplay();
      break;
      
    case("PQ"):
      ui.drawPQDisplay();
      break;
      
    case("CMD"):
      ui.drawCMDDisplay();
      break;
      
    case("CONSOLE"):
      ui.drawConsoleDisplay();
      break;
      
    default:
      break;
  }
  
  return;
}
