// universe parameters
private float rotx = 0;
private float rotz = 0;
private float rotationSensitivity = 1;
private boolean addingCylinders = false;

// elements in our game
private Board board;
private Mover sphere;
private ArrayList<Cylinder> cylinders;

/* settings for our game */
void settings() {
  size(500, 500, P3D);
}

/* kind of constructor for game */
void setup() {
  this.board = new Board();
  this.sphere = new Mover(new PVector(0, - (5 + Board.THICKNESS/2), 0));
  this.cylinders = new ArrayList();
  Cylinder salut = new Cylinder(new PVector(-50, 0, -50));
  cylinders.add(salut);
}

/* each frames draw scene */
void draw() {
  // translate origin in the middle of the screen
  translate(width/2, height/2, 0);
  background(200);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
 
  if (! addingCylinders) {
    // rotate all objects in the game and play
    rotateX(rotx);
    rotateZ(rotz);
    sphere.update(rotx, rotz);
    sphere.checkEdges(Board.WIDTH);
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
void addCylinder(float x, float y, float z) {
  PVector location = new PVector(x, y, z);
  Cylinder cylinder = new Cylinder(location);
  cylinders.add(cylinder);
}

void mouseDragged() {
  if (!addingCylinders) {
    float minLength = min(width, height);
    float rz = map(mouseX - pmouseX, -minLength, minLength, -PI/3, PI/3);
    float rx = map(mouseY - pmouseY, -minLength, minLength, PI/3, -PI/3);
    rotx += rx * rotationSensitivity;
    rotz += rz * rotationSensitivity;
    rotx = min(max(-PI/3, rotx), PI/3);
    rotz = min(max(-PI/3, rotz), PI/3);
  }
}

void mouseClicked() {
  if (addingCylinders) {
    // borders of the clickable region to add cylinders
    float leftBorder = (width - Board.WIDTH)/2;
    float rightBorder = width - leftBorder;
    float downBorder = (height - Board.WIDTH)/2;
    float upBorder = height - downBorder;
    if (leftBorder < mouseX && mouseX < rightBorder && downBorder < mouseY && mouseY < upBorder) {
      float xOnBoard = map(mouseX, leftBorder, rightBorder, -Board.WIDTH/2, Board.WIDTH/2);
      float yOnBoard =  - Board.THICKNESS / 2;
      float zOnBoard = map(mouseY, downBorder, upBorder, -Board.WIDTH/2, Board.WIDTH/2);
      addCylinder(xOnBoard, yOnBoard, zOnBoard);
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  rotationSensitivity += 0.1*e;
  rotationSensitivity = min(max(rotationSensitivity, 0.1), 3);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      addingCylinders = true;
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
