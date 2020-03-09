class Explosion {
  
  long startTime;        // keep track of when the explosion started*
  long begintoend;         // random lifespan for when it should be deleted
  long current;              // current age of the explosion
  
  
  
  Particle[] particles;  // array of Particle things
  
  
  Explosion(float x, float y) {
    
    // create random number of particles 
    particles = new Particle[ int(random(20,200)) ];
    for (int i=0; i<particles.length; i++) {
      particles[i] = new Particle(x,y);
    }   
    
    // save the current time as its start and set a random lifespan
    startTime = millis();
    begintoend = int(3000);    // 3-8 seconds
  }
  
  void update() {
    current = millis()-startTime;        // keep track of the explosion's age
    for (Particle p : particles) {   // update (move) each of the particles
      p.update();
    }
  }
  
  void display() {
    for (Particle p : particles) {
      p.display();
    }
  }
}


//for array
class Particle {
  
  PVector pos;        // current position
  PVector velocity;   // it's speed/direction
  float dia;          // diameter 
  
  
  Particle (float x, float y) {
    
    // start at explosion's center !!!!!
    pos = new PVector(x+random(-3,3), y+random(-3,3));
    
    // give the particle a random speed and diameter
    velocity = new PVector( random(-8,8), random(-8,8) );
    dia = random(2,10);
  }
  
  void update() {
    pos.add(velocity);
  }
  //rects that are displayed; colorful 
  void display() {
    fill(random(255), random(255), random(255));
    noStroke();
    rect(pos.x, pos.y, dia,dia);
  }
}
