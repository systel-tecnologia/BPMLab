/*
 File  : BPMPages.cpp
 Version : 1.0
 Date  : 17/03/2019
 Project : Systel BPM Pages Implementation Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com

 GUI Pages
 */

#include <avr/pgmspace.h>
#include <Arduino.h>
#include <AudioMessageDevice.h>
#include <Adafruit_GFX.h>
#include <Equino.h>
#include <MCUFRIEND_kbv.h>
#include <RTClib.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <UTFTGLUE.h>

#include "BPMExceptionHandler.h"
#include "BPMIcons.h"
#include "BPMLab.h"
#include "BPMUserInterface.h"

// States
static const char* started_label = " Started";
static const char* canceled_label = "Canceled";
static const char* done_label = "  Done  ";
static const char* wait_label = "Running Process...";
static const char* conn_label = " BPMLab Connected ";
static const char* pros_label = "Process Time Setup";
static const char* unit_label = "( Minutes )";

// Labels
static const char* start_label = "Start";
static const char* setup_label = "Setup";
static const char* cancel_label = "Cancel";
static const char* comm_label = "Connect";
static const char* next_label = "+";
static const char* prev_label = "-";
static const char* save_label = "Save";

// Formats
static const char* DATE_FORMAT = "%.2d/%.2d/%.4d";
static const char* TIME_FORMAT = "%.2d:%.2d:%.2d";

// Icons
uint8_t const *icons[] = { sdCard, sensorGrid, holePokeGrid, realTimeClock };

// Times
int minutes[6] = { 3, 15, 30, 60, 90, 120 };

BPMExceptionPage exceptionPage;
BPMLogoPage logoPage;
BPMMainPage mainPage;
BPMProcessPage processPage;
BPMSetupPage setupPage;
BPMCommPage commPage;

// Generic BPM Page

void BPMPage::show(void) {
	tft.fillScreen(BLACK);
	drawIcon(15, 10, bpmLogo, 209, 72, WHITE);
}

void BPMPage::navigateTo(BPMPage *page) {
	bpmLab.gotoPage(page);
}

void BPMPage::drawIcon(int16_t x, int16_t y, const uint8_t *icon, int16_t w,
		int16_t h, uint16_t color) {
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

void BPMPage::print(int x, int y, char* format, int size, ...) {
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
void BPMExceptionPage::show(void) {
	ExceptionData exceptionData = exceptionHandler.throwException();
	tft.fillScreen(RED);
	drawIcon(15, 10, bpmLogo, 209, 72, WHITE);
	uint16_t color = WHITE;
	tft.setTextColor(WHITE, RED);
	tft.setTextSize(FONT_SIZE_20);
	tft.print(exceptionData.exceptionMessage, exceptionData.msg_x,
			exceptionData.msg_y);
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
void BPMLogoPage::show(void) {
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
void BPMMainPage::show(void) {
	BPMPage::show();
	start_btn.initButton(&tft, 120, 150, 200, 50, BLACK, BLUE, WHITE,
			(char*) start_label, FONT_SIZE_20);
	setup_btn.initButton(&tft, 120, 215, 200, 50, BLACK, BLUE, WHITE,
			(char*) setup_label, FONT_SIZE_20);
	comm_btn.initButton(&tft, 120, 280, 200, 50, BLACK, BLUE, WHITE,
			(char*) comm_label, FONT_SIZE_20);
	start_btn.drawButton(false);
	setup_btn.drawButton(false);
	comm_btn.drawButton(true);
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t\tShow BPM Page Main...");
#endif
}

void BPMMainPage::refresh(void) {
	updateDateTime(bpmLab.getCurrenteDateTime(true));
}

void BPMMainPage::updateDateTime(DateTime dateTime) {
	tft.setTextColor(GREEN, BLACK);
	tft.setTextSize(FONT_SIZE_20);
	print(10, 95, (char*) DATE_FORMAT, 12, dateTime.day(), dateTime.month(),
			dateTime.year());
	print(137, 95, (char*) TIME_FORMAT, 12, dateTime.hour(), dateTime.minute(),
			dateTime.second());
}

void BPMMainPage::touch(int pixel_x, int pixel_y, TouchState state) {
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
		} /*else if (comm_btn.contains(pixel_x, pixel_y)) {
		 comm_btn.press(state == TS_PRESSED);
		 if (comm_btn.justPressed()) {
		 comm_btn.drawButton(true);
		 } else {
		 comm_btn.drawButton(false);
		 navigateTo(&commPage);
		 }
		 }*/
	}
}

// BPM Process Page
void BPMProcessPage::show(void) {
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
	tft.print(started_label, 69, 169);

	// Draw Cancel btn
	initializeCancelBtn((char*) cancel_label);
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t\tShow BPM Process Page...");
#endif
}

void BPMProcessPage::refresh(void) {
	if (bpmLab.isRunning()) {
		updateDateTime(bpmLab.getElapsedTime());
		currentValue = bpmLab.getCurrentProgress();
		if ((currentValue == 0) || (previousValue != currentValue)) {
			updateStates();
			previousValue = currentValue;
		}
	}
}

void BPMProcessPage::touch(int pixel_x, int pixel_y, TouchState state) {
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
				tft.print(canceled_label, 78, 169);
				initializeCancelBtn((char *) done_label);
			} else {
				navigateTo(&mainPage);
			}
		}
	}
}

