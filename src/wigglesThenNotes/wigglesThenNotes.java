package wigglesThenNotes;

import java.util.ArrayList;

import oscP5.OscMessage;
import oscP5.OscP5;
import processing.core.PApplet;
import processing.core.PGraphics;
import themidibus.MidiBus;

public class wigglesThenNotes extends PApplet {
	// Listening for input other than mouse and keyboard
	MidiBus myBus;
	OscP5 oscP5;


	boolean debug = false;
	DebugTray debugTray = new DebugTray();

	// Keeps track of the visual mode
	ArrayList<MidiViz> vizes = new ArrayList<MidiViz>();
	int activeViz;
	FadeManager fm = new FadeManager(this);

	// Stupid thing adam asked for
	CoinManager coins;
	
	public void settings() {
		  size(800, 600, P2D); // use the P2D renderer for the shader modes,
		  //fullScreen(P2D); // otherwise, use the default renderer
	}

	public void setup() {
	  background(0);
	  if (!debug) noCursor();
	  //pg = createGraphics(800, 600);

	  vizes.add(new Lissajous());
	  vizes.add(new MoireShader());
	  //vizes.add(new Moire());

	  activeViz = 0;

	  coins = new CoinManager(this);
	  // start MidiBus
	  myBus = new MidiBus(this, 0, "Gervill");
	  MidiBus.list();

	  // start oscP5, listening for incoming messages at port 12000
	  oscP5 = new OscP5(this, 12000);


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
	  if (fm.age > 0 && fm.age < 50) {
	    multiplier = map(abs(25-fm.age), 0, 25, 80, 4);
	  }
	  PGraphics pg = vizes.get(activeViz).draw(multiplier);


	  // Downsample and upsample
	  if (fm.age > 0 && fm.age < 100) {
	  } else {
	  }
	  //tint(255, 100);
	  image(pg, 0, 0, width*multiplier, height*multiplier);
	  
	  if (debug) debugTray.draw();

	  coins.draw();

	  // Uncomment if you want to make a video
	  //saveFrame("frames/####.tga");
	}


	float midiNoteToFreq(int note) {
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

	  if (true) {
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

	  if (true) {
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
	      if (channel == 1 && velocity > 0) {
	        coins.addCoin();
	      } else {
	        vizes.get(activeViz).noteOn(channel, pitch, velocity);
	      }

	      if (false) {
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

	      if (false) {
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
