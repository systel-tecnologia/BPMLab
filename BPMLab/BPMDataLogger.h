/*
 File  : BPMDataLogger.h
 Version : 2.0
 Date  : 30/08/2019
 Project : Systel BPM Data Logger Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 SD Card Data Logger
 
 */

#ifndef _BPMDataLogger_H_
#define _BPMDataLogger_H_

#include <Arduino.h>
#include <RTCLib.h>
#include <SD.h>
#include "BPMPositionSensor.h"

#define DTLOG_CS_PIN  10
#define DTLOG_D0_PIN  11
#define DTLOG_D1_PIN  12
#define DTLOG_CK_PIN  13

static const char* HEADER_FORMAT = "TIME;X;Y;Z;HP";
static const char* RECORD_FORMAT = "%ld;'%s;'%s;'%s;'%s";
static const char* FILE_NAME_FORMAT = "BPM%.5d.CSV";

// library interface description
class BPMDataLogger {
		// user-accessible "public" interface
	public:

		BPMDataLogger ();

		void start (void);

		void write(unsigned long time, SensorData* data);

		void openFile (int id, DateTime dateTime);

		void closeFile (void);

		boolean isFileOpen (void);

		int getFileIndex (void);

		char* getFileName (void);

		void listFileNames(void);

		void cardInfo (void);

		void deleteFile(String name);

		void dumpFile(String name);

		// library-accessible "protected" interface
	protected:

		void setup (void);

		void write (int bufferSize, char *format, ...);

		void setFileName (char *format, ...);

		// library-accessible "private" interface
	private:

		boolean fileIsOpen = false;

		int fileIndex = 0;

		char fileName[13];

		File dataFile;

};

#endif

