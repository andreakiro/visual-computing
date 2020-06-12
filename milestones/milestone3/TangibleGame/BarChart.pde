import java.util.Collections;

public final class BarChart {
  private final float UPDATE_INTERVAL = 1;
  private final float RECTANGLE_WIDTH = 5;
  
  private float yZoomLevel = 1;
  private float xZoomLevel = 0.5;
  private float maxAbsoluteScore = 0;
  
  private int frameCounter = 0;
  private Score score;
  private final float SURF_WIDTH;
  private final float SURF_HEIGHT;
  private final float MAX_ABS_SCORE_BEFORE_ZOOM;
  private ArrayList<Float> scores = new ArrayList();
  
  private HScrollbar scrollbar;
  
  BarChart(Score s, float sWidth, float sHeight) {
    SURF_WIDTH = sWidth;
    SURF_HEIGHT = sHeight;
    MAX_ABS_SCORE_BEFORE_ZOOM = SURF_HEIGHT * 0.7 / 2;
    
    float sbWidth = SURF_WIDTH * 0.8;
    float sbX = (SURF_WIDTH - sbWidth) / 2;
    float sbY = SURF_HEIGHT * 0.9;
    scrollbar = new HScrollbar(sbX, sbY, sbWidth, SURF_HEIGHT * 0.05, SCORE_BOARD_HEIGHT * 2, height - SCORE_BOARD_HEIGHT);
    score = s;
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
      
      if (maxAbsoluteScore > MAX_ABS_SCORE_BEFORE_ZOOM) {
        yZoomLevel = MAX_ABS_SCORE_BEFORE_ZOOM / maxAbsoluteScore;
      }
    }
    
    scrollbar.update();
    xZoomLevel = map(scrollbar.getPos(), 0, 1, 0.5, 1.5);
  }
  
  void display(PGraphics surf) {
    scrollbar.display(surf);
    surf.fill(color(0, 0, 0));
    surf.stroke(color(0, 0, 0));
    int oldestScore = max(0, scores.size() - surf.width / floor(RECTANGLE_WIDTH * xZoomLevel + 3));
    for (int i = oldestScore; i < scores.size(); ++i) {
      float XBar = (i - oldestScore) * (RECTANGLE_WIDTH * xZoomLevel + 3);
      surf.rect(XBar, surf.height / 2, RECTANGLE_WIDTH * xZoomLevel, -scores.get(i) * yZoomLevel);
    }
  }
  
  boolean getScrollbarLocked() {
    return scrollbar.locked;
  }
}
