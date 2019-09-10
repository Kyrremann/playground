class Player {

  float x, y;
  float speed, rate, strenght;
  int bW, bH, movementCounter, direction;
  int up, right, down, left;
  int frame;
  boolean hasTurned;
  PImage ninja;
  PImage[][] frames;

  public Player(PImage ninja) {
    this.speed = 3;
    this.rate = random(1);
    this.bW = 27;
    this.bH = 32;
    //this.x = random(500 - bW);
    //this.y = random(500 - bH);
    this.x = 250;
    this.y = 250;
    // int colour = ((int) random(3));
    this.ninja = ninja;
    this.frames = new PImage[4][4];
    generateFrames();
  }

  void draw() {
    if (frame >= 4) {
      frame = 0;
    }

    y -= (up == 0) ? 0 : speed;
    x += (right == 0) ? 0 : speed;
    y += (down == 0) ? 0 : speed;
    x -= (left == 0) ? 0 : speed;

    image(frames[direction][frame], x, y);

    if (up != 0 || right != 0 || down != 0 || left != 0) {
      frame++;
    }
  }

  void keyPressed(int value) {
    switch(value) {
    case 0:
      direction = 0;
      // y -= speed;
      up = 1;
      break;
    case 1:
      direction = 1;
      // x += speed;
      right = 1;
      break;
    case 2:
      direction = 2;
      // y += speed;
      down = 1;
      break;
    case 3:
      direction = 3;
      // x -= speed;
      left = 1;
      break;
    }
  }

  void keyReleased(int value) {
    switch(value) {
    case 0:
      direction = 0;
      // y -= speed;
      up = 0;
      break;
    case 1:
      direction = 1;
      // x += speed;
      right = 0;
      break;
    case 2:
      direction = 2;
      // y += speed;
      down = 0;
      break;
    case 3:
      direction = 3;
      // x -= speed;
      left = 0;
      break;
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

