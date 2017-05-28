// Omar Droubi, Bassel Rawda, Tarek Wehbe

import ddf.minim.*;
import processing.video.*;

PFont font; // Score
PFont font2; // Player
PFont font3; // GOAL!

PImage field;
PImage goal1;
PImage goal2; 
PImage messi;

Minim minim;
Movie myMovie;
AudioPlayer player;

Minim minim2;
AudioPlayer player2;

ArrayList<Player> barca;
goalKeeper keeper1;

ArrayList<Player> madrid;
goalKeeper keeper2;

Ball ball;
int index = 8;

// SCORE
int numbGoalsBarca = 0;
int numbGoalsMadrid = 0;

// Movie
boolean done1 = false;
boolean done2 = false;
boolean done3 = true;

int counter = 0;
boolean x;

void setup() {
  smooth();
  background(0);
  myMovie = new Movie(this, "EA Sports - Its in the Game.mov");

  field = loadImage("field.jpg");
  field.resize(field.width / 2, field.height / 2);

  if (myMovie.available() == false) {
    image(myMovie, 100, 30);

    myMovie.play();
  }

  size(field.width, field.height);

  messi = loadImage("messi.jpg");
  goal1 = loadImage("goal1.png");
  goal2 = loadImage("goal2.png");
  minim = new Minim(this);
  player = minim.loadFile("crowd.mp3"); 

  minim2 = new Minim(this);
  player2 = minim.loadFile("song.mp3"); 

  goal1.resize(goal1.width / 2, goal1.height / 2);
  goal2.resize(goal2.width / 2, goal2.height / 2);

  barca = new ArrayList<Player>();
  keeper1 = new goalKeeper("BRAVO", goal1.width + 10, height / 2 - 15, 20, 1);

  madrid = new ArrayList<Player>();
  keeper2 = new goalKeeper("CASILLAS", width - goal2.width - 10, height / 2 - 15, 20, 1);

  font = loadFont("TwCenMT-Italic-48.vlw");
  font2 = loadFont("Corbel-Bold-48.vlw");
  font3 = loadFont("EurostileBold-48.vlw");
  initiatePlayers();
}

void draw() {
  smooth();
  if (keyPressed) {
    if (key == 'a')
      done3 = true;
  }
  if (done1 == true && done2 == true && done3 == true) {
    player.play();  

    image(field, 0, 0);
    image(goal1, 0, height/2 - 56);
    image(goal2, width - goal1.width, height / 2 - 56);

    ball.drawBall(); 
    keeper1.drawGK();
    keeper1.move(230, 290);
    keeper2.drawGK();
    keeper2.move(230, 290);

    for (int i  = 0; i < 10; i++) {
      madrid.get(i).drawPlayer(255, 255, 255);

      barca.get(i).drawPlayer(0, 150, 255);

      if (mouseX <= barca.get(i).x + barca.get(i).w && mouseX >= barca.get(i).x - 5 && mouseY <= barca.get(i).y + barca.get(i).w && mouseY >= barca.get(i).y - 5) {
        index = i;
      }
    }

    // Text
    fill(255);
    textFont(font, 20);
    String score = "FC Barcelona " + numbGoalsBarca + " - " + numbGoalsMadrid + " Real Madrid";
    text(score, 355, 25);

    textFont(font2, 15);
    text(barca.get(index).name, 70, 533);

    // corners wall get out
    for (int i = 0; i < 10; i++) {
      if (barca.get(index).y >= field.height - 20)
        barca.get(index).y = field.height - 20;
      if (barca.get(index).x >= field.width - 60)
        barca.get(index).x = field.width - 60;
      if (barca.get(index).x <= 60)
        barca.get(index).x = 60;
      if (barca.get(index).y <= 20)
        barca.get(index).y = 20;

      if (madrid.get(index).y >= field.height - 20)
        madrid.get(index).y = field.height - 20;
      if (madrid.get(index).x >= field.width - 60)
        madrid.get(index).x = field.width - 60;
      if (madrid.get(index).x <= 60)
        madrid.get(index).x = 60;
      if (madrid.get(index).y <= 20)
        madrid.get(index).y = 20;

      if (ball.y >= field.height - 20)
        ball.y = field.height - 20;
      if (ball.x >= field.width - 60)
        ball.x = field.width - 60;
      if (ball.x <= 60)
        ball.x = 60;
      if (ball.y <= 20)
        ball.y = 20;
    }

    // KEEPER 1 Reaction
    if ((ball.x >= keeper1.x && ball.x <= keeper1.x + keeper1.w) && (ball.y >= keeper1.y && ball.y <= keeper1.y + keeper1.w)) {
      println("Thrown away by the goalkeeper " + keeper1.name);
      ball.x = barca.get(1).x + 15;
      ball.y = barca.get(1).y;
      index = 1;
    }

    // KEEPER 2 Reaction
    if ((ball.x >= keeper2.x && ball.x <= keeper2.x + keeper2.w) && (ball.y >= keeper2.y && ball.y <= keeper2.y + keeper2.w)) {
      println("Thrown away by the goalkeeper " + keeper2.name);
      ball.x = madrid.get(0).x + 15;
      ball.y = madrid.get(0).y;
    }


    barca.get(index).check(ball);
    barca.get(index).move(ball, barca, index, madrid);


    if (keyPressed) {
      //shoot
      if (key == 's' || key == 'S') {
        boolean checkIfWithUs = false;

        for (int i = 0; i < 10; i++) {
          if (barca.get(i).haveBall == true)
            checkIfWithUs = true;
        }

        if (checkIfWithUs == true) {
          ball.x += 100;
        }
      }

      // pass
      if (key == 'a' || key == 'A') {
        boolean checkIfWithUs = false;

        for (int i = 0; i < 10; i++) {
          if (barca.get(i).haveBall == true)
            checkIfWithUs = true;
        }

        if (checkIfWithUs == true) {
          double minimum = 100000000.0;
          int indexPass = index;
          double distance = minimum;
          for (int i = 0; i < 10; i++) {
            if (index != i) {
              distance = (Math.sqrt((Math.pow(((double)ball.x - (double)barca.get(i).x), (double)2.0)) + (Math.pow(((double)ball.y -(double)barca.get(i).y), (double)2.0))));
              if (distance < minimum) {
                minimum = distance;
                indexPass = i;
              }
            }
          }

          index = indexPass;
          ball.x = barca.get(index).x + 10;
          ball.y = barca.get(index).y;
        }
      }
      if (key == 'e' || key == 'E') {
        player.pause();
        done2 = false;
      }
    }

    // move PC players = let the PC play
    for (int i = 0; i < 10; i++) {
      madrid.get(i).check(ball);
      madrid.get(i).move(ball, madrid, i, barca);
    }

    if (checkIfGoal()) {
      done3 = false;

      madrid.removeAll(madrid);
      barca.removeAll(barca);
      initiatePlayers();
    }

    // EA SPORTS, ITS IN THE GAME INTRO
  } 
  if (done1 == false && done2 == false) {
    image(myMovie, 100, 30);

    myMovie.play();
    counter++;
    if (counter == 190)
      done1 = true;

    // MAIN MENU
  } 
  if (done1 == true && done2 == false) {
    player2.play();
    image(messi, 0, 0);
    fill(255);
    textFont(font3, 50);
    text("FIFA Football Game", 20, 100);
    textFont(font3, 20);
    text("Omar Droubi, Bassel Rawda, Tarek Wehbe - CMPS 230 - Spring 2015 - AUB", 20, 530); 

    // buttons
    textFont(font3, 30);
    text("KICK OFF", 20, 250);

    text("CONTROLS", 20, 300);

    text("EXIT", 20, 350);

    if (mousePressed) {
      if (mouseX >= 20 && mouseX <= 250 && mouseY >= 200 && mouseY <= 260) {
        done2 = true;
        player2.pause();
      }
      if (mouseX >= 20 && mouseX <= 250 && mouseY >= 261 && mouseY < 320) {
        textFont(font3, 20);

        text("e - Back to main menu", 200, 200);

        text("a - Pass / Skip the GOAL! announcement", 200, 250);

        text("s - Shoot", 200, 300);

        text("Arrows - Move Up/Down/Left/Right", 200, 350);

        text("Mouse Drag over player - Select the player", 200, 400);
      }
      if (mouseX >= 20 && mouseX <= 200 && mouseY >= 321 && mouseY <= 400) {
        exit();
      }
    }
  }
}

