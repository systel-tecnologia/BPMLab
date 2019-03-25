/*
 File  : BPMHolePokeSensor.cpp
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel BPM Data Logger Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 SD Card Data Logger
 
 */
#include <Arduino.h>
#include <Equino.h>
#include "BPMHolePokeSensor.h"
#include "BPMExceptionHandler.h"

byte hpPins[11] = { HP_PORT_PIN01, HP_PORT_PIN02, HP_PORT_PIN03, HP_PORT_PIN04, HP_PORT_PIN05, HP_PORT_PIN06, HP_PORT_PIN07, HP_PORT_PIN08, HP_PORT_PIN09, HP_PORT_PIN10, HP_PORT_PIN11 };

BPMHolePokeSensor::BPMHolePokeSensor () {

}

void BPMHolePokeSensor::start (void) {
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\tStarting BPM Hole Poke Sensor Array...");
#endif	
	setup();
	if (!test()) {
		exceptionHandler.exceptionDetected(HOLEPOKE_ERROR);
	}
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\t\tHole Poke Sensor Array Started...");
#endif
}

void BPMHolePokeSensor::setup (void) {
	for (int i = 0; i < sizeof(hpPins); i++) {
		pinMode(hpPins[i], INPUT_PULLUP);
	}
}

boolean BPMHolePokeSensor::test (void) {
	return true;
}

int BPMHolePokeSensor::read () {
	for (int i = 0; i < sizeof(hpPins); i++) {
		int v = digitalRead(hpPins[i]);
		if(v == LOW){
			return  (i + 1);
		}
	}
	return 0;
}

