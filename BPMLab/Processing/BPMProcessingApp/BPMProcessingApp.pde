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

private int option = 0;

void setup() {
  size(800, 600, P2D);
  
  ellipseMode(RADIUS);
  rectMode(CORNERS);
  imageMode(CENTER);
  
  if (option == 0) {
    bpmArena = new BPMArena(this);
  }

  if (option == 1) {
    bpmConnection = new BPMConnection(this);
  }
}


void draw() {
  background(51);
  switch (option) {
  case 0:
    bpmArena.draw();
    break;
  case 1:
    bpmConnection.done();
    break;
  }
}

void keyPressed() {
  
}

void keyReleased() {
  
}
