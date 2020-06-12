KalmanFilter2D calmMan = new KalmanFilter2D();

void settings(){
     size(1000, 1000);
}

void setup(){
}

void draw(){
  
  PVector p = calmMan.predict_and_correct(new PVector(mouseX, mouseY));
  background(255);
  fill(color(255,0,0));
  circle(mouseX, mouseY, 15);
  fill(color(0,0,255));
  circle(p.x, p.y, 15);
}
