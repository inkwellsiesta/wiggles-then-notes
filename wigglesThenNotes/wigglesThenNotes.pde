import netP5.*;
import oscP5.*;
import java.io.*;
import java.util.*;
import themidibus.*;
import peasy.*;

// Listening for input other than mouse and keyboard
MidiBus myBus;
OscP5 oscP5;

PeasyCam cam;

// Keeps track of the visual mode
ArrayList<Lissajous> vizes = new ArrayList<Lissajous>();

boolean debug = false;
//Assign mouse x/y to various parameters for testing purposes
boolean mapMouseToController = true;
int mouseChannel = 1;
int mouseXController = 46;
int mouseYController = 5;

int vizSize = 400;
int vizSpacing = 850;
int numVizs = 2; //For now, please make sure numRows * numCols = numVizs
int numRows = 1; 
int numCols = 2;


void setup() {
  //size(1080, 720, P3D); // use the P2D renderer for the shader modes,
  fullScreen(P3D); // otherwise, use the default renderer
  noCursor();

 for(int i=0;i<numVizs;i++)
   vizes.add(new Lissajous());

 
  //vizes.add(new MoireShader());
  //vizes.add(new Moire());

  // start MidiBus
  myBus = new MidiBus(this, "SLIDER/KNOB", "Gervill");
  MidiBus.list();

  // start oscP5, listening for incoming messages at port 12000
  oscP5 = new OscP5(this, 12000);
   
  cam = new PeasyCam(this, width/2, height/2, 0, min(width, height));
  cam.setActive(true);


  for (MidiViz viz : vizes) {
    viz.setup();
  }
}

void draw() { 
  background(0);
  
  //Leave ortho() commented out for fun panning and zooming around
  ortho();
  
  //First shift the whole grid over by 1/2 so the camera stays centered
  pushMatrix();
  translate((-(numCols - 1) * vizSpacing)/2, (-(numRows - 1) * vizSpacing)/2);
  
  int vizIndex = 0;
  int curCol = 0;
  int curRow = 0;
  for (MidiViz viz : vizes) {
    viz.update();
    //Draw viz in appropriate location within grid
    curCol = vizIndex % numCols;
    curRow = floor(vizIndex / numCols);
   
    pushMatrix();
      translate(curCol * (vizSpacing), curRow * (vizSpacing));
      viz.draw();
    popMatrix();
    
    vizIndex++;
  }
  
  popMatrix();

  // Uncomment if you want to make a video
  //saveFrame("frames/####.tga");
}


float midiNoteToFreq(int note) {
  return 27.5 * pow(2, ((note) / 12.));
}

void keyPressed() {
  if(key == 'c')
  {CameraState outputState = cam.getState();
    try {
      OutputStream file = new FileOutputStream(dataPath("")  + "\\test.cam");
      OutputStream buffer = new BufferedOutputStream(file);
      ObjectOutput output = new ObjectOutputStream(buffer);
      output.writeObject(outputState);
      output.close(); 
    }  
    catch(IOException ex){
     print(ex); 
    }
  }
  else
  {
    String inputPath = "";
  switch(key)
  {
    
    case '`':
      inputPath = dataPath("")  + "\\test.cam";
      break;
    case '1':
      inputPath = dataPath("")  + "\\diag_side.cam";
      break;
    case '2':
      inputPath = dataPath("")  + "\\flipped_x90.cam";
      break;
    case '3':
      inputPath = dataPath("")  + "\\flipped_z90.cam";
      break;
    case '4':
      inputPath = dataPath("")  + "\\side_nice.cam";
      break;
    case '5':
      inputPath = dataPath("")  + "\\side_nice2.cam";
      break;
    case '6':
      inputPath = dataPath("")  + "\\spinx1.cam";
      break;
    case '7':
      inputPath = dataPath("")  + "\\spinx2.cam";
      break;
    case '8':
      inputPath = dataPath("")  + "\\spinx3.cam";
      break;
    case '9':
      inputPath = dataPath("")  + "\\spinx4.cam";
      break;
    case '0':
      inputPath = dataPath("")  + "\\spinx5.cam";
      break;
  }
   try {
      InputStream file = new FileInputStream(inputPath);
      InputStream buffer = new BufferedInputStream(file);
      ObjectInput input = new ObjectInputStream (buffer);
      CameraState inputState = (CameraState)input.readObject();
      cam.setState(inputState);
      input.close();  
    }
    catch(Exception ex){
     print(ex); 
    }
    
  }
    
}

void mouseClicked() {
  for (MidiViz viz : vizes) {
    viz.mouseClicked();
  }
}

//--- MIDI CALLBACKS MIDI CALLBACKS MIDI CALLBACKS---//
//--- ---//
void noteOn(int channel, int pitch, int velocity) {
  for (Lissajous viz : vizes) {
    viz.noteOn(channel, pitch, velocity);
  }

  if (debug) {
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
    //controllerChange(mouseChannel, mouseXController, int(map(mouseX, 0, width, 0, 127)));
    //controllerChange(mouseChannel, mouseYController, int(map(mouseY, 0, height, 0, 127)));
    for (Lissajous viz : vizes) {
    viz.decay = map(mouseY, 0, height, 0, -1);
  }
  }
}

void controllerChange(int channel, int number, int value) {

  for (Lissajous viz : vizes) {
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
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/mtn/note")) {
    if (theOscMessage.checkTypetag("iii")) {
      int pitch = theOscMessage.get(0).intValue();
      int velocity = theOscMessage.get(1).intValue();
      int channel = theOscMessage.get(2).intValue();
      
      if(velocity > 0)
      {

        //Alternate starting and stopping even/odd viz's on channel 0 notes
        int i =0;
        if(channel == 0)
        {
            if(pitch == 0 || pitch == 1)
            for (Lissajous viz : vizes) {
                if(i%2==pitch)viz.speed = 0.000001;
                else viz.speed = 0.00008;
                i++;
            }
            else if(pitch == 2)
            for (Lissajous viz : vizes) {
                viz.speed = 0.000004;
            }
        }
        else //channel > 0              
          for (Lissajous viz : vizes) {
            viz.noteOn(channel, pitch, velocity);
          }
  
        if (debug) {
          println();
          println("OSC Note On:");
          println("--------");
          println("Channel:"+channel);
          println("Pitch:"+pitch);
          println("Velocity:"+velocity);
        }
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