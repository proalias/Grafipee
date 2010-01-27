class Sensor {
  float xPos;
  float yPos;
  int w = 30;
  int h = 30;
  int vPad = 10;
  int hPad = 10;
  float value = 0;
  
  void updateSensor(float valueInput){
    if (valueInput == 0.0){
      value = (int)value * 0.99;//decay sensor
    }else{
      value = valueInput;
    }
  }
  
  void updateMouse(){
    float dx = dist (xPos, yPos, mouseX, mouseY);
    float dy = dist (xPos, yPos, mouseX, mouseY);
    value = (int) dx*2;
  }
  
  void update(){
    fill(value);
    stroke(255,0,0);
    
    rect(xPos,yPos,w,h);
  }
}
/**
*
*  Returns a value which has been normalised and had any hardware peculiarities
*  taken into account.
*  TODO - test with hardware rig
*
**/
float correctSensorInput(int sensorInput){
   return float(sensorInput) / pressureLevels;
}
