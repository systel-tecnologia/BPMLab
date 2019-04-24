/*
 File: BPMLab.cpp
 Version: 1.0
 Date: 16/03/2019
 Project: Systel BPM Application
 Author: Daniel Valentin - dtvalentin@gmail.com

 */
#include <Arduino.h>
#include <AudioMessageDevice.h>
#include <TimerThree.h>
#include "BPMLab.h"

#include "BPMExceptionHandler.h"
#include "BPMUserInterface.h"

BPMLab bpmLab;

void setup(void) {

	Serial.begin(SERIAL_BOUND);
	while (!Serial) {
		; // wait for serial port to connect. Needed for native USB port only
	}
	if (Serial) {
		Serial.println("Serial Communication Started...");
	}

	// BPM Lab Start Point
	bpmLab.setup();

}

void loop(void) {
	// Main Execution
	bpmLab.run();
}

void rtcIsr() {
	bpmLab.update();
}

void timerIsr() {
	bpmLab.write();
}

BPMLab::BPMLab() {

}

void BPMLab::setup(void) {
	// Starting Output Audio Devide
	pinMode(SOUND_CTRL_PIN, OUTPUT);
	digitalWrite(SOUND_CTRL_PIN, LOW);
	audio.start(SOUND_PIN);

	// Starting RTC
	rtc.start();
	DateTime now = rtc.now();
	if (now.day() > 31) {
		exceptionHandler.exceptionDetected(TIME_CLOCK_ERROR);
	}

#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("Starting BPM Lab Devices and System...");
#endif

	// Starting Position Sensor Grid
	configStorage.start();
	configuration = configStorage.load();

	// Starting Position Sensor Grid
	userInterface.start();
	gotoPage(&logoPage);
	delay(3000);

	// Starting Position Sensor Grid
	dataLogger.start();

	// Starting Position Sensor Grid
	positionSensor.start();

	// Starting Position Sensor Grid
	holePokeSensor.start();

	// Start Interrupts
	attachInterrupt(digitalPinToInterrupt(RTC_INT_PIN), rtcIsr, CHANGE);
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\tBPM All Interrupts Started...");
#endif

	// Start Timer
	Timer3.initialize(TMR_INTERVAL_ISR); // @suppress("Method cannot be resolved")
	Timer3.attachInterrupt(timerIsr); // @suppress("Method cannot be resolved")
#if(DEBUG_LEVEL >= 2)
	DBG_PRINT_LEVEL("\tBPM Pooling TIMER 3 Started to ");
	DBG_PRINT_LEVEL(TMR_INTERVAL_ISR / 1000);
	DBG_PRINTLN_LEVEL("ms...");
#endif

	stop();

	// System state
	if (!exceptionHandler.hasException()) {
		audio.info(LEVEL_100, 1);
#if(DEBUG_LEVEL >= 2)
		DBG_PRINTLN_LEVEL("BPM Lab Devices Started...");
		DBG_PRINTLN_LEVEL("BPM System Running...");
#endif
		gotoPage(&mainPage);
	} else {
		gotoPage(&exceptionPage);
	}

	listen();
}

void BPMLab::run() {
	if (isRunning() && writeData) {
		// Datalog Processs
		RecordData record;
		DateTime now = getCurrenteDateTime(false);
		record.dateTime = now;
		record.position = positionSensor.read();
		record.holePoke = holePokeSensor.read();
		dataLogger.write(record);
		calculateElapsedTime(now);
		writeData = false;
	} else {
		// Requests Process
		if (isConnected()) {
			answersRequests();
		} else if (isWaitConnection()) {
			listeningConnections();
		}
	}

	// Update Display Data
	if (isRefreshRateMatchs()) {
		userInterface.updateDisplay();
		updateDisplay = false;
	}
	userInterface.readTouch();

}

void BPMLab::stop(void) {
	writeData = false;
	state = STOPPED;
	positionSensor.clear();
	dataLogger.closeFile();
}

