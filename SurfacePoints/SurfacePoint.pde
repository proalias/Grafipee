class SurfacePoint {
  
  float pX, pY, pZ, X, Y, Z;
  
  SurfacePoint(float initpX, float initpY, float initpZ, float initX, float initY, float initZ) { //this is the constructor

    pX = initpX;
    pY = initpY;
    pZ = initpZ;
    X  = initX;
    Y  = initY;
    Z  = initZ;
    
  }
 
  void display() {
    line(pX, pY, pZ, X, Y, Z);
    //point(X,Y,Z);
  }

}  
