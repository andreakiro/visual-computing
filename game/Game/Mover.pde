class Mover { 
  PVector location;
  PVector velocity;
  PVector gravityForce = new PVector(0,0,0);
  
  //Sphere properties
  static final int RADIUS = 5;
  final color COLOR = color(255,14,93);
  
  //Physics
  final float GRAVITY_CONSTANT = 0.05;
  final float NORMAL_FORCE = 1;
  final float MU = 0.01;
  
  Mover(PVector location) {
    this.location = location;
    velocity = new PVector(0,0,0); 
  }
   
  /**
  *  Update the location of the sphere taking gravity and friction in account
  */
  void update(float rotX, float rotZ) {
     
    //Fiction computation
    float frictionMagnitude = NORMAL_FORCE * MU; 
    PVector friction = velocity.copy(); 
    friction.mult(-1);
    friction.normalize(); 
    friction.mult(frictionMagnitude);
     
    //Gravitation computation
    gravityForce.x = sin(rotZ) * GRAVITY_CONSTANT; 
    gravityForce.z = sin(-rotX) * GRAVITY_CONSTANT;
    
    location.add(velocity.add(gravityForce).add(friction)); 
  }

  /**
  *  Display the sphere
  */
  void display() {
   stroke(COLOR);
   strokeWeight(2);
   fill(COLOR);
   translate(location.x, location.y, location.z);
   sphere(RADIUS);
  } 

  /**
  *  Check the interaction with the wall around the plate
  */
  void checkEdges(int width) {
    int border = width/2 - RADIUS;
    
    if (location.x > border){
      velocity.x = velocity.x * -1;
      location.x = border;
    }else if(location.x < -border) {
      velocity.x = velocity.x * -1; 
      location.x = -border;
    }
    
    if (location.z > border){
      velocity.z = velocity.z * -1;
      location.z = border;
    }else if(location.z < -border) {
      velocity.z = velocity.z * -1; 
      location.z = -border;
    }
  } 
}
