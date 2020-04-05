// universe parameters
private float rotx = 0;
private float rotz = 0;
private float rotationSensitivity = 2;
private boolean addingPS = false;

// elements in our game
private Board board;
private Mover sphere;
private ParticleSystem ps;

/* settings for our game */
void settings() {
  size(500, 500, P3D);
}

/* kind of constructor for game */
void setup() {
  this.board = new Board();
  this.sphere = new Mover(new PVector(0, Mover.Y, 0));
  this.ps = new ParticleSystem(loadShape("robotnik.obj"));
}

/* each frames draw scene */
void draw() {
  // translate origin in the middle of the screen
  translate(width/2, height/2, 0);
  //rotateX(-PI/5);
  background(200);
  directionalLight(50, 50, 50, 0, 1, 0);
  ambientLight(190, 190, 190);
 
  if (! addingPS) {
    // rotate all objects in the game and play
    rotateX(rotx);
    rotateZ(rotz);
    sphere.update(rotx, rotz);
    sphere.checkEdges(Board.WIDTH);
    ps.run(sphere);
  } else {
    // rotate plate to add cylinders
    //rotateX(PI/5);
    rotateX(-PI/2);
  }
  
  // display all elements
  board.display();
  sphere.display();
  ps.display();
}

void mouseDragged() {
  if (!addingPS) {
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
  if (addingPS) {
    // borders of the clickable region to add cylinders
    float leftBorder = (width - Board.WIDTH)/2;
    float rightBorder = width - leftBorder;
    float downBorder = (height - Board.WIDTH)/2;
    float upBorder = height - downBorder;
    if (leftBorder < mouseX && mouseX < rightBorder && downBorder < mouseY && mouseY < upBorder) {
      float clampedMouseX = min(max(mouseX, leftBorder + Cylinder.RADIUS), rightBorder - Cylinder.RADIUS);
      float clampedMouseY = min(max(mouseY, downBorder + Cylinder.RADIUS), upBorder - Cylinder.RADIUS);
      float xOnBoard = map(clampedMouseX, leftBorder, rightBorder, -Board.WIDTH/2, Board.WIDTH/2);
      float yOnBoard =  - Board.THICKNESS / 2;
      float zOnBoard = map(clampedMouseY, downBorder, upBorder, -Board.WIDTH/2, Board.WIDTH/2);
      PVector psLocation = new PVector(xOnBoard, yOnBoard, zOnBoard);
      PVector diff = new PVector(psLocation.x, 0, psLocation.z).sub(new PVector(sphere.getLocation().x, 0, sphere.getLocation().z));
      if (diff.mag() < Mover.RADIUS + Cylinder.RADIUS) {
        psLocation = diff.normalize().mult(Mover.RADIUS + Cylinder.RADIUS + 1).add(new PVector(sphere.getLocation().x, yOnBoard, sphere.getLocation().z));
      }
      this.ps.setActive(psLocation);
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
      addingPS = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      addingPS = false;
    }
  }
}
