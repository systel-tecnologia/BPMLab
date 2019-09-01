/*
 File  : InfraredMTX595D.cpp
 Version : 2.0
 Date  : 30/08/2019
 Project : Systel BPM Data Transmiter InfraRed Matrix Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Descrição: 
 1.0 - 04/03/2019 - Programação Básica
 
 */
#include <Arduino.h>
#include "InfraredMTX595D.h"

byte defaultLatchSegmentPins[3] = { PIN_CLK_SG, PIN_LATCH_SG, PIN_DATA_SG };
byte defaultLatchLightBeamPins[3] = { PIN_CLK_LB, PIN_LATCH_LB, PIN_DATA_LB };

const byte scanSegments[8] = { 4, 2, 1, 16, 8, 32, 64, 128 };
const byte scanLightBeans[8] = { 1, 2, 4, 8, 16, 32, 64, 128 };

InfraredMTX595D::InfraredMTX595D() {

}

void InfraredMTX595D::start(byte *segments, byte *lightBeans, int segmentSize,
		int lightBeamSize) {
	start(defaultLatchSegmentPins, defaultLatchLightBeamPins, segments,
			lightBeans, segmentSize, lightBeamSize);
	clear();
}

void InfraredMTX595D::start(byte *latchSegmentPins, byte *latchLightBeamPins,
		byte *segments, byte *lightBeans, int segmentSize, int lightBeamSize) {
	segmentPins = latchSegmentPins;
	lightBeamPins = latchLightBeamPins;
	selectedSegments = segments;
	selectLightBeans = lightBeans;
	segmentCount = segmentSize;
	lightBeamCount = lightBeamSize;
	setup();
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\t\t74HC595D Data Transmitter InfraRed Matrix Device Driver Started...");
	DBG_PRINT_LEVEL("\t\tWrite ON [");
	if (colPins && rowPins) {
		for (int i = 0; i <= 2; i++) {
			DBG_PRINT_LEVEL("(P");
			DBG_PRINT_LEVEL(i);
			DBG_PRINT_LEVEL(":");
			DBG_PRINT_LEVEL(colPins[i]);
			DBG_PRINT_LEVEL(",");
			DBG_PRINT_LEVEL(rowPins[i]);
			DBG_PRINT_LEVEL(")");
		}
	}
	DBG_PRINTLN_LEVEL("]");
#endif
	clear();
}

void InfraredMTX595D::write(int index, byte data) {
	write((index / lightBeamCount) % segmentCount , index % lightBeamCount, HIGH);
}

void InfraredMTX595D::write(const int segment, const int lightBeam, byte data) {
	int cData = constrain(data, LOW, HIGH);
	if (cData == HIGH) {
		int sSegment = selectedSegments[segment];
		int sLightBeam = selectLightBeans[lightBeam];
		write(lightBeamPins, scanLightBeans[sLightBeam]);
		write(segmentPins, scanSegments[sSegment]);
#if(DEBUG_LEVEL >= 4)
			DBG_PRINT_LEVEL("\t\t\tSend: (SEGMENT:");
			DBG_PRINT_LEVEL(segment);
			DBG_PRINT_LEVEL(", LIGHTBEAM:");
			DBG_PRINT_LEVEL(lightBeam);
			DBG_PRINT_LEVEL(") Data --> ");
			DBG_PRINTLN_LEVEL(cData);
#endif
	} else {
		clear();
	}
}

void InfraredMTX595D::write(byte *latchPins, const byte value) {
	digitalWrite(latchPins[LATCH], LOW);
	shiftOut(latchPins[DATA], latchPins[CLOCK], MSBFIRST, value);
	digitalWrite(latchPins[LATCH], HIGH);
}

int InfraredMTX595D::getLightBeamCount() {
	return lightBeamCount;
}

int InfraredMTX595D::getSegmentCount() {
	return segmentCount;
}

void InfraredMTX595D::clear() {
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t Send Reset ALL COL / ROW Data Values");
#endif
	write(segmentPins, 0);
	write(lightBeamPins, 0);
}

void InfraredMTX595D::setup(void) {
	for (int i = 0; i <= sizeof(segmentPins); i++) {
		pinMode(segmentPins[i], OUTPUT);
		pinMode(lightBeamPins[i], OUTPUT);
	}
}
