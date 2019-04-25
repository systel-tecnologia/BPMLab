/*
 File: SimpleConnection.pde
 Version: 1.0
 Date: 23/03/2019
 Project: Systel BPM Lab Processing Application
 Author: Daniel Valentin - dtvalentin@gmail.com
 
 *** Note: This function requires that you have
 ControlP5 v. 2.2.5 installed and imported ! ***
 */

import java.util.*;
import java.awt.Rectangle;
import g4p_controls.*;
import controlP5.*;

// Static Definition
public static final int BPM_ALPHA = 30;
public static final int RTC_FORM_ERROR = 0;
public static final int SD_CARD_FORM_ERROR = 1;
public static final int MAIN_FORM = 2;
public static final int START_FORM = 3;
public static final int DONE_FORM = 4;
public static final int CANCEL_FORM = 5;



// Processors
private BPMConnection bpmConnection;
private BPMArena bpmArena;
private BPMDataFileReader bpmDataFileReader; 
private BPMFileSystem bpmFileSystem;

// Controls
PFont font;
GKnob kb;
ControlP5 cp5;
GGroup grpMain;
ListBox drpfiles;
GLabel lblFileName, lblFileDate, lblFileSize, lblClock;
GLabel lblLog, lblfs, lblBaud, lblCommBps, lblFile, lblttFileName, lblttFileDate, lblttFileSize; 
GLabel lblConsole, lblArenaControls, lblConnectionControls;
GLabel lblttDiskType, lblttDiskSys, lblttDiskSize, lblttDiskUse, lblttFiles, lblttbpmFiles;
;
GLabel lblDiskType, lblDiskSys, lblDiskSize, lblDiskUse, lblFiles, lblbpmFiles;
GButton btnCommPort, btnDownload, btnDelete; 
GDropList drpCommPort;  
GSlider sdrBps; 
GTextArea txaLog; 
PImage rtcError, sdCardError;
PImage mainForm, cancelForm, startForm, doneForm;
GButton btnStart, btnSetup, btnCancel, btnDone, btnConnect;

// Vars
int baud = 0;
String portName = "";
String buffer = "";
String log = " ";
int formIndex = 0;
PImage forms[] = {};

BPMFile selectedFile;

void setup() {
  size(1270, 720, JAVA2D);
  font = createFont("Arial", 6);

  // Processosrs
  bpmArena = new BPMArena(this);
  bpmConnection = new BPMConnection(this);
  bpmDataFileReader = new BPMDataFileReader(this);
  bpmFileSystem = new BPMFileSystem(this);

  // Controls
  ellipseMode(RADIUS);
  rectMode(CORNERS);
  //imageMode(CENTER);
  noStroke();
  G4P.messagesEnabled(false);
  G4P.setCursor(ARROW);
  surface.setTitle("BPMLab Dashboard");
  grpMain = new GGroup(this);  
  createControls();
  createGUI();
  viewConnection.setAlpha(BPM_ALPHA, true);
  viewArena.setAlpha(BPM_ALPHA, true);
  viewConsole.setAlpha(BPM_ALPHA, true);
  viewLog.setAlpha(BPM_ALPHA, true);
  viewFileSystem.setAlpha(BPM_ALPHA, true);

  // Images
  rtcError = loadImage("rtcerror.png");
  sdCardError = loadImage("sdcarderror.png");
  mainForm  = loadImage("mainmenu.png");
  cancelForm  = loadImage("prosscancel.png");
  startForm = loadImage("prossstart.png");
  doneForm  = loadImage("prossdone.png");
  forms = new PImage[]{rtcError, sdCardError, mainForm, startForm, doneForm, cancelForm};

  // Clear all data
  reset();
}

void reset() {

  // Vars
  baud = bpmConnection.baudRates()[5];  
  portName = drpCommPort.getSelectedText();
  selectedFile = null;
  formIndex = -1;

  // Controls
  txaLog.setText("");
  drpfiles.clear();
  btnCommPort.setEnabled(true);
  btnCommPort.setText("Connect");
  lblFileName.setText("");
  lblFileDate.setText("");
  lblFileSize.setText("");
  lblDiskType.setText("");
  lblDiskSys.setText(""); 
  lblDiskSize.setText("");
  lblDiskUse.setText("");
  lblFiles.setText("");
  lblbpmFiles.setText("");

  btnDelete.setEnabled(false);
  btnDownload.setEnabled(false);
  btnConnect.setEnabled(false);

  btnStart.setVisible(false);
  btnSetup.setVisible(false);
  btnConnect.setVisible(false);
  btnCancel.setVisible(false);
  btnDone.setVisible(false);
  lblClock.setVisible(false);

  // Processsors
  bpmArena.position(0, 0, 0, 0, 0, 0, 0);
  bpmConnection.closeConnection();

  draw();
}

