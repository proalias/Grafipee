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
}

void draw() {
  background(0);
  renderGlobe();

  addPoint();
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
  text(rotationX,10,50);
  text(rotationY,10,100);
  PVector newPoint = new PVector(0,0,0);
  if (rotationY < 0 && rotationY > -180 || rotationY >180 && rotationY < 360){
    newPoint = getCoordinateOfPointByAngle(globeRadius/2 + 20,radians(rotationX),radians(rotationY));
  }else if ((rotationY > 0 && rotationY < 180) || (rotationY < -180 && rotationY > -360)){
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
  pushMatrix();
  translate(width/2.0, height/2.0, pushBack);
  pushMatrix();
  noFill();
  stroke(255,200);
  strokeWeight(2);
  smooth();
  popMatrix();
  lights();    
  pushMatrix();
  rotateX( radians(-rotationX) );  
  rotateY( radians(-rotationY) );
  fill(200);
  noStroke();
  textureMode(IMAGE);  
  texturedSphere(globeRadius, texmap);
  drawPoints();
  popMatrix();  
  popMatrix();
  rotationX += velocityX;
  rotationY += velocityY;
  
  rotationX = rotationX % 360;
  rotationY = rotationY % 360;
  
  velocityX *= 0.95;
  velocityY *= 0.95;
  
  // Implements mouse control (interaction will be inverse when sphere is  upside down)
  if(mousePressed){
    velocityX -= (mouseY-pmouseY) * 0.01;
    velocityY -= (mouseX-pmouseX) * 0.01;
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
  stroke(0);
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
