/*
 File  : InfraredOctLM339.cpp
 Version : 1.0
 Date  : 04/03/2019
 Project : Systel BPM Octet LM339 InfraRed Sensor Receiver Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Descrição: 
 1.0 - 04/03/2019 - Programação Básica
 
 */

#include "InfraredOctLM339.h"

byte defaultPins[8] =
		{
		PIN_DATA_IN0, PIN_DATA_IN1, PIN_DATA_IN2, PIN_DATA_IN3,
		PIN_DATA_IN4, PIN_DATA_IN5, PIN_DATA_IN6, PIN_DATA_IN7 };

InfraredOctLM339::InfraredOctLM339 () {

}

void InfraredOctLM339::start (void) {
	start(defaultPins);
}

void InfraredOctLM339::start (byte pins[]) {
	inputPins =
			pins;
	setup();
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\t\tLM339 Infrared Sensor Receiver Device Driver Started...");
	DBG_PRINT_LEVEL("\t\tReading ON [");
	if (inputPins) {
		for (int i =
				0; i <= 7; i++) {
			DBG_PRINT_LEVEL("(P");
			DBG_PRINT_LEVEL(i);
			DBG_PRINT_LEVEL(":");
			DBG_PRINT_LEVEL(inputPins[i]);
			DBG_PRINT_LEVEL(")");
		}
	}
	DBG_PRINTLN_LEVEL("]");
#endif	
}

int InfraredOctLM339::read (const int index) {
#if(DEBUG_LEVEL >= 4)
	DBG_PRINT_LEVEL("\t\t\tRead Port: ");
	DBG_PRINT_LEVEL(inputPins[index]);
	DBG_PRINT_LEVEL(" PIN: A");
	DBG_PRINT_LEVEL(index + 8);
	DBG_PRINT_LEVEL(" ROW Index: ");
	DBG_PRINT_LEVEL(index);
	DBG_PRINT_LEVEL(" <---> ");
#endif
	return digitalRead(inputPins[index]);
}

void InfraredOctLM339::setup (void) {
	for (int i =
			0; i < 8; i++) {
		pinMode(inputPins[i], INPUT);
	}
}
