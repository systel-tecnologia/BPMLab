/*
 File: SimpleConnection.pde
 Version: 1.0
 Date: 23/03/2019
 Project: Systel BPM Lab Processing Application
 Author: Daniel Valentin - dtvalentin@gmail.com
 
 *** Note: This function requires that you have
 ControlP5 v. 2.2.5 installed and imported ! ***
 */
import g4p_controls.*;

private BPMConnection bpmConnection;
private BPMArena bpmArena;
private BPMDataFileReader bpmDataFileReader; 

GGroup grpMain;
int baud = 0;
String portName = "COM4";

// Action controls
GLabel lblDelay, lblDuration, LblPromptDur, lblDurationLeft; 
GLabel lblAlpha, lblArenaControls, lblConnectionControls, lblCommBps; 
GButton btnFadeIn, btnFadeOut, btnEnable, btnDisable, btnInvisible; 
GButton btnVisible, btnCommPort, btnFadeTo; 
GDropList drpCommPort;  
GSlider sdrBps, sdrDuration, sdrAlpha; 
GToggleGroup togGroupSelect; 
GOption optPickGroup1, optPickGroup2; 


void setup() {
  size(1280, 720, JAVA2D);

  bpmArena = new BPMArena(this);
  bpmConnection = new BPMConnection(this);
  bpmDataFileReader = new BPMDataFileReader(this);

  G4P.messagesEnabled(false);
  G4P.setCursor(ARROW);
  surface.setTitle("BPMLab Dashboard");
  grpMain = new GGroup(this);  
  createControls();

  ellipseMode(RADIUS);
  rectMode(CORNERS);
  imageMode(CENTER);
  noStroke();
}


void draw() {
  background(213, 245, 213);
  stroke(0);
  strokeWeight(2);
  fill(200, 210, 200);
  bpmConnection.done();
  if (bpmConnection.isProcessStarted()) {
    DataLocation data = bpmDataFileReader.processData(bpmConnection.getData());
    bpmArena.setTitle(data.getFileName());
    if (data.x > 0 &&  data.y > 0) {
      bpmArena.holePoke(data.hp);
      bpmArena.position(data.x, data.y, data.z, data.w, data.h, data.l, data.hp);
    }
  }
  bpmArena.draw();
}

// Change the colour sceme used for all controls in selected group
public void btnCommPortClick(GButton source, GEvent event) {
  bpmConnection.openDevice(portName, baud);
}

// Update delay value
public void sdrBpsChange(GSlider source, GEvent event) {
  baud = bpmConnection.baudRates()[source.getValueI()];
  lblDelay.setText("" + baud);
}

// Pick one of the 8 predefined colour schemes
public void drpCommPortSelect(GDropList source, GEvent event) { 
  
}


public void createControls() {
  //Arena Group
  lblArenaControls = new GLabel(this, 270, 10, 190, 20);
  lblArenaControls.setText("Arena");
  lblArenaControls.setTextBold();

  // Connection Group
  lblConnectionControls = new GLabel(this, 10, 10, 150, 20);
  lblConnectionControls.setTextAlign(GAlign.LEFT, GAlign.LEFT);
  lblConnectionControls.setText("BPMLab Connection");
  lblConnectionControls.setTextBold();
  lblConnectionControls.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  lblCommBps = new GLabel(this, 10, 35, 180, 20);
  lblCommBps.setText("Connection Baud Rate (bps):");
  lblCommBps.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  lblDelay = new GLabel(this, 185, 35, 50, 20);
  baud = bpmConnection.baudRates()[5];
  lblDelay.setText("" + baud);
  lblDelay.setLocalColorScheme(GCScheme.GREEN_SCHEME);

  sdrBps = new GSlider(this, 10, 60, 230, 25, 15.0);
  sdrBps.setLimits(5, 0, 5);
  sdrBps.setNbrTicks(6);
  sdrBps.setStickToTicks(true);
  sdrBps.setShowTicks(true);
  sdrBps.setEasing(1.0);
  sdrBps.setNumberFormat(G4P.INTEGER, 0);
  sdrBps.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  sdrBps.addEventHandler(this, "sdrBpsChange");

  drpCommPort = new GDropList(this, 10, 95, 110, 120, 1, 30);
  drpCommPort.setItems(bpmConnection.portList(), 0);
  drpCommPort.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  drpCommPort.addEventHandler(this, "drpCommPortSelect");

  btnCommPort = new GButton(this, 130, 95, 110, 30);
  btnCommPort.setText("Connect");
  btnCommPort.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  btnCommPort.addEventHandler(this, "btnCommPortClick");
}

void keyPressed() {
  if (key == 'L') {
    bpmConnection.sendComamnd("LISTFILES");
  }
  if (key == 'D') {
    bpmConnection.sendComamnd("DUMPFILE,BPMDF004.CSV");
  }
}

void keyReleased() {
}
