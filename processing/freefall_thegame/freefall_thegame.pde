int height = 700, width = 1000;

Intro intro;
Level level;
Ship playerOne;
Ship playerTwo;
int gameState;
int timeOut;
float scaling;
int ox, oy;
PImage bgImg;

void setup() {
  size(displayWidth, displayHeight);
  background(#000000);
  noStroke();
  noCursor();
  textAlign(CENTER);
  textFont(loadFont("ComicSansMS-48.vlw"), 48);

  bgImg = loadImage("data/clouds.png");
  PImage tmpBg = createImage(bgImg.width * 10, bgImg.height * 10, RGB);
  for (int x = 0; x < bgImg.width; x++) {
    for (int y = 0; y < bgImg.height; y++) {
      for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
          tmpBg.set(x * 10 + i, y * 10 + j, bgImg.get(x, y));
        }
      }
    }
  }
  bgImg = tmpBg;

  scaling = (float) Math.min((double) displayWidth / width, 
  (double) displayHeight / height);
  ox = (int) (displayWidth - width * scaling) / 2;
  oy = (int) (displayHeight - height * scaling) / 2;

  reset();
}

private final void reset() {
  intro = new Intro(height, width);
   level = new Level(600, 400, 50, 550, 20);
   playerOne = new Ship("KHE", 200, 0, 600, 400, 50, 50, level);
   playerTwo = new Ship("SIG", 200, 0, 600, 400, 550, 50, level);
   gameState = 0;
   timeOut = 180;
   smooth();
}

void draw() {
  translate(ox, oy);
  scale(scaling);
  switch (gameState) {
  case 0:
    background(0);
    intro.draw();
    break;
  case 1:
    fill(000);
    rect(0, 0, width, 50);
    stroke(255);
    rect(50, 50, 400, 600);
    rect(550, 50, 400, 600);
    noStroke();

    level.draw();
    playerOne.draw();

    if (playerOne.dead) {
      if (timeOut < 0) {
        exitGame();
        // reset();
      } 
      else {
        timeOut--;
        color c = playerOne.c;
        playerOne.setColor(int(red(c)), int(blue(c)), int(green(c)), int(timeOut * 1.42));
      }
    }

    break;
  case 2:
    fill(000);
    rect(0, 0, width, 50);
    stroke(255);
    rect(50, 50, 400, 600);
    rect(550, 50, 400, 600);
    noStroke();
    level.draw();
    playerOne.draw();
    playerTwo.draw();

    if (playerOne.dead && playerTwo.dead) {
      if (timeOut < 0) {
        exitGame();
      } 
      else {
        timeOut--;
        color c = playerOne.c;
        playerOne.setColor(int(red(c)), int(blue(c)), int(green(c)), int(timeOut * 1.42));
        c = playerTwo.c;
        playerTwo.setColor(int(red(c)), int(blue(c)), int(green(c)), int(timeOut * 1.42));
      }
    }

    break;
  }
}

void exitGame() {
  System.out.println("exit " + playerOne.score + "," + playerTwo.score);
  exit();
}

void keyPressed() {
  if (gameState == 0) {
    gameState = intro.select();

    if (gameState != 0) {
      intro = null;
      background(0);
      noSmooth();
    }
    return;
  }

  switch (keyCode) {
  case UP:
    playerTwo.down = UP;
    break;
  case DOWN:
    playerTwo.down = DOWN;
    break;
  case LEFT:
    playerTwo.horizontal = LEFT;
    break;
  case RIGHT:
    playerTwo.horizontal = RIGHT;
    break;
  }

  switch (key) {
  case 'w':
    playerOne.down = UP;
    break;
  case 's':
    playerOne.down = DOWN;
    break;
  case 'a':
    playerOne.horizontal = LEFT;
    break;
  case 'd':
    playerOne.horizontal = RIGHT;
    break;
  }
}

void keyReleased() {
  switch (keyCode) {
  case UP:
  case DOWN:
    playerTwo.down = 0;
    break;
  case LEFT:
  case RIGHT:
    playerTwo.horizontal = 0;
    break;
  }

  switch (key) {
  case 'w':
  case 's':
    playerOne.down = 0;
    break;
  case 'a':
  case 'd':
    playerOne.horizontal = 0;
    break;
  }
}

boolean sketchFullScreen() {
  return true;
}

