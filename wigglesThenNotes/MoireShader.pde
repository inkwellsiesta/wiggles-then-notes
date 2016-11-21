class MoireShader implements MidiViz {
  PShader mShader;
  
  private float r = 1.5;
  private boolean isAnimating = false;
  
  void setup() {
    mShader = loadShader("assets/moirefrag.glsl");
    
    mShader.set("u_resolution", float(width), float(height));
    mShader.set("r", r);
}
  void update() {
    if (isAnimating) {
      r-=.01;
      if (r < .54*PI/20.) {
        r=1.5;
        //isAnimating = false;
      }
    }
  }
  void draw() {
    background(100);
    shader(mShader);
    rect(0,0,width,height);
    mShader.set("r", r);
    
    if (debug) {
      println(frameRate);
    }
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    //mShader.set("r", 0.5); // can only do this in the main thread
    isAnimating = true;
  }
  
  void controllerChange(int channel, int number, int value) {
  }
  
  void mouseClicked() {
  }
}