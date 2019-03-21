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
			navigateTo(&processPage);
			bpmLab.start();
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
		} else {
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
	tft.fillScreen(BLACK);
	currentValue = 0;
	updateDateTime(bpmLab.getElapsedTime());
	drawRingMeter();
	cancel_btn.initButton(&tft, 120, 275, 200, 50, BLACK, BLUE, WHITE, (char*) cancel_label, FONT_SIZE_20);
	cancel_btn.drawButton(false);
#if(DEBUG_LEVEL >= 4)
	DBG_PRINTLN_LEVEL("\t\t\tShow BPM Process Page...");
#endif
}

void BPMProcessPage::refresh () {
	if ((currentValue % 10) == 0) {
		updateDateTime(bpmLab.getElapsedTime());
		drawRingMeter();
	}
	currentValue = bpmLab.getCurrentProgress();
}

void BPMProcessPage::updateDateTime (TimeSpan time) {
	tft.setTextColor(GREEN, BLACK);
	tft.setTextSize(FONT_SIZE_30);
	print(50, 15, (char*) TIME_FORMAT, 12, time.hours(), time.minutes(), time.seconds());
}

void BPMProcessPage::touch (int pixel_x, int pixel_y, TouchState state) {
	if (cancel_btn.contains(pixel_x, pixel_y)) {
		cancel_btn.press(state == TS_PRESSED);
		if (cancel_btn.justPressed()) {
			cancel_btn.drawButton(true);
		} else {
			if (bpmLab.isRunning()) {
				bpmLab.cancel();
				updateDateTime(bpmLab.getElapsedTime());
				currentValue = bpmLab.getCurrentProgress();
				drawRingMeter();
				cancel_btn.initButton(&tft, 120, 275, 200, 50, BLACK, BLUE, WHITE, (char*) done_label, FONT_SIZE_20);
				cancel_btn.drawButton(false);
			} else {
				navigateTo(&mainPage);
			}
		}
	}
}

void BPMProcessPage::drawRingMeter () {
	ringMeter(currentValue, 0, 100, 28, 50, 95);
	char* status = started_label;
	tft.setTextSize(FONT_SIZE_20);
	if (bpmLab.isProcessDone()) {
		status = done_label;
		tft.setTextColor(GREEN, BLACK);
		tft.print(status, 78, 173);
		cancel_btn.initButton(&tft, 120, 275, 200, 50, BLACK, BLUE, WHITE, (char*) done_label, FONT_SIZE_20);
		cancel_btn.drawButton(false);
	} else
		if (bpmLab.isProcessCanceled() && currentValue > 0) {
			status = canceled_label;
			tft.setTextColor(RED, BLACK);
			tft.print(status, 78, 173);
		} else {
			tft.setTextColor(YELLOW, BLACK);
			tft.print(status, 72, 173);
		}
}

void BPMProcessPage::ringMeter (int percent, int vmin, int vmax, int x, int y, int r) {
	x += r;
	y += r;   											// Calculate coords of centre of ring
	int w = r / 4;    									// Width of outer ring is 1/4 of radius
	int angle = 150;  									// Half the sweep angle of meter (300 degrees)
	int v = map(percent, vmin, vmax, -angle, angle); 	// Map the value to an angle v
	byte seg = 5; 										// Segments are 5 degrees wide = 60 segments for 300 degrees
	byte inc = 5; 									// Draw segments every 5 degrees, increase to 10 for segmented ring

	// Draw colour blocks every inc degrees
	for (int i = -angle; i < angle; i += inc) {

		// Choose colour from scheme
		int colour = rainbow(map(i, -angle, angle, 127, 63));

		// Calculate pair of coordinates for segment start
		float sx = cos((i - 90) * RADS);
		float sy = sin((i - 90) * RADS);
		uint16_t x0 = sx * (r - w) + x;
		uint16_t y0 = sy * (r - w) + y;
		uint16_t x1 = sx * r + x;
		uint16_t y1 = sy * r + y;

		// Calculate pair of coordinates for segment end
		float sx2 = cos((i + seg - 90) * RADS);
		float sy2 = sin((i + seg - 90) * RADS);
		int x2 = sx2 * (r - w) + x;
		int y2 = sy2 * (r - w) + y;
		int x3 = sx2 * r + x;
		int y3 = sy2 * r + y;

		// Fill in coloured segments with 2 triangles
		if (i < v) {
			tft.fillTriangle(x0, y0, x1, y1, x2, y2, colour);
			tft.fillTriangle(x1, y1, x2, y2, x3, y3, colour);
		} else {
			tft.fillTriangle(x0, y0, x1, y1, x2, y2, GREY);
			tft.fillTriangle(x1, y1, x2, y2, x3, y3, GREY);
		}
	}

	tft.setTextColor(WHITE, BLACK);
	int offset = 40;
	if (percent >= 10)
		offset = 25;
	if (percent >= 100) {
		offset = 50;
		tft.setTextColor(GREEN, BLACK);
	}

	// Set the text colour to default
	tft.setTextSize(FONT_SIZE_40);
	tft.setCursor(0, 200);
	print(x - offset, y - 25, "%2d%c", 5, percent, '%');

}

unsigned int BPMProcessPage::rainbow (byte value) {
	byte red = 0; 			// Red is the top 5 bits of a 16 bit colour value
	byte green = 0;					// Green is the middle 6 bits
	byte blue = 0; 					// Blue is the bottom 5 bits
	byte quadrant = value / 32;

	if (quadrant == 0) {
		blue = 31;
		green = 2 * (value % 32);
		red = 0;
	}

	if (quadrant == 1) {
		blue = 31 - (value % 32);
		green = 63;
		red = 0;
	}

	if (quadrant == 2) {
		blue = 0;
		green = 63;
		red = value % 32;
	}

	if (quadrant == 3) {
		blue = 0;
		green = 63 - 2 * (value % 32);
		red = 31;
	}

	return (red << 11) + (green << 5) + blue;
}

// BPM Setup Page
void BPMSetupPage::show (void) {
	BPMPage::show();
}

// BPM Setup Page
void BPMCommPage::show (void) {
	BPMPage::show();
}
