PlayerController pc;
NinjaController ninjas;

void setup() {
  size(500, 500);
  background(255);
  fill(255);
  stroke(2);
  frameRate(24);
  // smooth();

  pc = new PlayerController(1);
  ninjas = new NinjaController(30);

  imageMode(CENTER);
}

void draw() {
  background(255);
  ninjas.draw();
  pc.draw();
}

void keyPressed() {
  if (keyCode == UP || keyCode == LEFT || keyCode == DOWN || keyCode == RIGHT) {
    pc.keyPressed(0);
  }
}

void keyReleased() {
  if (keyCode == UP || keyCode == LEFT || keyCode == DOWN || keyCode == RIGHT) {
    pc.keyReleased(0);
  }
}

