import java.util.*;

class Player {

  float x, y, r;
  int up, down, left, right;
  int speed, draw, size;
  PImage sprite;
  PImage[] cell;
  List<Bullet> bullets;
  int reloadingTime, reloadingBullet;
  int ammo, mag;

  Player(int x, int y) {
    this.x = x;
    this.y = y;
    speed = 3;
    draw = 0;
    r = 180;
    this.size = 32;
    sprite = loadImage("manwalk.png");
    cell = new PImage[14];
    for (int i = 0; i < 14; i++)
      cell[i] = sprite.get(i * 32, 0, 32, 32);
    imageMode(CENTER);
    bullets = new ArrayList<Bullet>();
    mag = 6;
    ammo = 30;
  }

  void draw() {
    if (reloadingTime > millis()) {
      if (reloadingBullet < millis()) {
        mag++;
        ammo--;
        reloadingBullet += 100;
      }
    } 
    else {
      x += (up == 0) ? 0 : -sin(radians(r)) * speed;
      y += (up == 0) ? 0 : cos(radians(r)) * speed;
      x -= (down == 0) ? 0 : -sin(radians(r)) * speed;
      y -= (down == 0) ? 0 : cos(radians(r)) * speed;


      r += (left == 0) ? (right == 0) ? 0 : 8 : 
      -8;

      if (up != 0)
        draw++;
      else if (down != 0)
        draw--;
      if (draw >= 14)
        draw = 0;
      else if (draw <= -1)
        draw = 13;
    }

    Bullet b;
    for (int i = 0; i < bullets.size(); i++) {
      b = bullets.get(i);
      b.draw();
      if (b.ob) {
        bullets.remove(b);
        i--;
      }
    }

    pushMatrix();
    translate(x, y);

    if (MageSlayer_Clone.this.debug) {
      rect(-1, 20, 2, 2);
    }
    rotate(radians(r));
    image(cell[draw], 0, 0);
    if (MageSlayer_Clone.this.debug) {
      line(0, -20, 0, 20);
      line(-20, 0, 20, 0);
      text("Angel: " + r, 10, 10);
      MageSlayer_Clone.this.dots.add(new Dot(x, y));
      rect(-1, 20, 2, 2);
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

  void reload() {
    if (ammo == 0)
      return;

    mag = 0;
    reloadingTime = millis() + 700;
    reloadingBullet = millis() + 100;
  }

  void shot() {
    if (mag == 0)
      return;

    bullets.add(new Bullet(r, x, y));
    mag--;
  }
}

