// Omar Droubi, Bassel Rawda, Tarek Wehbe

class Player {
  String name;
  int x;
  int y;
  int w;
  boolean haveBall;
  int speed;
  boolean chosen;
  boolean pcControl;
  boolean defense;
  boolean stay;

  int firstPositionX;
  int firstPositionY;

  public Player(String name, int x, int y, int w, int speed, boolean pcControl, boolean defense, boolean stay) {
    this.name = name;
    this.x = x;
    this.y = y;
    this.w = w;
    this.speed = speed;
    this.pcControl = pcControl;
    this.defense = defense;
    this.haveBall = false;
    this.stay = stay;
    this.firstPositionX = x;
    this.firstPositionY = y;
  }

  void move(Ball b, ArrayList<Player> barca, int index, ArrayList<Player> opposite) {
    check(b);
    if (pcControl == false) {
      if (haveBall == true) {
        if (keyPressed) {  
          if (key == CODED) {  
            if (keyCode == UP) {
              this.y = y - speed;
              b.x = this.x;
              b.y = this.y - 15;
            }
            if (keyCode == DOWN) {
              this.y = y + speed;
              b.x = this.x;
              b.y = this.y + 15;
            }
            if (keyCode == LEFT) {
              this.x = x - speed;
              b.x = this.x - 15;
              b.y = this.y;
            }
            if (keyCode == RIGHT) {
              this.x = x + speed;
              b.x = this.x + 15;
              b.y = this.y;
            }
          }
        }
      } else {
        if (keyPressed) {  
          if (key == CODED) {  
            if (keyCode == UP) {
              this.y = y - speed;
            }
            if (keyCode == DOWN) {
              this.y = y + speed;
            }
            if (keyCode == LEFT) {
              this.x = x - speed;
            }
            if (keyCode == RIGHT) {
              this.x = x + speed;
            }
          }
        }
      }
    } else {
      if (defense == true) {

        if (haveBall == true) {

          if (this.y < 185) {
            this.y += this.speed;
            b.y += this.speed;
          }
          if (this.y > 285) {
            this.y -= this.speed;
            b.y -= this.speed;
          }

          double minimum = 100000000.0;
          double distance = minimum;

          for (int i = 0; i < 10; i++) {
            if (index != i) {
              distance = (Math.sqrt((Math.pow(((double)ball.x - (double)barca.get(i).x), (double)2.0)) + (Math.pow(((double)ball.y -(double)barca.get(i).x), (double)2.0))));
              if (distance < minimum) {
                minimum = distance;
                index = i;
              }
            }
          }

          ball.x = barca.get(index).x + 10;
          ball.y = barca.get(index).y;
        } else {
          double minimum = 100000000.0;
          double distance = minimum;

          for (int i = 0; i < 10; i++) {
            if (index != i) {
              distance = (Math.sqrt((Math.pow(((double)this.x - (double)opposite.get(i).x), (double)2.0)) + (Math.pow(((double)this.y -(double)opposite.get(i).y), (double)2.0))));
              if (distance <= minimum) {
                minimum = distance;
                index = i;
              }
            }
          }

          if (minimum <= 200) {         
            if (opposite.get(index).x < this.x - 15)
              this.x -= speed;
            if (opposite.get(index).x > this.x + 15)
              this.x += speed;
            if (opposite.get(index).y < this.y - 15)
              this.y -= speed;
            if (opposite.get(index).y > this.y + 15)
              this.y += speed;
          }

          if (this.x < width-400) {
            this.x = this.firstPositionX;
            this.y = this.firstPositionY;
          }
        }
      } else {
        if (haveBall == true) {
          this.x -= this.speed;
          b.x -= this.speed;
          if (this.y < 235) {
            this.y += this.speed;
            b.y += this.speed;
          }
          if (this.y > 285) {
            this.y -= this.speed;
            b.y -= this.speed;
          }
        } else {
          if (b.x < this.x)
            this.x -= speed;
          if (b.y < this.y)
            this.y -= speed;
          if (b.x > this.x)
            this.x += speed;
          if (b.y > this.y)
            this.y += speed;
        }
      }
    }
  }



  void check(Ball b) {
    if ((b.x >= this.x - 15 && b.x <= this.x + 15) && (b.y >= this.y - 15 && b.y <= this.y + 15)) {
      haveBall = true;
    } else {
      haveBall = false;
    }
  }

  void drawPlayer(int red, int green, int blue) {
    fill(red, green, blue);
    ellipse(x, y, w, w);
  }
}

