class MoireShader implements MidiViz {
  PShader mShader;

  private float r = 0;
  private float minR = 0;
  private float n = 1;
  private boolean updateN = false;
  
  private float speed = .01;
  
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
    /*if (r < minR) {//(n*1.5/TAU - floor(n*1.5/TAU))*PI/n) {
      float offset = ((1.5*width/n) - floor(1.5*width/n));
      println(n);
      println(offset);
      r=1.5;
    }*/
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
    n = pitch;
    minR = (n*20*1.5*1.5/TAU - floor(n*20*1.5*1.5/TAU))*TAU/(n*20*1.5);
    updateN = true;
  }

  void controllerChange(int channel, int number, int value) {
    speed = map(value, 0, 127, -.01, .01);
  }

  void mouseClicked() {
  }

  String debugString() {
    return "framerate = " + round(frameRate);
  } 

  List<Slider> sliders() {
    return new ArrayList<Slider>();
  }
}