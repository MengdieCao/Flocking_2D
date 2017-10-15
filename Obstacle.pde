class Obstacle {
  PVector loc;
  float radius;
  //float currentR=0;

  Obstacle(float x, float y, float radius) {
    loc=new PVector(x, y);
    this.radius=radius;
  }

  void display() {
    //currentR+=1;
    //if (currentR>radius) {
    //  currentR=0;
    //}
    //pushMatrix();
    //translate(loc.x, loc.y);
    //pushStyle();
    //noStroke();

    fill(255, 0, 0);
    ellipse(loc.x, loc.y, radius, radius);

    //fill(255, 0, 0, 60);
    //sphere(currentR);
    //popStyle();
    //popMatrix();
  }
}