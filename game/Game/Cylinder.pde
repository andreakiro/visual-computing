public final class Cylinder {
  
  // some constants concerning cylinders
  public static final float CYLINDER_BASE_SIZE = 10;
  public static final float CYLINDER_HEIGHT = 50; 
  public static final int CYLINDER_RESOLUTION = 40;
  private final color CYLINDER_COLOR = color(50, 205, 50); // some lime green
  
  // attributes of a cylinder
  private PVector location;
  private PShape openCylinder;
  private PShape surfaceTop;
  private PShape surfaceBottom;
  private ArrayList<PShape> fullCylinder;
  
  /* construct a single cylinder */
  Cylinder(PVector location) {
    this.location = location;
    this.openCylinder = new PShape();
    this.surfaceTop = new PShape();
    this.surfaceBottom = new PShape();
    
    // get the x and y position on a circle for all the sides
    float[] xCircle = new float[CYLINDER_RESOLUTION + 1]; 
    float[] yCircle = new float[CYLINDER_RESOLUTION + 1];
    float angle;
    
    // init the xCircle and yCircle arrays
    for(int i = 0; i < xCircle.length; i++) {
      angle = (TWO_PI / CYLINDER_RESOLUTION) * i;
      xCircle[i] = sin(angle) * CYLINDER_BASE_SIZE;
      yCircle[i] = cos(angle) * CYLINDER_BASE_SIZE;
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
    surfaceTop.vertex(0, - CYLINDER_HEIGHT,0);
    surfaceBottom.vertex(0,0,0);
    
    // add vertices to fill full shapes
    for(int i = 0; i < xCircle.length; i++) { 
      openCylinder.vertex(xCircle[i], 0, yCircle[i]);
      openCylinder.vertex(xCircle[i], - CYLINDER_HEIGHT, yCircle[i]);
    
      surfaceTop.vertex(xCircle[i], - CYLINDER_HEIGHT, yCircle[i]);
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
    pushMatrix();
    translate(location.x, location.y, location.z);
    fill(CYLINDER_COLOR);
    stroke(CYLINDER_COLOR);
    for(PShape s : fullCylinder) {
      shape(s);
    }
    popMatrix();
  }
  
  PVector getLocation() {
    return location.copy();
  }
}
