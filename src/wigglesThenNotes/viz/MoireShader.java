package wigglesThenNotes.viz;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.opengl.PShader;
import wigglesThenNotes.MidiViz;
import wigglesThenNotes.Slider;
import wigglesThenNotes.wigglesThenNotes;

public class MoireShader implements MidiViz {
	  PShader mShader;
	  wigglesThenNotes sketch;

	  private float r = 0;
	  private float n = 75;
	  private boolean updateN = true;
	  private boolean updateFlip = false;
	  private boolean flip = false;
	  
	  private float speed = .001f;
	  private final float MAX_SPEED = .005f;
	  
	  PGraphics pg;

	  public void setup(wigglesThenNotes sketch) {
		  this.sketch = sketch;
	    mShader = sketch.loadShader("assets/moirefrag.glsl");

	    mShader.set("u_resolution", (float)sketch.width, (float)sketch.height);
	    mShader.set("r", r);
	    mShader.set("n", n);
	    mShader.set("m", 1.f);
	    mShader.set("flip", flip);
	    
	    pg = sketch.createGraphics(sketch.width, sketch.height, PApplet.P2D);
	  }
	  
	 public void update() {
	    r-=speed;
	  }
	  
	  public PGraphics draw(float m) {
	    pg.beginDraw();
	    pg.background(0);
	    pg.shader(mShader);
	    pg.rect(0, 0, sketch.width, sketch.height);
	    mShader.set("m", m);
	    mShader.set("r", r);
	    if (updateN) {
	      mShader.set("n", n);
	      updateN = false;
	    }
	    if (updateFlip) {
	      mShader.set("flip", flip);
	      updateFlip = false;
	    }
	    pg.endDraw();
	    return pg;
	  }

	  public void noteOn(int channel, int pitch, int velocity) {
	    //mShader.set("r", 0.5); // can only do this in the main thread
	    //n = pitch;
	    //updateN = true;
	    if (velocity > 0) {
	      flip = !flip;
	      updateFlip = true;
	    }
	  }

	  public void controllerChange(int channel, int number, int value) {
	    speed = PApplet.map(value, 0, 127, -MAX_SPEED, MAX_SPEED);
	  }

	  public void mouseClicked() {
	  }
	  
	  public void keyPressed() {
	  }

	  public String debugString() {
	    return "framerate = " + PApplet.round(sketch.frameRate) + "\n" +
	    "speed = " + speed;
	  } 

	  public List<Slider> sliders() {
	    return new ArrayList<Slider>();
	  }

	@Override
	public void shutdown() {
		// TODO Auto-generated method stub
		
	}
	}