void BPMProcessPage::updateStates(void) {
	tft.setTextColor(WHITE, BLACK);
	int offset = 0;
	if (currentValue >= 10)
		offset = 7;
	if (currentValue >= 100) {
		offset = 15;
		tft.setTextColor(GREEN, BLACK);
	}
	tft.setTextSize(FONT_SIZE_40);
	print(62 + offset, 110, "%3d%c", 8, currentValue, '%');

	if (currentValue == 100) {
		// Draw Ring Meter
		drawRing(24, 45, 90, 10, GREEN);
		tft.setTextSize(FONT_SIZE_20);
		tft.setTextColor(WHITE, BLACK);
		tft.print(done_label, 75, 169);
		initializeCancelBtn((char*) done_label);
	}

}

void BPMProcessPage::updateDateTime(TimeSpan time) {
	tft.setTextColor(GREEN, BLACK);
	tft.setTextSize(FONT_SIZE_30);
	print(55, 10, (char*) TIME_FORMAT, 12, time.hours(), time.minutes(),
			time.seconds());
}

void BPMProcessPage::drawRing(int x, int y, int r, int t, uint16_t color) {
	drawIcon(x, y, timerGauge, 195, 195, color);
}

void BPMProcessPage::initializeCancelBtn(char* label) {
	cancel_btn.initButton(&tft, 120, 275, 200, 50, BLACK, BLUE, WHITE, label,
	FONT_SIZE_20);
	cancel_btn.drawButton(false);
}

// BPM Setup Page
void BPMSetupPage::show(void) {
	BPMPage::show();
	setTimeIndex();
	tft.setTextColor(GREEN, BLACK);
	tft.setTextSize(FONT_SIZE_20);
	tft.print(pros_label, 15, 95);
	tft.setTextSize(FONT_SIZE_10);
	tft.print(unit_label, 90, 120);
	tft.setTextSize(FONT_SIZE_20);

	prev_btn.initButton(&tft, 50, 185, 75, 75, BLACK, BLUE, WHITE,
			(char*) prev_label, FONT_SIZE_20);
	next_btn.initButton(&tft, 190, 185, 75, 75, BLACK, BLUE, WHITE,
			(char*) next_label, FONT_SIZE_20);

	save_btn.initButton(&tft, 65, 280, 100, 50, BLACK, BLUE, WHITE,
			(char*) save_label, FONT_SIZE_20);
	cancel_btn.initButton(&tft, 175, 280, 100, 50, BLACK, BLUE, WHITE,
			(char*) cancel_label, FONT_SIZE_20);

	prev_btn.drawButton(false);
	next_btn.drawButton(false);
	save_btn.drawButton(false);
	cancel_btn.drawButton(false);
}

void BPMSetupPage::setTimeIndex(void) {
	for (int i = 0; i < sizeof(minutes); i++) {
		if (minutes[i] == abs(bpmLab.configuration.totalProcessSeconds / 60)) {
			timeIndex = i;
			break;
		}
	}
}

void BPMSetupPage::refresh(void) {
	tft.setTextColor(WHITE, BLACK);
	print(95, 175, " %3d", 8, minutes[timeIndex]);
}

void BPMSetupPage::touch(int pixel_x, int pixel_y, TouchState state) {
	if (prev_btn.contains(pixel_x, pixel_y)) {
		prev_btn.press(state == TS_PRESSED);
		if (prev_btn.justPressed()) {
			prev_btn.drawButton(true);
		} else {
			timeIndex--;
			if (timeIndex == -1) {
				timeIndex = 5;
			}
			prev_btn.drawButton(false);
		}
	}

	if (next_btn.contains(pixel_x, pixel_y)) {
		next_btn.press(state == TS_PRESSED);
		if (next_btn.justPressed()) {
			next_btn.drawButton(true);
		} else {
			timeIndex++;
			if (timeIndex == 6) {
				timeIndex = 0;
			}
			next_btn.drawButton(false);
		}
	}

	if (save_btn.contains(pixel_x, pixel_y)) {
		save_btn.press(state == TS_PRESSED);
		if (save_btn.justPressed()) {
			save_btn.drawButton(true);
		} else {
			int seconds = (minutes[timeIndex] * 60);
			if (bpmLab.configuration.totalProcessSeconds != seconds) {
				bpmLab.configuration.totalProcessSeconds = seconds;
				bpmLab.configuration.modified = 1;
				bpmLab.configStorage.save(bpmLab.configuration);
				bpmLab.audio.info(LEVEL_100, 3);
			}
			navigateTo(&mainPage);
		}
	}

	if (cancel_btn.contains(pixel_x, pixel_y)) {
		cancel_btn.press(state == TS_PRESSED);
		if (cancel_btn.justPressed()) {
			cancel_btn.drawButton(true);
		} else {
			navigateTo(&mainPage);
		}
	}
}

// BPM Setup Page
void BPMCommPage::show(void) {
	BPMPage::show();
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t\tShow BPM Connection Page...");
#endif
	drawIcon(60, 130, usb, 120, 90, GREEN);
	tft.setTextColor(GREEN, BLACK);
	tft.setTextSize(FONT_SIZE_20);
	tft.print(conn_label, 15, 250);
	bpmLab.listen();
}

void BPMCommPage::refresh(void) {
	if (!bpmLab.isRunning() || (bpmLab.isRunning() && blink)) {
		uint16_t color1 = BLACK;
		uint16_t color2 = BLACK;
		if (blink) {
			color1 = YELLOW;
			color2 = GREEN;
		}
		if (!bpmLab.isRunning()) {
			drawIcon(60, 130, usb, 120, 90, color2);
			tft.setTextColor(GREEN, BLACK);
			tft.setTextSize(FONT_SIZE_20);
			tft.print(conn_label, 15, 250);
		} else {
			drawIcon(60, 130, usb, 120, 90, color1);
			tft.setTextColor(YELLOW, BLACK);
			tft.setTextSize(FONT_SIZE_20);
			tft.print(wait_label, 15, 250);
		}
		blink = !blink;
	}
}
