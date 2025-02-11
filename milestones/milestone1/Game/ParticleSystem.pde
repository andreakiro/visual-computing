class ParticleSystem {
  
  private PVector origin;
  private Cylinder particles;
  private boolean active;
  private final float INTERVAL = 0.5;
  private int frameCounter;
  private final PShape shapeOnOrigin;
  private final int SCALE_SHAPE = 20;
  
  ParticleSystem(PShape s) {
    this.origin = new PVector(0, 0, 0);
    this.particles = new Cylinder();
    this.active = false;
    this.frameCounter = 0;
    this.shapeOnOrigin = s;
  }
  
  void addParticle(Mover m) {
    PVector center;
    int numAttempts = 100;
    
    for (int i = 0; i < numAttempts; i++) {
      int index = int(random(particles.getPositions().size()));
      center = particles.getPositions().get(index).copy();
      
      float angle = random(TWO_PI);
      center.x += sin(angle) * 2*Cylinder.RADIUS;
      center.z += cos(angle) * 2*Cylinder.RADIUS;
      if (checkPosition(center) && m.getLocation().sub(center).mag() > Mover.RADIUS + Cylinder.RADIUS) {
        particles.addCylinder(center);
        break;
      }
    }
  }
  
  boolean checkPosition(PVector center) {
    if (! (- Board.WIDTH / 2 + Cylinder.RADIUS < center.x  && center.x < Board.WIDTH / 2 - Cylinder.RADIUS && - Board.WIDTH / 2 + Cylinder.RADIUS < center.z  && center.z  < Board.WIDTH / 2 - Cylinder.RADIUS)) return false;
    for (PVector pos: particles.getPositions()) {
      if (checkOverlap(center, pos)) return false;
    }
    return true;
  }
  
  boolean checkOverlap(PVector c1, PVector c2) {
    return c1.copy().sub(c2).mag() < Cylinder.RADIUS * 2;
  }
  
  void run(Mover m) {
    if (active) {
      int collision = m.checkCylinderCollision(particles.getPositions());
      if (collision != -1) {
        if (collision == 0) setInactive();
        else particles.getPositions().remove(collision);
      }
      frameCounter += 1;
      if (frameCounter >= frameRate * INTERVAL) {
        addParticle(m);
        frameCounter = 0;
      }
    }
  }
  
  void setOrigin(PVector origin) {
    this.origin = origin;
  }
  
  void setActive(PVector origin) {
    this.origin = origin;
    active = true;
    particles.getPositions().clear();
    particles.addCylinder(this.origin);
  }
  
  void setInactive() {
    frameCounter = 0;
    particles.getPositions().clear();
    active = false;
  }
  
  Cylinder getParticles() {
    return particles;
  }
  
  void display() {
    if (active) {
      for (PVector pos: particles.getPositions()) {
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        particles.display();
        if (pos == origin) {
          translate(0, -Cylinder.RADIUS, 0);
          scale(SCALE_SHAPE, -SCALE_SHAPE, SCALE_SHAPE);
          shape(shapeOnOrigin);
        }
        popMatrix();
      }    
    }
  }
}
