import processing.opengl.*;
import processing.serial.*;

Serial myPort;
String buff = "";
int NEWLINE = 10;

int numPiezos = 25;
int[] boxShift = new int[numPiezos]; 

float colorMap;

PFont font1;

void setup()
{
  size(800, 800, OPENGL);
  font1 = loadFont("Verdana-48.vlw"); //load font
  // List all the available serial ports
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino module, so I open Serial.list()[0].
  // Change the 0 to the appropriate number of the serial port
  // that your microcontroller is attached to.
  myPort = new Serial(this, "COM3", 9600);

  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
}

void draw(){
  textFont(font1, 48);
  
  cameraNav();
  background(100);
  stroke(0);
  fill(255);

  int i = 0;
  for (int x =-200; x < width; x+= 200){
    for(int y =-200; y <height; y += 200){
     
    
    
    pushMatrix();
      translate(x+200, y+200, -200-boxShift[i]);
      colorMap = map(boxShift[i],0,1023,0,255);
      
      fill(colorMap,colorMap,colorMap);
      box(190,190, boxShift[i]);
      
      pushMatrix();
        translate(0,0,200);
        if(boxShift[i] >= 3){
          fill(255,0,0);
          //ellipse(0,0,80,80);
          text(boxShift[i],0,0);
        }
      popMatrix();
      
    popMatrix();
  
    i++;
    }
  }
    
  
}

void serialEvent(Serial myPort) { 
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  if (myString != null) {

    myString = trim(myString);

    // split the string at the commas
    // and convert the sections into integers:
    int sensors[] = int(split(myString, ','));
    // print out the values you got:
    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t"); 
    }
    // add a linefeed after all the sensor values are printed:
    println();
    for(int i = 0; i < numPiezos; i++){
      if (sensors.length > 1) {
        boxShift[i] = sensors[i]; //one boxShift for each sensor
      }
  }
}
}

void cameraNav(){
   beginCamera();
  
  //the keyboard controls forward and backward movement
  
  if(keyPressed){
    
    if(key =='w')
      translate(0,0,-3); //backward
    
    if(key =='s')
      translate(0,0,3); //forward
    
    if(key =='a')
      translate(-3,0,0); 
    if(key =='d')
      translate(3,0,0); 
      
    if(key =='d' && key == 'w')
      translate(3,0,-3);
      
    if(key =='d' && key == 's')
      translate(3,0,3);
      
    
    if(key =='a' && key == 'w')
      translate(-3,0,-3);
      
    if(key =='a' && key == 's')
      translate(-3,0,3);
  }
  
  //the mouse controls rotation
  if (mousePressed){
    //yaw
    rotateY(-(PI/16)*float(mouseX - pmouseX)/300);
    //pitch
    rotateX((PI/16)*float(mouseY - pmouseY)/300);
  }
  
  endCamera();

} //end of cameraNav

