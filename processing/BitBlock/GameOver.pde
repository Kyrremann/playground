class GameOver {

  String name = "";

  GameOver() {
  }

  void draw() {
    textAlign(CENTER);
    textSize(displayWidth / 20);
    text("GAME OVER", displayWidth / 2, displayHeight / 2);
    textSize(displayHeight / 30);
    text("Your score " + BitBlock.this.p.getScore(), displayWidth / 2, displayHeight / 2 + displayHeight / 30);
    //text("Please type in your initials", displayWidth / 2, displayHeight / 2 + (displayHeight / 30) * 2);
    //text(name, displayWidth / 2, displayHeight / 2 + (displayHeight / 30) * 3);
  }

  void keyReleased() {
    BitBlock.this.gameState = 0;
    /*if (key != CODED) {
      switch(key) {
      case BACKSPACE:
        name = name.substring(0, max(0, name.length()-1));
        break;
      case TAB:
      case ENTER:
      case RETURN:
      case ESC:
      case DELETE:
        break;
      default:
        name += key;
        name = name.toUpperCase();
      }
    }*/
  }
}
