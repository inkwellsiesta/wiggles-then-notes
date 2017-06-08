package wigglesThenNotes.viz;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PVector;
import wigglesThenNotes.MidiViz;
import wigglesThenNotes.Slider;
import wigglesThenNotes.wigglesThenNotes;

public class Moire implements MidiViz {
	wigglesThenNotes sketch;
	  ArrayList<Target> targets = new ArrayList<Target>();
	  PVector currentOrigin;
	  int strokeColor = 255;
	  
	  PGraphics pg;

	  public void setup(wigglesThenNotes sketch) {
		  this.sketch = sketch;
	    currentOrigin = new PVector(sketch.width/2, sketch.height/2);
	    pg = sketch.createGraphics(sketch.width, sketch.height);
	  }

	  public void update() {
	    syncUpdate();
	  }

	  synchronized void syncUpdate() {
	    for (int i = 0; i < targets.size(); i++) {
	      Target target = targets.get(i);
	      target.update();
	      if (target.shouldKill()) {
	        target.kill();
	      }
	      if (target.isDead()) {
	        targets.remove(target);
	      }
	    }
	  }

	  public PGraphics draw(float m) {
	    return syncDraw(m);
	  }

	  synchronized PGraphics syncDraw(float m) {
	    pg.beginDraw();
	      pg.background(0);
	      pg.pushMatrix();
	      pg.scale(1.f/m);
	    for (int i = 0; i < targets.size(); i++) {
	      targets.get(i).draw(pg, m);
	    }
	    pg.popMatrix();
	    pg.endDraw();
	    return pg;
	  }

	  public void noteOn(int channel, int pitch, int velocity) {
	    PApplet.println("adding target");
	    if (sketch.frameRate > 25) {
	      targets.add(new Target(10, PApplet.round(5000.f/sketch.midiNoteToFreq(pitch)), PApplet.max(1, velocity/80)));
	    } else {
	      PApplet.println("Can't add more than " + targets.size() + " targets.");
	    }
	  }

	  public void controllerChange(int channel, int number, int value) {
	    int nTargets = targets.size();
	    if (nTargets > 0) {
	      targets.get(nTargets-1).setAlpha(value*2);
	    }
	  }

	 public void mouseClicked() {
	    currentOrigin.set(sketch.mouseX, sketch.mouseY);
	  }
	  
	  public void keyPressed() {
	    if (sketch.keyCode == PApplet.BACKSPACE) {
	      for (int i = 0; i < targets.size(); i++) {
	        targets.remove(targets.get(i));
	      }
	    }
	  }

	  public String debugString() {
	    return "framerate = " + PApplet.round(sketch.frameRate) +
	    "\ntargetSize = " + targets.size();
	  } 

	  class Target {
	    int minrad, maxrad; // min and max radii
	    int weight;         // stroke weight
	    int speed;          // rate of change of radii 
	    PVector origin;     // where shape originates from
	    int intensity = 255, alpha = 255;
	    int age;            // number of frames of existence
	    static final int MAX_AGE = 4000;  // nothing lives forever
	    boolean dying = false;

	    int offset = 0;     // difference between specified minrad
	    // and effective minrad

	    Target(int size, int weight, int speed) {
	      this.minrad = 0;
	      this.maxrad = size;
	      this.weight = weight;
	      this.speed = speed;
	      this.origin = new PVector(currentOrigin.x, currentOrigin.y);
	      this.age = 0;
	    }

	    void update() {
	      age++;
	      if (dying) {
	        minrad += speed;
	      }

	      // Don't let the size increase infinitely
	      // beyond the window, that would be inefficient
	      if (maxrad < 2*PApplet.max(sketch.width, sketch.height)) {
	        maxrad += speed;
	      } else {
	        maxrad -= 4*weight;
	      }
	    }

	    void draw(PGraphics pg, float m) {
	      pg.stroke(intensity, alpha);
	      pg.strokeWeight(weight);
	      pg.noFill();
	      // To acheive the illusion of a continuously moving wavefront...
	      // Draw from the inside out when no new rings are being drawn
	      //   from the center of the target
	      if (dying) {
	        for (int i = minrad; i < maxrad; i+=weight*4) {
	          pg.ellipse(origin.x, origin.y, i, i);
	          //pg.shape(circle, origin.x, origin.y, i, i);
	        }
	        // Draw from the outside in otherwise
	      } else {
	        int i;
	        for (i = maxrad; i > minrad; i-=weight*4) {
	          pg.ellipse(origin.x, origin.y, i, i);
	          //pg.shape(circle, origin.x, origin.y, i, i);
	        }
	      PApplet.println(weight);
	        // But calculate the offset so there's no discontinuity
	        //  when the target is killed
	        offset = i - minrad + weight*4;
	      }
	    }

	    void setAlpha(int newAlpha) {
	      this.alpha = newAlpha;
	    }

	    void kill() {
	      dying = true;
	      minrad+=offset;
	    }

	    boolean shouldKill() {
	      return (age > MAX_AGE && !dying);
	    }

	    boolean isDead() {
	      return (minrad > maxrad);
	    }
	  }

	  public List<Slider> sliders() {
	    return new ArrayList<Slider>();
	  }

	@Override
	public void shutdown() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseMoved(int x, int y) {
		// TODO Auto-generated method stub
		
	}
	}