void movieEvent(Movie m) {
  m.read();
}

// 235 285
boolean checkIfGoal() {
  if (ball.x <= 65 && ball.y < 290 && ball.y > 220) {
    numbGoalsMadrid++;
    fill(255);

    textFont(font3, 50);
    text("GOAL! " + madrid.get(index).name + "!!", 280, 243);
    return true;
  } else if (ball.x >= field.width - 60 && ball.y < 285 && ball.y > 235) {
    numbGoalsBarca++;
    fill(255);

    textFont(font3, 50);
    text("GOAL! " + barca.get(index).name + "!!", 280, 243);

    return true;
  } else
    return false;
}

void initiatePlayers() {
  ball = new Ball(width / 2, height / 2 - 15, 20);

  barca.add(new Player("ALBA", 160, 50, 20, 2, false, true, false));
  barca.add(new Player("PIQUE", 160, 180, 20, 2, false, true, false));
  barca.add(new Player("MASCHERANO", 160, 310, 20, 2, false, true, true));
  barca.add(new Player("ALVES", 160, 440, 20, 2, false, true, true));
  barca.add(new Player("BUSQUETS", 230, 250, 20, 2, false, false, false));
  barca.add(new Player("INIESTA", 280, 100, 20, 2, false, false, true));
  barca.add(new Player("RAKITIC", 280, 400, 20, 2, false, false, false));
  barca.add(new Player("MESSI", 400, 150, 20, 2, false, false, false));
  barca.add(new Player("SUAREZ", 400, 250, 20, 2, false, false, false));
  barca.add(new Player("NEYMAR", 400, 350, 20, 2, false, false, false));

  madrid.add(new Player("MARCELO", field.width - 160, 50, 20, 1, true, true, true));
  madrid.add(new Player("RAMOS", field.width - 160, 180, 20, 1, true, true, false));
  madrid.add(new Player("PEPE", field.width - 160, 310, 20, 1, true, true, false));
  madrid.add(new Player("CARVAJAL", field.width - 160, 440, 20, 1, true, true, true));
  madrid.add(new Player("RODRIGUEZ", field.width - 230, 250, 20, 1, true, false, true));
  madrid.add(new Player("KROOS", field.width - 280, 100, 20, 1, true, false, true));
  madrid.add(new Player("MODRIC", field.width - 280, 400, 20, 1, true, false, false));
  madrid.add(new Player("RONALDO", field.width - 400, 150, 20, 1, true, false, true));
  madrid.add(new Player("BALE", field.width - 400, 250, 20, 1, true, false, true));
  madrid.add(new Player("BENZEMA", field.width - 400, 350, 20, 1, true, false, false));
}

