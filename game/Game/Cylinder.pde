class Cylinder{
  final float cylinderBaseSize = 10;
  final float cylinderHeight = 50; 
  final int cylinderResolution = 40;
  
  PShape openCylinder = new PShape();
  PShape surfaceTop = new PShape();
  PShape surfaceBottom = new PShape();
  
  ArrayList<PShape> create(){
  //cylindreSetup(openCylinder, surfaceTop, surfaceBottom);
  float angle;
  float[] x = new float[cylinderResolution + 1]; 
  float[] y = new float[cylinderResolution + 1]; //get the x and y position on a circle for all the sides
  
  for(int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  
  openCylinder = createShape(); 
  openCylinder.beginShape(QUAD_STRIP); //draw the border of the cylinder
  
  surfaceTop = createShape(); 
  surfaceTop.beginShape(TRIANGLE_FAN);
  
  surfaceBottom = createShape(); 
  surfaceBottom.beginShape(TRIANGLE_FAN);
  
  surfaceTop.vertex(0, -cylinderHeight,0);
  surfaceBottom.vertex(0,0,0);
  for(int i = 0; i < x.length; i++) { 
    openCylinder.vertex(x[i], 0, y[i]);
    openCylinder.vertex(x[i], -cylinderHeight, y[i]);
    
    surfaceTop.vertex(x[i], -cylinderHeight, y[i]);
    
    surfaceBottom.vertex(x[i], 0, y[i]);
  }
  
  openCylinder.endShape(); 
  surfaceTop.endShape();
  surfaceBottom.endShape();
  ArrayList<PShape> a = new ArrayList();
  a.add(openCylinder);
  a.add(surfaceTop);
  a.add(surfaceBottom);
  return a;
  }
}
