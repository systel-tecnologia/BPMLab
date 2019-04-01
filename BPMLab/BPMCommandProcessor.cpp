/*
 File  : BPMCommandProcessor.cpp
 Version : 1.0
 Date  : 23/03/2019
 Project : Systel Commando Processor Connectin Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 */
#include <Arduino.h>
#include "BPMLab.h"
#include "BPMCommandProcessor.h"

boolean BPMCommandProcessor::isAutorizationCode(String data) {
	if (data.equals(START_CODE)) {
		return true;
	}
	return false;
}

void BPMCommandProcessor::execute(String command) {
	if(command.startsWith("LISTFILES")){
		bpmLab.dataLogger.listFileNames();
	}
	if(command.startsWith("DUMPFILE")){
		bpmLab.dataLogger.dumpFile(command.substring(9, 21));
	}
}

