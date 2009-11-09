/**
*    PointCloud
*
*   Create an array of billboard style particles to closely orbit a sphere
*
**/
import processing.opengl.*;

ArrayList surfacePoints;
float cullingDepth;

void setup(){
  surfacePoints = new ArrayList();
}

void draw(){
  int i;
  for (i = surfacePoints.size(); i>=0; i--){
    //take the vertex from the original state and rotate it to the current position.
    point rotatedPoint = new point(surfacePoints[i].x, surfacePoints[i].y, surfacePoints[i].z);
    pushMatrix();
    rotateX( radians(globeRotX) );  
    rotateY( radians(globeRotY) );
    popMatrix();
    
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
  
}
