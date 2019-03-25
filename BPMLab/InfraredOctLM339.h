/*
 File  : InfraredOctLM339.h
 Version : 1.0
 Date  : 04/03/2019
 Project : Systel BPM Octet LM339 InfraRed Sensor Receiver Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Infrared Octet Data Receiver
 For Uno:
 DATA 1  6       // bit 0 Data Receiver
 DATA 2  7		// bit 1 Data Receiver
 DATA 3  8		// bit 2 Data Receiver
 DATA 4  9		// bit 3 Data Receiver
 DATA 5  10		// bit 4 Data Receiver
 DATA 6  11		// bit 5 Data Receiver	
 DATA 7  12		// bit 6 Data Receiver
 DATA 8  13		// bit 7 Data Receiver
 
 For Mega:
 DATA 1  A8      // bit 0 Data Receiver
 DATA 2  A9		// bit 1 Data Receiver
 DATA 3  A10		// bit 2 Data Receiver
 DATA 4  A11		// bit 3 Data Receiver
 DATA 5  A12		// bit 4 Data Receiver
 DATA 6  A13		// bit 5 Data Receiver	
 DATA 7  A14		// bit 6 Data Receiver
 DATA 8  A15		// bit 7 Data Receiver
 
 */

#ifndef _InfraredOctLM339_H_
#define _InfraredOctLM339_H_

#include <Arduino.h>
#include <DataReceiverDevice.h>

#if defined(__AVR_ATmega2560__)
#define PIN_DATA_IN0  A15
#define PIN_DATA_IN1  A14
#define PIN_DATA_IN2  A13
#define PIN_DATA_IN3  A12
#define PIN_DATA_IN4  A11
#define PIN_DATA_IN5  A10
#define PIN_DATA_IN6  A9
#define PIN_DATA_IN7  A8
#else
// Receive pin
#define PIN_DATA_IN0  6
#define PIN_DATA_IN1  7
#define PIN_DATA_IN2  8
#define PIN_DATA_IN3  9
#define PIN_DATA_IN4  10
#define PIN_DATA_IN5  11
#define PIN_DATA_IN6  12
#define PIN_DATA_IN7  13
#endif

// library interface description
class InfraredOctLM339: public DataReceiverDevice {
		// user-accessible "public" interface
	public:

		InfraredOctLM339 ();

		void start (void);

		void start (byte *pins);

		int read (const int index);

		// library-accessible "protected" interface
	protected:

		void setup (void);

		// library-accessible "private" interface
	private:

		byte *inputPins = 0;

};

#endif
