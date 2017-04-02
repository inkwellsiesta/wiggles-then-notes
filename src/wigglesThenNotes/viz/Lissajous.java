package wigglesThenNotes.viz;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PVector;
import wigglesThenNotes.AniFloat;
import wigglesThenNotes.MidiViz;
import wigglesThenNotes.Pattern;
import wigglesThenNotes.Slider;
import wigglesThenNotes.wigglesThenNotes;

public class Lissajous implements MidiViz {
	wigglesThenNotes sketch;
	  PVector center;
	  float randomness, // 
	    start, 
	    speed, // speed of starting point of line that
	    // forms shape
	    maxSpeed, 
	    phaseOffset; // phase offset b/t x and y axes in radians
	    
	    AniFloat decay; // 0 = no decay, more negative indicates
	    // how quickly shape exponentially decays to center
	    AniFloat r; // size of shape
	    
	    final int validNotes[] = {4, 10, 13, 17, 18, 20, 22, 32, 33, 34, 44, 45, 47, 48, 51, 56, 57, 68, 69, 74};
	    
	    
	  boolean noteLock; // if true, ignore midi and osc note changes

	  float f1; // frequency that shape is "tuned" to
	  float f2; // (ie freq that f1 will always oscillate at)

	  float alpha = 255; // transparency of lines vs dots

	  List<Slider> debugSliders;
	  PGraphics pg;

	  public void setup(wigglesThenNotes sketch) {
		  this.sketch = sketch;
	    pg = sketch.createGraphics(sketch.width, sketch.height);
	    center = new PVector(sketch.width/2, sketch.height/2, 0);
	    r = new AniFloat(PApplet.min(sketch.width/2, sketch.height/2), Pattern.EASING);
	    r.setEasing(.2f);
	    randomness = 0;
	    decay = new AniFloat(-.1f, Pattern.EASING);
	    decay.setEasing(.2f);
	    start = 0;
	    speed = .0001f;
	    maxSpeed = .0001f;
	    phaseOffset = PApplet.HALF_PI;
	    
	    f1 = sketch.midiNoteToFreq(57);
	    f2 = sketch.midiNoteToFreq(57);
	    
	    noteLock = false;

	    debugSliders = new ArrayList<Slider>();
	    // decay
	    debugSliders.add(new Slider("Decay", -1, 0, sketch));
	    // speed
	    debugSliders.add(new Slider("Speed", 0, maxSpeed, sketch));
	  }

	  public void update() {
	    start+=speed;
	    start%=PApplet.TAU;

	    //decay.setTarget(debugSliders.get(0).val);
	    decay.update();
	    r.update();
	    
	    speed = debugSliders.get(1).val;
	  }

	  public PGraphics draw(float m) {
	  pg.beginDraw();
	    center.set(pg.width/2, pg.height/2);
	    //r = min(pg.width/2, pg.height/2);
	    pg.background(0, 100);
	    
	    pg.pushMatrix();
	    pg.scale(1.f/m);
	    pg.stroke(255, alpha);
	    pg.noFill();
	    pg.strokeWeight(2);
	    pg.beginShape();
	    for (float i = start; i < PApplet.TWO_PI*4 + start; i+=.1) {
	      float x = center.x + (r.val()*PApplet.sin(f1*i) + sketch.random(-randomness, randomness))*PApplet.exp(decay.val()*(i-start));
	      float y = center.y + (r.val()*PApplet.sin(f2*i + phaseOffset) + sketch.random(-randomness, randomness))*PApplet.exp(decay.val()*(i-start));
	      pg.curveVertex(x, y);
	    }
	    pg.endShape();
	    pg.stroke(255, 255-alpha);
	    pg.beginShape(PApplet.POINTS);
	    for (float i = start + .1f; i < PApplet.TWO_PI*4 + start; i+=.1) {
	      float x = center.x + (r.val()*PApplet.sin(f1*i) + sketch.random(-randomness, randomness))*PApplet.exp(decay.val()*(i-start));
	      float y = center.y + (r.val()*PApplet.sin(f2*i + phaseOffset) + sketch.random(-randomness, randomness))*PApplet.exp(decay.val()*(i-start));
	      pg.strokeWeight(PApplet.map(PApplet.dist(x, y, center.x, center.y), 0, sketch.width/2, 1, 25));
	      pg.vertex(x, y);
	    }
	    pg.endShape();
	    pg.popMatrix();
	    pg.endDraw();

	    // Radial, this should probably be its own mode
	    /*pushStyle();
	     noStroke();
	     fill(255);
	     float x = center.x + min(width,height)/2.*cos(f1*start)*sin(f2*start + phaseOffset);
	     float y = center.y + min(width,height)/2.*sin(f1*start)*sin(f2*start + phaseOffset);
	     ellipse(x, y, 20, 20);
	     popStyle();*/
	     return pg;
	  }


	  public void noteOn(int channel, int pitch, int velocity) {
	    if (velocity > 0 && !noteLock) {
	      int midiNote = validNotes[PApplet.floor(sketch.random(validNotes.length))];
	      f2 = sketch.midiNoteToFreq(midiNote);
	    }
	  }

	  public String debugString() {
	    return "size = " + r.val() + "\n" +
	      "randomness = " + randomness + "\n" + 
	      "decay = " + decay.val() + "\n" + 
	      "speed = " + speed + "\n" + 
	      "max speed = " + maxSpeed + "\n" +
	      "phase offset = " + phaseOffset + "\n" + 
	      "bg alpha = " + alpha + "\n" +
	      "freq 1 = " + f1 + "\n" +
	      "freq 2 = " + f2 + "\n" + 
	      "note locked = " + noteLock + "\n" +  
	      "framerate = " + PApplet.round(sketch.frameRate);
	  }

	 public void controllerChange(int channel, int number, int value) {
	    switch (number) {
	      // Numbers lower than 20 should be reserved for midi/debug 
	      // changes
	    case 3: // changes the size
	      r.setTarget(PApplet.map(value, 0, 127, 0, PApplet.min(sketch.width/2, sketch.height/2)));
	      break;
	    case 4:
	      speed = PApplet.map(value, 0, 127, 0, maxSpeed);
	      debugSliders.get(1).val = speed;
	      break;
	    case 5:
	      decay.setTarget(PApplet.map(value, 0, 127, 0, -1));
	      debugSliders.get(0).val = decay.val();
	      break;
	  /*  case 6: 
	      maxSpeed = map(value, 0, 127, 0, .05);
	      break;*/
	    case 8:
	      phaseOffset = PApplet.map(value, 0, 127, 0, PApplet.HALF_PI);
	      break;
	    case 12:
	      alpha = PApplet.map(value, 0, 127, 0, 255);
	      break;

	      // Numbers higher than 20 can be used for OSC/production
	    case 46:
	      speed = PApplet.map(value, 0, 127, 0, maxSpeed);
	      debugSliders.get(1).val = speed;
	      break;
	    case 47:
	      alpha = PApplet.map(value, 0, 127, 0, 255);
	      break;
	    }
	  }

	  public void mouseClicked() {
	    //noteOn(1, int(random(0, 127)), 100);
	  }
	  
	  public void keyPressed() {
	    if (sketch.key == ' ') {
	      noteLock = !noteLock;
	    }
	  }

	  public List<Slider> sliders() {
	    return debugSliders;
	  }

	}
