/**
 * Textured Sphere 
 * by Mike 'Flux' Chang (cleaned up by Aaron Koblin). 
 * Based on code by Toxi. 
 * 
 * A 3D textured sphere with simple rotation control.
 * Note: Controls will be inverted when sphere is upside down. 
 * Use an "arc ball" to deal with this appropriately.
 */ 

import processing.opengl.*;
import toxi.geom.*;

PImage bg;
PImage texmap;
PImage texPoint;
int sDetail = 40;  // Sphere detail setting
float rotationX = 0;
float rotationY = 0;
float velocityX = 0;
float velocityY = 0;
float globeRadius = 450;
float pushBack = 0;

float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5;
int SINCOS_LENGTH = int(360.0 / SINCOS_PRECISION);

int pointW = 12;
int pointH = 18;
ArrayList points;
PFont font;

ArcBall arcBall;

void setup() {
  size(1024, 768, OPENGL);
  smooth();
  texmap = loadImage("world32k.jpg");   
  texPoint = loadImage("mapPoint.png");
  points = new ArrayList();
  points.add( new PVector(50,50,0)); 
  initializeSphere(sDetail);
  font = loadFont("Verdana-48.vlw");
  textFont(font);
  arcBall = new ArcBall(width / 2.0f, height / 2.0f, globeRadius);

 // camera(0.0, 0.0, 1120.0, 0.0, 0.0, 0.0, 
   //    0.0, 1.0, 0.0);

}

void draw() {
  background(0);
  
  translate(500.0f, 500.0f, 0.0f);  // positioning...
  arcBall.run();
  renderGlobe();
  //drawPoints();
  
  PMatrix p = new PMatrix3D();
  float[] a = arcBall.q_drag.getValue();
  

  text(a[0],-510,-450);
  text(a[1],-510,-400);
  text(a[2],-510,-350);
  text(a[3],-510,-300);
  
  rotate(-a[0],a[1],a[2],a[3]);
  p.invert();
  //p.translate(-500,-500,0);
  //PVector newPoint = new PVector(arcBall.v_drag.x * -250,arcBall.v_drag.y*-250,arcBall.v_drag.z*250);
  
  PVector newPoint = new PVector(arcBall.q_now.x * -550,arcBall.q_now.y*-550,arcBall.q_now.z*-550);


  //p.mult(newPoint,newPoint);
  
  points.add( newPoint); 
  
  
  //addPoint();
}

//draw a circle around each axis to determine whether the problem is related to
void drawGimbals(){
  
}
void mousePressed()
{
  arcBall.mousePressed();
}

void mouseDragged()
{
  arcBall.mouseDragged();
}


void drawPoints(){
  for (int i=points.size()-1;i>=0;i--){ 
    textureMode(NORMALIZED);

    beginShape();
    texture(texPoint);
    PVector testPoint = (PVector) points.get(i);
    //rotateX( radians(rotationX) );  
    //rotateY( radians(270 + rotationY) );
    vertex(testPoint.x-pointW, testPoint.y-pointH, testPoint.z,0,0);
    vertex(testPoint.x+pointW, testPoint.y-pointH, testPoint.z,1,0);
    vertex(testPoint.x+pointW, testPoint.y+pointH, testPoint.z,1,1);
    vertex(testPoint.x-pointW, testPoint.y+pointH, testPoint.z,0,1);
    endShape();
  }
}

void addPoint(){
  PVector newPoint = new PVector(0,0,0);
  if (rotationY < 0 && rotationY > -180 || rotationY >180 && rotationY < 360){
    newPoint = getCoordinateOfPointByAngle(globeRadius/2 + 20,radians(rotationX),radians(rotationY));
  }else if (rotationY > 0 && rotationY < 180 || rotationY < -180 && rotationY > -360){
    newPoint = getCoordinateOfPointByAngle(globeRadius/2 + 20,radians(-rotationX),radians(rotationY));
  }
  
  points.add( newPoint); 
}

//convert spherical coordinates into cartesian coordinates
PVector getCoordinateOfPointByAngle(float radius, float inclination, float azimuth){
   float pX, pY, pZ;
   
   pX = radius * sin (azimuth) * cos (inclination);
   pY = radius * sin (azimuth) * sin (inclination);
   pZ = radius * cos (azimuth);
   
   return new PVector(pX,pY,pZ);
}

