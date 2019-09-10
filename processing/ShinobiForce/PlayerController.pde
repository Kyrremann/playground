class PlayerController {

  Player[] players;
  PImage sprite;

  public PlayerController(int number) {
    this.sprite = loadImage("ninja.png");
    this.players = new Player[number];
    for (int i = 0; i < number; i++) {
      players[i] = new Player(sprite);
    }
  }

  void draw() {
    for (int i = 0; i < players.length; i++) {
      players[i].draw();
    }
  }

  void keyPressed(int player) {
    switch (player) {
    case 0:
      switch(keyCode) {
      case UP:
        players[0].keyPressed(0);
        break;
      case RIGHT:
        players[0].keyPressed(1);
        break;
      case DOWN:
        players[0].keyPressed(2);
        break;
      case LEFT:
        players[0].keyPressed(3);
        break;
      }
      break;
    }
  }
  
  void keyReleased(int player) {
    switch (player) {
    case 0:
      switch(keyCode) {
      case UP:
        players[0].keyReleased(0);
        break;
      case RIGHT:
        players[0].keyReleased(1);
        break;
      case DOWN:
        players[0].keyReleased(2);
        break;
      case LEFT:
        players[0].keyReleased(3);
        break;
      }
      break;
    }
  }
}

