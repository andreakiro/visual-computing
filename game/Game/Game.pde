// todo: we still do not add cylinders in appropriate position

// setup parameters
private final float RATIO = 5;
private final int WINDOW_SIZE = 500;

// universe parameters
private float rx = 0;
private float rz = 0;
private float speed = 1; // what is this ?
private boolean addingCylinders = false;

// elements in our game
private Board board;
private Mover sphere;
private ArrayList<Cylinder> cylinders;

/* settings for our game */
void settings() {
  size(WINDOW_SIZE, WINDOW_SIZE, P3D);
}

/* kind of constructor for game */
void setup() {
  this.board = new Board();
  this.sphere = new Mover(new PVector(0, - (5 + Board.PLATE_THICKNESS/2), 0));
  this.cylinders = new ArrayList();
  pushMatrix();
}

/* each frames draw scene */
void draw() {
  background(200);
  camera(0, 0, 300, 0, 0, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
 
  if (! addingCylinders) {
    // rotate all objects in the game and play
    rotateX(rx);
    rotateZ(rz);
    sphere.update(rx, rz);
    sphere.checkEdges(Board.PLATE_WIDTH);
    sphere.checkCylinderCollision(cylinders);
  } else {
    // rotate plate to add cylinders
    rotateX(-PI/2);
  }
  
  // display all elements
  board.display();
  sphere.display();
  for (Cylinder cylinder: cylinders) {
    cylinder.display();
  }
}

/* add a cylinder on board */
void addCylinder(float x, float y) {
  PVector location = new PVector(map(x, 0, WINDOW_SIZE, - Board.PLATE_WIDTH / 2, Board.PLATE_WIDTH), - Board.PLATE_THICKNESS / 2, map(y, 0, WINDOW_SIZE, - Board.PLATE_WIDTH / 2, Board.PLATE_WIDTH));
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
    if ((WINDOW_SIZE - Board.PLATE_WIDTH) / 2 < mouseX && mouseX < (WINDOW_SIZE - (WINDOW_SIZE - Board.PLATE_WIDTH) / 2) && (WINDOW_SIZE - Board.PLATE_WIDTH) / 2 < mouseY && mouseY < (WINDOW_SIZE - (WINDOW_SIZE - Board.PLATE_WIDTH) / 2)) {
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
