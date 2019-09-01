/*
 File  : InfraredRX74ls164.cpp
 Version : 1.0
 Date  : 18/08/2019
 Project : Systel BPM Data Receiver InfraRed Matrix Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 */
#include "InfraredRX74ls165.h"
#include "InfraredMTX595D.h"
#include <Arduino.h>

byte InfraredRX74ls165::read(int portNumber) {
	return read(latchPins, portNumber);
}

byte InfraredRX74ls165::read(byte *latchPins, int portNumber) {
	byte bitVal = 0;

	/* Trigger a parallel Load to latch the state of the data lines,
	 */
	digitalWrite(latchPins[ENABLED], HIGH);
	digitalWrite(latchPins[LOAD], LOW);
	delayMicroseconds(PULSE_WIDTH_USEC);
	digitalWrite(latchPins[LOAD], HIGH);
	delayMicroseconds(PULSE_WIDTH_USEC);
	digitalWrite(latchPins[ENABLED], LOW);

	/* Loop to read each bit value from the serial out line
	 * of the SN74HC165N.
	 */
	for (int i = 0; i < sensorCount; i++) {

		if(i == portNumber){
			bitVal = !digitalRead(latchPins[DATA]);
		}

		/* Pulse the Clock (rising edge shifts the next bit).
		 */
		digitalWrite(latchPins[CLOCK], HIGH);
		delayMicroseconds(PULSE_WIDTH_USEC);
		digitalWrite(latchPins[CLOCK], LOW);
	}

	return bitVal;
}

void InfraredRX74ls165::start(byte *pins, int sensors) {
	sensorCount = sensors;
	latchPins = pins;
	setup();
}

int InfraredRX74ls165::getSensorCount() {
	return sensorCount;
}

void InfraredRX74ls165::setup(void) {
	/* Initialize our digital pins...
	 */
	pinMode(latchPins[LOAD], OUTPUT);
	pinMode(latchPins[ENABLED], OUTPUT);
	pinMode(latchPins[CLOCK], OUTPUT);
	pinMode(latchPins[DATA], INPUT_PULLUP);

	digitalWrite(latchPins[CLOCK], LOW);
	digitalWrite(latchPins[LOAD], HIGH);

}

