final float RATIO = 5;

float rx = 0;
float rz = 0;
float speed = 1;
final int PLATE_WIDTH = 150;
Mover sphere;

void settings() {
  size(500, 500, P3D);
}

void setup() {
  sphere = new Mover(new PVector(0,-10,0));
}

void draw() {
  background(200);
  camera(0, 0, 300, 0, 0, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  
  color red = color(255, 0, 0);
  color green = color(0, 255, 0);
  color blue = color(0, 0, 255);
  color grey = color(200, 200, 200);
  
  //drawText(red, green, grey);
  
  rotateX(rx);
  rotateZ(rz);
  
  //drawAxes(red, green, blue);
  drawPlate(grey);
  sphere.update(rx, rz);
  sphere.checkEdges(PLATE_WIDTH);
  sphere.display();
  
}

void drawPlate(color c1){
  noStroke();
  fill(c1);
  box(PLATE_WIDTH, 10, PLATE_WIDTH);
}

void drawText(color c1, color c2, color c3){
  pushMatrix();
  translate(-width/2, -height/2, 0);
  fill(c1);
  text("X rotation : " + rx * 180 / PI, 10, 10);
  fill(c2);
  text("Z rotation : " + rz * 180 / PI, 10, 20);
  fill(c3);
  text("Speed : " + speed, 10, 30);
  popMatrix();
}

void drawAxes(color c1, color c2, color c3){
  stroke(c1);
  fill(c1);
  text("X", 90, -5, 0);
  line(-100, 0, 0, 100, 0, 0); 
  
  stroke(c2);
  fill(c2);
  text("Y", 5, 90, 0);
  line(0, -100, 0, 0, 100, 0);
  
  stroke(c3);
  fill(c3);
  text("Z", -5, -5, 90);
  line(0, 0, -100, 0, 0, 100);
}

void mouseDragged() {
  float clampedMouseY = min(max(mouseY, speed*height/RATIO), height - speed*height/RATIO);
  float clampedMouseX = min(max(mouseX, speed*width/RATIO), width - speed*width/RATIO);
  rx = map(clampedMouseY, speed*height/RATIO, height - speed*height/RATIO, PI/3, -PI/3);
  rz = map(clampedMouseX, speed*width/RATIO, width - speed*width/RATIO, -PI/3, PI/3);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  speed += 0.1*e;
  speed = min(max(speed, 0.1), (RATIO/2)-0.1);
}
