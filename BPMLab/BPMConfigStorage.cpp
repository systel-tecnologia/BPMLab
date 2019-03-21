/*
 File  : BPMConfigStorage.cpp
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel BPM Data Logger Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Storage EEPROM Devices Configuration Data
 
 */
#include <Arduino.h>
#include <Equino.h>
#include "BPMConfigStorage.h"

BPMConfigStorage::BPMConfigStorage () {

}

void BPMConfigStorage::start (void) {
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\tStarting BPM Devices Configuration EEPROM Data Storage...");
#endif	
	setup();
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\t\tEEPROM Data Storage Started...");
#endif
}

ConfigurationData BPMConfigStorage::load (void) {
	ConfigurationData data;
#if(DEBUG_LEVEL >= 3)
	DBG_PRINTLN_LEVEL("\t\tEEPROM Data loadded...");
#endif	
	return data;
}

void BPMConfigStorage::save (ConfigurationData data) {

}

void BPMConfigStorage::setup (void) {

}

void BPMConfigStorage::read (uint8_t* data, uint8_t size, uint8_t address) {

}

void BPMConfigStorage::write (uint8_t address, uint8_t data) {

}

void BPMConfigStorage::write (uint8_t address, uint8_t* data, uint8_t size) {

}

