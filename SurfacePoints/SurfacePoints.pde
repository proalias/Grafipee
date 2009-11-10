/**
*    PointCloud
*
*   Create an array of billboard style particles to closely orbit a sphere
*
**/
import processing.opengl.*;

ArrayList surfacePointsModel;
ArrayList surfacePointsTransformed;

float globeRadius = 300;
float cullingDepth = globeRadius / 2;//the depth at which a point is completely obscured by the sphere.

float rotationX = 0.0;
float rotationY = 0.0;

void setup(){
  //surfacePointsModel contains an array of points which are relative to a globe which has NO transformations applied.
  //This is to prevent the data becoming slowly corrupted by rounding errors, and to allow a culling phase
  size(300,300,OPENGL);
  surfacePointsModel = new ArrayList();
  surfacePointsTransformed = new ArrayList();
}

void draw(){
  int i;
  
  for (i = surfacePointsModel.size(); i>=0; i--){
    //take the vertex from the original state and rotate it to the current position.
    
    //create a rotation matrix to transform the points from the original model to the current view
    
    
    point rotatedPoint;
    rotatedPoint = new point(surfacePoints[i].x, surfacePoints[i].y, surfacePoints[i].z);
    pushMatrix();
    rotateX( radians(globeRotX) );  
    rotateY( radians(globeRotY) );
    popMatrix();
    endShape();
    //If the point is behind the sphere, don't draw it.
    if (rotatedPoint.z > cullingDepth){
     continue;
    }
    
    drawSurfacePoint(rotatedVertex);

  }

}

/** 
*   Draw a 3d vertex as a 2d billboard
**/
void drawSurfacePoint(point v){
  //TODO - work out scaling based on z, if any.
}


/**
*  Add a point based on the current rotation of the sphere.
*
**/
void addSurfacePoint(float xRot,float yRot){
  float tX;
  float tY;
  float tZ;
  
  point
  
}
