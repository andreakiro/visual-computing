class Mover { 
  PVector location;
  PVector velocity;
  PVector gravityForce = new PVector(0,0,0);
  
  final float gravityConstant = 0.05;
  final int RADIUS = 5;
  
  
   Mover(PVector location) {
    this.location = location;
    velocity = new PVector(0,0,0); 
  }
   
   void update(float rotX, float rotZ) {
     
    float normalForce = 1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu; 
    PVector friction = velocity.copy(); 
    friction.mult(-1);
    friction.normalize(); 
    friction.mult(frictionMagnitude);
     
     
    gravityForce.x = sin(rotZ) * gravityConstant; 
    gravityForce.z = sin(-rotX) * gravityConstant;
    
    location.add(velocity.add(gravityForce).add(friction)); 
  }

  void display() {
    
   stroke(color(255,14,93));
   strokeWeight(2);
   fill(color(255,14,93));
   translate(location.x, location.y, location.z);
   sphere(RADIUS);
  } 

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
