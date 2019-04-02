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
  boolean processStarted = false;
  String dataReaded = "";

  public BPMConnection(PApplet parent) {
    super();

    connected = false;
    listen = false;
    String portName = "COM1"; //Serial.list()[1];
    int baunds = 115200;
    device = new Serial(parent, portName, baunds);
  }


  public void done() {
    if ( device.available() > 0) {  // If data is available,
      String data = device.readString();    
      print(data);
      if (isBPMLabListen(data)) {
        if (isConnect(data)) {
          dataReaded = data;
        }
      } else if (isStartedProcess(data)) {
        dataReaded = data;
      }
    }
  }

  public String getData() {
    return dataReaded;
  }

  public boolean isProcessStarted() {
    return processStarted;
  }

  private boolean isStartedProcess(String data) {
    if (data.indexOf("Open File") >= 0) {
      processStarted = true;
    } else if (data.indexOf("Close File") >= 0) {
      processStarted = false;
    }
    return processStarted;
  }

  private boolean isBPMLabListen(String data) { 
    if (data.indexOf("BPM System Running...") >= 0) {
      listen = false;
    }

    if (!listen) {
      if (data.indexOf("BPM Lab Waiting for Connections...") >= 0) {
        listen = true;
        println("Processing::Send Connection Code...");
        device.write("BPMLabAdm");
      }
    }
    return listen;
  }

  private  boolean isConnect(String data) {
    if (!connected) {
      if (data.indexOf("BPM Connection Success. Wait for commands...") >= 0) {
        println("Processing::Connected to BPM Lab");
        connected = true;
      }
    }
    return connected;
  }
  
  public void sendComamnd(String command){
     device.write(command);   
  }
}
