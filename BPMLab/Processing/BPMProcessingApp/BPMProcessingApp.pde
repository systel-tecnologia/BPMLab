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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.time.*;
import java.time.temporal.*;
import grafica.*;

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

// Controls Main
PFont font0, font1, font2, font3;
GKnob kb;
ControlP5 cp5;
GGroup grpMain;
ListBox drpfiles;
GLabel lblFileName, lblFileDate, lblFileSize, lblClock;
GLabel lblLog, lblfs, lblBaud, lblCommBps, lblFile, lblttFileName, lblttFileDate, lblttFileSize; 
GLabel lblConsole, lblArenaControls, lblConnectionControls;
GLabel lblttDiskType, lblttDiskSys, lblttDiskSize, lblttDiskUse, lblttFiles, lblttbpmFiles;
GLabel lblTimer, lblPecentual, lblState, lblFilesAnalyze;
GLabel lblDiskType, lblDiskSys, lblDiskSize, lblDiskUse, lblFiles, lblbpmFiles;
GButton btnCommPort, btnDownload, btnDelete, btnAnalyze1; 
GDropList drpCommPort;  
GSlider sdrBps; 
GTextArea txaBPMLog; 
PImage rtcError, sdCardError;
PImage mainForm, cancelForm, startForm, doneForm;
GButton btnStart, btnSetup, btnCancel, btnDone, btnConnect, btnAnalyze2;

// Controls Analyzes
GLabel lblFile2, lblStat;
GLabel lblttFileName2, lblttFileRepo, lblttFileDate2, lblttFileSize2;
GLabel lblFileRepo, lblFileDate2, lblFileSize2;
GLabel lblttMoviments, lblttHolePokes, lblttRearings;
GLabel lblMoviments, lblHolePokes, lblRearings;
GLabel lblttRecords, lblttTmCount, lblRecords, lblTmCount;
GPlot plotBars, plotQuads, plotRoutes, plotRearing, plotHp;


// Vars
int baud = 0;
String portName = "";
String buffer = "";
String log = " ";
int formIndex = -1;
PImage forms[] = {};
String params[];
String[] portList;
LocalDateTime startTime;
BPMConfig config;
BPMAnalysis analysis;
BPMFile selectedFile;
SimpleDateFormat fmdt = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"); 
SimpleDateFormat fmtm = new SimpleDateFormat("00:mm:ss");
SimpleDateFormat fmdtf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
List<BPMFile> localFiles = new ArrayList<BPMFile>();
GPointsArray points1, points2, points3, points4, points5;

class BPMConfig {

  long baudrate;
  int fileIndex;
  int cronMode;
  long secs;
  int modify;

  BPMConfig() {
  }

  BPMConfig(String data) {
    String tokens[] = data.split(";");
    baudrate = Long.parseLong(tokens[0]);
    fileIndex = Integer.parseInt(tokens[1]);
    cronMode = Integer.parseInt(tokens[2]);
    secs = Long.parseLong(tokens[3]);
    modify = Integer.parseInt(tokens[4]);
  }
}

void setup() {
  size(1270, 720, JAVA2D);
  font0 = createFont("Arial", 16);
  font1 = createFont("Arial", 18);
  font2 = createFont("Arial", 25);
  font3 = createFont("Arial", 35);

  params = loadStrings("params.txt");

  // Processosrs
  bpmArena = new BPMArena();
  bpmConnection = new BPMConnection();
  bpmDataFileReader = new BPMDataFileReader();
  bpmFileSystem = new BPMFileSystem();

  // Controls
  ellipseMode(RADIUS);
  rectMode(CORNERS);
  noStroke();
  G4P.messagesEnabled(false);
  G4P.setCursor(ARROW);
  surface.setTitle("BPMLab Dashboard");
  grpMain = new GGroup(this);  
  createControls();
  createGUI();
  createControlsAnalysis();
  createGraphicsAnalysis();

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

  // Analyze Window
  viewFileAnalyze.setAlpha(BPM_ALPHA, true);
  viewFileEstat.setAlpha(BPM_ALPHA, true);
  viewQuadant.setAlpha(BPM_ALPHA, true);
  viewPath.setAlpha(BPM_ALPHA, true);
  viewHP.setAlpha(BPM_ALPHA, true);
  viewRg.setAlpha(BPM_ALPHA, true);

  // Clear all data
  reset();
}

