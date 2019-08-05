class Babylon extends Level {
  PImage tileset;
  PImage ground;
  PImage underground;
  PImage sky_babylon, sky_tileset;
  int x, y;

  Babylon() {
    tileset = loadImage("basic_ground_tileset.png");
    ground = createImage(50, 50, ARGB);
    ground.copy(tileset, 0, 0, 50, 50, 0, 0, 50, 50);
    underground = createImage(50, 50, ARGB);
    underground.copy(tileset, 0, 60, 50, 50, 0, 0, 50, 50);

    sky_tileset = loadImage("sky_babylon_background_by_trishrowdy.png");
    sky_babylon = createImage(511, 511, ARGB);
    sky_babylon.copy(sky_tileset, 3, 204, 511, 511, 0, 0, 511, 511);

    x = width / 2;
    y = height / 2 + 200;
  }

  void draw() {
    for (int i = 0; i < width / 511 + 1; i++) 
      image(sky_babylon, 511 * i, 0);
    for (int i = 0; i < (width / 50 + 1); i++) {
      //for (int j = 0; j < (height / 50) / 2; j++) {
      //image(underground, i * 50, y + 50);
      image(underground, i * 50, y + 50);
      image(ground, i * 50, y);
    }
  }
}