void renderGlobe() {
  /*
  //PVector cameraPos = getCoordinateOfPointByAngle(1000,rotationX,rotationY);
  Vec3D rotVect = new Vec3D(rotationX,rotationY,0);

  Vec3D X_AXIS = new Vec3D(1,0,0);
  Vec3D Y_AXIS = new Vec3D(0,1,0);
  Vec3D Z_AXIS = new Vec3D(0,0,1);
  
  Vec3D xrot = Z_AXIS.copy();
  xrot.rotateX(rotationX);
  Vec3D yrot = X_AXIS.copy();
  yrot.rotateY(rotationY);
  
  print(yrot);
  
  Vec3D zrot = X_AXIS.copy();
  zrot.rotateZ(0);
  
  Quaternion xrotQuat = new Quaternion( 1,  0, 0, 0 );  
  xrotQuat.set( xrot.dot( Z_AXIS ), xrot.cross( Z_AXIS) );  
     
  Quaternion yrotQuat = new Quaternion( 1,  0, 0, 0  );  
  yrotQuat.set( yrot.dot( X_AXIS ), yrot.cross( X_AXIS ) );  
     
  Quaternion zrotQuat = new Quaternion( 1,  0, 0, 0  );  
  zrotQuat.set( zrot.dot( X_AXIS ), zrot.cross( X_AXIS) );  
  
  Quaternion rotQuat = xrotQuat.multiply( yrotQuat ).multiply( zrotQuat );  
  //m       = rotQuat.getMatrix();  

  
  //Quaternion camQuaternion = Quaternion.createFromEuler(0,rotationX,rotationY);
  //camQuaternion.scale(10000);

  Matrix4x4 rotMatrix = rotQuat.toMatrix4x4();
  
  Vec3D newCamPos = new Vec3D(0,0,1000);
  
  rotMatrix.applyTo(newCamPos);
  */
  //print("X:"+rotQuat.x+",Y:"+rotQuat.y+",Z:"+rotQuat.z+"\r\f");
  //camera(newCamPos.x,newCamPos.y,newCamPos.z,0,0,0,0,1,0);

  pushMatrix();
  //translate(width/2.0, height/2.0, pushBack);
  pushMatrix();
  noFill();
  stroke(255,200);
  strokeWeight(2);
  smooth();
  popMatrix();
  lights();    
  pushMatrix();
  //rotateX( radians(-rotationX) );  
  //rotateY( radians(-rotationY) );
  fill(200);
  noStroke();
  textureMode(IMAGE);  

  
  texturedSphere(globeRadius, texmap);
  drawPoints();
  popMatrix();  
  popMatrix();
  rotationX += velocityX;
  rotationY += velocityY;
  
  print("rotationX="+rotationX);
  print("rotationY="+rotationY);  
  velocityX *= 0.95;
  velocityY *= 0.95;
  
  // Implements mouse control (interaction will be inverse when sphere is  upside down)
  if(mousePressed){

   // velocityX -= (mouseY-pmouseY) * 0.01;
   // velocityY -= (mouseX-pmouseX) * 0.01;
  }
}

void initializeSphere(int res)
{
  sinLUT = new float[SINCOS_LENGTH];
  cosLUT = new float[SINCOS_LENGTH];

  for (int i = 0; i < SINCOS_LENGTH; i++) {
    sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * SINCOS_PRECISION);
    cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * SINCOS_PRECISION);
  }

  float delta = (float)SINCOS_LENGTH/res;
  float[] cx = new float[res];
  float[] cz = new float[res];
  
  // Calc unit circle in XZ plane
  for (int i = 0; i < res; i++) {
    cx[i] = -cosLUT[(int) (i*delta) % SINCOS_LENGTH];
    cz[i] = sinLUT[(int) (i*delta) % SINCOS_LENGTH];
  }
  
  // Computing vertexlist vertexlist starts at south pole
  int vertCount = res * (res-1) + 2;
  int currVert = 0;
  
  // Re-init arrays to store vertices
  sphereX = new float[vertCount];
  sphereY = new float[vertCount];
  sphereZ = new float[vertCount];
  float angle_step = (SINCOS_LENGTH*0.5f)/res;
  float angle = angle_step;
  
  // Step along Y axis
  for (int i = 1; i < res; i++) {
    float curradius = sinLUT[(int) angle % SINCOS_LENGTH];
    float currY = -cosLUT[(int) angle % SINCOS_LENGTH];
    for (int j = 0; j < res; j++) {
      sphereX[currVert] = cx[j] * curradius;
      sphereY[currVert] = currY;
      sphereZ[currVert++] = cz[j] * curradius;
    }
    angle += angle_step;
  }
  sDetail = res;
}

// Generic routine to draw textured sphere
void texturedSphere(float r, PImage t) 
{
  int v1,v11,v2;
  r = (r + 240 ) * 0.33;
  beginShape(TRIANGLE_STRIP);
  texture(t);
  //stroke(0);
  float iu=(float)(t.width-1)/(sDetail);
  float iv=(float)(t.height-1)/(sDetail);
  float u=0,v=iv;
  for (int i = 0; i < sDetail; i++) {
    vertex(0, -r, 0,u,0);
    vertex(sphereX[i]*r, sphereY[i]*r, sphereZ[i]*r, u, v);
    u+=iu;
  }
  vertex(0, -r, 0,u,0);
  vertex(sphereX[0]*r, sphereY[0]*r, sphereZ[0]*r, u, v);
  endShape();   
  
  // Middle rings
  int voff = 0;
  for(int i = 2; i < sDetail; i++) {
    v1=v11=voff;
    voff += sDetail;
    v2=voff;
    u=0;
    beginShape(TRIANGLE_STRIP);
    texture(t);
    for (int j = 0; j < sDetail; j++) {
      vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1++]*r, u, v);
      vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2++]*r, u, v+iv);
      u+=iu;
    }
  
    // Close each ring
    v1=v11;
    v2=voff;
    vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1]*r, u, v);
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v+iv);
    endShape();
    v+=iv;
  }
  u=0;
  
  // Add the northern cap
  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i = 0; i < sDetail; i++) {
    v2 = voff + i;
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v);
    vertex(0, r, 0,u,v+iv);    
    u+=iu;
  }
  vertex(sphereX[voff]*r, sphereY[voff]*r, sphereZ[voff]*r, u, v);
  endShape();
  
}
