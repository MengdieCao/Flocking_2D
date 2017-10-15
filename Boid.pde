class Boid {
  float heightBoid = 20;
  float widthBoid = 10;
  PVector loc;
  PVector vel;
  PVector acc;

  float maxSteer;
  float maxVel;

  float disiredSpacing=40;

  float remainAcc;

  Boid(float x, float y) {
    loc=new PVector(x, y);
    vel=PVector.random2D();
    acc=new PVector(0, 0);

    maxSteer=0.01;
    maxVel=4;
  }

  //void assignAccAlongPriority() {
  //  remainAcc=maxSteer;

  //  //PVector ai;
  //  float mag;
    

  //  if (remainAcc>0) {
  //    PVector ca=collisionAvoidance(boids);
  //    mag=ca.mag();
  //    ca.setMag(min(remainAcc, mag));
  //    acc.add(ca);
  //    remainAcc=maxSteer-acc.mag();
  //  }

  //  if (remainAcc>0) {
  //    PVector vm=velocityMatching(boids);
  //    mag=vm.mag();
  //    vm.setMag(min(remainAcc, mag));
  //    acc.add(vm);
  //    remainAcc=maxSteer-acc.mag();
  //  }

  //  if (remainAcc>0) {
  //    PVector ct=centering(boids);
  //    mag=ct.mag();
  //    ct.setMag(min(remainAcc, mag));
  //    acc.add(ct);
  //  }
  //  for (int i=0; i<obs.size(); i++) {
  //    //PVector dodgeOb=dodgeObstacle(obs.get(i).loc, obs.get(i).radius+40);
  //    PVector dodgeOb=steering(obs.get(i).loc, obs.get(i).radius/2);
  //    mag=dodgeOb.mag();
  //    if (mag>0 && remainAcc>0) {
  //      dodgeOb.setMag(min(remainAcc, mag));
  //      acc.add(dodgeOb);
  //      remainAcc=maxSteer-acc.mag();
  //    }
  //  }
  //}

  void assignAccEven() {
    //PVector aw=avoidWall();
    //aw.mult(1);
    //acc.add(aw);

    PVector dodge;
    

    if(avoid_collision_on){
    PVector ca=collisionAvoidance(boids);
    ca.mult(1.5);
    acc.add(ca);
    }
    
    if(match_velocity_on){
    PVector vm=velocityMatching(boids);
    vm.mult(1);
    acc.add(vm);
    }
    
    if(centering_on){
    PVector ct=centering(boids);
    ct.mult(1);
    acc.add(ct);
    }
    for (int i=0; i<obs.size(); i++) {
      if (steering_on){
        dodge=steering(obs.get(i).loc, obs.get(i).radius/2+10);
      } else{
        dodge=dodgeObstacle(obs.get(i).loc, obs.get(i).radius+40);
      }
      //dodge.mult(2);
      acc.add(dodge);
    }
  }


  void update() {
    assignAccEven();
    //assignAccAlongPriority();

    vel.add(acc);
    vel.limit(maxVel);
    loc.add(vel);
    acc.mult(0);

    //bounce();
    wrapAround(WIDTH, HEIGHT);
  }


  //void display() {
  //  stroke(map(loc.z, WIDTH/2, -WIDTH/2, 255, 30));
  //  //stroke(255);
  //  strokeWeight(4);
  //  point(loc.x, loc.y, loc.z);
  //}

  void display() {
    //pushMatrix();
    //translate(loc.x, loc.y);
    //PVector temp=new PVector(vel.x, vel.y);
    //rotateZ(temp.heading());
    //temp=new PVector(temp.mag(), vel.z);
    //rotateY(temp.heading());
    //shape(cone, 0, 0);
    PVector direction = new PVector(vel.x,vel.y);
    float theta = direction.heading() + radians(90);
    //rotate(theta);
    //shape(s,loc.x,loc.y,20,40);
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -10*2);
    vertex(-10, 10*2);
    vertex(10, 10*2);
    endShape();
    popMatrix();

  }


  PVector dodgeObstacle(PVector ob_loc, float radius) {
    PVector xSI = loc.copy().sub(ob_loc);
    float dSI = xSI.mag();
    PVector dodgeAcce = xSI.normalize().mult(-0.8/(radius-dSI));
    return dodgeAcce;
  }
  
  PVector steering(PVector obstacle_loc, float radius){
    PVector vNorm = vel.copy().normalize();
    PVector xIS = obstacle_loc.copy().sub(loc.copy());
    float sClose = xIS.dot(vNorm);
    float tS = 100;
    float dS = vel.mag()*tS;
    PVector xClose;
    PVector vOrth;
    PVector xOrth;
    float vT;
    float dT;
    float tT;
    float deltaVS;
    PVector steeringAcce = new PVector(0,0);
    if (sClose >=0 && sClose < dS){
      xClose = loc.copy().add(vNorm.copy().mult(sClose));
      vOrth = xClose.copy().sub(obstacle_loc);
      xOrth = obstacle_loc.copy().add(vNorm.copy().mult(radius));
      dT = xOrth.copy().sub(loc).mag();
      vT = vel.copy().dot(xOrth.sub(loc))/dT;
      tT = dT/vT;
      deltaVS = vNorm.copy().cross(xOrth.copy().sub(loc)).mag()/tT;
      steeringAcce = steeringAcce.add(vOrth.normalize().mult(2*deltaVS/tT));
    }
    return steeringAcce;
  }

  PVector avoidWall() {
    float warningDistance=100;

    int count=0;
    PVector all=new PVector(0, 0);
    if (vel.x>0 && loc.x> WIDTH/2-warningDistance) {
      PVector repel=new PVector(-maxVel, 0);
      all.add(repel);
      count++;
    }

    if (vel.x<0 && loc.x< -WIDTH/2+warningDistance) {
      PVector repel=new PVector(maxVel, 0);
      all.add(repel);
      count++;
    }

    if (vel.y>0 && loc.y>HEIGHT/2-warningDistance) {
      PVector repel=new PVector(0, -maxVel);
      all.add(repel);
      count++;
    }

    if (vel.y<0 && loc.y<-HEIGHT/2+warningDistance) {
      PVector repel=new PVector(0, maxVel);
      all.add(repel);
      count++;
    }

    //if (vel.z>0 && loc.z>DEPTH/2-warningDistance) {
    //  PVector repel=new PVector(0, 0, -maxVel);
    //  all.add(repel);
    //  count++;
    //}

    //if (vel.z<0 && loc.z<-DEPTH/2+warningDistance) {
    //  PVector repel=new PVector(0, 0, maxVel);
    //  all.add(repel);
    //  count++;
    //}

    if (count>0) {
      all.div(count);
    }

    all.setMag(maxVel);

    PVector steer=PVector.sub(all, vel);
    steer.limit(maxSteer);
    return steer;
  }

  void bounce() {
    if (loc.x>WIDTH/2) {
      loc.x=WIDTH/2;
      vel.x*=-1;
    }
    if (loc.x<-WIDTH/2) {
      loc.x=-WIDTH/2;
      vel.x*=-1;
    }

    if (loc.y>HEIGHT/2) {
      loc.y=HEIGHT/2;
      vel.y*=-1;
    }
    if (loc.y<-HEIGHT/2) {
      loc.y=-HEIGHT/2;
      vel.y*=-1;
    }

    //if (loc.z>DEPTH/2) {
    //  loc.z=DEPTH/2;
    //  vel.z*=-1;
    //}
    //if (loc.z<-DEPTH/2) {
    //  loc.z=-DEPTH/2;
    //  vel.z*=-1;
    //}
  }








  PVector collisionAvoidance(ArrayList<Boid>boids) {
    PVector steer=new PVector(0, 0, 0);

    float coef;

    PVector sum=new PVector();
    int count=0;
    for (Boid other : boids) {
      if (other==this)continue;
      coef=distanceCoefficient(loc, other.loc, disiredSpacing, disiredSpacing*1.5);
      if (coef>0) {
        PVector repel=PVector.sub(loc, other.loc);
        repel.normalize();
        repel.div(PVector.dist(loc, other.loc));
        //repel.mult(coef);
        sum.add(repel);
        count++;
      }
    }
    if (count>0) {
      sum.setMag(maxVel);
      steer=PVector.sub(sum, vel);
      steer.limit(maxSteer);
      //return steer;
    }
    return steer;
  }


  PVector velocityMatching(ArrayList<Boid>boids) {
    PVector steer=new PVector(0, 0, 0);

    float coef;

    PVector sum=new PVector();
    int count=0;
    for (Boid other : boids) {
      if (other==this)continue;
      coef=distanceCoefficient(loc, other.loc, disiredSpacing, disiredSpacing*2);
      if (coef>0) {
        sum.add(other.vel);
        count++;
      }
    }
    if (count>0) {
      sum.div(float(count));
      sum.normalize();
      sum.mult(maxVel);
      steer=PVector.sub(sum, vel);
      steer.limit(maxSteer);
      //return steer;
    }
    return steer;
  }

  PVector centering(ArrayList<Boid>boids) {
    PVector steer=new PVector(0, 0, 0);

    float coef;

    PVector sum=new PVector();
    int count=0;
    for (Boid other : boids) {
      if (other==this)continue;
      coef=distanceCoefficient(loc, other.loc, disiredSpacing*1.4, disiredSpacing*2);
      if (coef>0) {
        sum.add(other.loc);
        count++;
      }
    }
    if (count>0) {
      sum.div(float(count));
      steer=PVector.sub(sum, loc);
      steer.setMag(maxVel);
      steer=PVector.sub(steer, vel);      
      steer.setMag(maxSteer);
    }
    return steer;
  }

  float distanceCoefficient(PVector l1, PVector l2, float rSmall, float rBig) {
    float distSq=sq(l1.x-l2.x)+sq(l1.y-l2.y)+sq(l1.z-l2.z);
    if (distSq>sq(rBig)) {
      return 0;
    } else if (distSq>sq(rSmall)) {
      return 1-(PVector.dist(l1, l2)-rSmall)/(rBig-rSmall);
    } else {
      return 1;
    }
  }


  void wrapAround(float x, float y) {
    if (loc.x>x/2) {
      loc.x=-x/2;
    }
    if (loc.x<-x/2) {
      loc.x=x/2;
    }
    if (loc.y>y/2) {
     loc.y=-y/2;
    }
    if (loc.y<-y/2) {
      loc.y=y/2;
    }
    //if (loc.z>z/2) {
    //  loc.z=-z/2;
    //}
    //if (loc.z<-z/2) {
    //  loc.z=z/2;
    //}
  }
}