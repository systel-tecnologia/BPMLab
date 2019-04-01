/*
 File  : BPMCommandProcessor.h
 Version : 1.0
 Date  : 23/03/2019
 Project : Systel Commando Processor Connectin Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 
 */

#ifndef _BPMCommandProcessor_H_
#define _BPMCommandProcessor_H_

#include <Arduino.h>

const String START_CODE	= "BPMLabAdm";		// Start Code for new Connections

// library interface description
class BPMCommandProcessor {
		// user-accessible "public" interface
	public:

		boolean isAutorizationCode (String data);

		void execute(String command);

		// library-accessible "protected" interface
	protected:

		// library-accessible "private" interface
	private:
};

#endif
