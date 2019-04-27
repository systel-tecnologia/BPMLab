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
	for (int colIndex = 0; colIndex < tx.getColsSize(); colIndex++) {
		for (int rowIndex = 0; rowIndex < tx.getRowsSize(); rowIndex++) {
			delay(1);
			if (!((colIndex == 3 || colIndex == 4) && rowIndex >= 6)) {
				tx.write(colIndex, rowIndex, HIGH);
				int value1 = rx.read(rowIndex);
				int value2 = rx.read(rowIndex);
				int value3 = rx.read(rowIndex);

				if ((colIndex == 5 && rowIndex == 6)
						|| (colIndex == 0 && rowIndex == 0)
						|| (colIndex == 0 && rowIndex == 2)
						|| (colIndex == 0 && rowIndex == 3)
						|| (colIndex == 1 && rowIndex == 2)
						|| (colIndex == 3 && rowIndex == 0)
						|| (colIndex == 5 && rowIndex == 0)
						|| (colIndex == 5 && rowIndex == 7)) {
					value1 = 0;
				}

				ret.value[colIndex][rowIndex] = (value1 & value2 & value3);
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
	int width = 0;
	int heigth = 0;
	int length = 0;
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
						width++;
					} else if (colIndex <= 4) { // Map y
						y = (((colIndex - 3) * rs) + rowIndex) - 1;
						heigth++;
					} else { //Map z
						z = ((colIndex - 5) * rs) + rowIndex;
						length++;
					}
				}
			}
		}
	}

	positionData.data = data;
	positionData.x = x;
	positionData.y = y;
	positionData.z = z;
	if (x == -1 || y == -1) {
		positionData.x = -1;
		positionData.y = -1;
	}
	return positionData;
}

boolean BPMPositionSensor::test(void) {
	return true;
}

