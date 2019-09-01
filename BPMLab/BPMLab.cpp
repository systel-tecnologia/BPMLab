/*
 File: BPMLab.cpp
 Version: 1.0
 Date: 16/03/2019
 Project: Systel BPM Application
 Author: Daniel Valentin - dtvalentin@gmail.com

 */
#include <Arduino.h>
#include <AudioMessageDevice.h>
#include "BPMLab.h"

#include "BPMExceptionHandler.h"
#include "BPMUserInterface.h"

BPMLab bpmLab;
unsigned long previousMillis = 0;        // will store last time LED was updated
const long interval = 1000;					// constants won't change:

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

void BPMLab::setup(void) {
	// Starting Output Audio Devide
	pinMode(SOUND_CTRL_PIN, OUTPUT);
	digitalWrite(SOUND_CTRL_PIN, LOW);
	audio.start(SOUND_PIN);

	// Starting RTC
	rtc.start();
	//rtc.setup(DateTime(F(__DATE__), F(__TIME__)));
	DateTime now = getCurrenteDateTime(true);

#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("Starting BPM Lab Devices and System...");
#endif

	// Starting Configuration Storage Device
	configStorage.start();
	configuration = configStorage.load();

	// Starting User Interface Display
	userInterface.start();
	gotoPage(&logoPage);
	delay(3000);

	// Starting Data Logger Device
	dataLogger.start();

	// Starting Position Sensor Grid
	positionSensor.start();

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

	userInterface.readTouch();
	unsigned long currentMillis = millis();
	if ((currentMillis - previousMillis) >= interval) {
		previousMillis = currentMillis;
		updateDisplay = true;
	}

	if (isRunning()) {
		// Datalog Processs
		if (!updateDisplay) {
			SensorData data = positionSensor.read();
			dataLogger.write((currentMillis - startTimeMillis), &data);
		} else {
			DateTime now = rtc.now();
			calculateElapsedTime(now);
			userInterface.updateDisplay();
		}
	} else {
		// Requests Process
		if (isConnected()) {
			answersRequests();
		} else if (isWaitConnection()) {
			listeningConnections();
		}
		if (updateDisplay) {
			userInterface.updateDisplay();
		}
	}
	updateDisplay = false;

}

void BPMLab::stop(void) {
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
	startTimeMillis = millis();
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
	connected = true;
}

void BPMLab::disconnect(void) {
#if(DEBUG_LEVEL >= 3)
	DBG_PRINTLN_LEVEL("\tBPM Disconnected Success...");
#endif
	connected = false;
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
	return connected;
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

boolean BPMLab::checkDateTimeError(DateTime dateTime) {
	return (dateTime.day() > 31 || dateTime.month() > 12
			|| dateTime.second() > 59 || dateTime.minute() > 59
			|| dateTime.hour() > 23);
}

DateTime BPMLab::getCurrenteDateTime(boolean throwException) {
	DateTime now = rtc.now();
	boolean error = checkDateTimeError(now);

	if (!throwException) {
		while (error) {
			error = checkDateTimeError(now);
		}
	} else {
		if (isRunning()) {
			stop();
		}
		if (error) {
			exceptionHandler.exceptionDetected(TIME_CLOCK_ERROR);
			gotoPage(&exceptionPage);
		}
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

