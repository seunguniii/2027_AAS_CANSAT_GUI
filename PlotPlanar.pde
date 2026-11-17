class PlotPlanar{
  float xmax; float xmin; float ymax; float ymin;
  float graph_step; float graph_scale;
  float margin_left; float margin_right;
  float margin_top; float margin_bottom;
  float graphX; float graphY;
  float graph_width; float graph_height;
  static final int data_buffer = 1000;
  float [] datax = new float[data_buffer];
  float [] datay = new float[data_buffer];
  
  final color font_color = black;
  
  float label_size;
  
  void init(float[] margin_scale, float[] graph_XY, float[] graph_size, float xmin, float ymin, float size){    
    this.xmax = xmin + size; this.xmin = xmin;
    this.ymax = ymin + size; this.ymin = ymin;
    for(int i = 0; i < data_buffer; i++){datax[i] = 0.5*(xmax+xmin); datay[i] = 0.5*(ymax+ymin);}
    graph_step = data_buffer/data_buffer;
    
    margin_left = width*margin_scale[0];
    margin_right = width*margin_scale[1];
    margin_top = height*margin_scale[2];
    margin_bottom = height*margin_scale[3];
    
    graphX = graph_XY[0]; graphY = graph_XY[1];
    
    graph_width = graph_size[0] - margin_left - margin_right;
    graph_height = graph_size[1] - margin_top - margin_bottom;
    
    graph_scale = graph_height / size;
    
    graph_step = graph_width / (data_buffer - 1);
    label_size = constrain(min(width, height)*0.02, 14, 30);
  }
  
  void updateArray(float datax, float datay){
    //min = data; max = data;
    for(int i = data_buffer - 1; i > 0; i--){
      this.datax[i] = this.datax[i-1];
      this.datay[i] = this.datay[i-1];
      //if(this.data[i] < min) min = this.data[i];
      //if(this.data[i] > max) max = this.data[i];
    }
    //graph_scale = graph_height / (max - min);
    this.datax[0] = datax; this.datay[0] = datay;
  }
  
  void plotFrame(String title){
    strokeWeight(stroke_weight);
    noFill();
    stroke(ui.main_color);
    rect(graphX, graphY, graph_width, graph_height);
    
    textSize(label_size);
    fill(font_color);
    text(title, graphX, graphY - margin_top*0.2);
    
    pushMatrix();
    float angle = radians(270);
    translate(graphX - margin_right*0.3, graphY + margin_top*2.5);
    rotate(angle);
    text(ymax, 0, 0);
    popMatrix();
    
    pushMatrix();
    translate(graphX - margin_right*0.3, graphY + graph_height - margin_bottom*0.2);
    rotate(angle);
    text(ymin, 0, 0);
    popMatrix();
    
    text(xmax, graphX + graph_width - margin_right*3, graphY + graph_height + margin_top*0.7);
    text(xmin, graphX - margin_left*0.5, graphY + graph_height + margin_bottom*0.7);
  }
  
  void plot(color plot_color_0){
    float plotX = datax[0]; float plotY = datay[0];
    if (plotY < ymin) plotY = ymin;
    else if (plotY > ymax) plotY = ymax;
    if (plotX < xmin) plotX = xmin;
    else if (plotX > xmax) plotX = xmax;
    
    float currentX = graphX + graph_height - (plotX - xmin)*graph_scale;
    float currentY = graphY + graph_height - (plotY - ymin)*graph_scale;
    
    fill(plot_color_0);
    String curr_pos = "(" + datax[0] + "*, " + datay[0] + "*)";
    text(curr_pos, currentX, currentY - margin_bottom*0.2);
    
    for(int i = 1; i < data_buffer; i++){
      float x0 = graphX + (datax[i] - xmin)*graph_scale;
      float x1 = graphX + (datax[i-1] - xmin)*graph_scale;
      float y0 = graphY + graph_height - (datay[i] - ymin)*graph_scale;
      float y1 = graphY + graph_height - (datay[i-1] - ymin)*graph_scale;
      
      stroke(plot_color_0); line(x0, y0, x1, y1);
    }
    stroke(plot_color_0); strokeWeight(stroke_weight*4);
    point(currentX, currentY);
  }
}
