class Shenlong {
  PImage shenlongSheet;
  PImage stand;
  PImage[] walk, kick_high, kick_low, hit_high;
  int frame;
  int kickSpeed;
  int rate, oldRate;
  int ground, x, oldX;
  int SPEED_X = 10;
  boolean firstPressed, dirLeft;
  boolean lkey, rkey, lfirst;

  boolean b_kick_high, b_kick_low, b_release_kick, b_released_kick;
  boolean b_hit_high, b_hit_low, b_release_hit;
  boolean b_crouching;

  Shenlong(int start) {
    oldRate = 0;

    shenlongSheet = loadImage("shenlongsheet_trans.png"); // "shenlongsheet.gif");

    stand = createImage(76, 95, ARGB);
    stand.copy(shenlongSheet, 28, 72, 76, 95, 0, 0, 76, 95);

    walk = new PImage[4];
    walk[0] = createImage(77, 101, ARGB);
    walk[1] = createImage(77, 102, ARGB);
    walk[2] = createImage(77, 100, ARGB);
    walk[3] = createImage(77, 102, ARGB);
    walk[0].copy(shenlongSheet, 621, 69, 77, 101, 0, 0, 77, 101);
    walk[1].copy(shenlongSheet, 524, 66, 77, 102, 0, 0, 77, 102);
    walk[2].copy(shenlongSheet, 709, 65, 77, 100, 0, 0, 77, 100);
    walk[3].copy(shenlongSheet, 524, 66, 77, 102, 0, 0, 77, 102);

    kick_high = new PImage[6];
    kick_high[0] = createImage(68, 102, ARGB);
    kick_high[1] = createImage(105, 107, ARGB);
    kick_high[2] = createImage(87, 107, ARGB);
    kick_high[3] = createImage(105, 107, ARGB);
    kick_high[4] = createImage(68, 102, ARGB);
    kick_high[5] = createImage(77, 102, ARGB);
    kick_high[0].copy(shenlongSheet, 281, 763, 68, 102, 0, 0, 68, 102);
    kick_high[1].copy(shenlongSheet, 357, 761, 105, 107, 0, 0, 105, 107);
    kick_high[2].copy(shenlongSheet, 472, 763, 87, 102, 0, 0, 87, 107);
    kick_high[3].copy(shenlongSheet, 357, 761, 105, 107, 0, 0, 105, 107);
    kick_high[4].copy(shenlongSheet, 281, 763, 68, 102, 0, 0, 68, 102);
    kick_high[5].copy(shenlongSheet, 524, 66, 77, 102, 0, 0, 77, 102);

    kick_low = new PImage[6];
    kick_low[0] = createImage(66, 81, ARGB);
    kick_low[1] = createImage(79, 75, ARGB);
    kick_low[2] = createImage(103, 75, ARGB);
    kick_low[3] = createImage(79, 75, ARGB);
    kick_low[4] = createImage(66, 81, ARGB);
    kick_low[5] = createImage(77, 75, ARGB);
    kick_low[0].copy(shenlongSheet, 14, 786, 66, 81, 0, 0, 66, 81);
    kick_low[1].copy(shenlongSheet, 90, 787, 79, 75, 0, 0, 79, 75);
    kick_low[2].copy(shenlongSheet, 171, 788, 103, 75, 0, 0, 103, 75);
    kick_low[3].copy(shenlongSheet, 90, 787, 79, 75, 0, 0, 79, 75);
    kick_low[4].copy(shenlongSheet, 14, 786, 66, 81, 0, 0, 66, 81);
    kick_low[5].copy(shenlongSheet, 345, 673, 77, 75, 0, 0, 77, 75);

    hit_high = new PImage[2];
    hit_high[0] = createImage(87, 75, ARGB);
    hit_high[1] = createImage(77, 75, ARGB);
    hit_high[0].copy(shenlongSheet, 10, 553, 87, 94, 0, 0, 87, 75);
    hit_high[1].copy(shenlongSheet, 345, 673, 77, 75, 0, 0, 77, 75);

b_released_kick = true;
    lkey = false;
    rkey = false;
    lfirst = false;
    frame = 0;
    x = start;
    oldX = x;
    ground = height / 2 + 202;
  }

