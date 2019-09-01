/*
 File  : InfraredRX74ls165.h
 Version : 1.0
 Date  : 18/08/2019
 Project : Systel BPM Data Receiver InfraRed Matrix Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Infrared Matrix Data Receiver Config

 PIN_LOAD_L1  	42 	// LOAD  	44  // Connects to Parallel load pin the 165 (PIN 1)
 PIN_ENAB_L1  	44 	// ENABLED  42  // Connects to Clock Enable pin the 165 (PIN 15)
 PIN_DATA_L1   	46  // DATA		46  // Connects to the Q7 pin the 165 (PIN 7)
 PIN_CLOCK_L1 	48 	// CLOCK 	48 	// Connects to the Clock pin the 165 (PIN 2)


 */

#ifndef _InfraredRX74ls165_H_
#define _InfraredRX74ls165_H_

#include <Arduino.h>
#include <DataReceiverDevice.h>
#include "InfraredMTX595D.h"

#define PIN_DATA0  	47  // DATA		2  	// Connects to the Q7 pin the 165 (PIN 9)
#define PIN_DATA1  	49  // DATA		2  	// Connects to the Q7 pin the 165 (PIN 9)
#define PIN_DATA2  	53  // DATA		2  	// Connects to the Q7 pin the 165 (PIN 9)
#define PIN_DATA3  	51  // DATA		2  	// Connects to the Q7 pin the 165 (PIN 9)

#define PIN_CLOCK 	41 	// CLOCK 	3 	// Connects to the Clock pin the 165 (PIN 2)
#define PIN_LOAD  	43 	// LOAD  	0 	// Connects to Parallel load pin the 165 (PIN 1)
#define PIN_ENABLED	45 	// ENABLED  1  	// Connects to Clock Enable pin the 165 (PIN 15)

#define LOAD 	0
#define ENABLED	1
#define DATA	2
#define CLOCK 	3

#define PULSE_WIDTH_USEC 15

// library interface description
class InfraredRX74ls165: public DataReceiverDevice {
	// user-accessible "public" interface
public:

	void start(byte *pins, int sensors);

	byte read(int portNumber);

	int getSensorCount();

	// library-accessible "protected" interface
protected:

	void setup(void);

	byte read(byte *latchPins, int portNumber);

	// library-accessible "private" interface
private:

	int sensorCount = 0;

	byte *latchPins = 0;

};

#endif

