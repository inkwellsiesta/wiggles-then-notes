class MoireShader implements MidiViz {
  PShader mShader;

  private float r = 0;
  private float n = 75;
  private boolean updateN = true;
  private boolean updateFlip = false;
  private boolean flip = false;
  
  private float speed = .001;
  private final float MAX_SPEED = .005;
  
  PGraphics pg;

  void setup() {
    mShader = loadShader("assets/moirefrag.glsl");

    mShader.set("u_resolution", float(width), float(height));
    mShader.set("r", r);
    mShader.set("n", n);
    mShader.set("m", 1.f);
    mShader.set("flip", flip);
    
    pg = createGraphics(width, height, P2D);
  }
  
  void update() {
    r-=speed;
  }
  
  PGraphics draw(float m) {
    pg.beginDraw();
    pg.background(0);
    pg.shader(mShader);
    pg.rect(0, 0, width, height);
    mShader.set("m", m);
    mShader.set("r", r);
    if (updateN) {
      mShader.set("n", n);
      updateN = false;
    }
    if (updateFlip) {
      mShader.set("flip", flip);
      updateFlip = false;
    }
    pg.endDraw();
    return pg;
  }

  void noteOn(int channel, int pitch, int velocity) {
    //mShader.set("r", 0.5); // can only do this in the main thread
    //n = pitch;
    //updateN = true;
    if (velocity > 0) {
      flip = !flip;
      updateFlip = true;
    }
  }

  void controllerChange(int channel, int number, int value) {
    speed = map(value, 0, 127, -MAX_SPEED, MAX_SPEED);
  }

  void mouseClicked() {
  }
  
  void keyPressed() {
  }

  String debugString() {
    return "framerate = " + round(frameRate) + "\n" +
    "speed = " + speed;
  } 

  List<Slider> sliders() {
    return new ArrayList<Slider>();
  }
}