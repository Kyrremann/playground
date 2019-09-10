class Bullet {

  float x, y, r;
  int speed;
  boolean ob;

  Bullet(float r, float x, float y) {
    this.r = r;
    this.x = x;
    this.y = y;
    this.speed = 10;
    this.ob = false;
  }

  void draw() {
    x += -sin(radians(r)) * speed;
    y += cos(radians(r)) * speed;
    fill(#F24E51);
    pushMatrix();
    translate(x, y);
    rotate(radians(r));
    quad(0, 0, -4, -10, 0, -15, 4, -10);
    popMatrix();

    if ((displayWidth + 100) < x || (displayHeight + 100) < y || x < -100 || y < -100)
      ob = true;

    hit();
  }

  void hit() {
    Monster kill = null;
    for (Monster m : MageSlayer_Clone.this.monsters) {
      if (y + 3 > m.y + (m.sh / 2))
        continue;
      if (y - 3 < m.y - (m.sh / 2))
        continue;
        
      if (x - 2 > m.x + (m.sw / 2))
        continue;
      if (x + 2 < m.x - (m.sw / 2))
        continue;

      kill = m;
      break;
    }
    if (kill == null)
      return;
      
    MageSlayer_Clone.this.monsters.remove(kill);
    ob = true;
  }
}

