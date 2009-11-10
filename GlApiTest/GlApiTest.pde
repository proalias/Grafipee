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
  
 
  pushMatrix();
  translate(500, 500, 0);
 
  for (int i=0;i<points.size();i++){ 
    pushMatrix();
    rotateX(rotX);
    rotateY(rotY);
    //rotateZ(0.58);
  
    
    textureMode(NORMALIZED);
    pushMatrix();
    rotateX(-rotX);
    rotateY(-rotY);
    beginShape();
    texture(a);
    SurfacePoint testPoint = (SurfacePoint) points.get(i);
    vertex(testPoint.x-pointW, testPoint.y-pointH, testPoint.z,0,0);
    vertex(testPoint.x+pointW, testPoint.y-pointH, testPoint.z,1,0);
    vertex(testPoint.x+pointW, testPoint.y+pointH, testPoint.z,1,1);
    vertex(testPoint.x-pointW, testPoint.y+pointH, testPoint.z,0,1);
    popMatrix();
    endShape();
    popMatrix();
  }
  popMatrix();

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
