/*
 File: SimpleConnection.pde
 Version: 1.0
 Date: 23/03/2019
 Project: Systel BPM Lab Processing Application
 Author: Daniel Valentin - dtvalentin@gmail.com
 
 *** Note: This function requires that you have
 ControlP5 v. 2.2.5 installed and imported ! ***
 */

private BPMConnection bpmConnection;
private BPMArena bpmArena;
private BPMDataFileReader bpmDataFileReader; 

void setup() {
  size(800, 600, JAVA2D);

  ellipseMode(RADIUS);
  rectMode(CORNERS);
  imageMode(CENTER);
  noStroke();
  bpmArena = new BPMArena(this);
  bpmConnection = new BPMConnection(this);
  bpmDataFileReader = new BPMDataFileReader(this);
}


void draw() {
  background(51);
  bpmConnection.done();
  if (bpmConnection.isProcessStarted()) {
    DataLocation data = bpmDataFileReader.processData(bpmConnection.getData());
    bpmArena.setTitle(data.getFileName());
    if (data.x > 0 &&  data.y > 0){
        bpmArena.holePoke(data.hp);
        bpmArena.position(data.x, data.y, data.z, data.w, data.h, data.l, data.hp);
    } 
  }
  bpmArena.draw();
}

void keyPressed() {
  if(key == 'L'){
    bpmConnection.sendComamnd("LISTFILES");
  }
  if(key == 'D'){
    bpmConnection.sendComamnd("DUMPFILE,BPMDF004.CSV");
  }
}

void keyReleased() {
}
