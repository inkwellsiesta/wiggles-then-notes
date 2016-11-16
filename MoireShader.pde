class MoireShader implements MidiViz {
  PShader mShader;
  
  private float r = 0.0;
  void setup() {
    mShader = loadShader("assets/moirefrag.glsl");//, "assets/moirevert.glsl");
    
    mShader.set("u_resolution", float(width), float(height));
    mShader.set("r", r);
}
  void update() {
  }
  void draw() {
    background(100);
    shader(mShader);
    rect(0,0,width,height);
    mShader.set("r", r);
  }
  void noteOn(int channel, int pitch, int velocity) {
    //mShader.set("r", 0.5); // can only do this in the main thread
    r = (r == 0.0)? 0.5 : 0.0;
  }
  void controllerChange(int channel, int number, int value) {
  }
  void mouseClicked() {
  }
}