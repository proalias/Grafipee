/** 
*
*  Sensor array. Takes input from a 5x5 grid of pressure sensors, 
*  and outputs a 2D motion vector.
*
**/
import processing.net.*; 
import processing.serial.*;
import java.lang.NumberFormatException;

Serial sensorPort;

int gridW = 5;
int gridH = 5;
int sensorCount = gridW * gridH;
Sensor [] sensors;
String [] inputValues;
float sensorVectX;
float sensorVectY;

int pressureLevels = 255;

boolean mouseInputMode = false;
String serialData = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
//parameters for simulated mouse input

int streamRadius = 50;//this is the radius of the circle around the mouse which influences the sensors

void initSensorGrid(){
  //initialise the connection with the sensor array
  
  println(Serial.list());
  sensorPort = new Serial(this,"COM4",9600);
  sensorPort.bufferUntil('\n');
  sensors = new Sensor [sensorCount];
  int i = sensorCount;
  while (i > 0){
    i-=1;
    sensors[i] = new Sensor();
    sensors[i].yPos = i % gridH * (sensors[i].w + sensors[i].hPad);
    sensors[i].xPos = round(i / gridH) * (sensors[i].w  + sensors[i].vPad);
   }
}

void serialEvent(Serial sensorPort){
  String myString = sensorPort.readStringUntil('\n');
  myString = trim(myString);
  println(myString);
  serialData = myString;
}


void updateSensors(){  
  int i = sensorCount;
   
  if (mouseInputMode){
   //take input from mouse
   //get re
   while (i > 0){
     i-=1;
     sensors[i].updateMouse();
   }
   
  }else if (!mouseInputMode){
     //take data from sensor grid
     //TODO - connect with arduino board etc.
    
    if (sensorPort.available() > 0) { 
      //dataIn = serialData;//sensorPort.readString(); 
      inputValues = serialData.split(",");
      int j=sensors.length;
      
      //println("inputValues.length="+inputValues.length+",sensors.length="+sensors.length);
      if (inputValues.length == sensors.length){
        if (inputValues.length > 0){
          while (j > 0){
           j-=1;
           //println("sensor "+j+"="+inputValues.length);
           float sensorValue;
           try{
            sensorValue = Float.valueOf(inputValues[j]).floatValue();
           }catch(NumberFormatException e){
             sensorValue = 0; 
           }
           sensors[j].updateSensor(sensorValue);
           
          }
        }
      }
    } 
  }
  for (i=0;i<sensorCount;i++){
   sensors[i].update(); 
  }
  getSensorVector();
}


void getSensorVector(){
   float[] result;
   result = new float[2];
   
   sensorVectX = 0;
   sensorVectY = 0;
   
   float[][] sensorWeighting = new float[][] {{-1,  -1},{-0.5,  -1},{0,   -1},{0.5,  -1},{1,  -1},
                                             {-1,-0.5},{-0.5,-0.5},{0, -0.5},{0.5,-0.5},{1,-0.5},
                                             {-1,   0},{-0.5,   0},{0,    0},{0.5,   0},{1,   0},
                                             {-1, 0.5},{-0.5, 0.5},{0,  0.5},{0.5, 0.5},{1, 0.5},
                                             {-1,   1},{-0.5,   1},{0,    1},{0.5,   1},{1,   1}};
   int i;
   for (i=0;i<sensorCount;i++){
       float valueX = sensors[i].value * sensorWeighting[i][1] * 10 ;
       float valueY = sensors[i].value * sensorWeighting[i][0] * 10; 
       
       //offset the values against their positions
       
        
        //sensors[i].xPos = i % gridH * (sensors[i].w + sensors[i].hPad);
       // sensors[i].yPos = round(i / gridH) * (sensors[i].w  + sensors[i].vPad);

        
        
          sensorVectX += valueX;
          sensorVectY += valueY;
          
          float c = 1400;
          if (sensorVectX > c){
            sensorVectX = -c;
          }
          sensorVectX = sensorVectX % c;//(1450/2 * PI); 
          sensorVectY = sensorVectY % c;//(1450/2 * PI); 
          //println(sensorVectX+","+sensorVectY);
   }
   
   line(0,0,sensorVectX,sensorVectY);
   
}

