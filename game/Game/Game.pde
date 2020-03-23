// universe parameters
private float rotx = 0;
private float rotz = 0;
private float rotationSensitivity = 2;
private boolean addingCylinders = false;

// elements in our game
private Board board;
private Mover sphere;
private Cylinder cylinder;

/* settings for our game */
void settings() {
  size(500, 500, P3D);
}

/* kind of constructor for game */
void setup() {
  this.board = new Board();
  this.sphere = new Mover(new PVector(0, Mover.Y, 0));
  this.cylinder = new Cylinder();
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
    sphere.checkCylinderCollision(cylinder.getPositions());
  } else {
    // rotate plate to add cylinders
    rotateX(-PI/2);
  }
  
  // display all elements
  board.display();
  sphere.display();
  for (PVector pos: cylinder.getPositions()) {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    cylinder.display();
    popMatrix();
  }
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
      cylinder.addCylinder(xOnBoard, yOnBoard, zOnBoard);
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  rotationSensitivity += 0.1*e;
  rotationSensitivity = min(max(rotationSensitivity, 0.5), 3);
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
