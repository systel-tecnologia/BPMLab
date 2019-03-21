/*
 File  : BPMExceptionHandler.cpp
 Version : 1.0
 Date  : 16/03/2019
 Project : Systel BPM Exception Handler interface Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 BPM Exception Handler interface
 
 */

#include "BPMLab.h"
#include "BPMExceptionHandler.h"

BPMExceptionHandler exceptionHandler;

BPMExceptionHandler::BPMExceptionHandler () {

}

ExceptionData BPMExceptionHandler::throwException (void) {
	ExceptionData occurs;
	if (hasException()) {
		occurs.exceptionCode = exception;
		occurs.isIconColorBlack = (exception == CARD_NOT_FOUND);
		strcpy_P(occurs.exceptionMessage, (char*) pgm_read_word(&(exceptionMessages[exception])));
		exception = NO_EXCEPTION;
#if(DEBUG_LEVEL >= 3)
		DBG_PRINT_LEVEL("\t\tERROR Found Code: ");
		DBG_PRINT_LEVEL(occurs.exceptionCode);
		DBG_PRINT_LEVEL(" Message: ");
		DBG_PRINTLN_LEVEL(occurs.exceptionMessage);
#endif
	}
	return occurs;
}

boolean BPMExceptionHandler::hasException (void) {
	return (exception != NO_EXCEPTION);
}

void BPMExceptionHandler::exceptionDetected (ExceptionCode exceptionCode) {
	if (exception == NO_EXCEPTION) {
		exception = exceptionCode;
	}
}