void draw() {
  background(213, 245, 213);
  stroke(0);
  strokeWeight(2);
  fill(200, 210, 200);

  if (formIndex > -1) {
    image(forms[formIndex], 35, 180, 200, 290);
    btnStart.setVisible(formIndex == MAIN_FORM);
    btnSetup.setVisible(formIndex == MAIN_FORM);
    btnConnect.setVisible(formIndex == MAIN_FORM);
    lblClock.setVisible(formIndex == MAIN_FORM);
    btnCancel.setVisible(formIndex == START_FORM);
    btnDone.setVisible(formIndex == DONE_FORM || formIndex == CANCEL_FORM);
  }

  // Move Arena
  if (bpmConnection.isProcessStarted()) {
    DataLocation data = bpmDataFileReader.processData(bpmConnection.getData());
    bpmArena.setTitle(data.getFileName());
    if (data.x > 0 &&  data.y > 0) {
      bpmArena.holePoke(data.hp);
      bpmArena.position(data.x, data.y, data.z, data.w, data.h, data.l, data.hp);
    }
  }
  bpmArena.update();
}

void serialEvent(Serial device) {
  char b = device.readChar();
  if (b > 31 || b == '\t') {
    buffer += b;
  }  
  if (b == 13) {
    bpmConnection.process(buffer);
    buffer = "";
  }
}

public void loadAllInitialData() {
  openFileSystem();
  loadFileList();
}

public void openFileSystem() {
  bpmConnection.sendCommand(BPMConnection.CMD_OPEN_FILESYSTEM);
  while (!bpmFileSystem.isOpenned()) {
    while (!bpmConnection.isCommandDataFound(BPMConnection.CMD_OPEN_FILESYSTEM)) {
      delay(100);
    }
    ArrayList<String> list = bpmConnection.getDataList(BPMConnection.CMD_OPEN_FILESYSTEM);
    bpmFileSystem.openBPMFileSystem(list);
  }
}

public void loadFileList() {
  if (bpmFileSystem.isOpenned()) {
    bpmConnection.sendCommand(BPMConnection.CMD_LIST_FILES);
    while (!bpmConnection.isCommandDataFound(BPMConnection.CMD_LIST_FILES)) {
      delay(100);
    }
    ArrayList<String> list = bpmConnection.getDataList(BPMConnection.CMD_LIST_FILES);
    bpmFileSystem.loadFiles(list);
    updateFileListBox();
    formIndex = MAIN_FORM;
  }
}

public void updateFileListBox() {
  ArrayList<BPMFile> files = bpmFileSystem.getFileNames();
  drpfiles.clear();
  for (BPMFile file : files) {
    String name = file.name + "     " + file.date + "     " + file.size + " KB";
    drpfiles.addItem(name, file);
    drpfiles.getItem(name).put("color", new CColor().setForeground(0xffff8800));
  }
  kb.setValue((bpmFileSystem.fsUsed + 1) / bpmFileSystem.fsSize);
  lblFileName.setText("");
  lblFileDate.setText("");
  lblFileSize.setText("");

  lblDiskType.setText(bpmFileSystem.volType);
  lblDiskSys.setText(bpmFileSystem.fatType); 
  println();
  lblDiskSize.setText(bpmFileSystem.fsSize + "MB");
  Float f = (bpmFileSystem.fsUsed + 1);
  lblDiskUse.setText(f.intValue() + "MB");
  lblFiles.setText(bpmFileSystem.fsCountFiles + "");
  lblbpmFiles.setText(bpmFileSystem.fsBmpFiles +"");
}

