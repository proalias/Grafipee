/** 
*
*  Sensor array. Takes input from a 5x5 grid of pressure sensors, 
*  and outputs a 2D motion vector.
*
**/

int gridW = 5;
int gridH = 5;
int sensorCount = gridW * gridH;
Sensor [] sensors;

int pressureLevels = 1024;

boolean mouseInputMode = true;

//parameters for simulated mouse input

int streamRadius = 50;//this is the radius of the circle around the mouse which influences the sensors



void setup(){
  //TODO - initialise the connection with the sensor array
  size(1024,768);
  sensors = new Sensor [25];
  int i = sensorCount;
  while (i > 0){
    i-=1;
    sensors[i] = new Sensor();
    sensors[i].xPos = i % gridH * (sensors[i].w + sensors[i].hPad);
    sensors[i].yPos = round(i / gridH) * (sensors[i].w  + sensors[i].vPad);
   }
}

void draw(){
  if (mouseInputMode){
   //take input from mouse
   int i = sensorCount;
   //get re
   while (i > 0){
     i-=1;
     sensors[i].update();
   }
   
  }else if (!mouseInputMode){
   //take data from sensor grid
   //TODO - connect with arduino board etc.
  }

}

class Sensor {
  float xPos;
  float yPos;
  int w = 30;
  int h = 30;
  int vPad = 10;
  int hPad = 10;
  
  void update(){
    float dx = dist (xPos, yPos, mouseX, mouseY);
    float dy = dist (xPos, yPos, mouseX, mouseY);
    fill(dx*2);
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
