import netP5.*;
import oscP5.*;

import themidibus.*;
import peasy.*;

// Listening for input other than mouse and keyboard
MidiBus myBus;
OscP5 oscP5;

PeasyCam cam;

// Keeps track of the visual mode
ArrayList<MidiViz> vizes = new ArrayList<MidiViz>();

boolean debug = false;
//Assign mouse x/y to various parameters for testing purposes
boolean mapMouseToController = true;
int mouseChannel = 1;
int mouseXController = 4;
int mouseYController = 5;

void setup() {
  size(600, 400, P3D); // use the P2D renderer for the shader modes,
  //fullScreen(); // otherwise, use the default renderer

 vizes.add(new Lissajous());
 // vizes.add(new MoireShader());
  //vizes.add(new Moire());

  // start MidiBus
  myBus = new MidiBus(this, "SLIDER/KNOB", "Gervill");
  MidiBus.list();

  // start oscP5, listening for incoming messages at port 12000
  oscP5 = new OscP5(this, 12000);
   
  cam = new PeasyCam(this, width/2, height/2, 0, min(width, height));
  cam.setActive(false);


  for (MidiViz viz : vizes) {
    viz.setup();
  }
}

void draw() { 
  noCursor(); 
  ortho();

  for (MidiViz viz : vizes) {
    viz.update();
    viz.draw();
  }

  // Uncomment if you want to make a video
  //saveFrame("frames/####.tga");
}


float midiNoteToFreq(int note) {
  return 27.5 * pow(2, ((note) / 12.));
}

void keyPressed() {
  cam.reset();
}

void mouseClicked() {
  debug = !debug;
  
  for (MidiViz viz : vizes) {
    viz.mouseClicked();
  }
}

//--- MIDI CALLBACKS MIDI CALLBACKS MIDI CALLBACKS---//
//--- ---//
void noteOn(int channel, int pitch, int velocity) {
  for (MidiViz viz : vizes) {
    viz.noteOn(channel, pitch, velocity);
  }

  if (true) {
    println();
    println("Note On:");
    println("--------");
    println("Channel:"+channel);
    println("Pitch:"+pitch);
    println("Velocity:"+velocity);
  }
}

//Mouse movements mapped to controller changes
void mouseMoved()
{
  if(mapMouseToController)
  {
    controllerChange(mouseChannel, mouseXController, int(map(mouseX, 0, width, 0, 127)));
    controllerChange(mouseChannel, mouseYController, int(map(mouseY, 0, height, 0, 127)));
  }
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

      for (MidiViz viz : vizes) {
        viz.noteOn(channel, pitch, velocity);
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
      for (MidiViz viz : vizes) {
        viz.controllerChange(channel, number, value);
      }

      if (true) {
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