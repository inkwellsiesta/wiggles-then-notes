package wigglesThenNotes;

import processing.core.PApplet;

class DebugTray {
	  boolean isActive;
	  boolean isHovered;

	  final int inactiveHeight = 20;
	  final int activeHeight = 180;
	  AniFloat h;
	  
	  wigglesThenNotes sketch;
	  
	  
	  public void setup(wigglesThenNotes sketch) {
	    isActive = false;
	    isHovered = false;
	    this.sketch = sketch;
	    h = new AniFloat(inactiveHeight, Pattern.EASING);
	  }

	  public void draw() {
	    // deal with the height of the box
	    h.update();

	    // then with the hover logic
	    isHovered = false;
	    if (sketch.mouseY > sketch.height - h.val() &&
	      sketch.mouseY < sketch.height) {
	      isHovered = true;
	    }

	    // then draw some stuff
	    sketch.pushStyle();
	    sketch.fill(0);
	    sketch.stroke(255);
	    sketch.rect(0, sketch.height - h.val(), sketch.width,
	    		sketch.height, 5);
	    if (isActive) {
	      // draw the triangle to dismiss
	      sketch.fill(255);
	      sketch.triangle(sketch.width/2 - 5, sketch.height - h.val() + 5, 
	    		  sketch.width/2 + 5, sketch.height - h.val() + 5, 
	    		  sketch.width/2, sketch.height - h.val() + 15);
	      // write the text
	      sketch.noStroke();     
	      sketch.textAlign(PApplet.LEFT, PApplet.TOP);
	      //for (MidiViz viz : vizes) {
	        MidiViz viz = sketch.vizes.get(sketch.activeViz);
	        sketch.text(viz.debugString(), 10, sketch.height - h.val() + 10, 
	        		sketch.width/2 - 20, h.val() - 20);
	          
	        // draw the control sliders
	        float x = sketch.width/2 + 10;
	        for (Slider slider : viz.sliders()) {
	          slider.draw(x, sketch.height - h.val() + 40.f, 
	            10.f, h.val() - 50.f);
	          x+=40;
	        }
	      //}
	    } else {
	      // draw the triangle to expand
	    	sketch.fill(255);
	    	sketch.triangle(sketch.width/2 - 5, sketch.height - h.val() + 15, 
	    		  sketch.width/2 + 5, sketch.height - h.val() + 15, 
	    		  sketch.width/2, sketch.height - h.val() + 5);
	    }
	    sketch.popStyle();
	  }

	  public void mouseClicked() {
	    if (isHovered) {
	      isActive = !isActive;
	    }

	    if (isActive) {
	      h.setTarget(activeHeight);
	    } else {
	      h.setTarget(inactiveHeight);
	    }
	  }

	  public void mousePressed() {
	    for (MidiViz viz : sketch.vizes) {
	    	if(viz.sliders() != null)
	      for (Slider slider : viz.sliders()) {
	        slider.mousePressed();
	      }
	    }
	  }

	  public void mouseDragged() {
	    for (MidiViz viz : sketch.vizes) {
	      for (Slider slider : viz.sliders()) {
	        slider.mouseDragged();
	      }
	    }
	  }

	  public void mouseReleased() {
	    for (MidiViz viz : sketch.vizes) {
	    	if(viz.sliders() != null)
	      for (Slider slider : viz.sliders()) {
	        slider.mouseReleased();
	      }
	    }
	  }
	}
