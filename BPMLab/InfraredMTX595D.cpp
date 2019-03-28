/*
 File  : InfraredMTX595D.cpp
 Version : 1.0
 Date  : 04/03/2019
 Project : Systel BPM Data Transmiter InfraRed Matrix Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Descrição: 
 1.0 - 04/03/2019 - Programação Básica
 
 */

#include "InfraredMTX595D.h"

byte defaultRowPins[3] = { PIN_CLK_ROW, PIN_LATCH_ROW, PIN_DATA_ROW };
byte defaultColPins[3] = { PIN_CLK_COL, PIN_LATCH_COL, PIN_DATA_COL };
const byte scanCols[8] = { 1, 2, 4, 16, 64, 8, 32, 128 };
const byte scanRows1[8] = { 128, 64, 32, 16, 8, 4, 2, 1 };
const byte scanRows2[8] = { 32, 16, 8, 4, 2, 1, 128, 64 };
const byte scanRows3[8] = { 32, 8, 16, 4, 2, 1, 128, 64 };

InfraredMTX595D::InfraredMTX595D () {

}

void InfraredMTX595D::start (void) {
	start(DEFAULT_COL_COUNT, DEFAULT_ROW_COUNT);
}

void InfraredMTX595D::start (int colsCount, int rowsCount) {
	start(defaultColPins, defaultRowPins, colsCount, rowsCount);
}

void InfraredMTX595D::start (byte *latchColPins, byte *latchRowPins, int colsCount, int rowsCount) {
	rows = rowsCount;
	cols = colsCount;
	colPins = latchColPins;
	rowPins = latchRowPins;
	setup();
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\t\t74HC595D Data Transmiter InfraRed Matrix Device Driver Started...");
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

void InfraredMTX595D::write (byte *latchPins, const byte value) {
	digitalWrite(latchPins[LATCH], LOW);
	shiftOut(latchPins[DATA], latchPins[CLOCK], MSBFIRST, value);
	digitalWrite(latchPins[LATCH], HIGH);
}

void InfraredMTX595D::write (const int col, const int row, int data) {
	if (data == HIGH) {
		if (col == 3) {
			write(rowPins, scanRows3[row]);
		} else
			if (col == 4) {
				write(rowPins, scanRows2[row]);
			} else {
				write(rowPins, scanRows1[row]);
			}
		write(colPins, scanCols[col]);
#if(DEBUG_LEVEL >= 4)
		DBG_PRINT_LEVEL("\t\t\tSend: (ROW:");
		DBG_PRINT_LEVEL(row);
		DBG_PRINT_LEVEL(", COL:");
		DBG_PRINT_LEVEL(col);
		DBG_PRINT_LEVEL(") Data --> ");
		DBG_PRINTLN_LEVEL(data);
#endif
	} else {
		clear();
	}
}

int InfraredMTX595D::getColsSize () {
	return cols;
}

int InfraredMTX595D::getRowsSize () {
	return rows;
}

void InfraredMTX595D::clear () {
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t Send Reset ALL COL / ROW Data Values");
#endif
	write(rowPins, 0);
	write(colPins, 0);
}

void InfraredMTX595D::setup (void) {
	for (int i = 0; i <= 2; i++) {
		pinMode(colPins[i], OUTPUT);
		pinMode(rowPins[i], OUTPUT);
	}
}
