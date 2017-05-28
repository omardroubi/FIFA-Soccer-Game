// Omar Droubi, Bassel Rawda, Tarek Wehbe

class goalKeeper {
  String name;
  int x;
  int y;
  int w;
  int speed;
  boolean haveBall;

  public goalKeeper(String name, int x, int y, int w, int speed) {
    this.name = name;
    this.x = x;
    this.y = y;
    this.w = w;
    this.speed = speed;
    haveBall = false;
  }

  void move(int min, int max) {
    if (y >= max)
      speed = -speed;
    if (y <= min)
      speed = -speed;

    this.y += speed;
  }


  void drawGK() {
    fill(0);
    ellipse(this.x, this.y, this.w, this.w);
  }
}

