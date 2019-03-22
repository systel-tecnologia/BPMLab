/*
 File  : BPMPages.cpp
 Version : 1.0
 Date  : 17/03/2019
 Project : Systel BPM Pages Implementation Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com

 GUI Pages
 */

#include <Arduino.h>
#include <stdarg.h>
#include <RTCLib.h>
#include "BPMLab.h"
#include "BPMIcons.h"
#include "BPMUserInterface.h"
#include "BPMExceptionHandler.h"

// States
static const char* started_label = " Started";
static const char* canceled_label = "Canceled";
static const char* done_label = "  Done  ";

// Labels
static const char* start_label = "Start";
static const char* setup_label = "Setup";
static const char* cancel_label = "Cancel";
static const char* comm_label = "Connect";

// Formats
static const char* DATE_FORMAT = "%.2d/%.2d/%.4d";
static const char* TIME_FORMAT = "%.2d:%.2d:%.2d";

// Icons
uint8_t const *icons[] = { sdCard, sensorGrid, holePokeGrid, realTimeClock };

BPMExceptionPage exceptionPage;
BPMLogoPage logoPage;
BPMMainPage mainPage;
BPMProcessPage processPage;
BPMSetupPage setupPage;
BPMCommPage commPage;

// Generic BPM Page

void BPMPage::show (void) {
	tft.fillScreen(BLACK);
	drawIcon(15, 10, bpmLogo, 209, 72, WHITE);
}

void BPMPage::navigateTo (BPMPage *page) {
	bpmLab.gotoPage(page);
}

void BPMPage::drawIcon (int16_t x, int16_t y, const uint8_t *icon, int16_t w, int16_t h, uint16_t color) {
	int16_t i, j, byteWidth = (w + 7) / 8;
	uint8_t byte;
	for (j = 0; j < h; j++) {
		for (i = 0; i < w; i++) {

			if (i & 7)
				byte <<= 1;
			else
				byte = pgm_read_byte(icon + j * byteWidth + i / 8);

			tft.setColor(color);

			if (byte & 0x80) {
				tft.drawPixel(x + i, y + j);
			}
		}
	}
}

void BPMPage::print (int x, int y, char* format, int size, ...) {
	char record[size];
	va_list args;
	va_start(args, format);
	vsnprintf(record, size, format, args);
	va_end(args);
	tft.print(record, x, y);
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL(record);
#endif
}

// BPM Exception Page
void BPMExceptionPage::show (void) {
	ExceptionData exceptionData = exceptionHandler.throwException();
	tft.fillScreen(RED);
	drawIcon(15, 10, bpmLogo, 209, 72, WHITE);
	uint16_t color = WHITE;
	tft.setTextColor(WHITE, RED);
	tft.setTextSize(FONT_SIZE_20);
	tft.print(exceptionData.exceptionMessage, exceptionData.msg_x, exceptionData.msg_y);
	if (exceptionData.isIconColorBlack) {
		color = BLACK;
		tft.setColor(WHITE);
		tft.fillRect(65, 250, 175, 175);
	}
	drawIcon(60, 170, icons[exceptionData.exceptionCode - 1], 120, 90, color);
	bpmLab.audio.error(LEVEL_100, 5);
#if(DEBUG_LEVEL >= 3)
	DBG_PRINTLN_LEVEL("\t\t\tSystem Halted...");
#endif
	while (true) {
		;
	};
}

// BPM Logo Page
void BPMLogoPage::show (void) {
	tft.fillScreen(WHITE);
	drawIcon(15, 70, bpmLogo, 209, 72, BLUE);
	tft.setTextColor(BLUE, WHITE);
	tft.setTextSize(FONT_SIZE_40);
	tft.print("V1.0", 70, 180);
	tft.setTextSize(FONT_SIZE_20);
	tft.print("Starting...", 65, 250);
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t\tShow BPM Lab Logo...");
#endif
}

// BPM Main Page
void BPMMainPage::show (void) {
	BPMPage::show();
	start_btn.initButton(&tft, 120, 150, 200, 50, BLACK, BLUE, WHITE, (char*) start_label, FONT_SIZE_20);
	setup_btn.initButton(&tft, 120, 215, 200, 50, BLACK, BLUE, WHITE, (char*) setup_label, FONT_SIZE_20);
	comm_btn.initButton(&tft, 120, 280, 200, 50, BLACK, BLUE, WHITE, (char*) comm_label, FONT_SIZE_20);
	start_btn.drawButton(false);
	setup_btn.drawButton(false);
	comm_btn.drawButton(false);
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t\tShow BPM Page Main...");
#endif
}

void BPMMainPage::refresh (void) {
	updateDateTime(bpmLab.getCurrenteDateTime(true));
}

