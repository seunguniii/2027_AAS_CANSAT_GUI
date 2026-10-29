class Button{
  int rectX;
  int rectY;
  int rectWidth;
  int rectHeight;
  
  color normColor;
  color highLightColor;
  //color myColor;
  
  String name;
  color fontColor;
  
  boolean pressed = false;
  boolean active = true;
  
  Button(float rectX, float rectY, float rectWidth, float rectHeight, color normColor, color highLightColor, String name, color fontColor){
    this.rectX = (int)rectX;
    this.rectY = (int)rectY;
    this.rectWidth = (int)rectWidth;
    this.rectHeight = (int)rectHeight;
    this.normColor = normColor;
    this.highLightColor = highLightColor;
    //this.myColor = normColor;
    this.name = name;
    this.fontColor = fontColor;
  }
  
  boolean mouseOver(){
    return active &&
           rectX <= mouseX && mouseX <= rectX + rectWidth &&
           rectY <= mouseY && mouseY <= rectY + rectHeight;
  }
  
  color update(){
    color myColor;
    if(!mouseOver()) {
      myColor = normColor;
      pressed = false;
      return myColor;
    }
    myColor = highLightColor;
    
    if(!mousePressed) pressed = false;
    else pressed = true;
    return myColor;
  }
  
  void drawMe(){
    strokeWeight(0);
    color myColor = update();
    fill(myColor); stroke(myColor);
    rect(rectX, rectY, rectWidth, rectHeight);
    
    fill(fontColor);
    textSize(rectHeight*0.7);
    text(name, rectX + rectWidth*0.1, rectY + rectHeight*0.7);
  }
}
