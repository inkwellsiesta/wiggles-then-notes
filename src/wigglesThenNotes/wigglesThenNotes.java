package wigglesThenNotes;

import java.util.ArrayList;

import org.monome.*;

import netP5.NetAddress;
import oscP5.OscMessage;
import oscP5.OscP5;
import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;
import processing.opengl.PShader;
import themidibus.MidiBus;
import wigglesThenNotes.viz.Battista;
import wigglesThenNotes.viz.Lissajous;
import wigglesThenNotes.viz.MoireShader;
import wigglesThenNotes.viz.MonomeDisplay;
import wigglesThenNotes.viz.Overlay;



public class wigglesThenNotes extends PApplet {
	// Listening for input other than mouse and keyboard
	MidiBus myBus;
	OscP5 oscP5;

	public boolean debug = false;
	DebugTray debugTray = new DebugTray();
	PImage mask;
	boolean maskToggle = false;
	boolean applyEdgeFilter = false;
	Monome m;
	int model[][];
	int rows = 8, cols = 16;
	boolean copyScreenToMonome = false;
	
	//Shaders
	PShader edges;
	
	// Keeps track of the visual mode
	ArrayList<MidiViz> vizes = new ArrayList<MidiViz>();
	int activeViz;
	FadeManager fm = new FadeManager(this);

	// Stupid thing adam asked for
	CoinManager coins;
	int fadeTime = 0; //set to 50 for short transition
	
	public final static int WIDTH = 800;
	public final static int HEIGHT = 600;
	public float cubeRotate = 0f;
	
	public void settings() {
		  size(WIDTH, HEIGHT, P2D); // use the P2D renderer for the shader modes,
		  //fullScreen(P2D); // otherwise, use the default renderer
	}

	public void setup() {
	  background(0);
	  m = new Monome(this);
	  model = new int[rows][cols];
	  
	  if (!debug) noCursor();
	  
	  edges = loadShader("edges.glsl");
	  
	  coins = new CoinManager(this);
	  
	  mask = loadImage("masks/sample.png");
	  mask.resize(this.width, this.height);
	  
	  // start MidiBus
	  // myBus = new MidiBus(this, 0, "Gervill");
	  //MidiBus.list();

	  oscP5 = new OscP5(this, 12000);

	  //vizes.add(new Overlay());
	  //vizes.add(new Lissajous());
	  vizes.add(new Battista());
	  //vizes.add(new MoireShader());
	  //vizes.add(new MonomeDisplay());
	  
	  activeViz = 0;

	  for (MidiViz viz : vizes) {
	    viz.setup(this);
	  }

	  if (debug) debugTray.setup(this);
	}

	public void draw() { 
	  background(0);
	  fm.update();

	  // Draw onto a PGraphics object
	  vizes.get(activeViz).update();
	  
	  float multiplier = 1f;
	  if (fm.age > 0 && fm.age <= fadeTime) {
	    multiplier = map(abs(25-fm.age), 0, 25, 80, 4);
	  }
	  PGraphics pg = vizes.get(activeViz).draw(multiplier);

	  // Downsample and upsample fade transition
	  if (fm.age > 0 && fm.age < 100) {
	  } else {
	  }
	  
	  if(maskToggle)
		    pg.mask(mask);
	  
	  image(pg, 0, 0, width*multiplier, height*multiplier);
	  
	  
	  
	  if(copyScreenToMonome)
	  {
		  updateMonomeFromScreen();
		  refreshMonome();
	  }
	  
	  if(applyEdgeFilter)filter(edges);
	  
	  if (debug) debugTray.draw();
	  coins.draw();
	}
	
	private void updateMonomeFromScreen()
	{
		PImage screen = this.get();
		  screen.loadPixels();
		  int monomeCells = 0;
		  int monomePixel;
		  int screenPixel;
		  int pixelRow;
		  int pixelCol;
		  
		  for(int r=0;r<rows;r++)
		  {
			  for(int c=0;c<cols;c++)
			  {
				  pixelRow = (screen.height / rows) * r;
				  pixelCol = (screen.width / cols) * c;
				  
				  screenPixel = screen.pixels[(pixelRow * screen.width + pixelCol)];
				  
				  //Check if black
				  if(screenPixel < color(1, 1, 1, 255))
					  monomePixel = 0;
				  //Check if gray
				  else if(screenPixel < color(10,10,10,255))
					  monomePixel = 2;
				  else monomePixel = 2;
				  model[monomeCells / cols][monomeCells % cols] = monomePixel; 
				  monomeCells++;
			  }
		  }
		
	}
	
	private void refreshMonome()
	{
		int[][] grayscaleModel = model;
		
		for(int r = 0;r<rows;r++)
			for(int c=0;c<cols;c++)
			{
				//Check if gray
				if(grayscaleModel[r][c] == 1)
					grayscaleModel[r][c] = this.frameCount % 2;
				//LED on
				else if(grayscaleModel[r][c] == 2)
					grayscaleModel[r][c] = 1;
			}
		
		
		m.refresh(grayscaleModel);
		
	}
	
