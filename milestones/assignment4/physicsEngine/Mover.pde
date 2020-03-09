class Mover { 
  PVector location;
  PVector velocity;
  final int RADIUS = 24;
  final PVector GRAVITY = new PVector(0,0.6);
   
   Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(1, 1); 
  }
   
   void update() {
    location.add(velocity.add(GRAVITY)); 
  }

  void display() {
   stroke(0);
   strokeWeight(2);
   fill(127);
   ellipse(location.x, location.y, RADIUS * 2, RADIUS * 2);
  } 

  void checkEdges() {
    if (location.x > width - RADIUS){
      velocity.x = velocity.x * -1;
      location.x = width - RADIUS;
    }else if(location.x < 0 + RADIUS) {
      velocity.x = velocity.x * -1; 
      location.x = 0 + RADIUS;
    }
    
    if (location.y > height - RADIUS ){
      velocity.y = velocity.y * -1; 
      location.y = height - RADIUS;
    }else if( location.y < 0 + RADIUS) {
      velocity.y = velocity.y * -1; 
      location.y = 0 + RADIUS;
    }
  } 
}
