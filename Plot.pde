class Plot{
  float max; float min;
  float graph_step; float graph_scale;
  float margin_left; float margin_right;
  float margin_top; float margin_bottom;
  float graphX; float graphY;
  float graph_width; float graph_height;
  float [] data = new float[data_buffer];
  
  float label_size;
  
  void init(float[] margin_scale, float[] graph_XY, float[] graph_size, float min, float max){
    for(int i = 0; i < data_buffer; i++){data[i] = min;}
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
    
    if(data_buffer > 1) graph_step = graph_width / (data_buffer - 1);
    else graph_step = 0;
    label_size = constrain(min(width, height)*0.02, 14, 30);
  }
  
  void updateArray(float data){
    for(int i = data_buffer - 1; i > 0; i--){
      this.data[i] = this.data[i-1];
    }
    this.data[0] = data < min? min:data;
  }
  
  void plot(String title){
    strokeWeight(stroke_weight);
    
    noFill();
    stroke(0);
    rect(graphX, graphY, graph_width, graph_height);
    
    textSize(label_size);
    fill(0);
    text(title, graphX, graphY - margin_top*0.2);
    text(max, graphX, graphY + margin_top*0.6);
    text(min, graphX, graphY + graph_height - margin_bottom*0.2);
    
    fill(dark_green);
    float currentY = graphY + graph_height - (data[0] - min)*graph_scale;
    text(data[0], graphX, currentY - margin_bottom*0.2);
    
    stroke(dark_green);
    for(int i = 1; i < data_buffer; i++){
      float x1 = graphX + graph_step*i;
      float x2 = graphX + graph_step*(i-1);
      float y1 = graphY + graph_height - (data[i] - min)*graph_scale;
      float y2 = graphY + graph_height - (data[i-1] - min)*graph_scale;
      
      line(x1, y1, x2, y2);
    }
  }
}
