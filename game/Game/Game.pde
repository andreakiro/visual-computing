final float RATIO = 5;
final int WINDOW_SIZE = 500;

Mover sphere;

// Box parameters
final int PLATE_WIDTH = 150;
final int PLATE_THICKNESS = 10;

// Universe parameters
float rx = 0;
float rz = 0;
float speed = 1;
boolean addingCylinders = false;

ArrayList<Cylinder> cylinders = new ArrayList();

void settings() {
  size(WINDOW_SIZE, WINDOW_SIZE, P3D);
}

void setup() {
  sphere = new Mover(new PVector(0, -(5 + PLATE_THICKNESS/2), 0));
  Cylinder cylinder = new Cylinder(new PVector(50, 0, 50));
  cylinders.add(cylinder);
  pushMatrix();
}

void draw() {
  background(200);
  camera(0, 0, 300, 0, 0, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
 
  if(!addingCylinders) {
    // rotate all objects in the game
    rotateX(rx);
    rotateZ(rz);
    sphere.update(rx, rz);
    sphere.checkEdges(PLATE_WIDTH);
    sphere.checkCylinderCollision(cylinders);
  } else {
    // rotate plate to add cylinders
    rotateX(-PI/2);
  }
  
  drawPlate(color(200, 200, 200));
  for (Cylinder cylinder: cylinders) {
    cylinder.display();
  }
  sphere.display();
}

void drawPlate(color c1){
  noStroke();
  fill(c1);
  box(PLATE_WIDTH, PLATE_THICKNESS, PLATE_WIDTH);
}

void addCylinder(float x, float y) {
  PVector location = new PVector(map(x, 0, WINDOW_SIZE, - PLATE_WIDTH / 2, PLATE_WIDTH), - PLATE_THICKNESS / 2, map(y, 0, WINDOW_SIZE, - PLATE_WIDTH / 2, PLATE_WIDTH));
  Cylinder cylinder = new Cylinder(location);
  cylinders.add(cylinder);
}

void mouseDragged() {
  if (!addingCylinders) {
    float clampedMouseY = min(max(mouseY, speed*height/RATIO), height - speed*height/RATIO);
    float clampedMouseX = min(max(mouseX, speed*width/RATIO), width - speed*width/RATIO);
    rx = map(clampedMouseY, speed*height/RATIO, height - speed*height/RATIO, PI/3, -PI/3);
    rz = map(clampedMouseX, speed*width/RATIO, width - speed*width/RATIO, -PI/3, PI/3);
  }
}

void mouseClicked() {
  if (addingCylinders) {
    if ((WINDOW_SIZE - PLATE_WIDTH) / 2 < mouseX && mouseX < (WINDOW_SIZE - (WINDOW_SIZE - PLATE_WIDTH) / 2) && (WINDOW_SIZE - PLATE_WIDTH) / 2 < mouseY && mouseY < (WINDOW_SIZE - (WINDOW_SIZE - PLATE_WIDTH) / 2)) {
      addCylinder(mouseX, mouseY);
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  speed += 0.1*e;
  speed = min(max(speed, 0.1), (RATIO/2)-0.1);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      addingCylinders = true;
      popMatrix();
      pushMatrix();
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      addingCylinders = false;
    }
  }
}
