class FadeManager {
  int targetViz;
  int age;
  
  FadeManager() {
  }
  
  void setTarget(int targetViz) {
    this.targetViz = targetViz;
    age = 0;
    //pg.resetShader();
  }
  
  void update() {
    age++;
    if (age == 25) {
      activeViz = targetViz;
    }
  }
}