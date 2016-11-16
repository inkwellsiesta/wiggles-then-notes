class Lissajous implements MidiViz {
  PVector center;
  float r, offset, decay, start, speed;
  float f1 = midiNoteToFreq(57);
  float f2 = midiNoteToFreq(57);
  float alpha = 255;

  void setup() {
    center = new PVector(width/2, height/2);
    r = min(width/2, height/2);
    offset = .5;
    decay = -.1;
    start = 0;
    speed = .1;
  }
  void update() {
    start+=speed;
  }
  void draw() {
  pushStyle();
  noStroke();
  fill(color(0, alpha));
  rect(0, 0, width, height);
  popStyle();
    stroke(255);
    noFill();
    strokeWeight(1);
    beginShape();
    for (float i = 0. + start; i < TWO_PI*4 + start; i+=.1) {
      float x = center.x + (r*sin(f1*i) + random(-offset, offset))*exp(decay*(i-start));
      float y = center.y + (r*sin(f2*i) + random(-offset, offset))*exp(decay*(i-start));
      curveVertex(x, y);
    }
    endShape();
  }
  void noteOn(int channel, int pitch, int velocity) {
    //f1 = f2;
    if (velocity > 0 ) {
      f2 = midiNoteToFreq(pitch);
      //speed = map(velocity, 0, 127, 0, .2);
    }
  }
  void controllerChange(int channel, int number, int value) {
    switch (number) {
    case 3:
      r = map(value, 0, 127, 0, min(width/2, height/2));
      break;
    case 4:
      offset = map(value, 0, 127, 0, 10);
      break;
    case 5:
      decay = map(value, 0, 127, 0, -1);
      break;
    case 46:
    //println("Changing Speed");
    //println("Number = " + number);
      speed = map(value, 0, 127, 0, .0001);
      break;
     case 47:
     println("Changing alpha");
    println("Number = " + number);
      alpha = map(value, 0, 127, 0, 255);
      break;
    }
  }
  void mouseClicked() {
  }
}