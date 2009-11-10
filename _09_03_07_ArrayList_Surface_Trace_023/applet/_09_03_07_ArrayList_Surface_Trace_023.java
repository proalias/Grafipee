import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class _09_03_07_ArrayList_Surface_Trace_023 extends PApplet {



ArrayList surfaceLines;

PVector centrePos; // centre of the sphere
  
PVector mousePos; //current 3D mouse position
PVector centreToMouse; //from the centre to the current mouse position

PVector pmousePos; // previous 3D mouse position
PVector pcentreToMouse; //from the centre to the previous mouse position

float rotationX = 0;
float rotationY = 0;
float velocityX = 0;
float velocityY = 0;
float globeRadius = 300;

int strokeWidth = 5;

float pcentreToMouse_z;
float centreToMouse_z;

public void setup() {
  size(800, 800, OPENGL);
  smooth();
  strokeWeight(strokeWidth);
  stroke(249,250,40);
  surfaceLines = new ArrayList(); // Create an empty ArrayList
}

public void draw() {
  background(100);
  
  centrePos = new PVector(width/2, height/2, 0); // calculate the centre of the sphere
  
  pmousePos = new PVector(pmouseX, pmouseY, (height/2.0f) / tan(PI*60.0f / 360.0f)); //calculate the previous mouse position
  pcentreToMouse = new PVector (pmousePos.x - centrePos.x, pmousePos.y - centrePos.y, pmousePos.z - centrePos.z); //calculate the vector from the centre to the previous mouse position
  
  mousePos = new PVector(mouseX, mouseY, (height/2.0f) / tan(PI*60.0f / 360.0f)); //calculate the current mouse position
  centreToMouse = new PVector(mousePos.x - centrePos.x, mousePos.y - centrePos.y, mousePos.z - centrePos.z); // calculate the vector from the centre to current mouse position
   
  /*UNROTATE X POINTS
  *  
  *  y' = y*cos q - z*sin q
  *  z' = y*sin q + z*cos q
  *  x' = x
  *
  */

  pcentreToMouse.y = pcentreToMouse.y*cos(radians(rotationX)) - pcentreToMouse.z*sin(radians(rotationX)) ;
  pcentreToMouse.z = pcentreToMouse.y*sin(radians(rotationX)) + pcentreToMouse.z*cos(radians(rotationX)) ;

  
  centreToMouse.y = centreToMouse.y*cos(radians(rotationX))- centreToMouse.z*sin(radians(rotationX)) ;
  centreToMouse.z = centreToMouse.y*sin(radians(rotationX))+ centreToMouse.z*cos(radians(rotationX));

  
   /*UNROTATE Y POINTS
  *  
  *  z' = z*cos q - x*sin q
  *  x' = z*sin q + x*cos q
  *  y' = y
  *
  */

  pcentreToMouse_z = pcentreToMouse.z;
  centreToMouse_z = centreToMouse.z;
  
  pcentreToMouse.z = pcentreToMouse_z*cos(radians(rotationY)) - pcentreToMouse.x*sin(radians(rotationY));
  pcentreToMouse.x = pcentreToMouse_z*sin(radians(rotationY)) + pcentreToMouse.x*cos(radians(rotationY));
  
  centreToMouse.z = centreToMouse_z*cos(radians(rotationY)) - centreToMouse.x*sin(radians(rotationY));
  centreToMouse.x = centreToMouse_z*sin(radians(rotationY)) + centreToMouse.x*cos(radians(rotationY));
 

  //Normalize these vectors to have a magnitude of 1
  centreToMouse.normalize();
  pcentreToMouse.normalize();
    
  //Now make them have them same magnitude as the radius of my invisible sphere  
  centreToMouse.mult(globeRadius);
  pcentreToMouse.mult(globeRadius);
 
  // With an array, we say surfaceLines.length, with an ArrayList, we say surfaceLines.size()
  // The length of an ArrayList is dynamic
  // Notice how we are looping through the ArrayList backwards
  // This is because we are deleting elements from the list  
  for (int i = surfaceLines.size()-1; i >= 0; i--) { 
    
    pushMatrix();
      translate(width/2.0f, height/2.0f, 0);
      rotateX( radians(-rotationX) );  
      rotateY( radians(-rotationY) );
      
      SurfaceLine surfaceLine = (SurfaceLine) surfaceLines.get(i);  // An ArrayList doesn't know what it is storing so we have to cast the object coming out
      surfaceLine.display();   
    popMatrix();
  } 
  
  //These operations make the rotation gradually slow down instead of abruptly
  rotationX += velocityX;
  rotationY += velocityY;
  velocityX *= 0.95f;
  velocityY *= 0.95f;
  velocityX += (pmouseY-mouseY) * 0.02f;
  velocityY += (pmouseX-mouseX) * 0.02f; 
  

}

//Only draw a new line (make a new object) when the mouse has moved
public void mouseMoved() {
  surfaceLines.add(new SurfaceLine(pcentreToMouse.x, pcentreToMouse.y, pcentreToMouse.z, centreToMouse.x, centreToMouse.y, centreToMouse.z)); // A new surfaceLine object is added to the ArrayList (by default to the end)
}

class SurfaceLine {
  
  float pX, pY, pZ, X, Y, Z;
  
  SurfaceLine(float initpX, float initpY, float initpZ, float initX, float initY, float initZ) { //this is the constructor

    pX = initpX;
    pY = initpY;
    pZ = initpZ;
    X  = initX;
    Y  = initY;
    Z  = initZ;
    
  }
 
  public void display() {
    line(pX, pY, pZ, X, Y, Z);
    //point(X,Y,Z);
  }

}  

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#f0f0f0", "_09_03_07_ArrayList_Surface_Trace_023" });
  }
}
