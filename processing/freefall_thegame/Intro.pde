class Intro {
  int height, width;
  ArrayList<Star> stars;
  int letterY = -150, letterX = 112, letterBase = 150;
  boolean selectedOne;
  int playerState = 1;


  Intro(int height, int width) {
    this.height = height;
    this.width = width;
    this.selectedOne = true;
    randomSeed(1337^1);
    stars = new ArrayList<Star>();
    for (int i = 0; i < 1000; i++)
      stars.add(new Star(random(height), random(width), random(3)));
  }

  void draw() {
    drawBackground();
    drawTitle();
    if (letterY >= letterBase) {
      drawTheGame();
      drawMenu();
    }
  }

  int select() {
    if (letterY >= letterBase) {
      if (keyCode == UP || keyCode == DOWN || key == 'w' || key == 's') {
        selectedOne = !selectedOne;
      } 
      else if (key == 'r' || key == 't' || key == 'f' || key == 'g' || key == 'o' || key == 'p' || key == 'k' || key == 'l') {
        return playerState;
      }
    } 
    else if (key == ENTER) {
      letterY = letterBase;
    }

    return 0;
  }

  void drawMenu() {
    textAlign(CENTER);
    if (selectedOne) {
      fill(255);
      text("- One player -", width / 2, height/2 + 48);
      fill(128);
      text("Two player", width / 2, height/2 + 96);
      playerState = 1;
    } 
    else {
      fill(128);
      text("One player", width / 2, height/2 + 48);
      fill(255);
      text("- Two player -", width / 2, height/2 + 96);
      playerState = 2;
    }
  }

  void drawTheGame() {
    textAlign(RIGHT);
    text("THE GAME", 887, letterBase + 173);
  }

  void drawTitle() {
    fill(255);
    if (letterY < letterBase)
      letterY += 5;
    drawF(letterX, letterY);
    drawR(letterX + 100, letterY);
    drawE(letterX + 200, letterY);
    drawE(letterX + 300, letterY);
    drawF(letterX + 400, letterY);
    drawA(letterX + 500, letterY);
    drawL(letterX + 600, letterY);
    drawL(letterX + 700, letterY);
  }

  void drawF(int x, int y) {
    rect(x, y, 25, 125);
    rect(x, y + 0, 75, 25);
    rect(x, y + 50, 50, 25);
  }

  void drawR(int x, int y) { 
    rect(x, y, 25, 125);
    rect(x, y, 50, 25);
    rect(x + 50, y + 25, 25, 25);
    rect(x, y + 50, 50, 25);
    rect(x + 50, y + 75, 25, 50);
  }

  void drawE(int x, int y) {
    rect(x, y, 25, 125);
    rect(x, y, 75, 25);
    rect(x, y + 50, 50, 25);
    rect(x, y + 100, 75, 25);
  }

  void drawA(int x, int y) {
    rect(x, y + 25, 25, 100);
    rect(x + 25, y, 25, 25);
    rect(x + 50, y + 25, 25, 100);
    rect(x, y + 50, 75, 25);
  }

  void drawL(int x, int y) {
    rect(x, y, 25, 125);
    rect(x, y + 100, 75, 25);
  }

  void drawBackground() {
    fill(255);
    for (Star s : stars)
      s.draw();
  }

  class Star {

    float x, y, trail, size;

    Star(float y, float x, float size) {
      this.x = x;
      this.y = y;
      this.size = size;
      trail = size * size * size;
    }

    void draw() {
      //rect(x, y, size, size);
      quad(x, y, x + (size / 2), y - size, x + size, y, x + (size / 2), y + trail);
      y -= size;
      if (y < -trail)
        y = height;
    }
  }
}

