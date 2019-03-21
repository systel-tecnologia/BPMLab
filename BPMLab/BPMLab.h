/*
 File: Equino.h
 Version: 1.0
 Date: 05/03/2019
 Project: Systel Equino Library
 Author: Daniel Valentin - dtvalentin@gmail.com
 
 */

#ifndef _BPMLab_H_
#define _BPMLab_H_

#include <Arduino.h>
#include <AudioBuzzer.h>
#include <RTClib.h>
#include <TC.h>

#include "BPMConfigStorage.h"
#include "BPMDataLogger.h"
#include "BPMHolePokeSensor.h"
#include "BPMPositionSensor.h"

class BPMPage;

// Software Config Params
#define SERIAL_BOUND 		115200  	// Serial interface Bound rate
#define TMR_INTERVAL_ISR	100000		// Timer Interval 10ms

// Hardware Config Params
#define SOUND_PIN     		18 
#define RTC_INT_PIN   		19

enum StateMachine {
	STOPPED, RUNNING, DONE, CANCELED
};

// library interface description
class BPMLab {
		// user-accessible "public" interface
	public:

		BPMLab ();

		void update (void);

		void write (void);

		void setup (void);

		void stop (void);

		void start (void);

		void done (void);

		void cancel (void);

		void run (void);

		void gotoPage (BPMPage *page);

		DateTime getCurrenteDateTime (boolean throwException);

		TimeSpan getElapsedTime ();

		int getCurrentProgress ();

		boolean isRunning ();

		boolean isProcessDone ();

		boolean isProcessCanceled ();

		RTCDs1307 rtc; // @suppress("Abstract class cannot be instantiated")

		AudioBuzzer audio;

		BPMPositionSensor positionSensor;

		BPMHolePokeSensor holePokeSensor;

		BPMDataLogger dataLogger;

		BPMConfigStorage configStorage;

		ConfigurationData configuration;

		// library-accessible "protected" interface
	protected:

		// library-accessible "private" interface
		void calculateElapsedTime (DateTime currentDateTime);

	private:

		boolean writeData = false;

		boolean updateDisplay = false;

		int currentProgress = 0;

		DateTime startDateTime = new DateTime();

		TimeSpan elapsedTime = TimeSpan(0, 0, 0, 0);

		TimeSpan endTime = TimeSpan(0, 0, 0, 0);

		StateMachine state = STOPPED;
};

extern BPMLab bpmLab;

#endif
