/*
 File: BPMConnection.pde
 Version: 1.0
 Date: 23/03/2019
 Project: Systel BPM Lab Application Simple Connection
 Author: Daniel Valentin - dtvalentin@gmail.com
 */

import processing.serial.*;

public class BPMConnection {

  Serial device;  // Create object from Serial class

  boolean listen = false;
  boolean connected = false;

  public BPMConnection(PApplet parent) {
    super();

    connected = false;
    listen = false;
    String portName = Serial.list()[1];
    int baunds = 115200;
    device = new Serial(parent, portName, baunds);
  }

  void loop() {
  }

  void done() {
    if ( device.available() > 0) {  // If data is available,
      String data = device.readString();    
      print(data);
      if (isBPMLabListen(data)) {
        if (isConnect(data)) {
        }
      }
    }
  }

  boolean isBPMLabListen(String data) { 
    if (data.equals("BPM Lab Devices Started...\r\nBPM System Running...\r\n")) {
      listen = false;
    }

    if (!listen) {
      if (data.equals("\tBPM Lab Waiting for Connections...\r\n")) {
        listen = true;
        println("Processing::Send Connection Code...");
        device.write("BPMLabAdm");
      }
    }
    return listen;
  }

  boolean isConnect(String data) {
    if (!connected) {
      if (data.equals("\tBPM Lab Receive Connection Code :BPMLabAdm\r\n\tBPM Connection Success. Wait for commands...\r\n")) {
        println("Processing::Connected to BPM Lab");
        connected = true;
      }
    }
    return connected;
  }
}
