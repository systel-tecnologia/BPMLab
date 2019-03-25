/*
 File  : BPMDataLogger.h
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel BPM Data Logger Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 SD Card Data Logger
 
 */

#ifndef _BPMDataLogger_H_
#define _BPMDataLogger_H_

#include <RTCLib.h>
#include <SD.h>
#include "BPMPositionSensor.h"

#define REMOTE_DEBUG  1
#define DTLOG_CS_PIN  10
#define DTLOG_D0_PIN  11
#define DTLOG_D1_PIN  12
#define DTLOG_CK_PIN  13

static const char* HEADER_FORMAT = "DATE\t\tTIME\t\tX\tY\tZ\tH\tW\tHP";
static const char* RECORD_FORMAT = "%.2d-%.2d-%.4d\t%.2d:%.2d:%.2d\t%.2d\t%.2d\t%.2d\t%.2d\t%.2d\t%.2d";
static const char* FILE_NAME_FORMAT = "BPMLOG%.2d.CSV";

struct RecordData {
		DateTime dateTime;
		PositionData position;
		int holePoke = 0;
};

// library interface description
class BPMDataLogger {
		// user-accessible "public" interface
	public:

		BPMDataLogger ();

		void start (void);

		void cardInfo (void);

		void write (RecordData data);

		void openFile (int id, DateTime dateTime);

		void closeFile (void);

		boolean isFileOpen (void);

		int getFileIndex (void);

		char* getFileName (void);

		// library-accessible "protected" interface
	protected:

		void setup (void);

		void write (char *format, ...);

		void setFileName (char *format, ...);

		// library-accessible "private" interface
	private:

		boolean fileIsOpen = false;

		int fileIndex = 0;

		char fileName[13];

		File dataFile;

};

#endif

