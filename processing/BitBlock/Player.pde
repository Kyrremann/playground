class Player {

  int score;
  float multiplier;
  float missedAlpha, missedRad;
  List<PlayerBlock> blocks;

  Player(int blocks) {
    this.multiplier = 1;
    this.blocks = new ArrayList<PlayerBlock>(blocks);
    for (int i = 0; i < blocks; i++)
      this.blocks.add(new PlayerBlock(displayWidth / 4, (displayHeight / (1 + blocks)) * (i + 1), displayHeight / 10, displayHeight / 10));
  }

  void draw() {
    for (PlayerBlock b : blocks) {
      if (b.getW() < 0) {
        BitBlock.this.gameState = 2;
        return;
      }

      b.draw();
    }
  }

  void changeColor(int block, int r, int g, int b) {
    if (block >= blocks.size())
      return;

    blocks.get(block).r = r;
    blocks.get(block).g = g;
    blocks.get(block).b = b;
  }

  int incMissed(int block) {
    multiplier = 1;
    blocks.get(block).missedAlpha = 255;
    blocks.get(block).missedRad = random(90) - 45;
    return blocks.get(block).missed++;
  }

  int incScore() {
    score += 10 * multiplier++;
    return score;
  }

  int getScore() {
    return score;
  }

  int getMissed() {
    int missed = 0;
    for (PlayerBlock b : blocks)
      missed += b.missed;
    return missed;
  }

  float getMultiplier() {
    return multiplier;
  }

  class PlayerBlock {

    float x, y;
    int w, h;
    int r, g, b;
    float multiAlpha, multiRad;
    float missedAlpha, missedRad;
    boolean blink;
    float size, frame; 
    int missed;

    PlayerBlock(float x, float y, int w, int h) {
      this.w = w;
      this.h = h;
      this.x = x;
      this.y = y;
      this.r = (int) random(255);
      this.g = (int) random(255);
      this.b = (int) random(255);
      this.size = 1;
      this.frame = .75;
      this.missed = 0;
    }

    float getW() {
      return w - (missed * 10);
    }

    float getH() {
      return h - (missed * 10);
    }

    void blink() {
      blink = true;
      multiAlpha = 255;
      multiRad = random(90) - 45;
    }

    void draw() {
      rectMode(CENTER);
      noStroke();
      if (blink) {
        fill(r, g, b);
        rect(x, y, h * size, w * size);
        fill(0);
        rect(x, y, h * (size - frame), w * (size - frame));
        size += .3;
      }

      if (size > 5) {
        size = 1;
        blink = false;
      }

      if (multiAlpha > 3) {      
        pushMatrix();
        fill(r, g, b, multiAlpha);
        translate(x + w, y);
        rotate(radians(multiRad));
        textSize(128);
        textAlign(LEFT);
        text("x" + (multiplier - 1), 0, 0);
        popMatrix();
        multiAlpha = multiAlpha / 1.1;
      }

      if (missedAlpha > 3) {      
        pushMatrix();
        fill(r, g, b, missedAlpha);
        translate(x + w * 2, y);
        rotate(radians(missedRad));
        textSize(128);
        textAlign(LEFT);
        text("MISSED!", 0, 0);
        popMatrix();
        missedAlpha = missedAlpha / 1.1;
      }

      rectMode(CENTER);
      fill(r, g, b);
      rect(x, y, getW(), getH());
    }
  }
}

