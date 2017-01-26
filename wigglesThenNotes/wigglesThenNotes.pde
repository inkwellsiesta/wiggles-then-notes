import netP5.*;
import oscP5.*;

import themidibus.*;

// Listening for input other than mouse and keyboard
MidiBus myBus;
OscP5 oscP5;

DebugTray debugTray = new DebugTray();

// Keeps track of the visual mode
ArrayList<MidiViz> vizes = new ArrayList<MidiViz>();
int activeViz;
FadeManager fm = new FadeManager();

// Used for the downsamply transition
PGraphics pg;

// Stupid thing adam asked for
CoinManager coins;

void setup() {
  size(800, 600, P3D); // use the P2D renderer for the shader modes,
  //fullScreen(P3D); // otherwise, use the default renderer
  pg = createGraphics(800, 600);

  vizes.add(new Lissajous());
  vizes.add(new MoireShader());
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
  //background(0);
  fm.update();


  // Draw onto a PGraphics object
  pg.beginDraw();
  vizes.get(activeViz).update();
  float multiplier = 1.;
  if (fm.age > 0 && fm.age < 100) {
     multiplier = map(abs(50-fm.age), 0, 50, 80, 4);
  }
  vizes.get(activeViz).draw(pg, multiplier);
  pg.endDraw();


  // Downsample and upsample
  if (fm.age > 0 && fm.age < 100) {
    PImage pi = pg.get();
    image(pg, 0, 0, width*multiplier, height*multiplier);
  } else {
    tint(255, 100);
    image(pg, 0, 0, width, height);
  }
  debugTray.draw();

  coins.draw();

  // Uncomment if you want to make a video
  //saveFrame("frames/####.tga");
}


float midiNoteToFreq(int note) {
  return 27.5 * pow(2, ((note) / 12.));
}

void keyPressed() {
  int num = Character.getNumericValue(key);
  if (num > 0 && num <= vizes.size()) {
    //activeViz = (num - 1);
    fm.setTarget(num-1);
  }
}

void mouseClicked() {
  vizes.get(activeViz).mouseClicked();

  coins.addCoin();
  debugTray.mouseClicked();
}

//--- MIDI CALLBACKS MIDI CALLBACKS MIDI CALLBACKS---//
//--- ---//
void noteOn(int channel, int pitch, int velocity) {
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