import gab.opencv.*;
import processing.video.*;

ImageProcessing imgproc;
Capture cam;
static final String CAMERA_NAME = "FaceTime HD Camera";
PImage img;

// universe parameters
private float rotx = 0;
private float rotz = 0;
//private float rotationSensitivity = 2;
private boolean addingPS = false;

// elements in our game
private Board board;
private Mover sphere;
private ParticleSystem ps;
private Score score;
private BarChart chart;

PGraphics camSurface;
PGraphics gameSurface;
PGraphics minimap;
PGraphics scoreboard;
PGraphics barChart;

private final int SCORE_BOARD_HEIGHT = 150;

/* settings for our game */
void settings() {
  size(700, 700, P3D); // Remove P3D here if you want to display the camera !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //size(700, 700);
}

/* kind of constructor for game */
void setup() {
  gameSurface = createGraphics(width, height - SCORE_BOARD_HEIGHT, P3D);
  minimap = createGraphics(SCORE_BOARD_HEIGHT, SCORE_BOARD_HEIGHT, P2D);
  scoreboard = createGraphics(SCORE_BOARD_HEIGHT, SCORE_BOARD_HEIGHT, P2D);
  barChart = createGraphics(width - SCORE_BOARD_HEIGHT * 2, SCORE_BOARD_HEIGHT, P2D);
  score = new Score();
  chart = new BarChart(score, barChart.width, barChart.height);
  this.board = new Board();
  this.sphere = new Mover(new PVector(0, Mover.Y, 0));
 
  this.ps = new ParticleSystem(loadShape("robotnik.obj"));
   
  
  imgproc = new ImageProcessing(this);
  String[] args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);
  
  /*
  String[] cameras = Capture.list();
    if (cameras == null) {
      println("Failed to retrieve the list of available cameras, will try the default...");
      cam = new Capture(this, 640, 480);
    } else if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
      }
      
      //select your predefined resolution from the list:
      cam = new Capture(this, cameras[0]);
      cam.start();
    }
  */
  //img = loadImage("board2.jpg");
}

/* each frames draw scene */
void draw() {
  background(255);
  //fill(0);
  /*
  if (cam.available() == true) {
    text("yoooooooooooooooooooooo " + frameCount, 50, 690);
    cam.read();
  } else {
    text("noooooooooooooooooooooo", 50, 690); 
  }
  img = cam.get();
  //image(img, 0, 0);
  */
  
  PVector rotation = imgproc.getRotation();
  rotx = rotation.x;
  rotz = rotation.y;
  while (rotx > Math.PI / 2) rotx -= Math.PI;
  while (rotx < -Math.PI / 2) rotx += Math.PI;
  while (rotz > Math.PI / 2) rotz -= Math.PI;
  while (rotz < -Math.PI / 2) rotz += Math.PI;
  
  drawGame();
  image(gameSurface, 0, 0);
  
  drawMiniMap();
  image(minimap, 0, height - SCORE_BOARD_HEIGHT);
  
  drawScoreBoard();
  image(scoreboard, SCORE_BOARD_HEIGHT, height - SCORE_BOARD_HEIGHT);
  
  drawBarChart();
  image(barChart, SCORE_BOARD_HEIGHT * 2, height - SCORE_BOARD_HEIGHT);
  /*
  text(rotx * 180 / Math.PI + " " + rotz * 180 / Math.PI + " " + rotation.z * 180 / Math.PI, 50, 50);
  
  
  camSurface.beginDraw();
  camSurface.image(img, 0, 0);
  for(PVector c : corners) {
    camSurface.circle(c.x, c.y, 10);
  }
  camSurface.endDraw();
  image(camSurface, 0, 0);
  */
}

void drawGame() {
  gameSurface.beginDraw();
  
  // translate origin in the middle of the screen
  gameSurface.translate(width/2, height/2, 0);
  //rotateX(-PI/5);
  gameSurface.background(200);
  gameSurface.directionalLight(50, 50, 50, 0, 1, 0);
  gameSurface.ambientLight(190, 190, 190);
 
  if (! addingPS) {
    // rotate all objects in the game and play
    gameSurface.rotateX(rotx);
    gameSurface.rotateZ(rotz);
    sphere.update(rotx, rotz);
    sphere.checkEdges(Board.WIDTH);
    ps.run(sphere, score);
    chart.update();
  } else {
    // rotate plate to add cylinders
    //rotateX(PI/5);
    gameSurface.rotateX(-PI/2);
  }
  
  // display all elements
  board.display(gameSurface);
  sphere.display(gameSurface);
  ps.display(gameSurface);
  
  gameSurface.endDraw();
}

void drawMiniMap() {
  minimap.beginDraw();
  minimap.background(150);
  
  // Map
  minimap.fill(color(10, 100, 200));
  minimap.noStroke();
  minimap.rect(0, 0, SCORE_BOARD_HEIGHT, SCORE_BOARD_HEIGHT);
  
  for(PVector pos: ps.getParticles().getPositions()) {
    if (pos.x == ps.getOrigin().x && pos.z == ps.getOrigin().z) {
      minimap.fill(color(200, 0, 0));
    } else {
      minimap.fill(color(255, 255, 255));
    }
    float mapX = map(pos.x, -Board.WIDTH/2, Board.WIDTH/2, 0, SCORE_BOARD_HEIGHT); 
    float mapY = map(pos.z, -Board.WIDTH/2, Board.WIDTH/2, 0, SCORE_BOARD_HEIGHT); 
    minimap.circle(mapX, mapY, 2 * SCORE_BOARD_HEIGHT * Cylinder.RADIUS / Board.WIDTH);
  }
  
  minimap.fill(color(0, 0, 255));
  float mapX = map(sphere.getLocation().x, -Board.WIDTH/2, Board.WIDTH/2, 0, SCORE_BOARD_HEIGHT);
  float mapY = map(sphere.getLocation().z, -Board.WIDTH/2, Board.WIDTH/2, 0, SCORE_BOARD_HEIGHT);
  minimap.circle(mapX, mapY, 2 * SCORE_BOARD_HEIGHT * Mover.RADIUS / Board.WIDTH);
  
  minimap.endDraw();
}

void drawScoreBoard() {
  scoreboard.beginDraw();
  scoreboard.background(color(225, 225, 225));
  scoreboard.fill(color(0, 0, 0));
  scoreboard.textAlign(LEFT, TOP);
  scoreboard.text("Total Score:\n" + score.getScore(), 10, 10);
  scoreboard.text("Velocity\n" + sphere.getVelocityMag(), 10, 50);
  scoreboard.text("Last Score:\n" + score.getLastScore(), 10, 100);
  scoreboard.endDraw();
}

void drawBarChart() {
  barChart.beginDraw();
  barChart.background(color(12, 132, 122));
  barChart.fill(color(0, 0, 0));
  chart.display(barChart);
  barChart.endDraw();
}

/*
void mouseDragged() {
  if (!addingPS && !chart.getScrollbarLocked()) {
    float minLength = min(width, height);
    float rz = map(mouseX - pmouseX, -minLength, minLength, -PI/3, PI/3);
    float rx = map(mouseY - pmouseY, -minLength, minLength, PI/3, -PI/3);
    rotx += rx * rotationSensitivity;
    rotz += rz * rotationSensitivity;
    rotx = min(max(-PI/3, rotx), PI/3);
    rotz = min(max(-PI/3, rotz), PI/3);
  }
}
*/

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

/*
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  rotationSensitivity += 0.1*e;
  rotationSensitivity = min(max(rotationSensitivity, 0.5), 3);
}
*/

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
