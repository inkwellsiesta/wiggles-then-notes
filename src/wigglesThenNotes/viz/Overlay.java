package wigglesThenNotes.viz;

import java.util.List;
import java.io.File;
import processing.core.PGraphics;
import processing.core.PImage;
import wigglesThenNotes.MidiViz;
import wigglesThenNotes.Slider;
import wigglesThenNotes.wigglesThenNotes;

public class Overlay implements MidiViz {
	
	final String IMAGEPATH = "overlays";
	PImage overlay;
	PGraphics pg;
	wigglesThenNotes sketch;
	
	@Override
	public void setup(wigglesThenNotes sketch) {
		this.sketch = sketch;
		pg = sketch.createGraphics(sketch.width, sketch.height);
		overlay = sketch.loadImage(File.separatorChar + IMAGEPATH + File.separatorChar + "sample.png");
		
		//TODO read all overlay images in the directory and load them into an arraylist
		//Select the first image as the current overlay
		
	}

	@Override
	public void update() {
		
	}

	@Override
	public PGraphics draw(float s) {
		pg.beginDraw();
		overlay.resize(sketch.width, sketch.height);
		pg.image(overlay, 0, 0);
		pg.endDraw();
		return pg;
	}

	@Override
	public void noteOn(int channel, int pitch, int velocity) {
		if(sketch.debug)nextOverlay();
	}

	@Override
	public void controllerChange(int channel, int number, int value) {
		return;
	}

	@Override
	public void mouseClicked() {
		if(sketch.debug)nextOverlay();
	}

	@Override
	public void keyPressed() {
		if(sketch.debug)nextOverlay();
	}

	@Override
	public String debugString() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Slider> sliders() {
		// TODO Auto-generated method stub
		return null;
	}
	
	void nextOverlay()
	{
		//TODO swap out the current overlay	
	}

	@Override
	public void shutdown() {
		// TODO Auto-generated method stub
		
	}
}
