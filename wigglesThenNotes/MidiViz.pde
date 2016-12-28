interface MidiViz {
  
  void setup();
  void update();
  void draw();
  void noteOn(int channel, int pitch, int velocity);
  void controllerChange(int channel, int number, int value);
  void mouseClicked();
  
  String debugString();
  
}