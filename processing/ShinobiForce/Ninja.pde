class Ninja {

  float x, y;
  float speed, rate, strenght;
  int bW, bH, movementCounter, direction;
  int dFrame, frame;
  boolean hasTurned;
  PImage ninja;
  PImage[][] frames;

  public Ninja(PImage ninja) {
    this.speed = 3;
    this.rate = random(1);
    this.bW = 26;
    this.bH = 32;
    this.x = random(500 - bW);
    this.y = random(500 - bH);
    // int colour = ((int) random(3));
    this.ninja = ninja;
    this.frames = new PImage[4][4];
    generateFrames();
  }

  void draw() {
    if (frame >= 4) {
      frame = 0;
    }
    image(frames[direction][frame++], x, y);

    movement();
    move();

    hitEdge();
    // changeSprite();
  }

  void changeSprite() {
    switch (direction) {
    case 0:
      bW = 25;
      bH = 31;
      break;
    case 1:
      bW = 25;
      bH = 31;
      break;
    case 2:
      bW = 25;
      bH = 31;
      break;
    case 3:
      bW = 25;
      bH = 31;
      break;
    }
  }

  void move() {
    switch (direction) {
    case 0:
      y -= speed;
      break;
    case 1:
      x += speed;
      break;
    case 2:
      y += speed;
      break;
    case 3:
      x -= speed;
      break;
    default:
      break;
    }
  }

  void movement() {

    if (movementCounter > 0) {
      movementCounter--;
      return;
    } 
    else if (direction == -1) {
      direction = (int) random(4);
    }

    int value = (int) random(3);
    switch(value) {
    case 0: // Forward
      movementCounter = (int) random(80) + 20;
      hasTurned = false;
      break;
    case 1: // Turn
      // speed = -1;
      if (hasTurned) {
        return;
      } 
      else {
        hasTurned = true;
      }
      direction = (int) random(3);
      break;
    case 2: // Still
      //if (hasTurned) {
      //return;
      //}
      // direction = -1;
      movementCounter = (int) random(25) + 5;
      break;
    }
  }

  void hitEdge() {
    if (y < 0) { // 0
      direction = (int) random(4) + 1;
      if (direction >= 4) {
        direction = 3;
      }
      movementCounter = (int) random(10) + 20;
    }
    if (x > (500 - bW)) { // 1
      direction = (int) random(4);
      while (direction == 1 || direction == 4) {
        direction = (int) random(4);
      }
      movementCounter = (int) random(10) + 20;
    }
    if (y > (500 - bH)) { // 2
      direction = (int) random(4);
      while (direction == 2 || direction == 4) {
        direction = (int) random(4);
      }
      movementCounter = (int) random(10) + 20;
    } 
    if (x < 0) { // 3
      direction = (int) random(3);
      movementCounter = (int) random(10) + 20;
    }
  }

  void generateFrames() {
    frames[0][0] = ninja.get(3, 97, 23, bH);
    frames[0][1] = ninja.get(34, 96, 23, bH);
    frames[0][2] = ninja.get(67, 97, 23, bH);
    frames[0][3] = ninja.get(34, 96, 23, bH);


    frames[1][0] = ninja.get(2, 65, 21, bH);
    frames[1][1] = ninja.get(35, 64, 21, bH);
    frames[1][2] = ninja.get(66, 65, 21, bH);
    frames[1][3] = ninja.get(35, 64, 21, bH);


    frames[2][0] = ninja.get(0, 1, bW, bH);
    frames[2][1] = ninja.get(32, 0, bW, bH);
    frames[2][2] = ninja.get(65, 1, bW, bH);
    frames[2][3] = ninja.get(32, 0, bW, bH);


    frames[3][0] = ninja.get(2, 33, 21, bH);
    frames[3][1] = ninja.get(34, 32, 21, bH);
    frames[3][2] = ninja.get(66, 33, 21, bH);
    frames[3][3] = ninja.get(34, 32, 21, bH);
  }
}

