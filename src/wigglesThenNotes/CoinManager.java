package wigglesThenNotes;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

class CoinManager {
	  ArrayList<Coin> coins;
	  PImage coinImg;
	  final float gravity = 1;
	  wigglesThenNotes sketch;
	  
	  CoinManager(wigglesThenNotes sketch) {
		  this.sketch = sketch;
	      coins = new ArrayList<Coin>();
	      coinImg = sketch.loadImage("coin.png");
	  }

	  synchronized void addCoin() {
	    coins.add(new Coin());
	  }
	  
	  void update() {
	    for (int i = 0; i < coins.size(); i++) {
	      Coin c = coins.get(i);
	      if (c.y > sketch.height) {
	        coins.remove(c);
	      }
	    }
	  }

	  synchronized void draw() {
	    sketch.tint(255, 255);
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
	        x = sketch.random(0, sketch.width);
	        y = sketch.random(0, sketch.height);
	        v = -8;
	        kill = false;
	      }

	      synchronized void draw() {
	        //if (age < 20) {
	          sketch.pushStyle();
	          //tint(255, map(age, 0, 20, 255, 0));
	          v+=gravity;
	          sketch.image(coinImg,
	        		  x - 25*PApplet.cos(PApplet.radians(50*age)),
	        		  y+v*age, 50*PApplet.cos(PApplet.radians(50*age)),
	        		  50);
	          sketch.popStyle();
	        //}
	        age++;
	      }
	    }
	}
