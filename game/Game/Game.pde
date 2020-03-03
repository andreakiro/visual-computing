final float RATIO = 5;

float rx = 0;
float rz = 0;
float speed = 1;

void settings() {
  size(500, 500, P3D);
}

void setup() {
}

void draw() {
  background(200);
  camera(0, 0, 450, 0, 0, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  
  color red = color(255, 0, 0);
  color green = color(0, 255, 0);
  color blue = color(0, 0, 255);
  color grey = color(125, 125, 125);
  
  pushMatrix();
  translate(-width/2, -height/2, 0);
  fill(red);
  text("X rotation : " + rx * 180 / PI, 10, 10);
  fill(green);
  text("Z rotation : " + rz * 180 / PI, 10, 20);
  fill(grey);
  text("Speed : " + speed, 10, 30);
  popMatrix();
  
  rotateX(rx);
  rotateZ(rz);
  
  noStroke();
  fill(grey);
  box(100, 10, 100);
  
  stroke(red);
  fill(red);
  text("X", 90, -5, 0);
  line(-100, 0, 0, 100, 0, 0); 
  
  stroke(green);
  fill(green);
  text("Y", 5, 90, 0);
  line(0, -100, 0, 0, 100, 0);
  
  stroke(blue);
  fill(blue);
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
