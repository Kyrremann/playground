class Level {

  final int ox1, ox2;
  final int MAX_SPEED = 15;
  final int BOX_SIZE = 10;
  float speed = 2.0;
  int bgSpeed = (int)(speed / 2);
  float limit = speed * speed * 100.0;
  float acceleration = 3.0 / limit;
  int height, width, difficulty;
  ArrayList<Box> box;
  float widthFactor = 8;
  int min_width = Ship.SHIP_SIZE * 5, max_width = int(Ship.SHIP_SIZE * widthFactor);
  int max_bend = BOX_SIZE;
  float x, y, bend;
  int bgY, colorY;
  float w;
  final float[] bend_factor = {-2, -1.75, -1.2, -0.65, -0.27, -0.09, 0, 0.09, 0.27, 0.65, 1.2, 1.75, 2};
  boolean even = false;

  Level(int height, int width, int ox1, int ox2, int difficulty) {
    this.ox2 = ox2;
    this.ox1 = ox1;
    this.height = height;
    this.width = width;
    this.x = width / 2;
    this.w = max_width;
    this.difficulty = difficulty;
    this.box = new ArrayList<Box>();

    int boxes_per_screen = height / BOX_SIZE + 1;
    for (int i = 0; i < boxes_per_screen / 2; i++) {
      box.add(new Wall((int)(x - w), i * BOX_SIZE));
      box.add(new Wall((int)(x + w), i * BOX_SIZE));
    }
    for (int i = boxes_per_screen / 2; i < boxes_per_screen; i++) {
      bend = max(-max_bend, min(max_bend, bend + bend_factor[(int) random(0, bend_factor.length)]));
      w = max(min_width, min(max_width, w + bend_factor[(int) random(0, bend_factor.length)]));
      x += bend;
      box.add(new Wall((int)(x - w), i * BOX_SIZE));
      box.add(new Wall((int)(x + w), i * BOX_SIZE));
    }
    for (int i = boxes_per_screen - 4; i < boxes_per_screen; i++) {
      Box b = box.get(i * 2);
      b.setColor(1,1,1,0);
      b.penetrable = true;
      b = box.get(i * 2 + 1);
      b.setColor(1,1,1,0);
      b.penetrable = true;
    }
  }

  void draw() {
    y += speed;
    bgY += bgSpeed;
    colorY++;
    
    if (speed < MAX_SPEED) {
      speed += acceleration;
    }

    if (y >= limit) {
      y = 0;
      if (speed < MAX_SPEED) {
        bgSpeed = (int)(speed / 2);
        limit = speed * speed * 100.0;
        acceleration = 3.0 / limit;
        widthFactor -= 0.08;
        max_width = int(Ship.SHIP_SIZE * widthFactor);
        min_width = max_width - 3;
        box.add(new Blocker(random(0, width), height));
      }
    }
    
    if (bgY > height)
      bgY -= height;
    int h = height - bgY;
    
    copy(bgImg, 0, bgY, bgImg.width, h,
         ox1, 50, width, h);
    copy(bgImg, 0, 0, bgImg.width, bgY,
         ox1, 50 + h, width, bgY);
    copy(bgImg, 0, bgY, bgImg.width, h,
         ox2, 50, width, h);
    copy(bgImg, 0, 0, bgImg.width, bgY,
         ox2, 50 + h, width, bgY);

    for (Box b : box)
      b.draw();
  }
  
  color getColor() {
    float h = (colorY / 600.0) % 6;
    int i = (int) h;
    float f = h - i;
    
    switch(i) {
      case 0:
        return color(255, f * 255, 0);
      case 1:
        return color((1 - f) * 255, 255, 0);
      case 2:
        return color(0, 255, f * 255);
      case 3:
        return color(0, (1.0 - f) * 255, 255);
      case 4:
        return color(f * 255, 0, 255);
      default:
        return color(255, 0, (1.0 - f) * 255);
    }
  }

  class Wall extends Box {
    Wall(int x, int y) {
      super(x, y, Level.this.height, Level.this.width, ox1, 50, BOX_SIZE, getColor());
      while (x < 0) {
        x += width;
      }
      x %= width;
      this.x = x;
    }

    void draw() {
      y -= speed;

      if (y < -size) {
        y += height + size;
        if (alpha(c) == 255) {
          c = getColor();
        }
        if (even) {
          bend = max(-max_bend, min(max_bend, bend + bend_factor[(int) random(0, bend_factor.length)]));
          w = max(min_width, min(max_width, w + bend_factor[(int) random(0, bend_factor.length)]));
          Level.this.x += bend;
          x = Level.this.x - w;
        } else {
          x = Level.this.x + w;
        }
        
        while (x < 0) {
          x += width;
        }
        x %= width;
        even = !even;
      }

      ox = ox1;
      super.draw();
      ox = ox2;
      super.draw();
    }
  }
  
  class Blocker extends Box {
    Blocker(float x, float y) {
      super(x, y, Level.this.height, Level.this.width, ox1, 50, BOX_SIZE, getColor());
      while (x < 0) {
        x += width;
      }
      x %= width;
      this.x = x;
    }
    
    void draw() {
      y -= speed;
      
      if (y < -size) {
        y += size + height;
        c = getColor();
        x = random(0, width);
      }
      
      ox = ox1;
      super.draw();
      ox = ox2;
      super.draw();
    }
  }
}

