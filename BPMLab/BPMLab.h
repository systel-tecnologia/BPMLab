/*
 File: BPMLab.h
 Version: 1.0
 Date: 16/03/2019
 Project: Systel BPM Application
 Author: Daniel Valentin - dtvalentin@gmail.com

 */

#ifndef _BPMLab_H_
#define _BPMLab_H_

#include <Arduino.h>
#include <AudioBuzzer.h>
#include <RTClib.h>
#include <TimeDevice.h>

#include "BPMCommandProcessor.h"
#include "BPMConfigStorage.h"
#include "BPMDataLogger.h"
#include "BPMPositionSensor.h"

class BPMPage;

// Software Config Params
#define SERIAL_BOUND 		115200  	// Serial interface Bound rate

// Hardware Config Params
#define SOUND_CTRL_PIN 		17
#define SOUND_PIN     		18 
#define RTC_INT_PIN   		19

enum StateMachine {
	STOPPED, RUNNING, DONE, CANCELED, WAIT_CONECTION, CONNECTED
};

// library interface description
class BPMLab {
		// user-accessible "public" interface
	public:

		void update (void);

		void setup (void);

		void stop (void);

		void start (void);

		void done (void);

		void cancel (void);

		void run (void);

		void listen (void);

		void connect (void);

		void disconnect (void);

		void close (void);

		void reset (void);

		boolean isRunning (void);

		boolean isProcessDone (void);

		boolean isProcessCanceled (void);

		boolean isConnected (void);

		boolean isWaitConnection (void);

		void gotoPage (BPMPage *page);

		int getCurrentProgress (void);

		DateTime getCurrenteDateTime (boolean throwException);

		TimeSpan getElapsedTime (void);

		RTCDs1307 rtc; // @suppress("Abstract class cannot be instantiated")

		AudioBuzzer audio;

		BPMPositionSensor positionSensor;

		BPMDataLogger dataLogger;

		BPMConfigStorage configStorage;

		ConfigurationData configuration;

		BPMCommandProcessor commandProcessor;

		// library-accessible "protected" interface
	protected:

		// library-accessible "private" interface
		void calculateElapsedTime (DateTime currentDateTime);

		void answersRequests (void);

		void listeningConnections (void);

		boolean checkDateTimeError(DateTime dateTime);

	private:

		unsigned long startTimeMillis = 0;

		boolean updateDisplay = false;

		boolean connected = false;

		int32_t currentProgress = 0;

		DateTime startDateTime;

		TimeSpan elapsedTime = TimeSpan(0, 0, 0, 0);

		TimeSpan endTime = TimeSpan(0, 0, 0, 0);

		StateMachine state = STOPPED;
};

extern BPMLab bpmLab;

#endif
