/*
 File  : BPMPositionSensor.cpp
 Version : 1.0
 Date  : 05/03/2019
 Project : Systel BPM Position Sensor Grid Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com

 */
#include <Arduino.h>
#include <Equino.h>
#include "BPMPositionSensor.h"
#include "BPMExceptionHandler.h"

BPMPositionSensor::BPMPositionSensor () {

}

void BPMPositionSensor::start (void) {
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\tStarting BPM Position Sensor Array...");
#endif
	setup();
	tx.start();
	rx.start();
	if (!test()) {
		exceptionHandler.exceptionDetected(SENSOR_GRID_ERROR);
	}
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\t\tPosition Sensor Array Started...");
#endif
}

void BPMPositionSensor::setup (void) {

}

void BPMPositionSensor::clear (void) {
	tx.clear();
}

SensorData BPMPositionSensor::readData (void) {
	SensorData ret;
	for (int colIndex = 0; colIndex < tx.getColsSize(); colIndex++) {
		for (int rowIndex = 0; rowIndex < tx.getRowsSize(); rowIndex++) {
			tx.write(colIndex, rowIndex, HIGH);
			int value = rx.read(rowIndex);
			ret.value[colIndex][rowIndex] = value;
#if(DEBUG_LEVEL >= 4)
			DBG_PRINT_LEVEL("\t\t\tReceived: (COL:");
			DBG_PRINT_LEVEL(colIndex);
			DBG_PRINT_LEVEL(", ROW:");
			DBG_PRINT_LEVEL(rowIndex);
			DBG_PRINT_LEVEL(") VALUE: [");
			DBG_PRINT_LEVEL(value);
			DBG_PRINTLN_LEVEL("]");
#endif
		}
	}
	return ret;
}

PositionData BPMPositionSensor::read (void) {
	SensorData data = readData();
	PositionData ret;
	int width = 0;
	int heigth = 0;
	int x = -1;
	int y = -1;
	int z = -1;
	ret.width = width;
	ret.heigth = heigth;
	ret.x = x;
	ret.y = y;
	ret.z = z;
	return ret;
}

boolean BPMPositionSensor::test (void) {
	return true;
}
