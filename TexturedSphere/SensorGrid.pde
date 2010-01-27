/** 
*
*  Sensor array. Takes input from a 5x5 grid of pressure sensors, 
*  and outputs a 2D motion vector.
*
**/
import processing.net.*; 
import processing.serial.*;
import java.lang.NumberFormatException;


class SensorGrid{
Client sensorPort;

int gridW = 5;
int gridH = 5;
int sensorCount = gridW * gridH;
Sensor [] sensors;
String [] inputValues;
Vec3 positionVect = new Vec3();
Vec3 sensorVect;
Vec3 newReading = new Vec3();
int pressureLevels = 255;

boolean mouseInputMode = false;
String dataIn;
//parameters for simulated mouse input

int streamRadius = 50;//this is the radius of the circle around the mouse which influences the sensors

void initSensorGrid(Client client){
  //initialise the connection with the sensor array
  
  println(Serial.list());
  sensorPort = client;
  sensors = new Sensor [sensorCount];
  int i = sensorCount;
  while (i > 0){
    i-=1;
    sensors[i] = new Sensor();
    sensors[i].yPos = i % gridH * (sensors[i].w + sensors[i].hPad);
    sensors[i].xPos = round(i / gridH) * (sensors[i].w  + sensors[i].vPad);
   }
   
   sensorVect = new Vec3(0,0,0);
   
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
    if (sensorPort.available() > 0) { 
      dataIn = sensorPort.readString(); 
      inputValues = remapInput(dataIn);
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
  
  newReading = getSensorVector();
}

Vec3 getCurrentVelocity(){
  newReading = getSensorVector();
  positionVect.x =newReading.x;
  positionVect.y =newReading.y;

  float drag = 1;
  
  positionVect.x *= drag;
  positionVect.y *= drag;
  
  
  
  return positionVect;
}

Vec3 getSensorVector(){
   float[] result;
   result = new float[2];
   
   Vec3 newVect = new Vec3();
   float[][] sensorWeighting = new float[][] {{-1,  -1}, {-0.5,  -1}, {0,   -1}, {0.5,  -1}, {1,  -1},
                                              {-1,-0.5}, {-0.5,-0.5}, {0, -0.5}, {0.5,-0.5}, {1,-0.5},
                                              {-1,   0}, {-0.5,   0}, {0,    0}, {0.5,   0}, {1,   0},
                                              {-1, 0.5}, {-0.5, 0.5}, {0,  0.5}, {0.5, 0.5}, {1, 0.5},
                                              {-1,   1}, {-0.5,   1}, {0,    1}, {0.5,   1}, {1,   1}};
   int i;
   for (i=0;i<sensorCount;i++){
       float valueX = sensors[i].value * sensorWeighting[i][1];
       float valueY = sensors[i].value * sensorWeighting[i][0]; 
       
       //offset the values against their positions
       
        
        //sensors[i].xPos = i % gridH * (sensors[i].w + sensors[i].hPad);
       // sensors[i].yPos = round(i / gridH) * (sensors[i].w  + sensors[i].vPad);

       
       newVect.x += valueX*10;
       newVect.y += valueY*10;
   }
   
   //test values
   
   println("vx:"+newVect.x+"vy:"+newVect.y);
   
   //newVect.normalize();
   line(0,0,newVect.x,newVect.y);
   ellipse(newVect.x,newVect.y,20,20);
   return newVect;
     
}

  String[] remapInput(String inputStr){
     println("in:"+inputStr);

     String[] input = inputStr.split(",");
     if (input.length == 25){
     String[] result = new String[25];
     result[ 0]= input[0];
     result[ 1]= input[5];
     result[ 2]= input[10];
     result[ 3]= input[15];
     result[ 4]= input[20];
     result[ 5]= input[1];
     result[ 6]= input[6];
     result[ 7]= input[11];
     result[ 8]= input[16];
     result[ 9]= input[21];
     result[10]= input[2];
     result[11]= input[7];
     result[12]= input[12];
     result[13]= input[17];
     result[14]= input[22];
     result[15]= input[3];
     result[16]= input[8];
     result[17]= input[13];
     result[18]= input[18];
     result[19]= input[23];
     result[20]= input[4];
     result[21]= input[9];
     result[22]= input[14];
     result[23]= input[19];
     result[24]= input[24]; 
   
     return result;  
     }
     return input; 
  }
}
