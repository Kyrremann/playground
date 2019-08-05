import java.util.*;

Player p;
List<Monster> monsters;
List<Dot> dots;
Level l;
boolean debug;

void setup() {
  size(displayWidth, displayHeight);
  p = new Player(displayWidth / 2, displayHeight / 2);
  monsters = new ArrayList<Monster>();
  for (int i = 0; i < 50; i++)
    // monsters.add(new Monster(displayWidth / 2 + (i * 32), displayHeight / 2 + (i * 32)));
    monsters.add(new Monster(random(displayWidth), random(displayHeight)));
  l = new Level();
  dots = new ArrayList<Dot>(1024);
}

void draw() {
  background(128);
  //l.draw();
  for (Monster m : monsters)
    m.draw();
  p.draw();
  for (Dot d : dots)
    d.draw();

  fill(255);
  text("B/A: " + p.mag + "/" + p.ammo, 10, 20);
  text("M: " + monsters.size(), 10, 40);
}

List<Level.LevelPart> getParts() {
  return l.parts;
}

void keyPressed() {

  switch (keyCode) {
  case UP:
    p.up = UP;
    break;
  case DOWN:
    p.down = DOWN;
    break;
  case LEFT:
    p.left = LEFT;
    break;
  case RIGHT:
    p.right = RIGHT;
    break;
  case 'X':
    p.shot();
    break;
  case 'R':
    p.reload();
    break;
  }
}

void keyReleased() {
  switch (keyCode) {
  case UP:
    p.up = 0;
    break;
  case DOWN:
    p.down = 0;
    break;
  case LEFT:
    p.left = 0;
    break;
  case RIGHT:
    p.right = 0;
    break;
  case 'X':
    break;
  }
}

boolean sketchFullScreen() {
  return true;
}

class Dot {
  float x, y;
  Dot(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void draw() {
    point(x, y);
  }
}