	private void resetMonome()
	{
		m = new Monome(this);
	}


	public float midiNoteToFreq(int note) {
	  return 27.5f * pow(2.f, ((float)(note) / 12.f));
	}

	public void keyPressed() {
	  vizes.get(activeViz).keyPressed();
	  
	  // Change the visualization mode if there are multiples
	  int num = Character.getNumericValue(key);
	  if (num > 0 && num <= vizes.size()) {
	    fm.setTarget(num-1);
	  }
	}
	
	public void mouseClicked() {
	  vizes.get(activeViz).mouseClicked();

	  if (debug) debugTray.mouseClicked();
	}

	//--- MIDI CALLBACKS MIDI CALLBACKS MIDI CALLBACKS---//
	//--- ---//
	public void noteOn(int channel, int pitch, int velocity) {
	  vizes.get(activeViz).noteOn(channel, pitch, velocity);

	  if (debug) {
	    println();
	    println("Note On:");
	    println("--------");
	    println("Channel:"+channel);
	    println("Pitch:"+pitch);
	    println("Velocity:"+velocity);
	  }
	}

	public void mousePressed() {
	  if( debug) debugTray.mousePressed();
	}

	public void mouseDragged() {
		if( debug) debugTray.mouseDragged();
	}

	public void mouseReleased() {
		if( debug) debugTray.mouseReleased();
	}

	public void controllerChange(int channel, int number, int value) {

	  for (MidiViz viz : vizes) {
	    viz.controllerChange(channel, number, value);
	  }

	  if (debug) {
	    println();
	    println("Controller Change:");
	    println("--------");
	    println("Channel:"+channel);
	    println("Number:"+number);
	    println("Value:"+value);
	  }
	}
	//--- ---//

	//--- OSC CALLBACKS OSC CALLBACKS OSC CALLBACKS ---//
	//--- ---//
	public void oscEvent(OscMessage theOscMessage) {
	  if (theOscMessage.checkAddrPattern("/mtn/note")) {
	    if (theOscMessage.checkTypetag("iii")) {
	      int pitch = theOscMessage.get(0).intValue();
	      int velocity = theOscMessage.get(1).intValue();
	      int channel = theOscMessage.get(2).intValue();
	      
	      //Channels 9 - 11 control the outer sketch, not the inner viz
	      //CHANNEL 10 - change viz	      
	      if(channel == 10 && velocity > 0)
	      {
	    	  if(pitch >= 0 && pitch < vizes.size())
	    		  fm.setTarget(pitch);
	    	  
	      } 
	      //CHANNEL 11 - coins
	      else if (channel == 11 && velocity > 0) {
	        coins.addCoin();
	      }
	      else if (channel == 9 && velocity >0){
	    	  resetMonome();
	      }
	      else if (channel == 8 && velocity >0){
	    	  if(velocity > 0 && velocity < 63)
	    		  maskToggle = false;
	    	  else maskToggle = true;
	      }
	      else if (channel == 7 && velocity >0){
	    	  if(velocity > 0 && velocity < 63)
	    		  copyScreenToMonome = false;
	    	  else copyScreenToMonome = true;
	      }
	      else if (channel == 6 && velocity >0){
	    	  //Run shutdown method on the viz about to be switched away from
	    	  vizes.get(activeViz).shutdown();
	    	  if(pitch < vizes.size())
	    		  activeViz = pitch;
	      }
	      //Otherwise pass data to the active viz
	      else {
	        vizes.get(activeViz).noteOn(channel, pitch, velocity);
	      }

	      if (debug) {
	        println();
	        println("OSC Note On:");
	        println("--------");
	        println("Channel:"+channel);
	        println("Pitch:"+pitch);
	        println("Velocity:"+velocity);
	      }
	      return;
	    }
	  }
	  if (theOscMessage.checkAddrPattern("/mtn/ctrl")) {    
	    if (theOscMessage.checkTypetag("iii")) {
	      int number = theOscMessage.get(0).intValue();
	      int value = theOscMessage.get(1).intValue();
	      int channel = theOscMessage.get(2).intValue();
	      vizes.get(activeViz).controllerChange(channel, number, value);

	      if (debug) {
	        println();
	        println("OSC Controller Change:");
	        println("--------");
	        println("Channel:"+channel);
	        println("Number:"+number);
	        println("Value:"+value);
	      }

	      return;
	    }
	  }
	}
	//--- ---//

	public static void main(String[] args) {
		PApplet.main(wigglesThenNotes.class.getName());
		System.out.println(wigglesThenNotes.class.getName());
	}
	
	public void mouseMoved()
	{
		vizes.get(activeViz).mouseMoved(this.mouseX, this.mouseY);
		
	}

}
