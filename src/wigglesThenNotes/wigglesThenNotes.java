package wigglesThenNotes;

import java.util.ArrayList;

import oscP5.OscMessage;
import oscP5.OscP5;
import processing.core.PApplet;
import processing.core.PGraphics;
import themidibus.MidiBus;
import wigglesThenNotes.viz.Lissajous;
import wigglesThenNotes.viz.MoireShader;
import wigglesThenNotes.viz.Overlay;



public class wigglesThenNotes extends PApplet {
	// Listening for input other than mouse and keyboard
	MidiBus myBus;
	OscP5 oscP5;

	public boolean debug = true;
	DebugTray debugTray = new DebugTray();

	// Keeps track of the visual mode
	ArrayList<MidiViz> vizes = new ArrayList<MidiViz>();
	int activeViz;
	FadeManager fm = new FadeManager(this);

	// Stupid thing adam asked for
	CoinManager coins;
	int fadeTime = 0; //set to 50 for short transition
	
	public final static int WIDTH = 800;
	public final static int HEIGHT = 600;
	
	public void settings() {
		  size(WIDTH, HEIGHT, P2D); // use the P2D renderer for the shader modes,
		  //fullScreen(P2D); // otherwise, use the default renderer
	}

	public void setup() {
	  background(0);
	  if (!debug) noCursor();
	  
	  coins = new CoinManager(this);
	  
	  // start MidiBus
	  myBus = new MidiBus(this, 0, "Gervill");
	  MidiBus.list();

	  // start oscP5, listening for incoming messages at port 12000
	  oscP5 = new OscP5(this, 12000);

	  vizes.add(new Overlay());
	  //vizes.add(new Lissajous());
	  //vizes.add(new MoireShader());
	  
	  activeViz = 0;

	  for (MidiViz viz : vizes) {
	    viz.setup(this);
	  }

	  debugTray.setup(this);
	}

	public void draw() { 
	  //background(0);
	  fm.update();

	  // Draw onto a PGraphics object
	  vizes.get(activeViz).update();
	  float multiplier = 1.f;
	  if (fm.age > 0 && fm.age <= fadeTime) {
	    multiplier = map(abs(25-fm.age), 0, 25, 80, 4);
	  }
	  PGraphics pg = vizes.get(activeViz).draw(multiplier);

	  // Downsample and upsample fade transition
	  if (fm.age > 0 && fm.age < 100) {
	  } else {
	  }
	  image(pg, 0, 0, width*multiplier, height*multiplier);
	  
	  if (debug) debugTray.draw();

	  coins.draw();
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

	  debugTray.mouseClicked();
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
	  debugTray.mousePressed();
	}

	public void mouseDragged() {
	  debugTray.mouseDragged();
	}

	public void mouseReleased() {
	  debugTray.mouseReleased();
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
	      
	      //The following channels control the outer sketch, not the inner viz
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

	}

}
