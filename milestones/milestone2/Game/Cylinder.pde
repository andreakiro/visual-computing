public final class Cylinder {
  
  // some constants concerning cylinders
  public static final float RADIUS = 10;
  public static final float HEIGHT = 10; 
  public static final int RESOLUTION = 40;
  private final color CYLINDER_COLOR = color(50, 205, 50); // some lime green
  
  private ArrayList<PVector> positions;
  
  // attributes of a cylinder
  private PShape openCylinder;
  private PShape surfaceTop;
  private PShape surfaceBottom;
  private ArrayList<PShape> fullCylinder;
  
  /* construct a single cylinder */
  Cylinder() {
    this.positions = new ArrayList();
    this.openCylinder = new PShape();
    this.surfaceTop = new PShape();
    this.surfaceBottom = new PShape();
    
    // apply color to cylinder
    fill(CYLINDER_COLOR);
    noStroke();
    
    // get the x and y position on a circle for all the sides
    float[] xCircle = new float[Cylinder.RESOLUTION + 1]; 
    float[] yCircle = new float[Cylinder.RESOLUTION + 1];
    float angle;
    
    // init the xCircle and yCircle arrays
    for(int i = 0; i < xCircle.length; i++) {
      angle = (TWO_PI / Cylinder.RESOLUTION) * i;
      xCircle[i] = sin(angle) * Cylinder.RADIUS;
      yCircle[i] = cos(angle) * Cylinder.RADIUS;
    }
  
    // draw the borders of the cylinder
    openCylinder = createShape();
    openCylinder.beginShape(QUAD_STRIP);
    
    // draw the top of the cyclinder
    surfaceTop = createShape(); 
    surfaceTop.beginShape(TRIANGLE_FAN);
  
    // draw the bottom of the cyclinder
    surfaceBottom = createShape(); 
    surfaceBottom.beginShape(TRIANGLE_FAN);
    
    // init center vertex
    surfaceTop.vertex(0, - Cylinder.HEIGHT,0);
    surfaceBottom.vertex(0,0,0);
    
    // add vertices to fill full shapes
    for(int i = 0; i < xCircle.length; i++) { 
      openCylinder.vertex(xCircle[i], 0, yCircle[i]);
      openCylinder.vertex(xCircle[i], - Cylinder.HEIGHT, yCircle[i]);
    
      surfaceTop.vertex(xCircle[i], - Cylinder.HEIGHT, yCircle[i]);
      surfaceBottom.vertex(xCircle[i], 0, yCircle[i]);
    }
  
    // stop working on shapes
    openCylinder.endShape(); 
    surfaceTop.endShape();
    surfaceBottom.endShape();
    
    // add parts of the cylinder into full cylinder
    fullCylinder = new ArrayList();
    fullCylinder.add(openCylinder);
    fullCylinder.add(surfaceTop);
    fullCylinder.add(surfaceBottom);
  }
  
  /* display cylinder */
  void display() {
    for(PShape s : fullCylinder) {
      shape(s);
    }
  }
  
  /* add a cylinder on board */
  void addCylinder(PVector location) {
    positions.add(location);
  }
  
  /* get cylinders positions */
  ArrayList<PVector> getPositions() {
    return positions;
  }
}