void BPMLab::start(void) {
	updateDisplay = true;
	currentProgress = 0;
	elapsedTime = TimeSpan(0);
	endTime = TimeSpan(configuration.totalProcessSeconds);
	startDateTime = rtc.now();
	calculateElapsedTime(startDateTime);
	if (!dataLogger.isFileOpen()) {
		dataLogger.openFile(configuration.fileIndex++, startDateTime);
		configuration.modified = 1;
		configStorage.save(configuration);
	}
	state = RUNNING;
	updateDisplay = false;
}

void BPMLab::cancel(void) {
	positionSensor.clear();
	state = CANCELED;
	dataLogger.closeFile();
}

void BPMLab::done(void) {
	positionSensor.clear();
	state = DONE;
	dataLogger.closeFile();
}

void BPMLab::listen(void) {
#if(DEBUG_LEVEL >= 3)
	DBG_PRINTLN_LEVEL("\tBPM Lab Waiting for Connections...");
#endif
	state = WAIT_CONECTION;
}

void BPMLab::connect(void) {
#if(DEBUG_LEVEL >= 3)
	DBG_PRINTLN_LEVEL("\tBPM Connection Success. Wait for commands...");
#endif
	state = CONNECTED;
}

void BPMLab::close(void) {
	reset();
}

void BPMLab::reset(void) {
	digitalWrite(LCD_RS, HIGH);
}

boolean BPMLab::isRunning(void) {
	return (state == RUNNING);
}
boolean BPMLab::isProcessDone(void) {
	return (state == DONE);
}

boolean BPMLab::isProcessCanceled() {
	return (state == CANCELED);
}

boolean BPMLab::isWaitConnection() {
	return (state == WAIT_CONECTION);
}

boolean BPMLab::isConnected() {
	return (state == CONNECTED);
}

boolean BPMLab::isRefreshRateMatchs(void) {
	if (isRunning()) {
		return updateDisplay && !writeData;
	}
	return updateDisplay;
}

void BPMLab::answersRequests(void) {
	if (Serial.available() > 0) {
		String command = Serial.readString();
#if(DEBUG_LEVEL >= 3)
		DBG_PRINT_LEVEL("\tBPM Lab Receive Request Command (");
		DBG_PRINT_LEVEL(command);
		DBG_PRINTLN_LEVEL(")...");
#endif
		commandProcessor.execute(command);
	}

}

void BPMLab::listeningConnections(void) {
	if (Serial.available() > 0) {
		String data = Serial.readString();
#if(DEBUG_LEVEL >= 3)
		DBG_PRINT_LEVEL("\tBPM Lab Receive Connection Code :");
		DBG_PRINTLN_LEVEL(data);
#endif
		if (commandProcessor.isAutorizationCode(data)) {
			gotoPage(&commPage);
			connect();
		} else {
#if(DEBUG_LEVEL >= 3)
			DBG_PRINTLN_LEVEL("\tBPMLab Autorization Code is not valid...");
#endif
		}
	}
}

DateTime BPMLab::getCurrenteDateTime(boolean throwException) {
	int i = 0;
	DateTime now = rtc.now();
	while (now.day() > 31) {
		now = rtc.now();
		i++;
		if (i > 5) {
			break;
		}
	}
	if (now.day() > 31 && throwException) {
		if (isRunning()) {
			stop();
		}
		exceptionHandler.exceptionDetected(TIME_CLOCK_ERROR);
		gotoPage(&exceptionPage);
	}
	return now;
}

void BPMLab::calculateElapsedTime(DateTime currentDateTime) {
	uint32_t t1 = elapsedTime.totalseconds();
	uint32_t t2 = endTime.totalseconds();
	int32_t newProgress = map(t1, 0, t2, 0, 100);
	currentProgress = newProgress;
	if (t1 >= t2) {
		elapsedTime = endTime;
		currentProgress = 100;
		userInterface.updateDisplay();
		done();
	}
	elapsedTime = (currentDateTime - startDateTime);
}

int BPMLab::getCurrentProgress(void) {
	return currentProgress;
}

TimeSpan BPMLab::getElapsedTime(void) {
	return elapsedTime;
}

void BPMLab::gotoPage(BPMPage *page) {
	userInterface.showPage(page);
}

void BPMLab::update(void) {
	if (!updateDisplay) {
		updateDisplay = true;
	}
}

void BPMLab::write(void) {
	if (!writeData) {
		writeData = true;
	}
}
