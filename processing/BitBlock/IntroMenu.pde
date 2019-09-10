class IntroMenu {

  float alpha, fontSize, titleY;
  boolean neg, menu, howToState;
  List<Star> stars;
  int introState, menuState, speed, blocks;
  int[] c;

  IntroMenu() {
    alpha = 205;
    fontSize = displayWidth / 10;
    titleY = displayHeight / 2;
    speed = 10;
    blocks = 1;
    stars = new ArrayList<Star>();
    c = BitBlock.this.getColor();
    for (int i = 0; i < 500; i++)
      stars.add(new Star(random(displayWidth), random(displayHeight), random(5)));
  }

  void draw() {
    for (Star s : stars)
      s.draw();

    switch (introState) {
    case 0:
      fill(255, 255, 255, alpha);
      textAlign(CENTER);
      textSize(fontSize);
      text("BITBLOCK", displayWidth / 2, displayHeight / 2);
      alpha +=  (neg) ? 1 : -1;
      if (alpha < 50 || alpha > 205) {
        neg = !neg;
        c = BitBlock.this.getColor();
      }
      fill(c[0], c[1], c[2]);
      textSize(fontSize / 4);
      text("Press the any-button", (displayWidth / 2), (displayHeight / 2) + (displayHeight / 10));
      break;
    case 1:
      fill(255, 255, 255, alpha);
      textAlign(CENTER);
      textSize(fontSize);

      if (titleY > displayWidth / 9 && fontSize > displayWidth / 20) {
        titleY -= 5;
        fontSize--;
      } 
      else {
        anyButton();
      }
      text("BITBLOCK", displayWidth / 2, titleY);
      break;
    case 2:
      fill(255);
      textSize(fontSize);
      text("BITBLOCK", displayWidth / 2, titleY);
      textSize(displayHeight / 30);
      if (menuState == 0)
        fill(c[0], c[1], c[2]);
      else
        fill(255);
      text("Start", displayWidth / 2, titleY + ((displayHeight / 5) * 1));
      if (menuState == 1)
        fill(c[0], c[1], c[2]);
      else
        fill(255);
      text("Speed: < " + speed + " >", displayWidth / 2, titleY + ((displayHeight / 10) * 3));
      if (menuState == 2)
        fill(c[0], c[1], c[2]);
      else
        fill(255);
      text("Blocks: < " + blocks + " >", displayWidth / 2, titleY + ((displayHeight / 10) * 4));
      if (menuState == 3)
        fill(c[0], c[1], c[2]);
      else
        fill(255);
      text("Tell me how to play", displayWidth / 2, titleY + ((displayHeight / 10) * 5));
      if (menuState == 4)
        fill(c[0], c[1], c[2]);
      else
        fill(255);
      text("Exit", displayWidth / 2, titleY + ((displayHeight / 10) * 6));
      break;
    case 3:
      fill(128, 50);
      rectMode(CENTER);
      rect(displayWidth / 2, displayHeight / 2, displayWidth / 2, displayHeight / 1.5);
      fill(255);
      textSize(displayHeight / 40);
      text("BitBlocks in it's simplest form is about matching the color of your block with the block coming against it."
        + "\nThere is no need to match the clicking with the music. Just match the colors.\n"
        + "\nYou control with the numers 1-4 or by using the mouse to click on the wanted color."
        + "\n 1 = Red, 2 = Yellow\n3 = Green, 4 = Blue", displayWidth / 2, displayHeight / 2, displayWidth / 2.5, displayHeight / 2);
      break;
    }
  }

  class Star {

    float size, trail, blink;
    float x, y;
    int[] c;

    Star(float x, float y, float size) {
      this.x = x;
      this.y = y;
      this.size = size;
      this.trail = size * size;
      this.blink = random(100);
      c = BitBlock.this.getColor();
    }

    void draw() {
      noStroke();
      rectMode(CENTER);
      fill(c[0], c[1], c[2]);
      if (blink > 0 && blink < 10)
        rect(x, y, size + 1, size + 1);
      else if (blink > 10 && blink < 20)
        rect(x, y, size + 2, size + 2);
      else if (blink > 20 && blink < 30)
        rect(x, y, size + 1, size + 1);
      rect(x, y, size, size);

      blink++;
      if (blink > 100)
        blink = random(100);
    }
  }

  void anyButton() {
    menu = true;
    introState++;
  }

  void menuUp() {
    menuState--;
    if (menuState < 0)
      menuState = 4;
  }

  void menuDown() {
    menuState++;
    if (menuState > 4)
      menuState = 0;
  }

  void menuLeft() {
    if (menuState == 1) {
      speed--;
      if (speed <= 0)
        speed = 1;
    } 
    else if (menuState == 2) {
      blocks--;
      if (blocks <= 0)
        blocks = 1;
    }
  }

  void menuRight() {

    if (menuState == 1) {
      speed++;
    } 
    else if (menuState == 2) {
      blocks++;
      if (blocks >= 3)
        blocks = 2;
    }
  }

  void menuEnter() {
    switch (menuState) {
    case 0:
      BitBlock.this.e = new Enemies(blocks, speed);
      BitBlock.this.p = new Player(blocks);
      BitBlock.this.gameState++;
      break;
    case 3:
      introState++;
      howToState = true;    
      break;
    case 4:
      exit();
      break;
    }
  }

  void howToReturn() {
    introState--;
    howToState = false;
  }
}

