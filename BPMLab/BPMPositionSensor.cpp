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

BPMPositionSensor::BPMPositionSensor() {

}

void BPMPositionSensor::start(void) {
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

void BPMPositionSensor::setup(void) {

}

void BPMPositionSensor::clear(void) {
	tx.clear();
}

SensorData BPMPositionSensor::readData(void) {
	SensorData ret;
	int i = 0;
	for (int colIndex = 0; colIndex < tx.getColsSize(); colIndex++) {
		for (int rowIndex = 0; rowIndex < tx.getRowsSize(); rowIndex++) {
			if (!((colIndex == 3 || colIndex == 4) && rowIndex >= 6)) {
				tx.write(colIndex, rowIndex, HIGH);
				delay(1);
				byte value = rx.read(rowIndex);

				if ((colIndex == 5 && rowIndex == 6)
						|| (colIndex == 5 && rowIndex == 2)
						|| (colIndex == 0 && rowIndex == 6)
						|| (colIndex == 2 && rowIndex == 1)) {
					value = 0;
				}

				ret.value[colIndex][rowIndex] = value;
				ret.log[i] = (value + 48);
				i++;
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
	}
	delay(1);
	clear();
	return ret;
}

PositionData BPMPositionSensor::read(void) {
	PositionData positionData;
	int x = -1;
	int y = -1;
	int z = -1;
	int cs = tx.getColsSize();
	int rs = tx.getRowsSize();
	SensorData data = readData();
	for (int colIndex = 0; colIndex < cs; colIndex++) {
		for (int rowIndex = 0; rowIndex < rs; rowIndex++) {
			if (!((colIndex == 3 || colIndex == 4) && rowIndex >= 6)) {
				if (data.value[colIndex][rowIndex] == 1) {
					if (colIndex <= 2) { // Map x
						x = (colIndex * rs) + rowIndex;
						break;
					} else if (colIndex <= 4) { // Map y
						y = (((colIndex - 3) * rs) + rowIndex) - 1;
						break;
					} else { //Map z
						z = ((colIndex - 5) * rs) + rowIndex;
						break;
					}
				}
			}
		}
	}

	positionData.data = data;
	positionData.x = x;
	positionData.y = y;
	positionData.z = z;
	return positionData;
}

boolean BPMPositionSensor::test(void) {
	return true;
}

