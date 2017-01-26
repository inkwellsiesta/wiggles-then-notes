class Lissajous implements MidiViz {
  PVector center;
  float r, // size of shape
    randomness, // 
    decay, // 0 = no decay, more negative indicates
    // how quickly shape exponentially decays to center
    start, 
    speed, // speed of starting point of line that
    // forms shape
    maxSpeed, 
    phaseOffset; // phase offset b/t x and y axes in radians

  float f1 = midiNoteToFreq(57); // frequency that shape is "tuned" to
  float f2 = midiNoteToFreq(58); // (ie freq that f1 will always oscillate at)
  float f3 = midiNoteToFreq(60);

  float alpha = 255; // transparency of background
  // 0-255, lower numbers let previous
  // frames show through

  List<Slider> debugSliders;

  void setup() {
    center = new PVector(width/2, height/2, 0);
    r = min(width/2, height/2);
    randomness = .5;
    decay = -.1;
    start = 0;
    speed = .0001;
    maxSpeed = .0001;
    phaseOffset = HALF_PI;

    debugSliders = new ArrayList<Slider>();
    // decay
    debugSliders.add(new Slider("Decay", -1, 0));
    // speed
    debugSliders.add(new Slider("Speed", 0, maxSpeed));
  }

  void update() {
    start+=speed;
    start%=TAU;

    decay = debugSliders.get(0).val;
    speed = debugSliders.get(1).val;
  }

  void draw(PGraphics pg, float m) {
    center.set(pg.width/2, pg.height/2);
    r = min(pg.width/2, pg.height/2);
    pg.background(0);
    
    pg.pushMatrix();
    pg.scale(1./m);
    pg.stroke(255, 50);
    pg.noFill();
    pg.strokeWeight(2);
    pg.beginShape();
    for (float i = start; i < TWO_PI*4 + start; i+=.1) {
      float x = center.x + (r*sin(f1*i) + random(-randomness, randomness))*exp(decay*(i-start));
      float y = center.y + (r*sin(f2*i + phaseOffset) + random(-randomness, randomness))*exp(decay*(i-start));
      pg.curveVertex(x, y);
    }
    pg.endShape();
    pg.stroke(255);
    pg.beginShape(POINTS);
    for (float i = start + .1; i < TWO_PI*4 + start; i+=.1) {
      float x = center.x + (r*sin(f1*i) + random(-randomness, randomness))*exp(decay*(i-start));
      float y = center.y + (r*sin(f2*i + phaseOffset) + random(-randomness, randomness))*exp(decay*(i-start));
      pg.strokeWeight(map(dist(x, y, center.x, center.y), 0, width/2, 0, 8));
      pg.vertex(x, y);
    }
    pg.endShape();
    pg.popMatrix();

    // Radial, this should probably be its own mode
    /*pushStyle();
     noStroke();
     fill(255);
     float x = center.x + min(width,height)/2.*cos(f1*start)*sin(f2*start + phaseOffset);
     float y = center.y + min(width,height)/2.*sin(f1*start)*sin(f2*start + phaseOffset);
     ellipse(x, y, 20, 20);
     popStyle();*/
  }


  void noteOn(int channel, int pitch, int velocity) {
    if (velocity > 0 ) {
      f2 = midiNoteToFreq(pitch);
    }
  }

  public String debugString() {
    return "size = " + r + "\n" +
      "randomness = " + randomness + "\n" + 
      "decay = " + decay + "\n" + 
      "speed = " + speed + "\n" + 
      "max speed = " + maxSpeed + "\n" +
      "phase offset = " + phaseOffset + "\n" + 
      "bg alpha = " + alpha + "\n" +
      "freq 1 = " + f1 + "\n" +
      "freq 2 = " + f2 + "\n" + 
      "framerate = " + round(frameRate);
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
      debugSliders.get(0).val = decay;
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
      debugSliders.get(1).val = speed;
      break;
    case 47:
      alpha = map(value, 0, 127, 0, 255);
      break;
    }
  }

  void mouseClicked() {
    noteOn(1, int(random(0, 127)), 100);
  }

  List<Slider> sliders() {
    return debugSliders;
  }
}