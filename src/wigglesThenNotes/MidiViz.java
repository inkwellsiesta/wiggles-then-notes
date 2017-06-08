package wigglesThenNotes;

import java.util.List;

import processing.core.PGraphics;

public interface MidiViz {

	  public void setup(wigglesThenNotes sketch);
	  public void update();
	  public PGraphics draw(float s);
	  public void noteOn(int channel, int pitch, int velocity);
	  public void controllerChange(int channel, int number, int value);
	  public void mouseClicked();
	  public void keyPressed();
	  
	  String debugString();
	  public List<Slider> sliders();
	  public void shutdown();
	  public void mouseMoved(int x, int y);
	}