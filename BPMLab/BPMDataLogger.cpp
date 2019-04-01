/*
 File  : BPMDataLogger.cpp
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel BPM Data Logger Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 SD Card Data Logger
 
 */
#include <Arduino.h>
#include <stdarg.h>
#include <Equino.h>
#include <SD.h>
#include "BPMPositionSensor.h"
#include "BPMExceptionHandler.h"
#include "BPMDataLogger.h"

BPMDataLogger::BPMDataLogger() {

}

void BPMDataLogger::start(void) {
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\tStarting BPM Data Logger...");
#endif		
	setup();
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\t\tData Logger Started...");
#endif
}

void BPMDataLogger::setup(void) {
	if (SD.begin(DTLOG_CS_PIN, DTLOG_D0_PIN, DTLOG_D1_PIN, DTLOG_CK_PIN)) {
#if(DEBUG_LEVEL >= 3)
		DBG_PRINTLN_LEVEL("\t\tReading SD Card Information...");
#endif
		cardInfo();
	} else {
		exceptionHandler.exceptionDetected(CARD_NOT_FOUND);
	}
}

void BPMDataLogger::cardInfo(void) {

	Sd2Card card = SD.card;
	SdVolume volume = SD.volume;
	SdFile root = SD.root;

	DBG_PRINT_LEVEL("\t\tCard type: ");
	switch (card.type()) {
	case SD_CARD_TYPE_SD1:
		DBG_PRINTLN_LEVEL("SD1");
		break;
	case SD_CARD_TYPE_SD2:
		DBG_PRINTLN_LEVEL("SD2");
		break;
	case SD_CARD_TYPE_SDHC:
		DBG_PRINTLN_LEVEL("SDHC");
		break;
	default:
		DBG_PRINTLN_LEVEL("CARD UNKNOW");
	}

	DBG_PRINT_LEVEL("\t\tClusters: ");
	DBG_PRINTLN_LEVEL(volume.clusterCount());
	DBG_PRINT_LEVEL("\t\tBlocks x Cluster: ");
	DBG_PRINTLN_LEVEL(volume.blocksPerCluster());
	DBG_PRINT_LEVEL("\t\tTotal Blocks: ");
	DBG_PRINTLN_LEVEL(volume.blocksPerCluster() * volume.clusterCount());
	DBG_PRINT_LEVEL("\t\tVolume type is: FAT");
	DBG_PRINTLN_LEVEL(volume.fatType(), DEC);
	uint32_t volumesize = volume.blocksPerCluster();
	volumesize *= volume.clusterCount();
	DBG_PRINT_LEVEL("\t\tVolume size (Kb): ");
	DBG_PRINTLN_LEVEL(volumesize /= 2);
	DBG_PRINT_LEVEL("\t\tVolume size (Mb): ");
	DBG_PRINTLN_LEVEL(volumesize /= 1024);
	DBG_PRINT_LEVEL("\t\tVolume size (Gb):  ");
	DBG_PRINTLN_LEVEL((float ) volumesize / 1024.0);
	DBG_PRINTLN_LEVEL("\t\tName\t\tDate\t\t   Size");
	DBG_PRINTLN_LEVEL(
			"\t\t-----------------------------------------------------");
	root.ls(LS_R | LS_DATE | LS_SIZE, 16);

}

void BPMDataLogger::write(char *format, ...) {
	char record[60];
	va_list args;
	va_start(args, format);
	vsnprintf(record, 80, format, args);
	va_end(args);
#if(DEBUG_LEVEL >= 3)
	DBG_PRINTLN_LEVEL(record);
#endif

	if (dataFile) {
		dataFile.println(record);
	}

}

void BPMDataLogger::write(RecordData data) {
	write((char*) RECORD_FORMAT, data.dateTime.day(), data.dateTime.month(),
			data.dateTime.year(), data.dateTime.hour(), data.dateTime.minute(),
			data.dateTime.second(), data.position.x, data.position.y,
			data.position.z, data.position.heigth, data.position.width,
			data.holePoke);
}

void BPMDataLogger::openFile(int id, DateTime dateTime) {
	fileIndex = id;
	setFileName((char*) FILE_NAME_FORMAT, id);
#if(DEBUG_LEVEL >= 3)
	DBG_PRINT_LEVEL("Open File ");
	DBG_PRINTLN_LEVEL(getFileName());
#endif
	// Abrindo Arquivo
	dataFile = SD.open(getFileName(), FILE_WRITE);
	write((char*) HEADER_FORMAT);
	dataFile.close();
	dataFile = SD.open(getFileName(), FILE_WRITE);
	if (dataFile) {
		fileIsOpen = true;
	}
	fileIsOpen = true;
}

void BPMDataLogger::closeFile(void) {
	if (fileIsOpen) {
#if(DEBUG_LEVEL >= 3)
		DBG_PRINT_LEVEL("Close File ");
		DBG_PRINTLN_LEVEL(getFileName());
#endif
		if (dataFile) {
			dataFile.close();
		}
	}
	fileIsOpen = false;
}

boolean BPMDataLogger::isFileOpen(void) {
	return fileIsOpen;
}

int BPMDataLogger::getFileIndex(void) {
	return fileIndex;
}

char* BPMDataLogger::getFileName(void) {
	return fileName;
}

void BPMDataLogger::setFileName(char *format, ...) {
	va_list args;
	va_start(args, format);
	vsnprintf(fileName, 13, format, args);
	va_end(args);
}
