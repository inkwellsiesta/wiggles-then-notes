import netP5.*;
import oscP5.*;

import themidibus.*;

// Listening for input other than mouse and keyboard
MidiBus myBus;
OscP5 oscP5;

DebugTray debugTray = new DebugTray();

// Keeps track of the visual mode
ArrayList<MidiViz> vizes = new ArrayList<MidiViz>();

PGraphics pg;

int activeViz;

CoinManager coins;


void setup() {
  size(800, 600, P3D); // use the P2D renderer for the shader modes,
  //fullScreen(P3D); // otherwise, use the default renderer
  pg = createGraphics(800, 600);

  vizes.add(new Lissajous());
  //vizes.add(new MoireShader());
  vizes.add(new Moire());
  
  activeViz = 0;


  coins = new CoinManager();
  // start MidiBus
  myBus = new MidiBus(this, "SLIDER/KNOB", "Gervill");
  MidiBus.list();

  // start oscP5, listening for incoming messages at port 12000
  oscP5 = new OscP5(this, 12000);


  for (MidiViz viz : vizes) {
    viz.setup();
  }

  debugTray.setup();
}

void draw() { 
  background(0);
  
  
  // Draw onto a PGraphics object
  pg.beginDraw();
  //for (MidiViz viz : vizes) {
    vizes.get(activeViz).update();
    vizes.get(activeViz).draw(pg);
  //}
  pg.endDraw();
  
  
  // Downsample and upsample
  PImage pi = pg.get();
  pi.resize(round((sin(radians(frameCount*2)) + 1)*200 + 10), 0);
  pi.resize(width, 0);
  image(pi, 0, 0);
  debugTray.draw();
  
  coins.draw();

  // Uncomment if you want to make a video
  //saveFrame("frames/####.tga");
  //println(frameRate);
 
}


float midiNoteToFreq(int note) {
  return 27.5 * pow(2, ((note) / 12.));
}

void keyPressed() {
  println(key);
  int num = Character.getNumericValue(key);
  println(num);
  if (num > 0 && num <= vizes.size()) {
    activeViz = (num - 1);
  }
}

void mouseClicked() {
  //for (MidiViz viz : vizes) {
    vizes.get(activeViz).mouseClicked();
  //}

  coins.addCoin();
  debugTray.mouseClicked();
}

//--- MIDI CALLBACKS MIDI CALLBACKS MIDI CALLBACKS---//
//--- ---//
void noteOn(int channel, int pitch, int velocity) {
  //or (MidiViz viz : vizes) {
    vizes.get(activeViz).noteOn(channel, pitch, velocity);
  //}

  if (true) {
    println();
    println("Note On:");
    println("--------");
    println("Channel:"+channel);
    println("Pitch:"+pitch);
    println("Velocity:"+velocity);
  }
}

void mousePressed() {
  debugTray.mousePressed();
}

void mouseDragged() {
  debugTray.mouseDragged();
}

void mouseReleased() {
  debugTray.mouseReleased();
}

void controllerChange(int channel, int number, int value) {

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
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/mtn/note")) {
    if (theOscMessage.checkTypetag("iii")) {
      int pitch = theOscMessage.get(0).intValue();
      int velocity = theOscMessage.get(1).intValue();
      int channel = theOscMessage.get(2).intValue();

      //for (MidiViz viz : vizes) {
        vizes.get(activeViz).noteOn(channel, pitch, velocity);
      //}

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
      //for (MidiViz viz : vizes) {
        vizes.get(activeViz).controllerChange(channel, number, value);
      //}

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