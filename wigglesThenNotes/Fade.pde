class FadeManager {
  int targetViz;
  int age;
  
  FadeManager() {
  }
  
  void setTarget(int targetViz) {
    this.targetViz = targetViz;
    age = 0;
  }
  
  void update() {
    age++;
    if (age == 50) {
      activeViz = targetViz;
    }
  }
}