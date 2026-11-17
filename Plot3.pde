class Plot3{
  float max; float min;
  float graph_step; float graph_scale;
  float margin_left; float margin_right;
  float margin_top; float margin_bottom;
  float graphX; float graphY;
  float graph_width; float graph_height;
  static final int data_buffer = 1000;
  float [] data0 = new float[data_buffer];
  float [] data1 = new float[data_buffer];
  float [] data2 = new float[data_buffer];
  
  final color font_color = black;
  
  float label_size;
  
  void init(float[] margin_scale, float[] graph_XY, float[] graph_size, float min, float max){
    for(int i = 0; i < data_buffer; i++){data0[i] = min; data1[i] = min; data2[i] = min;}
    graph_step = data_buffer/data_buffer;
    
    margin_left = width*margin_scale[0];
    margin_right = width*margin_scale[1];
    margin_top = height*margin_scale[2];
    margin_bottom = height*margin_scale[3];
    
    graphX = graph_XY[0]; graphY = graph_XY[1];
    
    graph_width = graph_size[0] - margin_left - margin_right;
    graph_height = graph_size[1] - margin_top - margin_bottom;
    
    this.max = max; this.min = min;
    
    graph_scale = graph_height / (max - min);
    
    graph_step = graph_width / (data_buffer - 1);
    label_size = constrain(min(width, height)*0.02, 14, 30);
  }
  
  void updateArray(float data0, float data1, float data2){
    //min = data; max = data;
    for(int i = data_buffer - 1; i > 0; i--){
      this.data0[i] = this.data0[i-1];
      this.data1[i] = this.data1[i-1];
      this.data2[i] = this.data2[i-1];
      //if(this.data[i] < min) min = this.data[i];
      //if(this.data[i] > max) max = this.data[i];
    }
    //graph_scale = graph_height / (max - min);
    this.data0[0] = data0; this.data1[0] = data1; this.data2[0] = data2;
  }
  
  void plotFrame(String title){
    strokeWeight(stroke_weight);
    noFill();
    stroke(ui.main_color);
    rect(graphX, graphY, graph_width, graph_height);
    
    textSize(label_size);
    fill(font_color);
    text(title, graphX, graphY - margin_top*0.2);
    text(max, graphX, graphY + margin_top*0.6);
    text(min, graphX, graphY + graph_height - margin_bottom*0.2);
  }
  
  void plot(color plot_color_0, color plot_color_1, color plot_color_2){
    float plotY0 = data0[0]; float plotY1 = data1[0]; float plotY2 = data2[0];
    if (plotY0 < min) plotY0 = min;
    else if (plotY1 > max) plotY1 = max;
    if (plotY1 < min) plotY1 = min;
    else if (plotY2 > max) plotY2 = max;
    if (plotY2 < min) plotY2 = min;
    else if (plotY2 > max) plotY2 = max;
    
    float currentY0 = graphY + graph_height - (plotY0 - min)*graph_scale;
    float currentY1 = graphY + graph_height - (plotY1 - min)*graph_scale;
    float currentY2 = graphY + graph_height - (plotY2 - min)*graph_scale;
    
    fill(plot_color_0);
    text(data0[0], graphX, currentY0 - margin_bottom*0.2);
    fill(plot_color_1);
    text(data1[0], graphX, currentY1 - margin_bottom*0.2);
    fill(plot_color_2);
    text(data2[0], graphX, currentY2 - margin_bottom*0.2);
    
    for(int i = 1; i < data_buffer; i++){
      float x1 = graphX + graph_step*i;
      float x2 = graphX + graph_step*(i-1);
      
      float y10 = graphY + graph_height - (data0[i] - min)*graph_scale;
      float y20 = graphY + graph_height - (data0[i-1] - min)*graph_scale;
      float y11 = graphY + graph_height - (data1[i] - min)*graph_scale;
      float y21 = graphY + graph_height - (data1[i-1] - min)*graph_scale;
      float y12 = graphY + graph_height - (data2[i] - min)*graph_scale;
      float y22 = graphY + graph_height - (data2[i-1] - min)*graph_scale;
      
      stroke(plot_color_0); line(x1, y10, x2, y20);
      stroke(plot_color_1); line(x1, y11, x2, y21);
      stroke(plot_color_2); line(x1, y12, x2, y22);
    }
  }
}
