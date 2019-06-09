class Level {

  List<Star> stars;
  int levelState;
  float levelAlpha, levelRad;

  Level() {
    stars = new ArrayList<Star>();
    for (int i = 0; i < 250; i++)
      stars.add(new Star(random(displayWidth), random(displayHeight), random(5)));
    incLevel();
  }

  void draw() {
    for (Star s : stars)
      s.draw();

    if (levelAlpha > 0) {
      int[] p = BitBlock.this.getColor();
      pushMatrix();
      fill(p[0], p[1], p[2], levelAlpha);
      textAlign(RIGHT);
      textSize(128);
      //rotate(radians(levelRad));
      text("LEVEL " + levelState, (displayWidth * .9), displayHeight / 2);
      popMatrix();
      levelAlpha -= 3;
    }
  }

  int incLevel() {
    levelState++;
    levelAlpha = 255;
    levelRad = random(90) - 45;
    //if (levelState > 2)
    //levelState = 0;
    return levelState;
  }

  class Star {

    float size, trail, blink;
    float x, y;

    Star(float x, float y, float size) {
      this.x = x;
      this.y = y;
      this.size = size;
      this.trail = size * size;
      this.blink = random(100);
    }

    void draw() {
      rectMode(CENTER);
      switch (levelState / 3) {
      case 0:
        rect(x, y, size, size);
        break;
      case 1:
        quad(x, y - (size / 2), x, y + (size / 2), x, y, x - trail, y);
        break;
      case 2:
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
        break;
      }
      x += size;

      if (x - trail > displayWidth) {
        x = 0;
        y = random(displayHeight);
      }
    }
  }
}

