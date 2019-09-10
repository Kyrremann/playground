class People {
  
  float x, y;
  
  public People() {
    // 250, 250
    // 200, 250
    this.x = 200;
    this.y = 250;
  }
  
  void draw() {
    noStroke();
    fill(255, 0, 0);
    rect(x, y, 5, 5);
  }
}
