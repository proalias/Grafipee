import processing.opengl.*;

SurfacePoint testPoint;
PImage a;
float  rotX, rotY;
ArrayList points;

void setup(){
  size(1000,1000,OPENGL);
  a = loadImage("mapPoint.png");
  rotX = 0;
  rotY = 0;
  points = new ArrayList();
  points.add( new SurfacePoint(50,50,0, a));
}

void draw(){
  background(255);
  
  lights();
  
  int pointW = 12;
  int pointH = 18;
  
  rotX += random(0.02);
  rotY += random(0.02);  
  
 

  SurfacePoint newPoint = getCoordinateOfPointByAngle(300,rotX, rotY);
  points.add( newPoint); 
}


//convert spherical coordinates into cartesian coordinates
SurfacePoint getCoordinateOfPointByAngle(float radius, float inclination, float azimuth){
   float pX, pY, pZ;
   
   pX = radius * sin (azimuth) * cos (inclination);
   pY = radius * sin (azimuth) * sin (inclination);
   pZ = radius * cos (azimuth);
   
   return new SurfacePoint(pX,pY,pZ,a);
}
