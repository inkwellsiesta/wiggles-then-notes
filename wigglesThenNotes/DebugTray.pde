class DebugTray {
  boolean isActive;
  boolean isHovered;

  final int inactiveHeight = 20;
  final int activeHeight = 180;
  AniFloat h;
  
  
  public void setup() {
    isActive = false;
    isHovered = false;
    h = new AniFloat(inactiveHeight);
  }

  public void draw() {
    // deal with the height of the box
    h.update();

    // then with the hover logic
    isHovered = false;
    if (mouseY > height - h.val() &&
      mouseY < height) {
      isHovered = true;
    }

    // then draw some stuff
    pushStyle();
    fill(0);
    stroke(255);
    rect(0, height - h.val(), width, height, 5);
    if (isActive) {
      // draw the triangle to dismiss
      fill(255);
      triangle(width/2 - 5, height - h.val() + 5, 
        width/2 + 5, height - h.val() + 5, 
        width/2, height - h.val() + 15);
      // write the text
      noStroke();     
      textAlign(LEFT, TOP);
      for (MidiViz viz : vizes) {
        text(viz.debugString(), 10, height - h.val() + 10, 
          width/2 - 20, h.val() - 20);
          
        // draw the control sliders
        float x = width/2 + 10;
        for (Slider slider : viz.sliders()) {
          slider.draw(x, height - h.val() + 40, 
            10, h.val() - 50);
          x+=40;
        }
      }
    } else {
      // draw the triangle to expand
      fill(255);
      triangle(width/2 - 5, height - h.val() + 15, 
        width/2 + 5, height - h.val() + 15, 
        width/2, height - h.val() + 5);
    }
    popStyle();
  }

  public void mouseClicked() {
    if (isHovered) {
      isActive = !isActive;
    }

    if (isActive) {
      h.setTarget(activeHeight);
    } else {
      h.setTarget(inactiveHeight);
    }
  }

  public void mousePressed() {
    for (MidiViz viz : vizes) {
      for (Slider slider : viz.sliders()) {
        slider.mousePressed();
      }
    }
  }

  public void mouseDragged() {
    for (MidiViz viz : vizes) {
      for (Slider slider : viz.sliders()) {
        slider.mouseDragged();
      }
    }
  }

  public void mouseReleased() {
    for (MidiViz viz : vizes) {
      for (Slider slider : viz.sliders()) {
        slider.mouseReleased();
      }
    }
  }
}