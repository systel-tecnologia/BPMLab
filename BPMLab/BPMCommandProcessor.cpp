/*
 File  : BPMCommandProcessor.cpp
 Version : 1.0
 Date  : 23/03/2019
 Project : Systel Commando Processor Connectin Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 */
#include <Arduino.h>
#include "BPMLab.h"
#include "BPMUserInterface.h"
#include "BPMCommandProcessor.h"

void softReset(void) {

}

boolean BPMCommandProcessor::isAutorizationCode(String data) {
	if (data.equals(START_CODE)) {
		return true;
	}
	return false;
}

void BPMCommandProcessor::executeStartProccessCommand(void) {
	Serial.print(bpmLab.configuration.boundRate);
	Serial.print(";");
	Serial.print(bpmLab.configuration.fileIndex);
	Serial.print(";");
	Serial.print(bpmLab.configuration.modeCron);
	Serial.print(";");
	Serial.print(bpmLab.configuration.totalProcessSeconds);
	Serial.print(";");
	Serial.println(bpmLab.configuration.modified);
	startProcess = true;
}

void BPMCommandProcessor::execute(String command) {

	Serial.println(command + " START");

	if (command.startsWith("SDCARDINFO")) {
		bpmLab.dataLogger.cardInfo();
	}

	if (command.startsWith("DELETEFILE")) {
		bpmLab.dataLogger.deleteFile(command.substring(11, 23));
	}

	if (command.startsWith("LISTFILES")) {
		bpmLab.dataLogger.listFileNames();
	}

	if (command.startsWith("DOWNLOAD")) {
		bpmLab.dataLogger.dumpFile(command.substring(9, 21));
	}

	if (command.startsWith("DISCONNECT")) {
		softReset();
	}

	if (command.startsWith("PROCESSINIT")) {
		executeStartProccessCommand();
	}

	Serial.println(command + " END");

	if (startProcess) {
		bpmLab.start();
		startProcess = false;
	}
}

