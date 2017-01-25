class MoireShader implements MidiViz {
  PShader mShader;

  private float r = 1.5;
  private float minR = 0;
  private float n = 1;
  private boolean updateN = false;

  void setup() {
    mShader = loadShader("assets/moirefrag.glsl");

    mShader.set("u_resolution", float(width), float(height));
    mShader.set("r", r);
    mShader.set("n", n);
  }
  void update() {
    r-=.005;
    if (r < minR) {//(n*1.5/TAU - floor(n*1.5/TAU))*PI/n) {
      r=1.5;
    }
  }
  void draw(PGraphics pg) {
    background(100);
    shader(mShader);
    rect(0, 0, width, height);
    mShader.set("r", r);
    if (updateN) {
      mShader.set("n", n);
      updateN = false;
    }
  }

  void noteOn(int channel, int pitch, int velocity) {
    //mShader.set("r", 0.5); // can only do this in the main thread
    n = pitch;
    minR = (n*20*1.5*1.5/TAU - floor(n*20*1.5*1.5/TAU))*TAU/(n*20*1.5);
    updateN = true;
  }

  void controllerChange(int channel, int number, int value) {
  }

  void mouseClicked() {
  }

  String debugString() {
    return "framerate = " + frameRate;
  } 

  List<Slider> sliders() {
    return new ArrayList<Slider>();
  }
}