public void btnCommPortClick(GButton source, GEvent event) {
  if (!bpmConnection.isConnected()) {
    int reply = G4P.selectOption(this, "Reset BPMLab and starts connection?", "Confirm", G4P.WARNING, G4P.YES_NO);
    if (reply == G4P.OK) {
      cursor(WAIT);
      reset();
      bpmConnection.openDevice(portName, baud);
      while (!bpmConnection.isConnected()) {
        if (bpmConnection.isErrorFound()) {
          String error = bpmConnection.errorFound();
          if (error.contains("SD Card")) {
            formIndex = SD_CARD_FORM_ERROR;
          }
          if (error.contains("Time Clock")) {
            formIndex = RTC_FORM_ERROR;
          }
          break;
        }
        delay(100);
      }
      if (!bpmConnection.isErrorFound()) {
        btnCommPort.setText("Disconnect");
        loadAllInitialData();
      }
      cursor(ARROW);
    }
  } else {
    int reply = G4P.selectOption(this, "Close connection and exit?", "Confirm", G4P.WARNING, G4P.YES_NO);
    if (reply == G4P.OK) {
      exit();
    }
  }
}

public void btnStartClick(GButton source, GEvent event) {
  if (bpmConnection.isConnected()) {
    int reply = G4P.selectOption(this, "Start Process?", "Confirm", G4P.WARNING, G4P.YES_NO);
    if (reply == G4P.OK) {
      cursor(WAIT);
      bpmConnection.sendCommand(BPMConnection.CMD_PROCESS_START);
      while (!bpmConnection.isCommandDataFound(BPMConnection.CMD_PROCESS_START)) {
        delay(100);
      }
      ArrayList<String> list = bpmConnection.getDataList(BPMConnection.CMD_PROCESS_START);
      startProcess(list);
      cursor(ARROW);
    }
  }
}

public void startProcess(ArrayList<String> list) {
  String data = list.get(0);
  String tokens[] = data.split(";");
  printArray(tokens);
  formIndex = START_FORM;
}

public void btnDeleteClick(GButton source, GEvent event) {
  if (selectedFile != null) {
    int reply = G4P.selectOption(this, "Delete file " + selectedFile.name + "?", "Confirm", G4P.WARNING, G4P.YES_NO);
    if (reply == G4P.OK) {
      cursor(WAIT);
      bpmConnection.sendCommand(BPMConnection.CMD_DELETEFILE, selectedFile.name);
      while (!bpmConnection.isCommandDataFound(BPMConnection.CMD_DELETEFILE)) {
        delay(100);
      }
      ArrayList<String> list = bpmConnection.getDataList(BPMConnection.CMD_DELETEFILE);
      if (bpmFileSystem.deleteFile(selectedFile, list)) {
        updateFileListBox();
        G4P.showMessage(this, "File delete success!", "Information", G4P.INFO);
      }
      cursor(ARROW);
    }
  } else {
    G4P.showMessage(this, "No selected file!", "Error", G4P.ERROR);
  }
}

public void btnDownloadClick(GButton source, GEvent event) {
  if (selectedFile != null) {
    String repo = G4P.selectFolder("Repository");
    if (repo != null) {
      File file = new File(repo, selectedFile.name);
      boolean doDownLoad = true;
      if (file.exists()) {
        int reply = G4P.selectOption(this, "Override BPMFile " + selectedFile.name + "?", "Confirmation", G4P.WARNING, G4P.YES_NO);
        if (reply == G4P.NO) {
          doDownLoad = false;
        }
      }
      if (doDownLoad) {
        cursor(WAIT);
        bpmConnection.sendCommand(BPMConnection.CMD_DOWNLOAD_FILE, selectedFile.name);
        while (!bpmConnection.isCommandDataFound(BPMConnection.CMD_DOWNLOAD_FILE)) {
          delay(100);
        }
        ArrayList<String> list = bpmConnection.getDataList(BPMConnection.CMD_DOWNLOAD_FILE);
        if (bpmFileSystem.saveBPMFile(list, file)) {
          G4P.showMessage(this, "File download complete!", "Information", G4P.INFO);
        }
        cursor(ARROW);
      }
    }
  } else {
    G4P.showMessage(this, "No selected file!", "Error", G4P.ERROR);
  }
}

// Update delay value
public void sdrBpsChange(GSlider source, GEvent event) {
  baud = bpmConnection.baudRates()[source.getValueI()];
  lblBaud.setText("" + baud);
}

// Pick one of the 8 predefined colour schemes
public void drpCommPortSelect(GDropList source, GEvent event) { 
  portName = source.getSelectedText();
}

