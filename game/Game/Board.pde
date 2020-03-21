public final class Board {
  
  // some constants for the board
  public static final int PLATE_WIDTH = 150;
  public static final int PLATE_THICKNESS = 10;
  private final color BOARD_COLOR = color(200, 200, 200); // some boring grey
  
  /* construct a board */
  Board() {}
  
  /* display board */
  void display() {
    noStroke();
    fill(BOARD_COLOR);
    box(PLATE_WIDTH, PLATE_THICKNESS, PLATE_WIDTH);
  }
}
