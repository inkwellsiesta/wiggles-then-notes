class Slider {
  final String name;
  final float min, max;
  float val;

  float x, y, w, h;
  boolean isAdjusting;

  Slider(String name,
        float min, float max) {
    this.name = name;
    this.min = min;
    this.max = max;
    val = (max + min)*.5;
    isAdjusting = false;
  }
  private float sliderY() {
    return map(val, min, max, y, y + h);
  }
  public void draw(float x, float y, 
    float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    pushStyle();
    fill(0);
    stroke(255);
    rect(x + w*.25, y, w*.5, h);
    fill(255);
    rect(x, sliderY() - h*.05, 
      w, h*.1);
    popStyle();
  }

  public void mousePressed() {
    if (mouseX > x && mouseX < x + w
      && mouseY > sliderY() - h*.05 && mouseY < sliderY() + h*.05) {
      isAdjusting = true;
    }
  }

  public void mouseDragged() {
    if (isAdjusting) {
      val = map(mouseY, y, y + h, min, max);
      val = max(val, min);
      val = min(val, max);
    }
  }

  public void mouseReleased() {
    isAdjusting = false;
  }
}