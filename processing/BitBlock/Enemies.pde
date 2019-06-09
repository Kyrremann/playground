class Enemies {

  float x, y;
  int w, h;
  float speed;
  int speedCount = 1000;
  int[] c;
  List<Enemy> enemies;
  int levelState = 2;

  Enemies(int blocks, int speed) {
    this.speed = speed; 
    enemies = new ArrayList<Enemy>();
    for (int i = 0; i < blocks; i++)
    enemies.add(new Enemy(displayWidth / 4, (displayHeight / (1 + blocks)) * (i + 1), displayHeight / 10, displayHeight / 10, i));
  }

  void draw() {
    for (Enemy e : enemies)
      e.draw();
  }

  void incLevel() {
    levelState++;
  }

  class Enemy {

    float x, y, w, h, xo;
    int[] c;
    int row;

    Enemy(float x, float y, int w, int h, int row) {
      this.w = w;
      this.h = h;
      this.x = x;
      this.y = y;
      this.row = row;
      c = BitBlock.this.getColor();
    }

    void draw() {
      rectMode(CENTER);
      fill(c[0], c[1], c[2]);
      rect(x, y, w, h);
      collision();
      x -= Enemies.this.speed;
    }


    void collision() {
      Player p = BitBlock.this.p;
      Player.PlayerBlock b = BitBlock.this.p.blocks.get(row);

      if (b.x + b.getW() < x)
        return;

      if (b.r != c[0] || b.g != c[1] || b.b != c[2]) {
        p.incMissed(row);
      } 
      else {
        b.blink();
        explode();
        p.incScore();
        if (p.getScore() / speedCount == 1) {
          speed++;
          speedCount += 1000;
          BitBlock.this.incLevel();
        }
      }

      reset();
    }

    /*
     * Move back and change color
     */
    void reset() {
      x = displayWidth;
      c = getColor();
    }

    void explode() {
    }
  }
}

