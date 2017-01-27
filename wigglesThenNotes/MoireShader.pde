class MoireShader implements MidiViz {
  PShader mShader;

  private float r = 0;
  private float n = 75;
  private boolean updateN = true;
  
  private float speed = .001;
  private final float MAX_SPEED = .001;
  
  PGraphics pg;

  void setup() {
    mShader = loadShader("assets/moirefrag.glsl");

    mShader.set("u_resolution", float(width), float(height));
    mShader.set("r", r);
    mShader.set("n", n);
    
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
    mShader.set("r", r);
    if (updateN) {
      mShader.set("n", n);
      updateN = false;
    }
    pg.endDraw();
    return pg;
  }

  void noteOn(int channel, int pitch, int velocity) {
    //mShader.set("r", 0.5); // can only do this in the main thread
    //n = pitch;
    //updateN = true;
  }

  void controllerChange(int channel, int number, int value) {
    speed = map(value, 0, 127, -MAX_SPEED, MAX_SPEED);
  }

  void mouseClicked() {
  }
  
  void keyPressed() {
  }

  String debugString() {
    return "framerate = " + round(frameRate);
  } 

  List<Slider> sliders() {
    return new ArrayList<Slider>();
  }
}