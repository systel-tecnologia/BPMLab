/*
 File  : BPMConfigStorage.cpp
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel Storage EEPROM Devices Configuration Data Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Storage EEPROM Devices Configuration Data
 
 */
#include <Arduino.h>
#include <EEPROM.h>
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
	int eeAddress = DATA_STORE_ADDRESS;
	EEPROM.get(eeAddress, data);
	delay(100);
#if(DEBUG_LEVEL >= 3)
	DBG_PRINT_LEVEL("\t\tEEPROM Data loadded... [");
	DBG_PRINT_LEVEL(data.boundRate);
	DBG_PRINT_LEVEL(", ");
	DBG_PRINT_LEVEL(data.fileIndex);
	DBG_PRINT_LEVEL(", ");
	DBG_PRINT_LEVEL(data.modeCron);
	DBG_PRINT_LEVEL(", ");
	DBG_PRINT_LEVEL(data.modified);
	DBG_PRINT_LEVEL(", ");
	DBG_PRINT_LEVEL(data.totalProcessSeconds);
	DBG_PRINTLN_LEVEL("]");
#endif
	return data;
}

void BPMConfigStorage::save (ConfigurationData data) {
	if (data.modified != 0) {
#if(DEBUG_LEVEL >= 4)
		DBG_PRINTLN_LEVEL("\t\tEEPROM Data saved...");
#endif
		int eeAddress = DATA_STORE_ADDRESS;
		data.modified = 0;
		EEPROM.put(eeAddress, data);
		delay(100);
	}
}

void BPMConfigStorage::setup (void) {
	int eeAddress = INIT_DATA_FLAG_ADDRESS;
	uint8_t flag = 0;
	EEPROM.get(eeAddress, flag);
	delay(100);
	if (flag != INIT_DATA_FLAG) {
#if(DEBUG_LEVEL >= 3)
		DBG_PRINTLN_LEVEL("\t\tStartig Configuration Database...");
#endif
		reset();
		flag = INIT_DATA_FLAG;
		EEPROM.put(eeAddress, flag);
		delay(100);
	}

}

void BPMConfigStorage::reset (void) {
#if(DEBUG_LEVEL >= 3)
	DBG_PRINTLN_LEVEL("\t\tReset Configuration Database...");
#endif
	ConfigurationData data;
	data.modified = 1;
	save(data);
}
