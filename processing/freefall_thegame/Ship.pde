class Ship extends Box {

  boolean dead;
  int down = 0;
  static final int BOTTOM = 575;
  static final int SHIP_SIZE = 15;
  final String name;
  int horizontal = 0;
  int score = 0;
  Level level;
  float hp = 1;

  Ship(String name, int x, int y, int height, int width, int ox, int oy, Level level) {
    super(x, y, height, width, ox, oy, SHIP_SIZE, color(255, 255, 255));
    this.name = name;
    this.level = level;
  }

  void draw() {
    x += horizontal == 0 ? .0 : horizontal == LEFT ? -6. : 6.;
    y += this.down == 0 ? .0 : this.down == UP ? -2. : 2.;
    if (y > BOTTOM)
      y = BOTTOM;

    fill(c);
    if (!dead)
      score += y;
    else
      text("GAME OVER!", width / 2 + ox, height / 2 + oy);

    text(score, 200 + ox, 50);
    hittingWalls();

    super.draw();

    if (hittingBoxes()) {
      hp -= .15;
      setColor(255, int(255 * hp), int(255 * hp));
      if (hp < 0)
        dead = true;
    } 
    else if (hp > 0) {
      hp = hp < 1f ? hp + 0.001f : 1f;
      setColor(255, int(255 * hp), int(255 * hp));
    }
  }

  boolean hittingBoxes() {

    for (Box b : level.box) {
      if (collides(b))
        return true;
    }

    return false;
  }

  void hittingWalls() {
    if (y > height)
      y = height - SHIP_SIZE;
    else if (x >= (width))
      x = 0;
    else if (x < 0)
      x = width + x;
  }
}

