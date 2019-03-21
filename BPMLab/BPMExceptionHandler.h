/*
 File  : BPMExceptionHandler.h
 Version : 1.0
 Date  : 16/03/2019
 Project : Systel BPM Exception Handler interface Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 BPM Exception Handler interface
 
 */

#ifndef _BPMExceptionHandler_H_
#define _BPMExceptionHandler_H_

#include <avr/pgmspace.h>

static const char msg0[] PROGMEM = "No Error Found...";
static const char msg1[] PROGMEM = "SD Card Not Found";
static const char msg2[] PROGMEM = "Sensor Grid Fails";
static const char msg3[] PROGMEM = "  Hole Poke Fails";
static const char msg4[] PROGMEM = " Time Clock Error";

static const char * const exceptionMessages[] PROGMEM = { msg0, msg1, msg2, msg3, msg4 };

enum ExceptionCode {
	NO_EXCEPTION, CARD_NOT_FOUND, SENSOR_GRID_ERROR, HOLEPOKE_ERROR, TIME_CLOCK_ERROR
};

struct ExceptionData {
		ExceptionCode exceptionCode = NO_EXCEPTION;
		char exceptionMessage[20];
		int msg_x = 15;
		int msg_y = 115;
		boolean isIconColorBlack = false;
};

// library interface description
class BPMExceptionHandler {
		// user-accessible "public" interface
	public:

		BPMExceptionHandler ();

		ExceptionData throwException (void);

		boolean hasException (void);

		void exceptionDetected (ExceptionCode exceptionCode);

		// library-accessible "protected" interface
	protected:

		// library-accessible "private" interface
	private:

		ExceptionCode exception = NO_EXCEPTION;
};

extern BPMExceptionHandler exceptionHandler;

#endif

