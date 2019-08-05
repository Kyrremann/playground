Shenlong she, she2;
Level lvl;
boolean drawFirst;

void setup() {
  size(1200, 600);
  frameRate(30); 

  drawFirst = false;

  initMap();
  initCharacters();
}

void initMap() {
  lvl = new Babylon();
}

void initCharacters() {
  she = new Shenlong(50);
  she2 = new Shenlong(width - 100);
}

void draw() {
  // background(#629FFF);
  lvl.draw();
  if (!drawFirst) {
    she.draw();
    she2.draw();
  } 
  else {
    she2.draw();
    she.draw();
  }
}

void keyPressed() {
  if (keyCode == 'O' || keyCode == 'P')
    drawFirst = true;
  else
    drawFirst = false;

  if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT || keyCode == 'O' || keyCode == 'P')
    she.keyPressed(keyCode);
  else if (keyCode == 'W' || keyCode == 'S' || keyCode == 'A' || keyCode == 'D')
    she2.keyPressed(keyCode);
}

void keyReleased() {
  if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT || keyCode == 'O' || keyCode == 'P')
    she.keyReleased(keyCode);
  else if (keyCode == 'W' || keyCode == 'S' || keyCode == 'A' || keyCode == 'D')
    she2.keyReleased(keyCode);
}

