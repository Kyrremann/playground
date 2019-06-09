PImage grass;

class Level {
  List<LevelPart> parts;
  Level() {
    grass = loadImage("grass.png");
    parts = new ArrayList<LevelPart>();
    parts.add(new LevelPart(100, 100, 25, 500));
  }

  void draw() {
    for (int y = 0; y < displayHeight / grass.height + 2; y++)
      for (int x = 0; x < displayWidth / grass.width + 1; x++)
        image(grass, x * grass.width, y * grass.height);

    for (LevelPart l : parts)
      l.draw();
  }

  List<LevelPart> getParts() {
    return parts;
  }

  class LevelPart {
    float x, y, w, h;

    LevelPart(float x, float y, float w, float h) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
    }

    void draw() {
      fill(128);
      rect(x, y, w, h);
    }

    boolean collision(Monster m) {
      if ((x + w) + 5 < m.x)
        return false;
      if (m.x + m.sw < x - 5)
        return false;
      if ((y + h) + 5< m.y)
        return false;
      if (m.y + m.sh < y - 5)
        return false;
      // if (!(r - 10 > m.r) && !(r + 10 < m.r))
        // return false;

      return true;
    }
  }
}

