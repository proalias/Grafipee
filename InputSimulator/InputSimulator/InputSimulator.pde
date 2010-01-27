import processing.serial.*;
import processing.net.*;

Server sensorServer;   

String[] lines;
int index = 0;
int lf = 10;

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);
  println(Serial.list());
  lines = loadStrings("data/input.txt");
  index = 0;
  sensorServer = new Server(this, 1985);
}
  
void draw() {
  int t=millis();
  int i=0;
  String[] pieces = split(lines[0], ' ');
 // print("pieces.length"+pieces.length);
  //for (i=0;i<pieces.length;i++){
    String [] dataSplit = pieces[index%(pieces.length-1)].split("----");
    String timeStamp = dataSplit[0];
    String sensorData = dataSplit[1];
    
    //println(">>"+sensorData+"<<"+index);
    sensorServer.write(sensorData);
  //}
 
  index += 1;
}

