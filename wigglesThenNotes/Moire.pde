class Moire implements MidiViz {
  ArrayList<Target> targets = new ArrayList<Target>();
  PVector currentOrigin;
  int strokeColor = 255;

  void setup() {
    noFill();
    currentOrigin = new PVector(width/2, height/2);
  }

  void update() {
    syncUpdate();
  }

  synchronized void syncUpdate() {
    for (int i = 0; i < targets.size(); i++) {
      Target target = targets.get(i);
      target.update();
      if (target.shouldKill()) {
        target.kill();
      }
      if (target.isDead()) {
        targets.remove(target);
      }
    }
  }

  void draw() {
    background(0);
    syncDraw();
    
    if (debug) {
      pushStyle();
      fill(255);
      textAlign(LEFT, TOP);
      text("framerate = " + frameRate, 0, 0);
      popStyle();
    }
  }

  synchronized void syncDraw() {
    for (int i = 0; i < targets.size(); i++) {
      targets.get(i).draw();
    }
  }

  void noteOn(int channel, int pitch, int velocity) {
    println("adding target");
    if (frameRate > 50) {
      targets.add(new Target(10, round(10000./midiNoteToFreq(pitch)), max(1, velocity/10)));
    }
    else {
      println("Can't add more than " + targets.size() + " targets.");
    }
  }

  void controllerChange(int channel, int number, int value) {
    int nTargets = targets.size();
    if (nTargets > 0) {
      targets.get(nTargets-1).setAlpha(value*2);
    }
  }

  void mouseClicked() {
    currentOrigin.set(mouseX, mouseY);
  }


  class Target {
    int minrad, maxrad; // min and max radii
    int weight;         // stroke weight
    int speed;          // rate of change of radii 
    PVector origin;     // where shape originates from
    int intensity = 255, alpha = 255;
    int age;            // number of frames of existence
    static final int MAX_AGE = 500;  // nothing lives forever
    boolean dying = false;
    
    int offset = 0;     // difference between specified minrad
                        // and effective minrad

    Target(int size, int weight, int speed) {
      this.minrad = 0;
      this.maxrad = size;
      this.weight = weight;
      this.speed = speed;
      this.origin = new PVector(currentOrigin.x, currentOrigin.y);
      this.age = 0;
    }

    void update() {
      age++;
      if (dying) {
        minrad += speed;
      }

      // Don't let the size increase infinitely
      // beyond the window, that would be inefficient
      if (maxrad < 2*max(width, height)) {
        maxrad += speed;
      } else {
        maxrad -= 4*weight;
      }
    }

    void draw() {
      stroke(intensity, alpha);
      strokeWeight(weight);
      // To acheive the illusion of a continuously moving wavefront...
      // Draw from the inside out when no new rings are being drawn
      //   from the center of the target
      if (dying) {
        for (int i = minrad; i < maxrad; i+=weight*4) {
          ellipse(origin.x, origin.y, i, i);
        }
      // Draw from the outside in otherwise
      } else {
        int i;
        for (i = maxrad; i > minrad; i-=weight*4) {
          ellipse(origin.x, origin.y, i, i);
        }
        // But calculate the offset so there's no discontinuity
        //  when the target is killed
        offset = i - minrad + weight*4;
      }
    }
    
    void setAlpha(int newAlpha) {
      this.alpha = newAlpha;
    }
    
    void kill() {
      dying = true;
      minrad+=offset;
    }
    
    boolean shouldKill() {
      return (age > MAX_AGE && !dying);
    }
      
    boolean isDead() {
      return (minrad > maxrad);
    }
  }
}