class Fireworks implements MidiViz {
  ArrayList<Particle> particles = new ArrayList<Particle>();
  PVector currentOrigin;
  
  void setup() {
    background(0);
    colorMode(HSB);
    currentOrigin = new PVector(width/2, height/2);
  }
  
  void update() {
    syncUpdate();
  }
  
  synchronized void syncUpdate() {
    for (int i = 0; i < particles.size(); i++) {
      Particle particle = particles.get(i);
      particle.update();
      if (particle.outsideScreen()) {
        particles.remove(particle);
      }
    }
  }

  void draw() {
    syncDraw();
    filter(BLUR);
  }
  
  synchronized void syncDraw() {
    for (int i = 0; i < particles.size(); i++) {
      Particle particle = particles.get(i);
      particle.draw();
    }
  }
    
  void noteOn(int channel, int pitch, int velocity) {
    int elColor, elSize;
    elColor = (int)map((float)pitch, 32., 72., 100., 255.);
    elSize = 10;
    particles.add(new Particle(log(velocity), elColor, elSize));
  }
  
  void controllerChange(int channel, int number, int value) {}
  
  void mouseClicked() {
    currentOrigin.set(mouseX, mouseY);  
  }
  
  String debugString() {
    return "";
  }


  class Particle {
    PVector velocity;
    PVector position;
    color c;
    int size;

    Particle(float s, int c, int size) {
      position = new PVector(currentOrigin.x, currentOrigin.y);
      velocity = (new PVector(random(-1, 1), random(-1, 1)))
        .normalize()
        .mult(max(1, s));

      this.c = color(c, 255, 255);
      this.size = size;
    }

    void update() {
      velocity.add(0, .01);
      position.add(velocity);
    }

    boolean outsideScreen() {
      return (position.x < -size/2 || position.x > width + size/2 ||
        position.y < -size/2 || position.y > height + size/2);
    }

    void draw() {
      stroke(c);
      noFill();
      ellipse(position.x, position.y, size, size);
    }
  }
}