void reset() {

  // Vars
  baud = bpmConnection.baudRates()[5];  
  portName = drpCommPort.getSelectedText();
  selectedFile = null;
  formIndex = -1;
  startTime = LocalDateTime.now();
  config = new BPMConfig();

  // Controls
  txaBPMLog.setText("");
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
  lblState.setText("");
  lblTimer.setText("00:00:00");
  lblPecentual.setText("0%");

  btnDelete.setEnabled(false);
  btnAnalyze1.setEnabled(true);
  btnAnalyze2.setEnabled(true);
  btnDownload.setEnabled(false);
  btnConnect.setEnabled(false);

  btnStart.setVisible(false);
  btnSetup.setVisible(false);
  btnConnect.setVisible(false);
  btnCancel.setVisible(false);
  btnDone.setVisible(false);
  lblClock.setVisible(false);
  lblTimer.setVisible(false);
  lblPecentual.setVisible(false);
  lblState.setVisible(false);

  // Processsors
  bpmArena.reset();
  bpmConnection.closeConnection();

  // Analyze Window
  resetAnalyzeWindow();
}

void draw() {
  background(235);
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
    lblTimer.setVisible(formIndex == START_FORM || formIndex == DONE_FORM || formIndex == CANCEL_FORM);
    lblPecentual.setVisible(formIndex == START_FORM || formIndex == DONE_FORM || formIndex == CANCEL_FORM);
    lblState.setVisible(formIndex == START_FORM || formIndex == DONE_FORM || formIndex == CANCEL_FORM);
    if (formIndex == START_FORM) {
      lblTimer.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
      lblPecentual.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
      lblState.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
      lblState.setText("Started");
    }
    if (formIndex == DONE_FORM) {
      lblTimer.setLocalColorScheme(GCScheme.GREEN_SCHEME);
      lblPecentual.setLocalColorScheme(GCScheme.GREEN_SCHEME);
      lblState.setLocalColorScheme(GCScheme.GREEN_SCHEME);
      lblState.setText("Done");
    }
    if (formIndex == CANCEL_FORM) {
      lblTimer.setLocalColorScheme(GCScheme.RED_SCHEME);
      lblPecentual.setLocalColorScheme(GCScheme.RED_SCHEME);
      lblState.setLocalColorScheme(GCScheme.RED_SCHEME);
      lblState.setText("Canceled");
    }
  }

  // Move Arena
  if (bpmConnection.isProcessStarted()) {
    BPMRegister  data = bpmDataFileReader.processData(bpmConnection.getData());
    bpmArena.setPosition(data);
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

public void logger(String log) {
  //txaBPMLog.appendText(log);
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
    bpmFileSystem.loadRemoteFiles(list);
    updateFileListBox();
    formIndex = MAIN_FORM;
  }
}

public void updateFileListBox() {
  drpfiles.clear();
  ArrayList<BPMFile> files = bpmFileSystem.getRemoteFiles();
  for (BPMFile file : files) {
    String name = file.name + "     " + file.date + "     " + file.size + " KB";
    drpfiles.addItem(name, file);
    drpfiles.getItem(name).put("color", new CColor().setForeground(0xffff8800));
  }
  kb.setValue((bpmFileSystem.fsUsed + 1) / bpmFileSystem.fsSize);
  lblFileName.setText("");
  lblFileDate.setText("");
  lblFileSize.setText("");

  resetAnalyzeWindow();

  lblDiskType.setText(bpmFileSystem.volType);
  lblDiskSys.setText(bpmFileSystem.fatType); 
  lblDiskSize.setText(bpmFileSystem.fsSize + "MB");
  Float f = (bpmFileSystem.fsUsed + 1);
  lblDiskUse.setText(f.intValue() + "MB");
  lblFiles.setText(bpmFileSystem.fsCountFiles + "");
  lblbpmFiles.setText(bpmFileSystem.fsBmpFiles +"");
}

