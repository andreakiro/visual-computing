public final class Board {
  
  // some constants for the board
  public static final int WIDTH = 150;
  public static final int THICKNESS = 10;
  private final color BOARD_COLOR = color(200, 200, 200); // some boring grey
  
  /* construct a board */
  Board() {}
  
  /* display board */
  void display() {
    noStroke();
    fill(BOARD_COLOR);
    box(WIDTH, THICKNESS, WIDTH);
  }
}
