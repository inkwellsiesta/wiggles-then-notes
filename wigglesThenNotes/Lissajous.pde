class Lissajous implements MidiViz {
  PVector center;
  float r,  // size of shape
    randomness,  // 
    decay,  // 0 = no decay, more negative indicates
            // how quickly shape exponentially decays to center
    start,  
    speed,  // speed of starting point of line that
            // forms shape
    maxSpeed,
    phaseOffset; // phase offset b/t x and y axes in radians
            
  float f1 = midiNoteToFreq(57); // frequency that shape is "tuned" to
  float f2 = midiNoteToFreq(58); // (ie freq that f1 will always oscillate at)
  float f3 = midiNoteToFreq(60);
  
  float alpha = 255; // transparency of background
                     // 0-255, lower numbers let previous
                     // frames show through

  void setup() {
    center = new PVector(width/2, height/2, 0);
    r = vizSize; //min(width/2, height/2);
    randomness = 0;//.5;
    decay = -.1;
    start = 0;
    speed = 0; //.0001;
    maxSpeed = .0001;
    phaseOffset = HALF_PI;
  }
  
  void update() {
    start+=speed;
    start%=TAU;
  }
  
  void draw() {
    //background(0);
  //pushStyle();
  //noStroke();
  //fill(color(0, alpha));
  //rect(0, 0, width, height);
  //popStyle();
    stroke(255);
    noFill();
    strokeWeight(1);
    beginShape();
    for (float i = start; i < TWO_PI*4 + start; i+=.1) {
      float x = center.x + (r*sin(f1*i) + random(-randomness, randomness))*exp(decay*(i-start));
      float y = center.y + (r*sin(f2*i + phaseOffset) + random(-randomness, randomness))*exp(decay*(i-start));
      float z = center.z + (r*sin(f3*i) + random(-randomness, randomness))*exp(decay*(i-start));
      curveVertex(x, y, z);
    }
    endShape();
    
    // Radial, this should probably be its own mode
    /*pushStyle();
    noStroke();
    fill(255);
    float x = center.x + min(width,height)/2.*cos(f1*start)*sin(f2*start + phaseOffset);
    float y = center.y + min(width,height)/2.*sin(f1*start)*sin(f2*start + phaseOffset);
    ellipse(x, y, 20, 20);
    popStyle();*/
    
    if (debug) {
      pushStyle();
      fill(255);
      String debugStr = "size = " + r + "\n" +
                        "randomness = " + randomness + "\n" + 
                        "decay = " + decay + "\n" + 
                        "speed = " + speed + "\n" + 
                        "max speed = " + maxSpeed + "\n" +
                        "phase offset = " + phaseOffset + "\n" + 
                        "bg alpha = " + alpha + "\n" +
                        "freq 1 = " + f1 + "\n" +
                        "freq 2 = " + f2 + "\n" + 
                        "framerate = " + frameRate + "\n";
      textAlign(LEFT, TOP);
      text(debugStr, 0, 0);
      popStyle();
    }
  }
  
  
  void noteOn(int channel, int pitch, int velocity) {   
    if(channel == 1)
      //glitch note freq
      f2 = midiNoteToFreq(int(random(0,127)));
  }
  
  void controllerChange(int channel, int number, int value) {
    switch (number) {
    // Numbers lower than 20 should be reserved for midi/debug 
    // changes
    case 3: // changes the size
      r = map(value, 0, 127, 0, min(width/2, height/2));
      break;
    case 4:
      randomness = map(value, 0, 127, 0, 10);
      break;
    case 5:
      decay = map(value, 0, 127, 0, -1);
      break;
    case 6: 
      maxSpeed = map(value, 0, 127, 0, .05);
      break;
    case 8:
      phaseOffset = map(value, 0, 127, 0, HALF_PI);
      break;
    case 12:
      alpha = map(value, 0, 127, 0, 255);
      break;
    
    // Numbers higher than 20 can be used for OSC/production
    case 46:
      speed = map(value, 0, 127, 0, maxSpeed);
      break;
     case 47:
      alpha = map(value, 0, 127, 0, 255);
      break;
    }
  }
  
  void mouseClicked() {
    //f2 = midiNoteToFreq(int(random(0,127)));
  }
  
}