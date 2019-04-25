/*
 File: BPMConnection.pde
 Version: 1.0
 Date: 23/03/2019
 Project: Systel BPM Lab Application Simple Connection
 Author: Daniel Valentin - dtvalentin@gmail.com
 */

import processing.serial.*;


public class BPMConnection {

  public static final String CMD_OPEN_FILESYSTEM = "SDCARDINFO";

  public static final String CMD_DISCONNECT = "DISCONNECT";

  public static final String CMD_LIST_FILES = "LISTFILES";

  public static final String CMD_DELETEFILE = "DELETEFILE";

  public static final String CMD_DOWNLOAD_FILE = "DOWNLOAD";

  public static final String  CMD_PROCESS_START = "PROCESSINIT";

  PApplet owner;
  Serial device;  // Create object from Serial class

  int bauds[] = {4800, 9600, 19200, 38400, 57600, 115200};

  boolean listen = false;
  boolean connected = false;
  boolean processStarted = false;
  boolean deviceIsOpen = false;
  String dataReaded = "";
  String command = "";
  String param = "";
  String error = "";

  public BPMConnection(PApplet parent) {
    super();
    owner = parent;
    connected = false;
    listen = false;
  }

  public int[] baudRates() {
    return bauds;
  }
  public String[] portList() {
    return Serial.list();
  }

  public void openDevice(String portName, int baunds) {
    try {
      error = "";
      connected = false;
      if (device != null) {
        device.clear();
        device.stop();
      }
      device = new Serial(owner, portName, baunds);
      device.clear();
      deviceIsOpen = device.active();
    } 
    catch(Exception e) {
      txaLog.appendText(e.getMessage());
      e.printStackTrace();
    }
  }

  public void  process(String buffer) {
    println(buffer);
    if (buffer.contains(" START") || buffer.contains(" END") || buffer.contains("Serial") || buffer.contains("BPM Lab")) {
      txaLog.appendText(buffer);
    }
    if (buffer.contains("ERROR Found Code")) {
      error = buffer;
      txaLog.appendText(error);
    }

    if (!isErrorFound()) {
      if (!isConnected()) {
        connect(buffer);
      } 
      if (isCommandSended()) {
        dataReaded += (buffer + "\n");
      } else {
        dataReaded = buffer;
      }
    }
  }

  public String getData() {
    return dataReaded;
  }

  public boolean isConnected() {
    return connected;
  }

  public boolean isCommandSended() {
    return (command != "");
  }

  public void closeConnection() {
    /*  if (device != null) {
     if (device.active()) {
     sendCommand(CMD_DISCONNECT);
     device.stop();
     device.clear();
     connected = false;
     }
     }*/
  }

  public void sendCommand(String command) {
    param = "";
    error = "";
    if (deviceIsOpen) {
      if (this.command == "") {
        dataReaded = "";
        device.write(command);
        this.command = command;
      }
    }
  }

  public boolean isErrorFound() {
    return !error.isEmpty();
  }

  public String errorFound() {
    return error;
  }

  public void sendCommand(String command, String param) {
    if (deviceIsOpen) {
      if (this.command == "") {
        dataReaded = "";
        error = "";
        device.write(command +";" + param);
        this.param = ";" + param;
        this.command = command;
      }
    }
  }

  public boolean isCommandDataFound(String command) {
    if (!dataReaded.isEmpty()) {
      if (dataReaded.contains(command + param + " START") && dataReaded.contains(command + param + " END")) {
        return true;
      }
    }
    return false;
  }

  public ArrayList<String> getDataList(String command) {
    ArrayList<String> list = new ArrayList<String>();
    if (isCommandDataFound(command)) {
      String[] tokens = dataReaded.split("\n");
      int i = 0;
      for (String data : tokens) {
        if (i > 1 && i < tokens.length -1) {
          list.add(data);
        }
        i++;
      }
    }
    this.command = "";
    dataReaded = "";
    txaLog.appendText("Processing::Data Received...");
    return list;
  }

  private boolean isBPMLabListen(String data) { 
    if (!listen) {
      if (data.contains("BPM Lab Waiting for Connections...")) {
        listen = true;
        txaLog.appendText("Processing::Send Connection Code...");
        device.write("BPMLabAdm");
      }
    }
    return listen;
  }

  private  boolean isConnect(String data) {
    if (!connected) {
      if (data.indexOf("BPM Connection Success. Wait for commands...") >= 0) {
        txaLog.appendText("Processing::Connected to BPM Lab");
        connected = true;
      }
    }
    return connected;
  }

  private void connect(String data) {
    if (isBPMLabListen(data)) {
      if (isConnect(data)) {
        txaLog.appendText("Processing::BPMLab Dashboard Connected");
      }
    }
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
}
