import java.util.*;

List<ClickBox> cbox;
Player p;
Enemies e;
Level l;
IntroMenu i;
GameOver g;
PFont aerial;
final static int aerialSize = 32;
int gameState;

void setup() {
  size(displayWidth, displayHeight);
  stroke(255);
  aerial = createFont("aerial.ttf", aerialSize);
  textFont(aerial);
  gameState = 0;

  cbox = new ArrayList<ClickBox>();
  cbox.add(new ClickBox(0, 255, 0, 0));
  cbox.add(new ClickBox(1, 255, 255, 0));
  cbox.add(new ClickBox(2, 0, 255, 0));
  cbox.add(new ClickBox(3, 0, 0, 255));
  l = new Level();
  i = new IntroMenu();
  g = new GameOver();
}

void draw() {
  switch (gameState) {
  case 0:
    // intro and menu
    background(0, 0, 0, 50);
    i.draw();
    break;
  case 1:
    background(0);
    l.draw();
    statistics();

    p.draw();
    e.draw();
    for (ClickBox b : cbox)
      b.draw();
    break;
  case 2:
    background(0);
    g.draw();
    break;
  }
}

void incLevel() {
  l.incLevel();
  e.incLevel();
}

void statistics() {
  fill(255);
  textAlign(RIGHT);
  textSize(32);
  text(p.getScore() + " score", displayWidth, aerialSize);
  text(p.getMissed() + " missed", displayWidth, aerialSize * 2);
  text(p.getMultiplier() + " multiplier", displayWidth, aerialSize * 3);
}

void mousePressed() {
  if (mouseY > (round(displayHeight/10) * 10 / 4) * 0 && mouseY < (round(displayHeight/10) * 10 / 4) * 1) {
    p.changeColor(0, cbox.get(0).r, cbox.get(0).g, cbox.get(0).b);
  } 
  else if (mouseY > (round(displayHeight/10) * 10 / 4) * 1 && mouseY < (round(displayHeight/10) * 10 / 4) * 2) {
    p.changeColor(0, cbox.get(1).r, cbox.get(1).g, cbox.get(1).b);
  } 
  else if (mouseY > (round(displayHeight/10) * 10 / 4) * 2 && mouseY < (round(displayHeight/10) * 10 / 4) * 3) {
    p.changeColor(0, cbox.get(2).r, cbox.get(2).g, cbox.get(2).b);
  } 
  else if (mouseY > (round(displayHeight/10) * 10 / 4) * 3 && mouseY < (round(displayHeight/10) * 10 / 4) * 4) {
    p.changeColor(0, cbox.get(3).r, cbox.get(3).g, cbox.get(3).b);
  }
}

void keyPressed() {
  if (!i.menu && gameState == 0) {
    // i.anyButton();
    gameState = 1; 
      BitBlock.this.e = new Enemies(1, 7);
      BitBlock.this.p = new Player(1);
    return;
  } 
  else if (i.menu && gameState == 0 && !i.howToState) {
    switch (keyCode) {
    case UP:
      i.menuUp();
      break;
    case DOWN:
      i.menuDown();
      break;
    case LEFT:
      i.menuLeft();
      break;
    case RIGHT:
      i.menuRight();
      break;
    case 32:
    case ENTER:
      i.menuEnter();
      break;
    }

    return;
  } 
  else if (i.howToState) {
    switch (keyCode) {
    case ENTER:
      i.howToReturn();
      break;
    }

    return;
  }
  else if (gameState == 2) {
    return;
  }

  switch (keyCode) {
  case LEFT:
  case '1':
    p.changeColor(0, cbox.get(0).r, cbox.get(0).g, cbox.get(0).b);
    break;
  case UP:
  case '2':
    p.changeColor(0, cbox.get(1).r, cbox.get(1).g, cbox.get(1).b);
    break;
  case RIGHT:
  case '3':
    p.changeColor(0, cbox.get(2).r, cbox.get(2).g, cbox.get(2).b);
    break;
  case DOWN:
  case '4':
    p.changeColor(0, cbox.get(3).r, cbox.get(3).g, cbox.get(3).b);
    break;
  case '7':
    p.changeColor(1, cbox.get(0).r, cbox.get(0).g, cbox.get(0).b);
    break;
  case '8':
    p.changeColor(1, cbox.get(1).r, cbox.get(1).g, cbox.get(1).b);
    break;
  case '9':
    p.changeColor(1, cbox.get(2).r, cbox.get(2).g, cbox.get(2).b);
    break;
  case '0':
    p.changeColor(1, cbox.get(3).r, cbox.get(3).g, cbox.get(3).b);
    break;
  case 'Q':
    p.changeColor(2, cbox.get(0).r, cbox.get(0).g, cbox.get(0).b);
    break;
  case 'W':
    p.changeColor(2, cbox.get(1).r, cbox.get(1).g, cbox.get(1).b);
    break;
  case 'E':
    p.changeColor(2, cbox.get(2).r, cbox.get(2).g, cbox.get(2).b);
    break;
  case 'R':
    p.changeColor(2, cbox.get(3).r, cbox.get(3).g, cbox.get(3).b);
    break;
  case 'U':
    p.changeColor(3, cbox.get(0).r, cbox.get(0).g, cbox.get(0).b);
    break;
  case 'I':
    p.changeColor(3, cbox.get(1).r, cbox.get(1).g, cbox.get(1).b);
    break;
  case 'O':
    p.changeColor(3, cbox.get(2).r, cbox.get(2).g, cbox.get(2).b);
    break;
  case 'P':
    p.changeColor(3, cbox.get(3).r, cbox.get(3).g, cbox.get(3).b);
    break;
  }
}


void keyReleased() {

  if (gameState == 2) {
    g.keyReleased();
  }
}

int[] getColor() {
  switch ((int) random(4)) {
  case 0:
    return new int[] { 
      255, 0, 0
    };
  case 1:
    return new int[] { 
      255, 255, 0
    };
  case 2:
    return new int[] { 
      0, 255, 0
    };
  case 3:
    return new int[] { 
      0, 0, 255
    };
  }

  return new int[3];
}

boolean sketchFullScreen() {
  return true;
}

