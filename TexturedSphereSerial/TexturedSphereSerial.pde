/**
 * Textured Sphere 
 * by Mike 'Flux' Chang (cleaned up by Aaron Koblin). 
 * Based on code by Toxi. 
 * 
 * A 3D textured sphere with simple rotation control.
 * Note: Controls will be inverted when sphere is upside down. 
 * Use an "arc ball" to deal with this appropriately.
 */ 

import javax.media.opengl.GL;
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
float globeRadius = 1450;
float pushBack = 0;

float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5;
int SINCOS_LENGTH = int(360.0 / SINCOS_PRECISION);

int pointW = 60;
int pointH = 90;
ArrayList points;
PFont font;
float cameraZ = 5000;

ArcBall arcBall;

void setup() {
  size(1024, 768, OPENGL);
  smooth();
  initSensorGrid();
  GL gl = ((PGraphicsOpenGL)g).gl; //reference to the JOGL renderer in case we need access to anything low level 
  texmap = loadImage("world32k.jpg");   
  texPoint = loadImage("mapPoint.png");
  points = new ArrayList();
  points.add( new Vec3D(50,50,0)); 
  initializeSphere(sDetail);
  font = loadFont("Verdana-48.vlw");
  textFont(font);
  arcBall = new ArcBall(width / 2.0f, height / 2.0f, globeRadius);

  camera(0.0, 0.0, cameraZ, 0.0, 0.0, 0.0, 
       0.0, 1.0, 0.0);

}


void draw() {
  background(0);

  lights();    
  //translate(00.0f, 500.0f, 0.0f);  // positioning...
  pushMatrix();
  
  arcBall.run();
  
  fill(200);
  noStroke();
  textureMode(IMAGE);  

  
  texturedSphere(globeRadius, texmap);
 
  
  PMatrix worldMatrix = getMatrix().get();
  popMatrix();
  Quat quat = arcBall.q_now;
  
  
 // PVector newPoint = new PVector(quat[1] * -250,quat[2] *-250,quat[3] *-250);


  Vec3D npVect = new Vec3D(0,0,globeRadius+100);
  
  Quaternion qRot = new Quaternion(quat.w,quat.x,quat.y,quat.z);
  Matrix4x4 pointRot = qRot.toMatrix4x4();
  Vec3D newRot = pointRot.applyTo(npVect);
  
  
  points.add( newRot); 
  
  drawPoints(pointRot,worldMatrix);


 pushMatrix();
  translate(0,0,4600);
  updateSensors();
  arcBall.sensorQ();
  popMatrix();
    
}


void mousePressed()
{
  arcBall.mousePressed();
}

void mouseDragged()
{
  arcBall.mouseDragged();
}


void drawPoints(Matrix4x4 rotMatrix, PMatrix worldMatrix){
  
  Vec3D p0,p1,p2,p3;
    
    /*
    //create the points that describe the corners of the billboard (same for each point)
    p0 = rotMatrix.applyTo(new Vec3D(-pointW, -pointH, 0));
    p1 = rotMatrix.applyTo(new Vec3D(+pointW, -pointH, 0));
    p2 = rotMatrix.applyTo(new Vec3D(+pointW, +pointH, 0));
    p3 = rotMatrix.applyTo(new Vec3D(-pointW, +pointH, 0));
    */
   //create the points that describe the corners of the billboard (same for each point)
    p0 = new Vec3D(-pointW, -pointH, 0);
    p1 = new Vec3D(+pointW, -pointH, 0);
    p2 = new Vec3D(+pointW, +pointH, 0);
    p3 = new Vec3D(-pointW, +pointH, 0);
    
   
   //remove duplicate points (this may not be necessary in future revisions)
 
  HashSet h = new HashSet(points);
  points.clear();
  points.addAll(h);

  ArrayList newPoints = new ArrayList();
  
  for (int i=0;i<points.size()-1;i++){
     PVector p = new PVector();
     Vec3D sourceA= (Vec3D) points.get(i);
     PVector sourceB = new PVector(sourceA.x,sourceA.y,sourceA.z);
  
     worldMatrix.mult( sourceB, p);
     p.z = p.z + cameraZ;//undo camera transform
     newPoints.add(p);
  }
  
  Collections.sort(newPoints, new ZSortComparator());
  
  for (int i=0; i<points.size()-1;i++){ 
    textureMode(NORMALIZED);

    beginShape();
    texture(texPoint);
    PVector testPoint = (PVector) newPoints.get(i);
    
    vertex(testPoint.x + p0.x,testPoint.y + p0.y,testPoint.z + p0.z,0,0);
    vertex(testPoint.x + p1.x,testPoint.y + p1.y,testPoint.z + p1.z,1,0);
    vertex(testPoint.x + p2.x,testPoint.y + p2.y,testPoint.z + p2.z,1,1);
    vertex(testPoint.x + p3.x,testPoint.y + p3.y,testPoint.z + p3.z,0,1);
    
    endShape();
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
  r = globeRadius;//(r + 240 ) * 0.33;
  beginShape(TRIANGLE_STRIP);
  texture(t);
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
     //vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1++]*r);
     // vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2++]*r);
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
