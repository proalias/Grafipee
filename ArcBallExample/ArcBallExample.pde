/**
arcball taken from http://processinghacks.com/hacks:arcball
@author Tom Carden
*/
 
import com.processinghacks.arcball.*;
 
void setup() {
  size(600,400,P3D);
  ArcBall arcball = new ArcBall(this);
}
 
void draw() {
 
  background(255);
 
  translate(width/2,height/2,-height/2);
  fill(255,0,0,40);
  noStroke();
  for (int i = 1; i <= 5; i++) {
    box(60*i);
  }
  stroke(100,0,0);
  noFill();
  box(300);
 
}
