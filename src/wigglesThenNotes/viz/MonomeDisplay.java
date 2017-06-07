package wigglesThenNotes.viz;

import java.util.List;

import processing.core.PGraphics;
import wigglesThenNotes.MidiViz;
import wigglesThenNotes.Slider;
import wigglesThenNotes.wigglesThenNotes;
import oscP5.*;
import processing.core.*;
import org.monome.*;
import netP5.*;
import oscP5.*;

public class MonomeDisplay implements MidiViz {

	Monome m;
	int model[][];
	int rows = 8, cols = 16;
	OscP5 abletonOSC;
	int[] frame;
	NetAddress localhost;
	boolean invert = false;
	wigglesThenNotes sketch;
	PGraphics pg;

	@Override
	public void setup(wigglesThenNotes sketch) {
		// TODO Auto-generated method stub
		m = new Monome(sketch);
		this.sketch = sketch;
		abletonOSC = new OscP5(this, 7777);
		// monomeOSC = new OscP5(this,7778);

		localhost = new NetAddress("127.0.0.1", 12002);

		frame = new int[rows];
		model = new int[rows][cols];
		pg = this.sketch.createGraphics(sketch.width, sketch.height);
	}

	@Override
	public void update() {
		// TODO Auto-generated method stub

	}

	
	@Override
	public PGraphics draw(float s) {
		int colWidth = sketch.width / cols;
		int rowWidth = sketch.height / rows;
		
		pg.beginDraw();
		pg.background(0, 100);
		pg.stroke(255);
		pg.fill(255);
		  for(int x=0;x<rows;x++)
		  {
		    for(int y=0;y<cols;y++)
		    {
		      if(getModel()[x][y] == 1)pg.rect(y*colWidth, x*rowWidth, colWidth, rowWidth);
		    }
		  }
		pg.endDraw();
		return pg;
	}

	//NoteOn from the main wiggles sketch
	@Override
	public void noteOn(int channel, int pitch, int velocity) {
		if(channel == 9 && velocity > 0)
			restartMonome();
	}

	@Override
	public void controllerChange(int channel, int number, int value) {
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseClicked() {
		// TODO Auto-generated method stub

	}

	@Override
	public void keyPressed() {
		// TODO Auto-generated method stub

	}

	@Override
	public String debugString() {
		return "MonomeDisplay";
	}

	@Override
	public List<Slider> sliders() {
		// TODO Auto-generated method stub
		return null;
	}
	
	public void addFrameToModel(int[] frame)
	{
	  for(int x=0;x<rows;x++)
	  {
	    model[x][cols-1] = frame[x];
	  }
	}

	public void addNoteToFrame(int note, int index)
	{
	  frame[index] = note;
	}

	public int[][] getModel()
	{
		
		int[][] tempModel = new int[rows][cols];
		
		
		for(int x=0;x<rows;x++)
			for(int y=0;y<cols;y++)
			{
				if(invert)
				{
				if(model[x][y] == 1)tempModel[x][y] = 0;
				if(model[x][y] == 0)tempModel[x][y] = 1;
				}else
					tempModel[x][y] = model[x][y];
			}
		
		return tempModel;
	}


	public void shiftModel()
	{
	  
	  for(int x=0;x<rows;x++)
	  {
	    for(int y=0;y<cols-1;y++)
	    {
	      model[x][y] = model[x][y+1];
	    }
	  }
	}

	public void restartMonome()
	{
		m = new Monome(sketch);
	}

	public void clearModel()
	{
		frame = new int[rows];
		model = new int[rows][cols];
	}

	public void oscEvent(OscMessage msg) {
	  int note;
	  if(msg.checkAddrPattern("/mtn/note") && msg.get(1).intValue() > 0)
	    {
	      note = msg.get(0).intValue();
	     if(note == 8)
	      {
	    	  shiftModel();
	    	  addFrameToModel(frame);
	        
	    	if(m != null)
	    		m.refresh(getModel());
	        frame = new int[8];
	      }
	      else if(note == 9)
	      {
	    	  clearModel();
	      }
	      else if(note == 10)
	    	  invert = true;
	      else if(note == 11)
	    	  invert = false;
	      else if(note < 8)
	      {
	        addNoteToFrame(1, 7-note);
	      }
	      
	  }
	}

	@Override
	public void shutdown() {
		// TODO Auto-generated method stub
		clearModel();
		m.refresh(getModel());
	}

}
