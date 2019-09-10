class ClickBox {

  float x, y;
  int r, g, b;
  int w, h;

  ClickBox(float y, int r, int g, int b) {
    this.h = round(displayHeight/10) * 10 / 4;
    this.w = h;
    this.x = 0;
    this.y = h * y;
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void draw() {
    rectMode(CORNER);
    fill(r, g, b);
    rect(0, y, w, h);
  }
}

