public final class BarChart {
  private final float UPDATE_INTERVAL = 1;
  private final float RECTANGLE_WIDTH = 5;
  
  private float zoomLevel = 1;
  private float maxAbsoluteScore = 0;
  private int frameCounter = 0;
  private Score score;
  private float maxAbsScoreBeforeZoom;
  private ArrayList<Float> scores = new ArrayList();
  
  BarChart(Score s, float maxAbsScoreBeforeZoom) {
    score = s;
    this.maxAbsScoreBeforeZoom = maxAbsScoreBeforeZoom;
  }
  
  void update() {
    frameCounter += 1;
    if (frameCounter >= frameRate * UPDATE_INTERVAL) {
      frameCounter = 0;
      
      float s = score.getScore();
      scores.add(s);
      if (abs(s) > maxAbsoluteScore) {
        maxAbsoluteScore = abs(s);
      }
      
      if (maxAbsoluteScore > maxAbsScoreBeforeZoom) {
        zoomLevel = maxAbsScoreBeforeZoom / maxAbsoluteScore;
      }
    }
  }
  
  void display(PGraphics surf) {
    float XBar = 0;
    for(float s: scores) {
      surf.rect(XBar, surf.height / 2, RECTANGLE_WIDTH, -s * zoomLevel);
      XBar += RECTANGLE_WIDTH + 3;
    }
  }
}
