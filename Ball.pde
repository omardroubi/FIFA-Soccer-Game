// Omar Droubi, Bassel Rawda, Tarek Wehbe

class Ball {
  int x;
  int y;
  int w;

  public Ball(int x, int y, int w) {
    this.x = x;
    this.y = y;
    this.w = w;
  }

  public void drawBall() {
    fill(255, 0, 0);
    ellipse(x, y, w, w);
  }
}

