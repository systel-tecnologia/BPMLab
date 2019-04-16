/*
 File  : BPMUserInterface.cpp
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel BPM Data Logger Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 LCD Startup & BPM User Interface
 
 */
#include <Arduino.h>
#include <Equino.h>
#include <Adafruit_GFX.h>
#include <TouchScreen.h>
#include <TimeDevice.h>
#include "BPMLab.h"
#include "BPMUserInterface.h"

UTFTGLUE tft(LCD_MD, LCD_CD, LCD_WR, LCD_CS, LCD_RS, LCD_RD);
BPMUserInterface userInterface;

void BPMUserInterface::start (void) {
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\tStarting BPM LCD & User Interface...");
#endif
	setup();
#if(DEBUG_LEVEL >= 2)
	DBG_PRINTLN_LEVEL("\t\tLCD & User Interface Started...");
#endif
}

void BPMUserInterface::setup (void) {
#if(DEBUG_LEVEL >= 3)
	DBG_PRINTLN_LEVEL("\t\tDisplay TFT Initialized...");
#endif
	tft.InitLCD();
	tft.setRotation(PORTRAIT);
	tft.fillScreen(BLACK);
}

void BPMUserInterface::updateDisplay (void) {
	if (activePage) {
		activePage->refresh();
	}
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t\tUpdating Display...");
#endif	
}

void BPMUserInterface::showPage (BPMPage *page) {
	activePage = page;
	if (activePage) {
		tft.clrScr();
		activePage->show();
	}
}

void BPMUserInterface::readTouch (void) {
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t\tTouch Input Data Received...");
#endif
	if (getTouchPosition()) {
		bpmLab.audio.info(LEVEL_100, 1);
		if (activePage) {
			activePage->touch(pixel_x, pixel_y, TS_PRESSED);
			activePage->touch(pixel_x, pixel_y, TS_RELEASED);
		}
	}
}

bool BPMUserInterface::getTouchPosition (void) {
	TSPoint p = ts.getPoint();
	pinMode(YP, OUTPUT);      //restore shared pins
	pinMode(XM, OUTPUT);
	digitalWrite(YP, HIGH);   //because TFT control pins
	digitalWrite(XM, HIGH);
	bool pressed = (p.z > MINPRESSURE && p.z < MAXPRESSURE);
	if (pressed) {
		pixel_x = map(p.x, TS_LEFT, TS_RT, 0, tft.width()); //.kbv makes sense to me
		pixel_y = map(p.y, TS_TOP, TS_BOT, 0, tft.height());
	}
	return pressed;
}

