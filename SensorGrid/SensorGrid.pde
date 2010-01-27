/** 
*
*  Sensor array. Takes input from a 5x5 grid of pressure sensors, 
*  and outputs a 2D motion vector.
*
**/
import processing.net.*; 
import processing.serial.*;
import java.lang.NumberFormatException;

Client sensorPort;

int gridW = 5;
int gridH = 5;
int sensorCount = gridW * gridH;
Sensor [] sensors;
String [] inputValues;

int pressureLevels = 255;

boolean mouseInputMode = false;
String dataIn;
//parameters for simulated mouse input

int streamRadius = 50;//this is the radius of the circle around the mouse which influences the sensors

void setup(){
  //initialise the connection with the sensor array
  
  println(Serial.list());
  sensorPort = new Client(this,"127.0.0.1",1985);
  size(1024,768);
  sensors = new Sensor [sensorCount];
  int i = sensorCount;
  while (i > 0){
    i-=1;
    sensors[i] = new Sensor();
    sensors[i].xPos = i % gridH * (sensors[i].w + sensors[i].hPad);
    sensors[i].yPos = round(i / gridH) * (sensors[i].w  + sensors[i].vPad);
   }
}

void draw(){
  
  int i = sensorCount;
   
  if (mouseInputMode){
   //take input from mouse
   //get re
   while (i > 0){
     i-=1;
     sensors[i].updateMouse();
     sensors[i].update();
   }
   
  }else if (!mouseInputMode){
     //take data from sensor grid
     //TODO - connect with arduino board etc.
    
    if (sensorPort.available() > 0) { 
      dataIn = sensorPort.readString(); 
      println(dataIn);
      inputValues = dataIn.split(",");
      int j=sensors.length;
      
      println("inputValues.length="+inputValues.length+",sensors.length="+sensors.length);
      if (inputValues.length == sensors.length){
        if (inputValues.length > 0){
          while (j > 0){
           j-=1;
           println("sensor "+j+"="+inputValues.length);
           float sensorValue;
           try{
            sensorValue = Float.valueOf(inputValues[j]).floatValue();
           }catch(NumberFormatException e){
             sensorValue = 0; 
           }
           sensors[j].updateSensor(sensorValue);
           sensors[j].update();
          }
        }
      }
    } 
  }
}