  void draw() {
    moving();
    rate = millis();
    if (oldX != x) {
      oldX = x;

      walk();
    }
    else {
      if (b_kick_high)
        kick(1);
      else if (b_kick_low)
        kick(3);
      else
        stand();
    }
  }

  void moving() {
    if (freeToMove()) {
      if (lfirst) {
        if (rkey)
          x += SPEED_X;
        else if (lkey)
          x += -SPEED_X;
      } 
      else {

        if (lkey)
          x += -SPEED_X;
        else if (rkey)
          x += SPEED_X;
      }
    }

    if (x > width)
      x = -49;
    else if (x < -50)
      x = width;
  }

  boolean freeToMove() {
    if (b_kick_high)
      return false;
    else if (b_kick_low)
      return false;
    return true;
  }

  void stand() {
    if (dirLeft) {
      pushMatrix();
      scale(-1, 1);
      image(stand, -(x + stand.width), ground - stand.height + 2);
      popMatrix();
    } 
    else
      image(stand, x, ground - stand.height + 2);
  }

  void walk() {
    if (rate - oldRate > 120) {
      oldRate = rate;
      frame++;
      if (frame == 4)
        frame = 0;
    }

    if (dirLeft) {
      pushMatrix();
      scale(-1, 1);
      image(walk[frame], -(x + walk[frame].width), ground - walk[frame].height);
      popMatrix();
    } 
    else
      image(walk[frame], x, ground - walk[frame].height);
  }

  void kick(int type) {
    switch (type) {
    case 1:
      if (rate - oldRate > 120) {
        oldRate = rate;
        frame++;
        if (frame == kick_high.length)
          frame = 0;
      }

      if (dirLeft) {
        pushMatrix();
        scale(-1, 1);
        image(kick_high[frame], -(x + kick_high[frame].width), ground - kick_high[frame].height);
        popMatrix();
      } 
      else
        image(kick_high[frame], x, ground - kick_high[frame].height);
      break;

    case 3:
      if (rate - oldRate > 120) {
        oldRate = rate;
        frame++;
        if (frame == kick_low.length)
          frame = 0;
      }

      if (dirLeft) {
        pushMatrix();
        scale(-1, 1);
        image(kick_low[frame], -(x + kick_low[frame].width), ground - kick_low[frame].height);
        popMatrix();
      } 
      else
        image(kick_low[frame], x, ground - kick_low[frame].height);
      break;

    default:
      break;
    }

    // if (b_release_kick && frame == 0) {
    if (frame == 0) {
      b_kick_high = false;
      b_kick_low = false;
    }
  }

  void keyPressed(int dir) {
    if (dir == LEFT || dir == 'A') {
      lkey = true;
      lfirst = !rkey;
      dirLeft = true;
    } 
    else if (dir == RIGHT || dir == 'D') {
      rkey = true;
      dirLeft = false;
    }
    if (b_released_kick) {
      b_released_kick = false;
      if (dir == 'O') {
        b_kick_high = true;
      } 
      else if (dir == 'P')
        b_kick_low = true;
    }
  }

  void keyReleased(int dir) {
    if (dir == LEFT || dir == 'A') {
      lkey = false;
      lfirst = false;
    } 
    else if (dir == RIGHT || dir == 'D') {
      rkey = false;
    }

    if (dir == 'O') {
      b_released_kick = true;
      if (frame != 0)
        b_release_kick = true;
      else
        b_kick_high = false;
    } 
    else if (dir == 'P')
      b_released_kick = true;
    if (frame != 0)
      b_release_kick = true;
    else
      b_kick_low = false;

    firstPressed = true;
  }
}

