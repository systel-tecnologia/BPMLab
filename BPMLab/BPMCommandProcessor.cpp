/*
 File  : BPMCommandProcessor.cpp
 Version : 1.0
 Date  : 23/03/2019
 Project : Systel Commando Processor Connectin Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 */

#include "BPMCommandProcessor.h"

boolean BPMCommandProcessor::isAutorizationCode (String data) {
	if(data.equals(START_CODE)){
		return true;
	}
	return false;
}
