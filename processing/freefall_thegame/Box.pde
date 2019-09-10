class Box {
  boolean penetrable;
  int oy, ox;
  float x, y;
  int height, width;
  int size;
  color c;

  Box(float x, float y, int height, int width, int ox, int oy, int size, color c) {
    this.oy = oy;
    this.ox = ox;
    this.width = width;
    this.height = height;
    this.x = x;
    this.y = y;
    this.size = size;
    this.c = c;
  }

  void setColor(int r, int g, int b) {
    c = color(r, g, b);
  }
  
  void setColor(int r, int g, int b, int a) {
    c = color(r, g, b, a);
  }

  void draw() {
    float dx = x;
    float dy = y;
    float dw = size;
    float dh = size;

    if (x < 0) {
      dx = width + x;
      dw = -x;
    } else if (x > width - size) {
      dw = width - x;
    }

    if (y < 0) {
      dy = 0;
      dh = size + y;
    } else if (y > height - size) {
      dh = height - y;
    }

    fill(c);
    rect(dx + ox, dy + oy, dw, dh);
    if (dw < size) {
      rect(ox, dy + oy, size - dw, dh);
    }
  }

  boolean collides(Box b) {
    if (penetrable || b.penetrable)
      return false;
      
    if (y + size < b.y)
      return false;

    if (y > b.y + b.size)
      return false;

    float rx = x + size - width;
    if (rx < 0) {
      if (x > b.x + b.size)
        return false;

      if (x + size < b.x)
        return false;
        
    } else if (rx < b.x && b.x + b.size < x) {
      return false;
    }

    return true;
  }
}

