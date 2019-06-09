class Monster {

  float x, y, r;
  int draw, rm, speed;
  int sw, sh;
  int move, rotate;
  boolean moveOrRotate, lr;
  PImage sprite;
  PImage[] cell;

  Monster(float x, float y) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.speed = 1;
    this.sw = 26;
    this.sh = 20;
    sprite = loadImage("man_walk2.png");
    cell = new PImage[14];
    for (int i = 0; i < 14; i++)
      cell[i] = sprite.get((i * 32) + 3, 7, sw, sh);
    imageMode(CENTER);
  }

  void draw() {

    if (moveOrRotate) {
      if (move == 0) {
        move = (int) random(80) + 5;
        moveOrRotate = false;
      }

      x += -sin(radians(r)) * speed;
      y += cos(radians(r)) * speed;
      move--;
    } 
    else {
      if (rotate == 0) {
        rotate = (int) random(20) + 1;
        moveOrRotate = true;
        lr = !lr;
      }

      if (lr)
        r += 8;
      else
        r -= 8;
      rotate--;
    }

    hitPlayer();
    hitMonster();
    hitWall();

    if (draw >= 14)
      draw = 0;
    else if (draw <= -1)
      draw = 13;
    pushMatrix();
    translate(x, y);
    fill(255);
    rotate(radians(r));
    image(cell[draw++], 0, 0);
    if (MageSlayer_Clone.this.debug) {
      line(0, -20, 0, 20);
      line(-20, 0, 20, 0);
      text(r, sw, sw);
    }
    popMatrix();

    if (x < 0)
      x = displayWidth;
    if (y < 0)
      y = displayHeight;
    if (x > displayWidth)
      x = 0;
    if (y > displayHeight)
      y = 0;

    if (r > 360)
      r -= 360;
    else if (r < 0)
      r += 360;
  }

  void hitWall() {
    List<Level.LevelPart> parts = MageSlayer_Clone.this.getParts();
    for (Level.LevelPart l : parts) {
      if (l.collision(this)) {
        r += 180;
        return;
      }
    }
  }

  void hitMonster() {
    for (Monster m : MageSlayer_Clone.this.monsters) {
      if (this == m)
        continue;

      if (x + (sw / 2) < m.x - (m.sw / 2))
        continue;
      if (x - (sw / 2) > m.x + (m.sw / 2))
        continue;

      if (y + (sh / 2) < m.y - (m.sh / 2))
        continue;
      if (y - (sh / 2) > m.y + (m.sh / 2))
        continue;

      if (!(r - 10 > p.r) && !(r + 10 < p.r))
        continue;

      r += 180;
      break;
    }
  }

  void hitPlayer() {
    Player p = MageSlayer_Clone.this.p;
    if (x + (sw / 2) < p.x - (p.size / 2))
      return;
    if (x - (sw / 2) > p.x + (p.size / 2))
      return;

    if (y + (sh / 2) < p.y - (p.size / 2))
      return;
    if (y - (sh / 2) > p.y + (p.size / 2))
      return;


    if (!(r - 10 > p.r) && !(r + 10 < p.r))
      return;

    r += 180;
  }
}

