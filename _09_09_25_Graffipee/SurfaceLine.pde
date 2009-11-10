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
 
  void display() {
    pushMatrix();
      translate(X, Y, Z);

           noStroke();
           pushMatrix();
           rotateY(-PI);
           rotateX(-PI);
           //rotateX(radians(X));
       
           image(placemark, 0, 0, 10, 10);
           
      popMatrix();
    popMatrix();
    //point(X,Y,Z);
  }

}  
