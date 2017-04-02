package wigglesThenNotes;

public class AniFloat {
  private float val;
  private float target;
  
  private Pattern pattern;
  
  private float easing = .5f;
  
  private final static float k = .3f;
  private final static float b = .9f;
  private float v;

  public AniFloat(float val, Pattern p) {
    this.target = val;
    this.val = val;
    this.pattern = p;
    
    v = 0.f;
  }
  
  public void setEasing(float e) {
    easing = e;
  }

  public float val() {
    return this.val;
  }

  public void setTarget(float val) {
    this.target = val;
  }

  public void update() {
    switch (pattern) {
      case EASING:
        this.val+=(this.target - this.val)*easing;
        break;
      case SPRING:
        float a = this.target - this.val;
        v+=(k*a);
        v*=b;
        this.val += v;
        
        break;
    }
  }
}