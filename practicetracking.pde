import processing.video.*;
import gab.opencv.*;
import de.voidplus.dollar.*;



Movie mov;                     
OpenCV cv;                        
ArrayList<Contour> blobs;           
OneDollar gesture;                  // gesture detection 
PVector centroid;                   // center of gestures when found
ArrayList<Explosion> explosions;    // explosions triggered by our gesture


void setup() {
  //size of screen... adjusted based on size of screen 
  //to be presented on
  size(1280,720);
  //movie file name
  mov = new Movie(this, sketchPath("pleasework.mov")); 
  mov.play();
  //starts at beginning of video
  mov.jump(0);
  //if i want my video to replay
  //mov.loop();
 
  
  //choose which gesture to be detected 
  gesture = new OneDollar(this);
  gesture.learn("circle", new int[] { 91,185,93,185,95,185,97,185,100,188,102,189,104,190,106,193,108,195,110,198,112,201,114,204,115,207,117,210,118,212,120,214,121,217,122,219,123,222,124,224,126,226,127,229,129,231,130,233,129,231,129,228,129,226,129,224,129,221,129,218,129,212,129,208,130,198,132,189,134,182,137,173,143,164,147,157,151,151,155,144,161,137,165,131,171,122,174,118,176,114,177,112,177,114,175,116,173,118 } );
  gesture.on("circle", "explode");
  
  
  //connects to explosion tab 
  explosions = new ArrayList<Explosion>();
}


void draw() {
  //searching for .mov file
  if (mov.available()) {
    mov.read();
    image(mov, 0,0);
   
    //shows where video will be displayed
    cv = new OpenCV(this, get(0,0,width,height));
    
   
    cv.threshold(150);
    cv.dilate();
    cv.erode();
    
    // get the blobs and get the largest one
    blobs = cv.findContours();
    float largestArea = 0;
    int largestIndex = 0;
    for (int i=0; i<blobs.size(); i++) {
      float area = blobs.get(i).area();
      if (area > largestArea) {
        largestArea = area;
        largestIndex = i;
      }
    }
    Contour largest = blobs.get(largestIndex);
    
    // calculate center of the largest blob
    float midofX = 0;
    float centerY = 0;
    ArrayList<PVector> pts = largest.getPolygonApproximation().getPoints();
    for (PVector pt : pts) {
      midofX += pt.x;
      centerY += pt.y;
    }
    midofX /= pts.size();
    centerY /= pts.size();
    
    //blob color
   // fill(0, 150, 255, 150);
   fill(random(200), random(200), random(200));
    noStroke();
    beginShape();
    //shape 
    for (PVector point : largest.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
      
    }
    endShape(CLOSE);
    
    // track the blob using the gesture library
    gesture.track(midofX, centerY);
    
    
    for (int i=explosions.size()-1; i>=0; i-=1) {
      Explosion e = explosions.get(i);
      e.update();
      e.display();
      
    //
      if (e.current >= e.begintoend) {
        explosions.remove(i);
      }
    }
  }
}
//done :)
