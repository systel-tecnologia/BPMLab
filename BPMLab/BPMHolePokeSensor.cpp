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

}

boolean BPMHolePokeSensor::test (void) {
	return true;
}

int BPMHolePokeSensor::read () {
	return lastHolePokeSensorState;
}

