// setup parameters
private final float RATIO = 5;
private final int WINDOW_SIZE = 500;

// universe parameters
private float rx = 0;
private float rz = 0;
private float rotation_sensitivity = 1;
private boolean addingCylinders = false;

// borders of the clickable region to add cylinders
private final float minBorder = (WINDOW_SIZE - Board.PLATE_WIDTH)/2;
private final float maxBorder = WINDOW_SIZE - minBorder;

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
  Cylinder salut = new Cylinder(new PVector(-50, 0, -50));
  cylinders.add(salut);
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
  float xOnBoard = map(x, minBorder, maxBorder, -Board.PLATE_WIDTH/2, Board.PLATE_WIDTH/2);
  float yOnBoard =  - Board.PLATE_THICKNESS / 2;
  float zOnBoard = map(y, minBorder, maxBorder, -Board.PLATE_WIDTH/2, Board.PLATE_WIDTH/2);
  PVector location = new PVector(xOnBoard, yOnBoard, zOnBoard);
  Cylinder cylinder = new Cylinder(location);
  cylinders.add(cylinder);
}

void mouseDragged() {
  if (!addingCylinders) {
    float clampedMouseY = min(max(mouseY, rotation_sensitivity*height/RATIO), height - rotation_sensitivity*height/RATIO);
    float clampedMouseX = min(max(mouseX, rotation_sensitivity*width/RATIO), width - rotation_sensitivity*width/RATIO);
    rx = map(clampedMouseY, rotation_sensitivity*height/RATIO, height - rotation_sensitivity*height/RATIO, PI/3, -PI/3);
    rz = map(clampedMouseX, rotation_sensitivity*width/RATIO, width - rotation_sensitivity*width/RATIO, -PI/3, PI/3);
  }
}

void mouseClicked() {
  if (addingCylinders) {
    if (minBorder < mouseX && mouseX < maxBorder && minBorder < mouseY && mouseY < maxBorder) {
      addCylinder(mouseX, mouseY);
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  rotation_sensitivity += 0.1*e;
  rotation_sensitivity = min(max(rotation_sensitivity, 0.1), (RATIO/2)-0.1);
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
