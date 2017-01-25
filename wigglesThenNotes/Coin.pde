class CoinManager {
  ArrayList<Coin> coins;
  PImage coinImg;
  final float gravity = 1;
  
  CoinManager() {
      coins = new ArrayList<Coin>();
      coinImg = loadImage("coin.png");
  }

  synchronized void addCoin() {
    coins.add(new Coin());
  }
  
  void update() {
    for (int i = 0; i < coins.size(); i++) {
      Coin c = coins.get(i);
      if (c.y > height) {
        coins.remove(c);
      }
    }
  }

  synchronized void draw() {
    for (Coin coin : coins) {
      coin.draw();
    }
  }

    class Coin {
      float x, y;
      float v;
      int age;
      boolean kill;

      Coin() {
        age = 0;
        x = random(0, width);
        y = random(0, height);
        v = -8;
        kill = false;
      }

      synchronized void draw() {
        //if (age < 20) {
          pushStyle();
          //tint(255, map(age, 0, 20, 255, 0));
          v+=gravity;
          image(coinImg, x - 25*cos(radians(50*age)), y+v*age, 50*cos(radians(50*age)), 50);
          popStyle();
        //}
        age++;
      }
    }
}