import java.util.List;

interface MidiViz {

  void setup();
  void update();
  PGraphics draw(float s);
  void noteOn(int channel, int pitch, int velocity);
  void controllerChange(int channel, int number, int value);
  void mouseClicked();

  String debugString();
  List<Slider> sliders();
}