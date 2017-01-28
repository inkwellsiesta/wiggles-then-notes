class Lissajous implements MidiViz {
  PVector center;
  float randomness, // 
    start, 
    speed, // speed of starting point of line that
    // forms shape
    maxSpeed, 
    phaseOffset; // phase offset b/t x and y axes in radians
    
    AniFloat decay; // 0 = no decay, more negative indicates
    // how quickly shape exponentially decays to center
    AniFloat r; // size of shape
    
    final int validNotes[] = {4, 10, 13, 17, 18, 20, 22, 32, 33, 34, 44, 45, 47, 48, 51, 56, 57, 68, 69, 74};
    
    
  boolean noteLock; // if true, ignore midi and osc note changes

  float f1 = midiNoteToFreq(57); // frequency that shape is "tuned" to
  float f2 = midiNoteToFreq(57); // (ie freq that f1 will always oscillate at)

  float alpha = 255; // transparency of lines vs dots

  List<Slider> debugSliders;
  PGraphics pg;

  void setup() {
    pg = createGraphics(width, height);
    center = new PVector(width/2, height/2, 0);
    r = new AniFloat(min(width/2, height/2), Pattern.EASING);
    r.setEasing(.2);
    randomness = 0;
    decay = new AniFloat(-.1, Pattern.EASING);
    decay.setEasing(.2);
    start = 0;
    speed = .0001;
    maxSpeed = .0001;
    phaseOffset = HALF_PI;
    
    noteLock = false;

    debugSliders = new ArrayList<Slider>();
    // decay
    debugSliders.add(new Slider("Decay", -1, 0));
    // speed
    debugSliders.add(new Slider("Speed", 0, maxSpeed));
  }

  void update() {
    start+=speed;
    start%=TAU;

    //decay.setTarget(debugSliders.get(0).val);
    decay.update();
    r.update();
    
    speed = debugSliders.get(1).val;
  }

  PGraphics draw(float m) {
  pg.beginDraw();
    center.set(pg.width/2, pg.height/2);
    //r = min(pg.width/2, pg.height/2);
    pg.background(0, 100);
    
    pg.pushMatrix();
    pg.scale(1./m);
    pg.stroke(255, alpha);
    pg.noFill();
    pg.strokeWeight(2);
    pg.beginShape();
    for (float i = start; i < TWO_PI*4 + start; i+=.1) {
      float x = center.x + (r.val()*sin(f1*i) + random(-randomness, randomness))*exp(decay.val()*(i-start));
      float y = center.y + (r.val()*sin(f2*i + phaseOffset) + random(-randomness, randomness))*exp(decay.val()*(i-start));
      pg.curveVertex(x, y);
    }
    pg.endShape();
    pg.stroke(255, 255-alpha);
    pg.beginShape(POINTS);
    for (float i = start + .1; i < TWO_PI*4 + start; i+=.1) {
      float x = center.x + (r.val()*sin(f1*i) + random(-randomness, randomness))*exp(decay.val()*(i-start));
      float y = center.y + (r.val()*sin(f2*i + phaseOffset) + random(-randomness, randomness))*exp(decay.val()*(i-start));
      pg.strokeWeight(map(dist(x, y, center.x, center.y), 0, width/2, 1, 25));
      pg.vertex(x, y);
    }
    pg.endShape();
    pg.popMatrix();
    pg.endDraw();

    // Radial, this should probably be its own mode
    /*pushStyle();
     noStroke();
     fill(255);
     float x = center.x + min(width,height)/2.*cos(f1*start)*sin(f2*start + phaseOffset);
     float y = center.y + min(width,height)/2.*sin(f1*start)*sin(f2*start + phaseOffset);
     ellipse(x, y, 20, 20);
     popStyle();*/
     return pg;
  }


  void noteOn(int channel, int pitch, int velocity) {
    if (velocity > 0 && !noteLock) {
      int midiNote = validNotes[floor(random(validNotes.length))];
      f2 = midiNoteToFreq(midiNote);
    }
  }

  public String debugString() {
    return "size = " + r.val() + "\n" +
      "randomness = " + randomness + "\n" + 
      "decay = " + decay.val() + "\n" + 
      "speed = " + speed + "\n" + 
      "max speed = " + maxSpeed + "\n" +
      "phase offset = " + phaseOffset + "\n" + 
      "bg alpha = " + alpha + "\n" +
      "freq 1 = " + f1 + "\n" +
      "freq 2 = " + f2 + "\n" + 
      "note locked = " + noteLock + "\n" +  
      "framerate = " + round(frameRate);
  }

  void controllerChange(int channel, int number, int value) {
    switch (number) {
      // Numbers lower than 20 should be reserved for midi/debug 
      // changes
    case 3: // changes the size
      r.setTarget(map(value, 0, 127, 0, min(width/2, height/2)));
      break;
    case 4:
      speed = map(value, 0, 127, 0, maxSpeed);
      debugSliders.get(1).val = speed;
      break;
    case 5:
      decay.setTarget(map(value, 0, 127, 0, -1));
      debugSliders.get(0).val = decay.val();
      break;
  /*  case 6: 
      maxSpeed = map(value, 0, 127, 0, .05);
      break;*/
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
    //noteOn(1, int(random(0, 127)), 100);
  }
  
  void keyPressed() {
    if (key == ' ') {
      noteLock = !noteLock;
    }
  }

  List<Slider> sliders() {
    return debugSliders;
  }
}