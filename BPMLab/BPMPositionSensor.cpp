/*
 File  : BPMPositionSensor.cpp
 Version : 2.0
 Date  : 30/08/2019
 Project : Systel BPM Position Sensor Grid Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com

 */

#include "BPMPositionSensor.h"

#include <Arduino.h>
#include <Equino.h>

#include "BPMExceptionHandler.h"

byte defaultXSegments[3] = { 0, 1, 2 };
byte defaultYSegments[2] = { 3, 4 };
byte defaultZSegments[2] = { 5, 6 };

byte defaultXLightBeans[8] = { 7, 6, 5, 4, 3, 2, 1, 0 };
byte defaultZLightBeans[8] = { 0, 1, 2, 3, 4, 5, 6, 7 };
byte defaultYLightBeans[6] = { 2, 3, 4, 5, 6, 7 };

byte input1LatchPins[4] = { PIN_LOAD, PIN_ENABLED, PIN_DATA0, PIN_CLOCK };
byte input2LatchPins[4] = { PIN_LOAD, PIN_ENABLED, PIN_DATA1, PIN_CLOCK };
byte input3LatchPins[4] = { PIN_LOAD, PIN_ENABLED, PIN_DATA2, PIN_CLOCK };
byte input4LatchPins[4] = { PIN_LOAD, PIN_ENABLED, PIN_DATA3, PIN_CLOCK };

BPMPositionSensor::BPMPositionSensor() {

}

void BPMPositionSensor::start(void) {
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\tStarting BPM Position Sensor Array...");
#endif
	setup();

	tx.start(defaultXSegments, defaultXLightBeans, sizeof(defaultXSegments),
			sizeof(defaultXLightBeans));
	ty.start(defaultYSegments, defaultYLightBeans, sizeof(defaultYSegments),
			sizeof(defaultYLightBeans));
	tz.start(defaultZSegments, defaultZLightBeans, sizeof(defaultZSegments),
			sizeof(defaultZLightBeans));

	rx.start(input1LatchPins, 24);
	ry.start(input3LatchPins, 16);
	rz.start(input4LatchPins, 16);
	rh.start(input2LatchPins, 8);

	if (!test()) {
		exceptionHandler.exceptionDetected(SENSOR_GRID_ERROR);
	}
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\t\tPosition Sensor Array Started...");
#endif
	clear();
}

void BPMPositionSensor::setup(void) {

}

void BPMPositionSensor::clear(void) {
	tx.clear();
	ty.clear();
	tz.clear();
}

SensorData BPMPositionSensor::read(void) {
	clear();
	SensorData data;
	int cx = rx.getSensorCount();
	for (int x = 0; x < cx; x++) {
		tx.write(x, HIGH);
		byte value1 = rx.read((cx - 1) - x);
		data.x[x] = (value1 + 48);
	}
	tx.clear();

	int cy = ry.getSensorCount();
	for (int y = 0; y < cy; y++) {
		if(y > 3){
			ty.write((y - 4), HIGH);
			byte value2 = ry.read((cy - 1) - (y - 4));
			data.y[y - 4] = (value2 + 48);
		} else {
			byte value2 = ry.read(y);
			data.h[11 - y] = (value2 + 48);
		}
	}
	data.y[0] = 48;

	ty.clear();

	int cz = rz.getSensorCount();
	for (int z = 0; z < cz; z++) {
		tz.write(z, HIGH);
		byte value3 = rz.read((cz - 1) - z);
		data.z[z] = (value3 + 48);
	}
	tz.clear();

	for (int h = 0; h < rh.getSensorCount(); h++) {
		byte value4 = rh.read(h);
		data.h[h] = (value4 + 48);
	}

	return data;
}

boolean BPMPositionSensor::test(void) {
	return true;
}

