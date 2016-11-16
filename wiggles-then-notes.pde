import netP5.*;
import oscP5.*;

import themidibus.*;


MidiBus myBus;
int bgColor;

OscP5 oscP5;

ArrayList<MidiViz> vizes = new ArrayList<MidiViz>();

float rHeight = 0.f;

PShader mShader;

void setup() {
  //size(600, 400);
  fullScreen();
  
  bgColor = color(0, 25);

  vizes.add(new Lissajous());
  //vizes.add(new Moire());

  //mySine = new SinOsc(this);
  //mySine.play();
  myBus = new MidiBus(this, "Akai MPD18", "Gervill");
  MidiBus.list();

  for (MidiViz viz : vizes) {
    viz.setup();
  }


  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
}

void draw() { 
  //background(bgColor);
  
  for (MidiViz viz : vizes) {
    viz.update();
    viz.draw();
  }
  
  //fill(255);
  //ellipse(width/2, map(rHeight, 0, 127, height, 0), 30, 30);

  //saveFrame("frames/####.tga");
}

  
float midiNoteToFreq(int note) {
  return 27.5 * pow(2, ((note) / 12.));
}


void noteOn(int channel, int pitch, int velocity) {
  for (MidiViz viz : vizes) {
    viz.noteOn(channel, pitch, velocity);
  }

  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {

  for (MidiViz viz : vizes) {
    viz.controllerChange(channel, number, value);
  }
  

  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

void mouseClicked() {

  for (MidiViz viz : vizes) {
    viz.mouseClicked();
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/mtn/note")) {
    if (theOscMessage.checkTypetag("iii")) {
      int pitch = theOscMessage.get(0).intValue();
      int velocity = theOscMessage.get(1).intValue();
      int channel = theOscMessage.get(2).intValue();
      for (MidiViz viz : vizes) {
        viz.noteOn(channel, pitch, velocity);
      }

/*
      println();
      println("Note On:");
      println("--------");
      println("Channel:"+channel);
      println("Pitch:"+pitch);
      println("Velocity:"+velocity);
      */
      return;
    }
  }
  if (theOscMessage.checkAddrPattern("/mtn/ctrl")) {    if (theOscMessage.checkTypetag("iii")) {
      int number = theOscMessage.get(0).intValue();
      int value = theOscMessage.get(1).intValue();
      int channel = theOscMessage.get(2).intValue();
      for (MidiViz viz : vizes) {
        viz.controllerChange(channel, number, value);
      }

  //rHeight = (float)value;
  //println(rHeight);
      println();
      println("Controller Change:");
      println("--------");
      println("Channel:"+channel);
      println("Number:"+number);
      println("Value:"+value);
      
      return;
    }
  }
}