public void btnCommPortClick(GButton source, GEvent event) {
  printArray(portList);
  if (portList == null || portList.length == 0 || portList[0].equals("Not Found")) {
    G4P.showMessage(this, "Connection Port is not present!", "Information", G4P.INFO);
  } else { 
    if (!bpmConnection.isConnected()) {
      int reply = G4P.selectOption(this, "Reset BPMLab and starts Remote Connection?", "Confirm", G4P.WARNING, G4P.YES_NO);
      if (reply == G4P.OK) {
        cursor(WAIT);
        reset();
        bpmConnection.openDevice(this, portName, baud);
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
  btnDelete.setEnabled(false);
  btnAnalyze1.setEnabled(false);
  btnAnalyze2.setEnabled(false);
  btnDownload.setEnabled(false);
  String data = list.get(0);
  config = new BPMConfig(data);
  startTime = LocalDateTime.now();
  formIndex = START_FORM;
  logger("Processing::BPMLab process started...");
}

public void btnCancelClick(GButton button, GEvent event) {
  if (bpmConnection.isConnected()) {
    int reply = G4P.selectOption(this, "Cancel Process?", "Confirm", G4P.WARNING, G4P.YES_NO);
    if (reply == G4P.OK) {
      cursor(WAIT);
      bpmConnection.sendCommand(BPMConnection.CMD_PROCESS_CANCEL);
      while (!bpmConnection.isCommandDataFound(BPMConnection.CMD_PROCESS_CANCEL)) {
        delay(100);
      }
      ArrayList<String> list = bpmConnection.getDataList(BPMConnection.CMD_PROCESS_CANCEL);
      cancelProcess(list);
      cursor(ARROW);
    }
  }
}

public void btnDoneClick(GButton button, GEvent event) {
  loadFileList();
  btnDelete.setEnabled(true);
  btnAnalyze1.setEnabled(true);
  btnAnalyze2.setEnabled(true);
  btnDownload.setEnabled(true);
  bpmArena.reset();
  formIndex = MAIN_FORM;
}

public void cancelProcess(ArrayList<String> data) {
  String value = "";
  for (String l : data) {
    value += l;
  }
  if (value.contains("OK")) {
    formIndex = 5;
  }
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

    String repo = getParamValue("REPO");
    if (repo.isEmpty()) {
      repo = G4P.selectFolder("Repository");
      saveParams();
    }

    if (repo != null && !repo.isEmpty()) {
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

public void btnAnalyze1Click(GButton button, GEvent event) { 
  if (selectedFile != null) {
    String repo = getParamValue("REPO");
    if (repo.isEmpty()) {
      repo = G4P.selectFolder("Repository");
      saveParams();
    }
    if (repo != null && !repo.isEmpty()) {
      File file = new File(repo, selectedFile.name);
      if (file.exists()) {
        executeAnalysis(file);
      } else {
        G4P.showMessage(this, "Local File " + selectedFile.name + " not found. Try download before.", "Error", G4P.ERROR);
      }
    }
  } else {
    if (!analyzeWindow.isVisible()) {
      analyzeWindow.setVisible(true);
    }
  }
}

public void handleButtonEvents(GButton button, GEvent event) { /* code */
}


public void btnAnalyze2Click(GButton button, GEvent event) {
  String fname = G4P.selectInput("Open BPM File", "*", "BPM Files");
  if (!fname.isEmpty()) {
    File file = new File(fname);
    if (file.exists()) {
      executeAnalysis(file);
    } else {
      G4P.showMessage(this, "Not file found!", "Error", G4P.ERROR);
    }
  }
}

public void btnSetupClick(GButton button, GEvent event) { /* code */
}

public void executeAnalysis(File file) {
  cursor(WAIT);
  if (selectedFile == null) {
    bpmFileSystem.loadLocalFiles();
    ArrayList<BPMFile> files = bpmFileSystem.getLocalFiles();
    for (BPMFile bf : files) {
      if (bf.name.equals(file.getName())) {
        selectedFile = bf;
        break;
      }
    }
  }
  analysis = bpmDataFileReader.analyzeBPMFile(file);
  updateAnalysys(analysis);
  if (selectedFile != null) {
    lblFilesAnalyze.setText(selectedFile.name);
    lblFileDate2.setText(selectedFile.date);
    lblFileSize2.setText(selectedFile.size + "KB");
  }
  cursor(ARROW);
  if (!analyzeWindow.isVisible()) {
    analyzeWindow.setVisible(true);
  }
  selectedFile = null;
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

void controlEvent(ControlEvent event) {
  if (event.getName().equals("myList")) {
    Float index = event.getValue();
    Map m = drpfiles.getItem(index.intValue());
    BPMFile file = (BPMFile)m.get("value");
    lblFileName.setText(file.name);
    lblFileDate.setText(file.date);
    lblFileSize.setText(file.size + "KB");
    btnDelete.setEnabled(true);
    btnAnalyze1.setEnabled(true);
    btnAnalyze2.setEnabled(true);
    btnDownload.setEnabled(true);
    selectedFile = file;
  }
}

public void updateTimes() {
  Date dt = new Date(System.currentTimeMillis());
  lblClock.setText(fmdt.format(dt));
  if (startTime != null && formIndex == START_FORM) {
    Duration duration = Duration.between(LocalDateTime.now(), startTime);
    Long period = Math.abs(duration.toMillis()); 
    Long seconds =  (Long.divideUnsigned(period, new Long(1000)));
    if (config.secs > 0) {
      Float a = new Float(seconds);
      Float b = new Float(config.secs);
      Float c =  (a / b);
      Float d = (c * 100);
      lblPecentual.setText(d.intValue() + "%");
      if (d.intValue() == 100) {
        formIndex = DONE_FORM;
      }
    }
    lblTimer.setText(fmtm.format(period));
  }
}


public String getParamValue(String name) {
  for (String param : params) {
    String tokens[] = param.split("=");
    for (String value : tokens) {
      if (value.equals(name)) {
        if (tokens.length == 1 || tokens[1] == null) {
          return "";
        } else {
          return tokens[1];
        }
      }
    }
  }
  return "";
}

public void saveParams() {
}


public void createControls() {
  txaBPMLog = new GTextArea(this, 20, 520, 930, 180, G4P.SCROLLBARS_VERTICAL_ONLY);
  txaBPMLog.setText("");
  txaBPMLog.setLocalColor(70, 60);
  txaBPMLog.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  txaBPMLog.setOpaque(true);
  txaBPMLog.setTextEditEnabled(false);

  //Console Group
  lblConsole = new GLabel(this, 20, 155, 190, 20);
  lblConsole.setText("Remote Console");
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
  portList = bpmConnection.portList();
  drpCommPort.setItems(portList, 0);
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

  btnDownload = new GButton(this, 990, 650, 85, 30);
  btnDownload.setText("Download");
  btnDownload.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnDownload.addEventHandler(this, "btnDownloadClick");

  btnDelete = new GButton(this, 1082, 650, 85, 30);
  btnDelete.setText("Delete");
  btnDelete.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnDelete.addEventHandler(this, "btnDeleteClick");

  btnAnalyze1 = new GButton(this, 1175, 650, 85, 30);
  btnAnalyze1.setText("Analyze");
  btnAnalyze1.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnAnalyze1.addEventHandler(this, "btnAnalyze1Click");

  lblClock = new GLabel(this, 50, 265, 172, 30);
  lblClock.setText("");
  lblClock.setTextAlign(GAlign.CENTER, GAlign.CENTER);
  lblClock.setFont(font0.getFont());
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

  btnCancel = new GButton(this, 55, 410, 160, 40);
  btnCancel.setText("Cancel");
  btnCancel.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnCancel.addEventHandler(this, "btnCancelClick");

  btnDone = new GButton(this, 55, 410, 160, 40);
  btnDone.setText("Done");
  btnDone.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnDone.addEventHandler(this, "btnDoneClick");

  lblTimer= new GLabel(this, 85, 200, 200, 30);
  lblTimer.setFont(font2.getFont());
  lblTimer.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  lblPecentual = new GLabel(this, 75, 290, 125, 30);
  lblPecentual.setFont(font3.getFont());
  lblPecentual.setTextAlign(GAlign.CENTER, GAlign.CENTER);
  lblPecentual.setLocalColorScheme(GCScheme.YELLOW_SCHEME);

  lblState = new GLabel(this, 75, 340, 125, 30);
  lblState.setFont(font1.getFont());
  lblState.setTextAlign(GAlign.CENTER, GAlign.CENTER);
  lblState.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
}

public void createControlsAnalysis() {

  //File Group
  lblFile2 = new GLabel(analyzeWindow, 22, 15, 190, 20);
  lblFile2.setText("Selected File");
  lblFile2.setTextBold();
  lblFile2.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  lblttFileName2 = new GLabel(analyzeWindow, 30, 35, 190, 20);
  lblttFileName2.setText("Repo:");
  lblttFileName2.setTextBold();
  lblttFileName2.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttFileName2 = new GLabel(analyzeWindow, 30, 55, 190, 20);
  lblttFileName2.setText("File:");
  lblttFileName2.setTextBold();
  lblttFileName2.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttFileDate2 = new GLabel(analyzeWindow, 30, 75, 190, 20);
  lblttFileDate2.setText("Date:");
  lblttFileDate2.setTextBold();
  lblttFileDate2.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttFileSize2 = new GLabel(analyzeWindow, 30, 95, 190, 20);
  lblttFileSize2.setText("Size:");
  lblttFileSize2.setTextBold();
  lblttFileSize2.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblFileRepo = new GLabel(analyzeWindow, 70, 35, 190, 20);
  lblFileRepo.setText("");
  lblFileRepo.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblFilesAnalyze = new GLabel(analyzeWindow, 70, 55, 200, 20);
  lblFilesAnalyze.setText("");
  lblFilesAnalyze.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblFileDate2 = new GLabel(analyzeWindow, 70, 75, 190, 20);
  lblFileDate2.setText("");
  lblFileDate2.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblFileSize2 = new GLabel(analyzeWindow, 70, 95, 190, 20);
  lblFileSize2.setText("");
  lblFileSize2.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  btnAnalyze2 = new GButton(analyzeWindow, 180, 95, 85, 30);
  btnAnalyze2.setText("Analyze");
  btnAnalyze2.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  btnAnalyze2.addEventHandler(this, "btnAnalyze2Click");

  //Stat Group
  lblStat = new GLabel(analyzeWindow, 22, 150, 190, 20);
  lblStat.setText("Statistics");
  lblStat.setTextBold();
  lblStat.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  lblttRecords = new GLabel(analyzeWindow, 30, 170, 190, 20);
  lblttRecords.setText("Records:");
  lblttRecords.setTextBold();
  lblttRecords.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttTmCount = new GLabel(analyzeWindow, 30, 190, 190, 20);
  lblttTmCount.setText("Time Count:");
  lblttTmCount.setTextBold();
  lblttTmCount.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttMoviments = new GLabel(analyzeWindow, 30, 210, 190, 20);
  lblttMoviments.setText("Moviment:");
  lblttMoviments.setTextBold();
  lblttMoviments.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttHolePokes = new GLabel(analyzeWindow, 30, 230, 190, 20);
  lblttHolePokes.setText("Hole Poke:");
  lblttHolePokes.setTextBold();
  lblttHolePokes.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblttRearings = new GLabel(analyzeWindow, 30, 250, 190, 20);
  lblttRearings.setText("Rearing:");
  lblttRearings.setTextBold();
  lblttRearings.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblRecords = new GLabel(analyzeWindow, 95, 170, 190, 20);
  lblRecords.setText("0");
  lblRecords.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblTmCount = new GLabel(analyzeWindow, 105, 190, 190, 20);
  lblTmCount.setText("0");
  lblTmCount.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblMoviments = new GLabel(analyzeWindow, 95, 210, 190, 20);
  lblMoviments.setText("0");
  lblMoviments.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblHolePokes = new GLabel(analyzeWindow, 95, 230, 190, 20);
  lblHolePokes.setText("0");
  lblHolePokes.setLocalColorScheme(GCScheme.BLUE_SCHEME);

  lblRearings = new GLabel(analyzeWindow, 90, 250, 190, 20);
  lblRearings.setText("0");
  lblRearings.setLocalColorScheme(GCScheme.BLUE_SCHEME);
}


public void createGraphicsAnalysis() {
  // Plot Statistics 
  points1 = new GPointsArray(3);
  points1.add(0, 0, "Moviments");
  points1.add(1, 0, "Hole Poke");
  points1.add(2, 0, "Rearing");
  plotBars = new GPlot(analyzeWindow);
  plotBars.setPos(25, 280);
  plotBars.setDim(150, 240);
  plotBars.setYLim(0, 1);
  plotBars.setXLim(-1, 3);
  plotBars.getTitle().setText("Statistic ( Time 0 min )");
  plotBars.getTitle().setTextAlignment(LEFT);
  plotBars.getTitle().setRelativePos(0.2);
  plotBars.getYAxis().getAxisLabel().setText("Records");
  plotBars.setPoints(points1);
  plotBars.startHistograms(GPlot.VERTICAL);
  plotBars.getHistogram().setDrawLabels(true);
  plotBars.getHistogram().setRotateLabels(true);

  // Plot Zone
  plotQuads = new GPlot(analyzeWindow);
  plotQuads.setPos(310, 20);
  plotQuads.setDim(255, 180);
  plotQuads.setYLim(0.5, 9.5);
  plotQuads.setVerticalAxesTicksSeparation(1);
  plotQuads.setFixedXLim(true);
  plotQuads.setFixedYLim(true);
  plotQuads.getTitle().setText("Moviment");
  plotQuads.getYAxis().getAxisLabel().setText("Quadrant");
  plotQuads.getXAxis().getAxisLabel().setText("Routes");
  plotQuads.startHistograms(GPlot.HORIZONTAL);
  plotQuads.getHistogram().setDrawLabels(true);
  plotQuads.getHistogram().setRotateLabels(true);


  // Hole Poke
  plotHp = new GPlot(analyzeWindow);
  plotHp.setPos(310, 335);
  plotHp.setDim(255, 180);
  plotHp.setYLim(0.5, 11.5);
  plotHp.setVerticalAxesTicksSeparation(1);
  plotHp.setFixedXLim(true);
  plotHp.setFixedYLim(true);
  plotHp.getTitle().setText("Hole Poke");
  plotHp.getXAxis().getAxisLabel().setText("Records");
  plotHp.getYAxis().getAxisLabel().setText("HP Sensor");

  // Rearing
  plotRearing = new GPlot(analyzeWindow);
  plotRearing.setPos(702, 20);
  plotRearing.setDim(255, 180);
  plotRearing.setYLim(-0.5, 16.5);
  plotRearing.setFixedXLim(true);
  plotRearing.setFixedYLim(true);
  plotRearing.getTitle().setText("Rearing");
  plotRearing.getXAxis().getAxisLabel().setText("Records");
  plotRearing.getYAxis().getAxisLabel().setText("Z Sensor");


  // Plot Routes
  plotRoutes = new GPlot(analyzeWindow);
  plotRoutes.setPos(702, 335);
  plotRoutes.setDim(255, 180);
  plotRoutes.setYLim(-0.5, 12.5);
  plotRoutes.setXLim(-0.5, 23.5);
  plotRoutes.setVerticalAxesTicksSeparation(2);
  plotRoutes.setHorizontalAxesTicksSeparation(2);
  plotRoutes.setFixedXLim(true);
  plotRoutes.setFixedYLim(true);
  plotRoutes.getTitle().setText("Path");
  plotRoutes.getXAxis().getAxisLabel().setText("X Sensor");
  plotRoutes.getYAxis().getAxisLabel().setText("Y Sensor");
}

public void resetAnalyzeWindow() {
  lblFileRepo.setText(getParamValue("REPO"));
  lblRecords.setText("0 ( rows )");
  lblTmCount.setText("0 ( minutes )");
  lblMoviments.setText("0 ( routes )");
  lblHolePokes.setText("0 ( inputs )");
  lblRearings.setText("0 ( ups )");
  lblFilesAnalyze.setText("");
  lblFileDate2.setText("");
  lblFileSize2.setText(0 + "KB");
}

public void updateAnalysys(BPMAnalysis analysis) {
  lblRecords.setText(analysis.registers + " ( rows )");
  lblTmCount.setText(analysis.timeCount + " ( minutes )");
  lblMoviments.setText(analysis.moviments + " ( routes )");
  lblHolePokes.setText(analysis.holePokes + " ( inputs )");
  lblRearings.setText(analysis.rearings + " ( ups )");

  // Data Stat
  points1 = new GPointsArray(3);
  points1.add(0, analysis.moviments, "Moves");
  points1.add(1, analysis.holePokes, "Hole Poke");
  points1.add(2, analysis.rearings, "Rearing");
  plotBars.getTitle().setText("Statistic ( "+ analysis.timeCount +"  min )");
  plotBars.setYLim(0, analysis.registers);
  plotBars.setPoints(points1);

  // Data Zone
  points2 = new GPointsArray(analysis.route.size());
  int j = 0;
  for (BPMRoute route : analysis.route) {
    BPMQuadrant q1 = bpmArena.quadCoords.get(route.to);
    GPoint p1 = new GPoint(j, q1.index);
    points2.add(p1);
    j++;
  }

  plotQuads.setXLim(0, analysis.route.size());
  plotQuads.setPoints(points2);

  // Data Path, hp, rearing
  points3 = new GPointsArray(analysis.registers);
  points4 = new GPointsArray(analysis.registers);
  points5 = new GPointsArray(analysis.registers);
  int i = 0;
  for (BPMRegister row : analysis.row) {
    if (row.pos_x > -1 && row.pos_y > -1) {
      GPoint p1 = new GPoint(row.pos_x, row.pos_y);
      points3.add(p1);
    }

    GPoint p2 = new GPoint(i, row.hp);
    points4.add(p2);

    GPoint p3 = new GPoint(i, row.pos_z);
    points5.add(p3);
    i++;
  }
  plotHp.setXLim(0, analysis.registers);
  plotRearing.setXLim(0, analysis.registers);
  plotRoutes.setPoints(points3);
  plotHp.setPoints(points4);
  plotRearing.setPoints(points5);
}

public void handleDropListEvents(GDropList list, GEvent event) { /* code */
}
