/*
 File  : BPMDataLogger.cpp
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel BPM Data Logger Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 SD Card Data Logger
 
 */

#include "BPMDataLogger.h"

#include <Equino.h>
#include <HardwareSerial.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <utility/Sd2Card.h>
#include <SD.h>
#include <utility/SdFat.h>
#include <WString.h>

#include "BPMExceptionHandler.h"

DateTime dt;

void setDateTime(uint16_t *date, uint16_t *time) {
	*date = FAT_DATE(dt.year(), dt.month(), dt.day());
	*time = FAT_TIME(dt.hour(), dt.minute(), dt.second());
}

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
	SD.root.dateTimeCallback(setDateTime);
	if (SD.begin(DTLOG_CS_PIN, DTLOG_D0_PIN, DTLOG_D1_PIN, DTLOG_CK_PIN)) {
#if(DEBUG_LEVEL >= 3)
		DBG_PRINTLN_LEVEL("\t\tReading SD Card Information...");
#endif
	} else {
		exceptionHandler.exceptionDetected(CARD_NOT_FOUND);
	}
}

void BPMDataLogger::write(int bufferSize, char *format, ...) {
	char record[bufferSize];
	va_list args;
	va_start(args, format);
	vsnprintf(record, bufferSize, format, args);
	va_end(args);
	Serial.println(record);
	dataFile.println(record);
}

void BPMDataLogger::write(unsigned long time, SensorData *data) {
	if (!((data->x[0] == '1' && data->x[8] == '1' && data->x[16] == '1'
			&& data->x[11] == '1')
			||

			(data->x[0] == '1' && data->x[8] == '1' && data->x[10] == '1'
					&& data->x[15] == '1' && data->y[0] == '1')
			||

			(data->x[0] == '1' && data->y[1] == '1' && data->y[5] == '1'))) {

		data->z[0] = '0';

		write(100, (char*) RECORD_FORMAT, time, data->x, data->y, data->z,
				data->h);
	}
}

void BPMDataLogger::openFile(int id, DateTime dateTime) {
	dt = dateTime;
	fileIndex = id;
	setFileName((char*) FILE_NAME_FORMAT, id);
#if(DEBUG_LEVEL >= 3)
	DBG_PRINT_LEVEL("Open File ");
	DBG_PRINTLN_LEVEL(getFileName());
#endif
	// Abrindo Arquivo
	dataFile = SD.open(getFileName(), FILE_WRITE);
	write(80, (char*) HEADER_FORMAT);
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

void BPMDataLogger::listFileNames(void) {
	SdFile root = SD.root;
	dir_t *p;
	root.rewind();
	while ((p = root.readDirCache())) {
		// done if past last used entry
		if (p->name[0] == DIR_NAME_FREE)
			break;

		// skip deleted entry and entries for . and  ..
		if (p->name[0] == DIR_NAME_DELETED || p->name[0] == '.')
			continue;

		// only list subdirectories and files
		if (!DIR_IS_FILE_OR_SUBDIR(p))
			continue;

		// print file name with possible blank fill
		root.printDirName(*p, 12);
		Serial.print(';');

		// print modify date/time if requested
		root.printFatDate(p->lastWriteDate);
		Serial.print(' ');
		root.printFatTime(p->lastWriteTime);

		// print size if requested
		if (!DIR_IS_SUBDIR(p)) {
			Serial.print(';');
			Serial.print(p->fileSize);
		}
		Serial.println(";0");
	}
}

void BPMDataLogger::cardInfo(void) {
	Sd2Card card = SD.card;
	SdVolume volume = SD.volume;
	Serial.print(card.type());
	Serial.print(";");
	Serial.print(volume.fatType(), DEC);
	Serial.print(";");
	Serial.print(card.cardSize() / 2048, DEC);
	Serial.print(";");
	Serial.println((card.cardSize() / 2048) / 2, DEC);
}

void BPMDataLogger::deleteFile(String name) {
	char *fn = name.c_str();
	if (SD.exists(fn)) {
		if (SD.remove(fn)) {
			Serial.println("FILEDELETED;" + name);
		}
	}
}

void BPMDataLogger::dumpFile(String name) {
	char *fn = name.c_str();
	Serial.println(fn);
	File file = SD.open((char*) fn, FILE_READ);
	while (file.available()) {
		Serial.write(file.read());
	}
	file.close();
}