public void createControls() {
  txaLog = new GTextArea(this, 20, 520, 930, 180, G4P.SCROLLBARS_VERTICAL_ONLY);
  txaLog.setText("");
  txaLog.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  txaLog.setOpaque(true);
  txaLog.setTextEditEnabled(false);

  //Console Group
  lblConsole = new GLabel(this, 20, 155, 190, 20);
  lblConsole.setText("Console");
  lblConsole.setTextBold();
  lblConsole.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  //Log Group
  lblLog = new GLabel(this, 20, 500, 190, 20);
  lblLog.setText("Log");
  lblLog.setTextBold();
  lblLog.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  //File System Group
  lblfs = new GLabel(this, 980, 15, 190, 20);
  lblfs.setText("Disk");
  lblfs.setTextBold();
  lblfs.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  //Arena Group
  lblArenaControls = new GLabel(this, 280, 15, 190, 20);
  lblArenaControls.setText("Arena");
  lblArenaControls.setTextBold();
  lblArenaControls.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  // Connection Group
  lblConnectionControls = new GLabel(this, 20, 15, 150, 20);
  lblConnectionControls.setTextAlign(GAlign.LEFT, GAlign.LEFT);
  lblConnectionControls.setText("Connection");
  lblConnectionControls.setTextBold();
  lblConnectionControls.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  lblCommBps = new GLabel(this, 20, 35, 180, 20);
  lblCommBps.setText("Connection Baud Rate (bps):");
  lblCommBps.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  lblBaud = new GLabel(this, 185, 35, 50, 20);
  baud = bpmConnection.baudRates()[5];
  lblBaud.setText("" + baud);
  lblBaud.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  sdrBps = new GSlider(this, 20, 60, 230, 25, 15.0);
  sdrBps.setLimits(5, 0, 5);
  sdrBps.setNbrTicks(6);
  sdrBps.setStickToTicks(true);
  sdrBps.setShowTicks(true);
  sdrBps.setEasing(1.0);
  sdrBps.setNumberFormat(G4P.INTEGER, 0);
  sdrBps.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  sdrBps.addEventHandler(this, "sdrBpsChange");

  drpCommPort = new GDropList(this, 20, 95, 100, 110, 0, 30);
  drpCommPort.setItems(bpmConnection.portList(), 0);
  drpCommPort.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  drpCommPort.addEventHandler(this, "drpCommPortSelect");

  btnCommPort = new GButton(this, 135, 95, 110, 30);
  btnCommPort.setText("Connect");
  btnCommPort.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnCommPort.addEventHandler(this, "btnCommPortClick");

  kb = new GKnob(this, 1075, 50, 175, 175, 0.6f);
  kb.setTurnRange(100, 100); 
  kb.setLocalColorScheme(5); 
  kb.setOpaque(false); 
  kb.setNbrTicks(10); 
  kb.setShowTicks(true); 
  kb.setShowTrack(true); 
  kb.setShowArcOnly(false); 
  kb.setShowValue(true);
  kb.setStickToTicks(true); 
  kb.setTurnMode(1283); 
  kb.setIncludeOverBezel(true); 
  kb.setOverArcOnly(true); 
  kb.setSensitivity(2.4250002); 
  kb.setEasing(21.390625); 
  kb.setEnabled(false);
  kb.setValue(0); 

  cp5 = new ControlP5(this);
  drpfiles = cp5.addListBox("myList")
    .setPosition(980, 250)
    .setSize(265, 300)
    .setItemHeight(30)
    .setBarHeight(30)
    .setColorBackground(color(255, 128))
    .setColorActive(color(0))
    .setColorForeground(color(255, 100, 0));
  drpfiles.getCaptionLabel().set("BPM Files");
  drpfiles.getCaptionLabel().setColor(0xffff0000);

  // Disk Group
  lblttDiskType = new GLabel(this, 985, 35, 190, 20);
  lblttDiskType.setText("Type:");
  lblttDiskType.setTextBold();
  lblttDiskType.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttDiskSys = new GLabel(this, 985, 55, 190, 20);
  lblttDiskSys.setText("System:");
  lblttDiskSys.setTextBold();
  lblttDiskSys.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttDiskSize = new GLabel(this, 985, 75, 190, 20);
  lblttDiskSize.setText("Size:");
  lblttDiskSize.setTextBold();
  lblttDiskSize.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttDiskUse = new GLabel(this, 985, 95, 190, 20);
  lblttDiskUse.setText("Used:");
  lblttDiskUse.setTextBold();
  lblttDiskUse.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblDiskType = new GLabel(this, 1022, 35, 190, 20);
  lblDiskType.setText("");
  lblDiskType.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblDiskSys = new GLabel(this, 1035, 55, 190, 20);
  lblDiskSys.setText("");
  lblDiskSys.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblDiskSize = new GLabel(this, 1020, 75, 190, 20);
  lblDiskSize.setText("");
  lblDiskSize.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblDiskUse = new GLabel(this, 1022, 95, 190, 20);
  lblDiskUse.setText("");
  lblDiskUse.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttFiles = new GLabel(this, 985, 200, 190, 20);
  lblttFiles.setText("Total Files:");
  lblttFiles.setTextBold();
  lblttFiles.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttbpmFiles = new GLabel(this, 985, 220, 190, 20);
  lblttbpmFiles.setText("BPM Files:");
  lblttbpmFiles.setTextBold();
  lblttbpmFiles.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblFiles = new GLabel(this, 1052, 200, 190, 20);
  lblFiles.setText("");
  lblFiles.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblbpmFiles = new GLabel(this, 1052, 220, 190, 20);
  lblbpmFiles.setText("");
  lblbpmFiles.setLocalColorScheme(GCScheme.BLUE_SCHEME);


  //File Group
  lblFile = new GLabel(this, 980, 560, 190, 20);
  lblFile.setText("Selected File");
  lblFile.setTextBold();
  lblFile.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  lblttFileName = new GLabel(this, 990, 580, 190, 20);
  lblttFileName.setText("File:");
  lblttFileName.setTextBold();
  lblttFileName.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttFileDate = new GLabel(this, 990, 600, 190, 20);
  lblttFileDate.setText("Date:");
  lblttFileDate.setTextBold();
  lblttFileDate.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttFileSize = new GLabel(this, 990, 620, 190, 20);
  lblttFileSize.setText("Size:");
  lblttFileSize.setTextBold();
  lblttFileSize.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblFileName = new GLabel(this, 1025, 580, 190, 20);
  lblFileName.setText("");
  lblFileName.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblFileDate = new GLabel(this, 1025, 600, 190, 20);
  lblFileDate.setText("");
  lblFileDate.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblFileSize = new GLabel(this, 1025, 620, 190, 20);
  lblFileSize.setText("");
  lblFileSize.setLocalColorScheme(GCScheme.BLUE_SCHEME);


  btnDownload = new GButton(this, 990, 650, 110, 30);
  btnDownload.setText("Download");
  btnDownload.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnDownload.addEventHandler(this, "btnDownloadClick");

  btnDelete = new GButton(this, 1120, 650, 110, 30);
  btnDelete.setText("Delete");
  btnDelete.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnDelete.addEventHandler(this, "btnDeleteClick");

  lblClock = new GLabel(this, 80, 265, 200, 30);
  lblClock.setText("");
  lblClock.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  btnStart = new GButton(this, 55, 300, 160, 40);
  btnStart.setText("Start");
  btnStart.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnStart.addEventHandler(this, "btnStartClick");

  btnSetup = new GButton(this, 55, 355, 160, 40);
  btnSetup.setText("Setup");
  btnSetup.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  btnSetup.addEventHandler(this, "btnSetupClick");

  btnConnect = new GButton(this, 55, 410, 160, 40);
  btnConnect.setText("Connect");
  btnConnect.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  btnConnect.addEventHandler(this, "btnConnectClick");

  btnCancel = new GButton(this, 55, 410, 160, 40);
  btnCancel.setText("Cancel");
  btnCancel.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnCancel.addEventHandler(this, "btnCancelClick");

  btnDone = new GButton(this, 55, 410, 160, 40);
  btnDone.setText("Done");
  btnDone.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnDone.addEventHandler(this, "btnDoneClick");
}


void controlEvent(ControlEvent event) {
  if (event.getName().equals("myList")) {
    Float index = event.getValue();
    Map m = drpfiles.getItem(index.intValue());
    BPMFile file = (BPMFile)m.get("value");
    lblFileName.setText(file.name);
    lblFileDate.setText(file.date);
    lblFileSize.setText(file.size + "Kb");
    btnDelete.setEnabled(true);
    btnDownload.setEnabled(true);
    selectedFile = file;
  }
}

/*  if (!bpmConnection.isConnected()) {
 bpmConnection.connect(data);
 }*/
/*  if (device != null) {
 if (!bpmConnection.isConnected()) {
 bpmConnection.connect(device.readString());
 }
 }*/
