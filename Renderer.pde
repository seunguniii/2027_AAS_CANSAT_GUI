class Renderer{
  Coordinate [] point;
  Line [] line;
  int [][] edges;
  
  static final int NORMAL = 0;
  static final int TOP_RIM = 1;
  static final int FRONT = 2;
  static final int BACK = 3;
  
  int[] edgeStyle;
  int[] vertexStyle;
  boolean[] showVertex;
  
  int[][] faces;
  int[][] edgeFaces;
  
  boolean[] faceVisible;
  boolean[] edgeVisible;
  boolean[] vertexVisible;
  //Find edge connecting two vertices
  int findEdgeIndex(int a, int b){
    for(int i = 0; i < edges.length; i++){
      if((edges[i][0] == a && edges[i][1] == b) ||
         (edges[i][0] == b && edges[i][1] == a)){
        return i;
      }
    }
    return -1;
  }
  
  //Build edge-face adjacency
  void buildFaceAdjacency(){
    edgeFaces = new int[edges.length][2];
  
    for(int i = 0; i < edges.length; i++){
      edgeFaces[i][0] = -1;
      edgeFaces[i][1] = -1;
    }
  
    for(int f = 0; f < faces.length; f++){
      int[] face = faces[f];
  
      for(int i = 0; i < face.length; i++){
        int a = face[i];
        int b = face[(i+1)%face.length];
  
        int edgeIndex = findEdgeIndex(a, b);
  
        if(edgeIndex == -1) continue;
  
        if(edgeFaces[edgeIndex][0] == -1){
          edgeFaces[edgeIndex][0] = f;
        }
        else if(edgeFaces[edgeIndex][1] == -1){
          edgeFaces[edgeIndex][1] = f;
        }
      }
    }
  
    faceVisible = new boolean[faces.length];
    edgeVisible = new boolean[edges.length];
    vertexVisible = new boolean[point.length];
  }
  
  
  //Update visibility after rotation
  void updateVisibility(Coordinate[] rotated){
  
    //Reset vertex visibility
    for(int i = 0; i < vertexVisible.length; i++){
      vertexVisible[i] = false;
    }
  
    //Determine face visibility
    for(int f = 0; f < faces.length; f++){
      int[] face = faces[f];
  
      //Newell's method for polygon normal
      float nx = 0;
      float ny = 0;
      float nz = 0;
  
      for(int i = 0; i < face.length; i++){
        Coordinate a = rotated[face[i]];
        Coordinate b = rotated[face[(i+1)%face.length]];
  
        nx += (a.y-b.y)*(a.z+b.z);
        ny += (a.z-b.z)*(a.x+b.x);
        nz += (a.x-b.x)*(a.y+b.y);
      }
  
      //Camera looks along positive X, Y and Z
      faceVisible[f] = (nx + ny + nz) > 0.000001;
  
      //Vertices belonging to visible faces are visible
      if(faceVisible[f]){
        for(int i = 0; i < face.length; i++){
          vertexVisible[face[i]] = true;
        }
      }
    }
  
    //Determine edge visibility
    for(int i = 0; i < edges.length; i++){
      int f1 = edgeFaces[i][0];
      int f2 = edgeFaces[i][1];
  
      boolean visible1 = f1 >= 0 && faceVisible[f1];
      boolean visible2 = f2 >= 0 && faceVisible[f2];
  
      //An edge is visible if at least one adjacent face is visible
      edgeVisible[i] = visible1 || visible2;
  
      //Fallback for edges without face adjacency
      if(f1 == -1 && f2 == -1){
        edgeVisible[i] = true;
      }
    }
  }

  void initPQ(int pointSize, int lineSize, float h_scale){
    edges = new int[lineSize][2];
    edges[0][0] = 0; edges[0][1] = 2;
    edges[1][0] = 2; edges[1][1] = 6;
    edges[2][0] = 6; edges[2][1] = 3;
    edges[3][0] = 3; edges[3][1] = 0;
    
    edges[4][0] = 1; edges[4][1] = 4;
    edges[5][0] = 4; edges[5][1] = 7;
    edges[6][0] = 7; edges[6][1] = 5;
    edges[7][0] = 5; edges[7][1] = 1;
    
    edges[8][0] = 0; edges[8][1] = 1;
    edges[9][0] = 2; edges[9][1] = 4;
    edges[10][0] = 3; edges[10][1] = 5;
    edges[11][0] = 6; edges[11][1] = 7;
    
    float h = (float)(3.0/Math.sqrt(2.0));
    point = new Coordinate[pointSize];
    line = new Line[lineSize];
    
    //x: pitch(green), y: yaw(blue), z: roll(red)
    point[0] = new Coordinate(h, -h_scale*h, h);
    point[1] = new Coordinate(h, -h_scale*h, -h);
    point[2] = new Coordinate(h, h_scale*h, h);
    point[3] = new Coordinate(-h, -h_scale*h, h);
    point[4] = new Coordinate(h, h_scale*h, -h);
    point[5] = new Coordinate(-h, -h_scale*h, -h);
    point[6] = new Coordinate(-h, h_scale*h, h);
    point[7] = new Coordinate(-h, h_scale*h, -h);
    
    
    line[0] = new Line(point[0], point[2]);
    line[1] = new Line(point[2], point[6]);
    line[2] = new Line(point[6], point[3]);
    line[3] = new Line(point[3], point[0]);
    
    line[4] = new Line(point[1], point[4]);
    line[5] = new Line(point[4], point[7]);
    line[6] = new Line(point[7], point[5]);
    line[7] = new Line(point[5], point[1]);
    
    line[8] = new Line(point[0], point[1]);
    line[9] = new Line(point[2], point[4]);
    line[10] = new Line(point[3], point[5]);
    line[11] = new Line(point[6], point[7]);
    
    faces = new int[][]{{0, 1, 4, 2}, // +X: Front
                        {3, 6, 7, 5}, // -X: Back
                        {2, 4, 7, 6}, // +Y: Top
                        {0, 3, 5, 1}, // -Y: Bottom
                        {0, 2, 6, 3}, // +Z: Side
                        {1, 5, 7, 4}};  // -Z: Opposite side
    //color
    edgeStyle = new int[lineSize];
    vertexStyle = new int[pointSize];
    showVertex = new boolean[pointSize];
    
    float topY = h_scale*h;
    
    for(int i = 0; i < pointSize; i++){
      if(abs(point[i].y - topY) < 0.0001) vertexStyle[i] = TOP_RIM;
      if(abs(point[i].x - h) < 0.0001){
        if(vertexStyle[i] != TOP_RIM) vertexStyle[i] = FRONT;
      }
      showVertex[i] = true;
    }
    
    for(int i = 0; i < edges.length; i++){
      Coordinate a = point[edges[i][0]];
      Coordinate b = point[edges[i][1]];
    
      boolean topEdge = abs(a.y - topY) < 0.0001 &&
                        abs(b.y - topY) < 0.0001;
    
      boolean frontEdge = abs(a.x - h) < 0.0001 &&
                          abs(b.x - h) < 0.0001;
    
      if(topEdge) edgeStyle[i] = TOP_RIM;
      else if(frontEdge) edgeStyle[i] = FRONT;
    }
    
    buildFaceAdjacency();
  }   
  
  
  void initCTR(int segments, int meridians, float radius, float h){
    //segments >= 3, meridian >= 1, segment % meridian = 0
    point = new Coordinate[segments*2];
    edges = new int[segments*2 + meridians][2];
    
    edgeStyle = new int[edges.length];
    vertexStyle = new int[segments*2];
    showVertex = new boolean[segments*2];
    
    float halfHeight = 0.5*h;
    
    for(int i = 0; i < segments; i++){
      float angle = TWO_PI*i/segments;
      
      float x = radius*cos(angle);
      float y = radius*sin(angle);
      
      int next = (i+1)%segments;
      
      //bottom
      point[i]= new Coordinate(x, -halfHeight, y);
      edges[i][0] = i;
      edges[i][1] = next;
      
      //top
      point[i+segments] = new Coordinate(x, halfHeight, y);
      edges[i + segments][0] = i + segments;
      edges[i + segments][1] = next + segments;
      
      edgeStyle[i + segments] = TOP_RIM;
      vertexStyle[i+segments] = TOP_RIM;
      showVertex[i + segments] = true;
    }
    
    int stride = segments/meridians;
    for(int i = 0; i < meridians; i++){
      int index = i*stride;
      int edgeIndex = segments*2 + i;
      
      edges[segments*2 + i][0] = index;
      edges[segments*2 + i][1] = index + segments;
    
      if(i == 0){
        edgeStyle[edgeIndex] = FRONT;
        vertexStyle[index] = FRONT;
        showVertex[index] = true;
        showVertex[index+segments] = true;
      }else if(meridians > 1 && i == meridians/2){
        edgeStyle[edgeIndex] = BACK;
        vertexStyle[index] = BACK;
        showVertex[index] = true;
        showVertex[index+segments] = true;
      }
    }
    
    faces = new int[segments + 2][];
    
    //lateral
    for(int i = 0; i < segments; i++){
      int next = (i+1)%segments;
      faces[i] = new int[]{i, i + segments, next + segments, next};
    }
    
    //bottom face: outward normal points toward -y
    faces[segments] = new int[segments];
    for(int i = 0; i < segments; i++){faces[segments][i] = i;}
    
    //top face: outward normal points toward +y
    faces[segments+1] = new int[segments];
    for(int i = 0; i < segments; i++){faces[segments+1][i] = segments + (segments-1-i);}
    
    line = new Line[edges.length];
    for(int i = 0; i < edges.length;i++){
      line[i] = new Line(point[edges[i][0]], point[edges[i][1]]);
    }
    buildFaceAdjacency();
  }
  
  Coordinate rotatePoint(Coordinate point, float roll, float pitch, float yaw){
    float cosr = cos(roll); float sinr = sin(roll);
    float cosp = cos(pitch); float sinp = sin(pitch);
    float cosy = cos(yaw); float siny = sin(yaw);
    
    //roll
    float xr = point.x*cosr - point.y*sinr;
    float yr = point.x*sinr + point.y*cosr;
    float zr = point.z;
    
    //ptich
    float xrp = xr;
    float yrp = yr*cosp - zr*sinp;
    float zrp = yr*sinp + zr*cosp;
    
    //yaw
    float xrpy = xrp*cosy + zrp*siny;
    float yrpy = yrp;
    float zrpy = -xrp*siny + zrp*cosy;
    
    return new Coordinate(xrpy, yrpy, zrpy);
  }
  
  Coordinate[] transform(float roll, float pitch, float yaw){
    Coordinate[] result = new Coordinate[point.length];
    for(int i = 0; i < point.length; i++){result[i] = rotatePoint(point[i], roll, pitch, yaw);}
    return result;
  }
  
  PVector project(Coordinate p){
    float x = (p.x - p.z)*0.70710678;
    float y = (p.x - 2*p.y + p.z) * 0.40824829;
    
    return new PVector(x, y);
  }
  
  
  //draw
  float scale;   
  float margin_left; float margin_right;
  float margin_top; float margin_bottom;
  float graphX; float graphY;
  float graph_width; float graph_height;
  float label_size;
  
  void initPlot(float[] margin_scale, float[] graph_XY, float[] graph_size){
    margin_left = width*margin_scale[0];
    margin_right = width*margin_scale[1];
    margin_top = height*margin_scale[2];
    margin_bottom = height*margin_scale[3];
    
    graphX = graph_XY[0]; graphY = graph_XY[1];
    
    graph_width = graph_size[0] - margin_left - margin_right;
    graph_height = graph_size[1] - margin_top - margin_bottom;
    label_size = constrain(min(width, height)*0.02, 14, 30);    
    scale = 200*graph_size[0]/width;
  }
  
  void frameAttitude(String title){
    strokeWeight(stroke_weight);
    noFill();
    stroke(ui_color);
    rect(graphX, graphY, graph_width, graph_height);
    
    textSize(label_size);
    fill(font_color);
    text(title, graphX, graphY - margin_top*0.2);    
  }
  
  void drawAxisGuide(){
    float ox = graph_width*0.1 + graphX;
    float oy = graph_height*0.9 + graphY;
    float L = graph_width*0.1;
    float dx = L*0.70710678;
    float dy = L*0.40824829;
    
    stroke(green);
    line(ox, oy, ox + dx, oy + dy);
    stroke(blue);
    line(ox, oy, ox, oy - L*0.81649658);
    stroke(red);
    line(ox, oy, ox - dx, oy + dy);
  }
  
  float viewDepth(Coordinate p){return p.x + p.y + p.z;}
  void plotAttitude(float roll, float pitch, float yaw){
    strokeWeight(stroke_weight);
    drawAxisGuide();
    
    Coordinate[] rotated = transform(roll, pitch, yaw);
    PVector[] projected = new PVector[point.length];
    
    for(int i = 0; i < rotated.length; i++){projected[i] = project(rotated[i]);}
    updateVisibility(rotated);
    
    int maxItems = edges.length + point.length;
    
    float[] depths = new float[maxItems];
    int[] types = new int[maxItems];
    int[] indices = new int[maxItems];
    
    int count = 0;
    
    for(int i = 0; i < edges.length; i++){
      if(!edgeVisible[i]) continue;
      Coordinate a = rotated[edges[i][0]];
      Coordinate b = rotated[edges[i][1]];
      
      depths[count] = (viewDepth(a) + viewDepth(b))*0.5;
      types[count] = 0;
      indices[count] = i;
      
      count++;
    }
    
    for(int i = 0; i < point.length; i++){ 
      if(!showVertex[i] || !vertexVisible[i]) continue;
      depths[count] = viewDepth(rotated[i]);
      types[count] = 1;
      indices[count] = i;
      
      count++;
    }
    
    for(int i = 1; i < count; i++){
      float keyDepth = depths[i];
      int keyType = types[i];
      int keyIndex = indices[i];
      int j = i - 1;

      while(j >= 0 && depths[j] > keyDepth){
        depths[j+1] = depths[j];
        types[j+1] = types[j];
        indices[j+1] = indices[j];
        j--;
      }

      depths[j+1] = keyDepth;
      types[j+1] = keyType;
      indices[j+1] = keyIndex;
    }

    for(int i = 0; i < count; i++){
      if(types[i] == 0){
        int edgeIndex = indices[i];
  
        int aIndex = edges[edgeIndex][0];
        int bIndex = edges[edgeIndex][1];
  
        Coordinate a = rotated[aIndex];
        Coordinate b = rotated[bIndex];

        PVector pa = projected[aIndex];
        PVector pb = projected[bIndex];

        switch(edgeStyle[edgeIndex]){
          case TOP_RIM:
            stroke(render_top_color); break;
          case FRONT:
            stroke(render_front_color); break;
          case BACK:
            stroke(render_back_color); break;

          default:
            float depth = (a.y + b.y)*0.5;
            float g = map(depth, -3.7, 3.7, 80, 255);
            stroke(0, g, 0);
            break;
        }
        
        strokeWeight(stroke_weight);
        line(graphX + graph_width*0.5 + scale*pa.x, graphY + graph_height*0.5 + scale*pa.y,
             graphX + graph_width*0.5 + scale*pb.x, graphY + graph_height*0.5 + scale*pb.y);
      }else{ //vertices
        int index = indices[i];
  
        Coordinate p = rotated[index];
        PVector pp = projected[index];

        float sx = graphX + graph_width*0.5 + scale*pp.x;
        float sy = graphY + graph_height*0.5 + scale*pp.y;

        int fillColor;

        switch(vertexStyle[index]){
          case TOP_RIM:
            fillColor = render_top_color; break;
          case FRONT:
            fillColor = render_front_color; break;
          case BACK:
            fillColor = render_back_color; break;

          default:
            float g = map(p.y, -3.7, 3.7, 80, 200);
            fillColor = color(0, g, 0);
            break;
        }
        stroke(fillColor);
        strokeWeight(stroke_weight);
        fill(fillColor);

        float diameter = max(6, stroke_weight*2.5);
        ellipse(sx, sy, diameter, diameter);
      }
    }
  }
}

class Coordinate{
  float x;
  float y;
  float z;
  
  Coordinate(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

class Line{
  Coordinate a;
  Coordinate b;
  
  Line(Coordinate a, Coordinate b){
    this.a = a;
    this.b = b;
  }
}