void BPMMainPage::updateDateTime (DateTime dateTime) {
	tft.setTextColor(GREEN, BLACK);
	tft.setTextSize(FONT_SIZE_20);
	print(10, 95, (char*) DATE_FORMAT, 12, dateTime.day(), dateTime.month(), dateTime.year());
	print(137, 95, (char*) TIME_FORMAT, 12, dateTime.hour(), dateTime.minute(), dateTime.second());
}

void BPMMainPage::touch (int pixel_x, int pixel_y, TouchState state) {
	if (start_btn.contains(pixel_x, pixel_y)) {
		start_btn.press(state == TS_PRESSED);
		if (start_btn.justPressed()) {
			start_btn.drawButton(true);
		} else {
			start_btn.drawButton(false);
			bpmLab.start();
			navigateTo(&processPage);
		}
	} else {
		if (setup_btn.contains(pixel_x, pixel_y)) {
			setup_btn.press(state == TS_PRESSED);
			if (setup_btn.justPressed()) {
				setup_btn.drawButton(true);
			} else {
				setup_btn.drawButton(false);
				navigateTo(&setupPage);
			}
		} else
			if (comm_btn.contains(pixel_x, pixel_y)) {
				comm_btn.press(state == TS_PRESSED);
				if (comm_btn.justPressed()) {
					comm_btn.drawButton(true);
				} else {
					comm_btn.drawButton(false);
					navigateTo(&commPage);
				}
			}
	}
}

// BPM Process Page
void BPMProcessPage::show (void) {
	tft.clrScr();
	tft.setBackColor(BLACK);
	previousValue = 0;

	// Update Elapsede Time
	updateDateTime(bpmLab.getElapsedTime());

	// Draw Ring Meter
	drawRing(24, 45, 90, 10, YELLOW);

	// Print current percentual and states
	updateStates();

	// Print state started
	tft.setTextSize(FONT_SIZE_20);
	tft.setTextColor(YELLOW, BLACK);
	tft.print(started_label, 69, 185);

	// Draw Cancel btn
	initializeCancelBtn((char*) cancel_label);
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t\tShow BPM Process Page...");
#endif
}

void BPMProcessPage::refresh (void) {
	if (bpmLab.isRunning()) {
		updateDateTime(bpmLab.getElapsedTime());
		currentValue = bpmLab.getCurrentProgress();
		if ((currentValue == 0) || (previousValue != currentValue)) {
			updateStates();
			previousValue = currentValue;
		}
	}
}

void BPMProcessPage::touch (int pixel_x, int pixel_y, TouchState state) {
	if (cancel_btn.contains(pixel_x, pixel_y)) {
		cancel_btn.press(state == TS_PRESSED);
		if (cancel_btn.justPressed()) {
			cancel_btn.drawButton(true);
		} else {
			if (bpmLab.isRunning() && currentValue < 100) {
				bpmLab.cancel();
				// Draw Ring Meter
				drawRing(24, 45, 90, 10, RED);
				tft.setTextSize(FONT_SIZE_20);
				tft.setTextColor(RED, BLACK);
				tft.print(canceled_label, 78, 185);
				initializeCancelBtn((char *) done_label);
			} else {
				navigateTo(&mainPage);
			}
		}
	}
}

void BPMProcessPage::updateStates (void) {
	tft.setTextColor(WHITE, BLACK);
	int offset = 0;
	if (currentValue >= 10)
		offset = 7;
	if (currentValue >= 100) {
		offset = 15;
		tft.setTextColor(GREEN, BLACK);
	}
	tft.setTextSize(FONT_SIZE_40);
	print(67 + offset, 110, "%3d%c", 8, currentValue, '%');

	if (currentValue == 100) {
		// Draw Ring Meter
		drawRing(24, 45, 90, 10, GREEN);
		tft.setTextSize(FONT_SIZE_20);
		tft.setTextColor(GREEN, BLACK);
		tft.print(done_label, 75, 185);
		initializeCancelBtn((char*) done_label);
	}

}

void BPMProcessPage::updateDateTime (TimeSpan time) {
	tft.setTextColor(GREEN, BLACK);
	tft.setTextSize(FONT_SIZE_30);
	print(55, 10, (char*) TIME_FORMAT, 12, time.hours(), time.minutes(), time.seconds());
}

void BPMProcessPage::drawRing (int x, int y, int r, int t, uint16_t color) {
	drawIcon(x, y, timerGauge, 201, 201, color);
}

void BPMProcessPage::initializeCancelBtn (char* label) {
	cancel_btn.initButton(&tft, 120, 285, 200, 50, BLACK, BLUE, WHITE, label, FONT_SIZE_20);
	cancel_btn.drawButton(false);
}

// BPM Setup Page
void BPMSetupPage::show (void) {
	BPMPage::show();
}

// BPM Setup Page
void BPMCommPage::show (void) {
	BPMPage::show();
}
