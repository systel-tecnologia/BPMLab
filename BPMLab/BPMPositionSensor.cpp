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

SensorData BPMPositionSensor::read (const int col, const int row) {
	SensorData ret;
	tx.write(col, row, HIGH);
	ret.col = col;
	ret.row = row;
	ret.value = rx.read(row);
#if(DEBUG_LEVEL >= 4)
	DBG_PRINT_LEVEL("\t\t\tReceived: (COL:");
	DBG_PRINT_LEVEL(ret.col);
	DBG_PRINT_LEVEL(", ROW:");
	DBG_PRINT_LEVEL(ret.row);
	DBG_PRINT_LEVEL(") VALUE: [");
	DBG_PRINT_LEVEL(ret.value);
	DBG_PRINTLN_LEVEL("]");
#endif	
	return ret;
}

PositionData BPMPositionSensor::read (void) {
	PositionData ret;
	int width = 0;
	int heigth = 0;
	int x = -1;
	int y = -1;
	int z = -1;
	for (int colIndex =
			0; colIndex < tx.getColsSize(); colIndex++) {
		for (int rowIndex = 0; rowIndex < tx.getRowsSize(); rowIndex++) {
			SensorData data = read(colIndex, rowIndex);
			if (data.value == 1) {
				if (data.col <= 2) {
					x = ((data.col * 8) + data.row);
					width++;
				} else
					if (data.col == 3 || data.col == 4) {
						y = ((data.col * 8) + data.row) - 24;
						heigth++;
					} else
						if (data.col == 5 || data.col == 6) {
							z =1;
						}
			}
		}
	}
	tx.clear();
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
