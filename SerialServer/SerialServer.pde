/*
  Serial Server
 language: processing

 This program makes a connection between a serial port
 and a network socket.

 created 26 Mar. 2007
 updated 26 Jun. 2007
 by Tom Igoe
 */

import processing.serial.*;
import processing.net.*;

int socketNumber = 9001; // the port the server listens on
Server myServer;          // the server
Client thisClient;        // the reference to the client that logs
char terminationString = ' '; // the string that the client sends
// to cause the server to disconnect
// into the server

Serial myPort;           // the serial port you're using
String portnum;          // name of the serial port
String outString = "";   // the string being sent out the serial port
String inString = "";    // the string coming in from the serial port
String socketString = "";  // string of bytes in from the socket
int receivedLines = 0;   // how many lines have been received in the serial port
int bufferedLines = 5;  // number of incoming lines to keep

void setup() {
  size(400, 300);        // window size

  // create a font with the second font available to the system:
  PFont myFont = createFont(PFont.list()[2], 14);
  textFont(myFont);

  // list all the serial ports:
  println(Serial.list());

  // based on the list of serial ports printed from the
  //previous command, change the 0 to your port's number:
  portnum = Serial.list()[0];
  // initialize the serial port:
  myPort = new Serial(this, portnum, 9600);
  // buffer until a newLine:
  myPort.bufferUntil('n');
  // start the server:
  myServer = new Server(this, socketNumber); // Starts a server

}

void draw() {
  // clear the screen:
  background(0);
  // print the name of the serial port:
  text("Serial port: " + portnum, 10, 20);
  // Print out what you get:
  text("From serial port:n" + inString, 10, 80);
  text("From socket:n" + socketString, 200, 80);

  // if the client is not null, and says something, display what it said:
  if (thisClient !=null) {
    // print out the current client:
    text("Active client: " + thisClient.ip(), 10,  60);
    // read what the client said:
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) {
        // save what it said to print to the screen:
      socketString = whatClientSaid;
      // send what it said out the serial port:
      myPort.write(socketString);
    }
  }
}

// this method runs when bytes show up in the serial port:
void serialEvent(Serial myPort) {
  // read the String from the serial port:
  String whatSerialSaid = myPort.readStringUntil('n');
  if (whatSerialSaid != null) {
    // save what it said to print to the screen:
    inString = whatSerialSaid;
    // if there is a netClient, send the serial stuff to them:
    if (thisClient != null) {
      // put a zero byte before and after everything you send to Flash:
      thisClient.write(terminationString);
      // send the actual text string:
      thisClient.write(inString);
      // add the end zero byte:
      thisClient.write(terminationString);
    }
  }
} 

void serverEvent(Server myServer, Client someClient) {
  if (thisClient == null) {
    // don't accept the client if we already have one:
    thisClient = someClient;
  }
}
