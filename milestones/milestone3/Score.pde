public final class Score {
  private final static float HIT_CYLINDER_MULTIPLIER = 25;
  private final static float ADD_CYLINDER_LOST_POINTS = 10;
  private float score = 0;
  private float lastScore = 0;
  
  public float getScore() {
    return score;
  }
  
  public float getLastScore() {
    return lastScore;
  }
  
  public void hitCylinder(float velocity) {
    lastScore = velocity * HIT_CYLINDER_MULTIPLIER;
    score += lastScore;
  }
  
  public void addedCylinder() {
    score -= ADD_CYLINDER_LOST_POINTS;
  }
}
