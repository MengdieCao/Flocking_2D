//I can successfully load .svg file and display boids
//as the paper plane file I found online. However,
//since the boids are so small, the image looks just 
//like triangle. So I just used triangle.
//The rest is basically the same as the 3D one.



PShape s;

ArrayList<Boid>boids;
ArrayList<Obstacle>obs;

float WIDTH;
float HEIGHT;
//float DEPTH;

//PShape cone;

boolean avoid_collision_on=true;
boolean match_velocity_on=true;
boolean centering_on=true;
boolean steering_on = true;
void setup() {
  size(2000,1000);


  WIDTH=width;
  HEIGHT=height;
  //DEPTH=800;
  //s = loadShape("paperplane.svg");
  boids=new ArrayList<Boid>();
  obs=new ArrayList<Obstacle>();

  for (int i=0; i<100; i++) {
    boids.add(new Boid(random(-WIDTH/2, WIDTH/2), 
      random(-HEIGHT/2, HEIGHT/2)));
  }

  obs.add(new Obstacle(-300, -100,  100));
  obs.add(new Obstacle(300, 200,  100));
  //obs.add(new Obstacle(300, 400, 0, 300));


}

void draw() {
  background(0);
  //pushMatrix();
  translate(width/2, height/2);
  //rotateY(map(mouseX, 0, width, 0, TWO_PI));
  textSize(32);
  text("Collision Avoidance: "+avoid_collision_on, 500,0);
  text("Velocity Matching: "+match_velocity_on, 500,50);
  text("Centering: " + centering_on, 500,100 );
  text("Steering: " + steering_on, 500, 150);
  //drawFrame();

  for (Obstacle ob : obs) {
    ob.display();
  }

  for (Boid one : boids) {
    one.update();
    one.display();
  }
  //rect(frameCount * frameCount % width, 0, 40, height);
  
  saveFrame("frames/####.png");
 
}

void keyPressed(){
  if(key=='1'){
    avoid_collision_on=!avoid_collision_on;
    
  }
  if(key=='2'){
    match_velocity_on=!match_velocity_on;
 
  }
  if(key=='3'){
    centering_on=!centering_on;
 
  }
  if (key == '4'){
    steering_on = !steering_on;
  }
  if (key == 'a'){
    boids.add(new Boid(random(-WIDTH/2, WIDTH/2), 
      random(-HEIGHT/2, HEIGHT/2)));
  }
  
  
  
  if (key == 'q') {
  
   
  }


}

void mouseClicked(){
  obs.add(new Obstacle(mouseX-width/2, mouseY-height/2, random(50,100)));
}


void drawFrame() {
  stroke(255);
  strokeWeight(1);

  line(WIDTH/2, HEIGHT/2, WIDTH/2, -HEIGHT/2);
  line(WIDTH/2, HEIGHT/2, -WIDTH/2, HEIGHT/2);
  line(-WIDTH/2, -HEIGHT/2, WIDTH/2, -HEIGHT/2);
  line(-WIDTH/2, -HEIGHT/2, -WIDTH/2, HEIGHT/2);

  line(WIDTH/2, HEIGHT/2, WIDTH/2, -HEIGHT/2);
  line(WIDTH/2, HEIGHT/2, -WIDTH/2, HEIGHT/2);
  line(-WIDTH/2, -HEIGHT/2, WIDTH/2, -HEIGHT/2);
  line(-WIDTH/2, -HEIGHT/2, -WIDTH/2, HEIGHT/2);

  line(WIDTH/2, HEIGHT/2, WIDTH/2, HEIGHT/2);
  line(-WIDTH/2, -HEIGHT/2, -WIDTH/2, -HEIGHT/2);
  line(WIDTH/2, -HEIGHT/2, WIDTH/2, -HEIGHT/2);
  line(-WIDTH/2, HEIGHT/2, -WIDTH/2, HEIGHT/2);
}

//void createCone() {
//  float r=10;
//  cone=createShape();
//  cone=createShape();


//  cone.beginShape(TRIANGLE_STRIP);
//  cone.fill(255);
//  for (int i=0; i<8; i++) {
//    cone.vertex(0, sin(i*TWO_PI/8)*r, cos(i*TWO_PI/8)*r);
//    cone.vertex(30, 0, 0);
//  }

//  cone.vertex(0, 0, 1*r);
//  cone.vertex(30, 0, 0);

//  cone.endShape();
//}