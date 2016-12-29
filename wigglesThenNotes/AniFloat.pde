class AniFloat {
  private float val;
  private float target;


  AniFloat(float val) {
    this.target = val;
    this.val = val;
  }

  public float val() {
    return this.val;
  }

  public void setTarget(float val) {
    this.target = val;
  }

  public void update() {
    this.val+=(this.target - this.val)*.5;
  }
}