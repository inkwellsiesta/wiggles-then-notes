package wigglesThenNotes;

import processing.core.PApplet;

class FadeManager {
	  int targetViz;
	  int age;
	  wigglesThenNotes sketch;
	  
	  FadeManager(wigglesThenNotes sketch) {
		  this.sketch = sketch;
	  }
	  
	  void setTarget(int targetViz) {
	    this.targetViz = targetViz;
	    age = 0;
	    //pg.resetShader();
	  }
	  
	  void update() {
	    age++;
	    if (age == 25) {
	      sketch.activeViz = targetViz;
	    }
	  }
	}
