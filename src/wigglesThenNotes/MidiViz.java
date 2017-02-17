package wigglesThenNotes;

import java.util.List;

import processing.core.PGraphics;

interface MidiViz {

	  void setup(wigglesThenNotes sketch);
	  void update();
	  PGraphics draw(float s);
	  void noteOn(int channel, int pitch, int velocity);
	  void controllerChange(int channel, int number, int value);
	  void mouseClicked();
	  void keyPressed();
	  
	  String debugString();
	  List<Slider> sliders();
	}