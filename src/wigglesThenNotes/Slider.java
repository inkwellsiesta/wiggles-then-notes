package wigglesThenNotes;

import processing.core.PApplet;

class Slider {
	  final String name;
	  final float min, max;
	  float val;
	  
	  wigglesThenNotes sketch;

	  float x, y, w, h;
	  boolean isAdjusting;

	  Slider(String name,
	        float min, float max,
	        wigglesThenNotes sketch) {
	    this.name = name;
	    this.min = min;
	    this.max = max;
	    val = (max + min)*.5f;
	    isAdjusting = false;
	    this.sketch = sketch;
	  }
	  private float sliderY() {
	    return PApplet.map(val, min, max, y, y + h);
	  }
	  public void draw(float x, float y, 
	    float w, float h) {
	    this.x = x;
	    this.y = y;
	    this.w = w;
	    this.h = h;

	    sketch.pushStyle();
	    sketch.fill(0);
	    sketch.stroke(255);
	    sketch.rect(x + w*.25f, y, w*.5f, h);
	    sketch.fill(255);
	    sketch.rect(x, sliderY() - h*.05f, 
	      w, h*.1f);
	    sketch.popStyle();
	  }

	  public void mousePressed() {
	    if (sketch.mouseX > x && sketch.mouseX < x + w
	      && sketch.mouseY > sliderY() - h*.05 && sketch.mouseY < sliderY() + h*.05) {
	      isAdjusting = true;
	    }
	  }

	  public void mouseDragged() {
	    if (isAdjusting) {
	      val = PApplet.map(sketch.mouseY, y, y + h, min, max);
	      val = PApplet.max(val, min);
	      val = PApplet.min(val, max);
	    }
	  }

	  public void mouseReleased() {
	    isAdjusting = false;
	  }
	}