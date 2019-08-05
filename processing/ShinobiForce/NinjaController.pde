import java.util.List;

class NinjaController {

  int number;
  boolean ai;
  List<Ninja> ninjas;
  PImage sprite;

  public NinjaController(int number) {
    this.number = number;
    this.ai = true;
    this.sprite = loadImage("ninja.png");
    ninjas = new ArrayList<Ninja>(number);
    for (int i = 0; i < number; i++) {
      ninjas.add(new Ninja(sprite));
    }
  }

  void draw() {
    if (ai) { // AI moves random
      for (Ninja n : ninjas) {
        n.draw();
      }
    } 
    else {
    }
  }
}

