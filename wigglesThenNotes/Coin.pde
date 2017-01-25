class CoinManager {
  ArrayList<Coin> coins;
  final float gravity = 3;
  
  CoinManager() {
      coins = new ArrayList<Coin>();
  }

  void addCoin() {
    coins.add(new Coin());
  }

  void draw() {
    for (Coin coin : coins) {
      coin.draw();
    }
  }

    class Coin {
      float x, y;
      float v;
      int age;
      PImage img;

      Coin() {
        age = 0;
        x = random(0, width);
        y = random(0, height);

        img = loadImage("coin.png");
      }

      void draw() {
        if (age < 20) {
          pushStyle();
          tint(255, map(age, 0, 20, 255, 0));
          image(img, x - 25*cos(radians(75*age)), y-4*age, 50*cos(radians(75*age)), 50);
          popStyle();
        }
        age++;
      }
    }
}