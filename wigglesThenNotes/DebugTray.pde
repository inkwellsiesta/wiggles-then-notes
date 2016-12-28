class DebugTray{
   boolean isActive;
   boolean isHovered;
   
   final int inactiveHeight = 20;
   final int activeHeight = 150;
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
        fill(255);
        triangle(width/2 - 5, height - h.val() + 5,
                 width/2 + 5, height - h.val() + 5,
                 width/2, height - h.val() + 15);
                 
        for (MidiViz viz : vizes) {
           text(viz.debugString(), 10, height - h.val + 20);
        }
      }
      else {
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
      }
      else {
        h.setTarget(inactiveHeight);
      }
    }
  
  
}