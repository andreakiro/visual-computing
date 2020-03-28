public final class Mover {
  
  // some constants concerning mover
  public static final float RADIUS = 5.0;
  public static final float Y = - (Mover.RADIUS + Board.THICKNESS/2);
  private final color MOVER_COLOR = color(255, 14, 93); // some pinky nice color
  
  // attributes of mover
  private PVector location;
  private PVector velocity;
  private PVector gravity;
  
  // some physics constants
  public static final float GRAVITY_CONSTANT = 0.1;
  public static final float NORMAL_FORCE = 1;
  public static final float MU = 0.01;
  
  /* construct the mover */
  Mover(PVector location) {
    this.location = location;
    this.velocity = new PVector(0, 0, 0);
    this.gravity = new PVector(0, 0, 0);
  }
 
  /* update mover position according to physics */
  void update(float rotX, float rotZ) {
    
    // friction with plate
    float frictionMagnitude = NORMAL_FORCE * MU; 
    PVector friction = velocity.copy(); 
    friction.mult(-1);
    friction.normalize(); 
    friction.mult(frictionMagnitude);
     
    // gravity force
    gravity.x = sin(rotZ) * GRAVITY_CONSTANT; 
    gravity.z = sin(-rotX) * GRAVITY_CONSTANT;
    
    // update mover location
    location.add(velocity.add(gravity).add(friction)); 
  }

  /* display mover on screen */
  void display() {
    pushMatrix();
    translate(location.x, location.y, location.z);
    fill(MOVER_COLOR);
    stroke(MOVER_COLOR);
    strokeWeight(2);
    sphere(Mover.RADIUS);
    popMatrix();
  }

  /* check collisions with plate borders */
  void checkEdges(float width) {
    float border = width / 2 - Mover.RADIUS;
    
    if (location.x > border) {
      velocity.x = velocity.x * -1;
      location.x = border;
    } else if (location.x < - border) {
      velocity.x = velocity.x * -1; 
      location.x = - border;
    }
    
    if (location.z > border) {
      velocity.z = velocity.z * -1;
      location.z = border;
    } else if (location.z < - border) {
      velocity.z = velocity.z * -1; 
      location.z = - border;
    }
  }
  
  /* check collisions with cylinders borders */
  int checkCylinderCollision(ArrayList<PVector> cylinders) {
    PVector locationWithoutY = new PVector(location.x, 0, location.z);
    int result = -1;
    for (PVector pos: cylinders) {
      PVector posWithoutY = new PVector(pos.x, 0, pos.z);
      PVector dist = locationWithoutY.copy().sub(posWithoutY); // dist(mover, cylinder) on board plane
      if (dist.mag() <= Mover.RADIUS + Cylinder.RADIUS) {
        location = dist.copy().normalize().mult(Mover.RADIUS + Cylinder.RADIUS).add(new PVector(pos.x, Mover.Y, pos.z));
        PVector normal = dist.normalize();
        velocity.sub(normal.mult(2*velocity.dot(normal)));
        result = cylinders.indexOf(pos);
      }
    }
    return result;
  }
  
  PVector getLocation() {
    return location.copy();
  }
}
