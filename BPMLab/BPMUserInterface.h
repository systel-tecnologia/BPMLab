/*
 File  : BPMUserInterface.h
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel BPM LCD Startup & BPM User Interface Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 LCD Startup & BPM User Interface
 
 */

#ifndef _BPMUserInterface_H_
#define _BPMUserInterface_H_

#include <Arduino.h>
#include <RTCLib.h>
#include <UTFTGLUE.h>
#include <RTCLib.h>
#include <TC.h>
#include <TouchScreen.h>
#include <Adafruit_GFX.h>
#include <AudioMessageDevice.h>

#define LCD_MD 			0  // LCD Model
#define LCD_CS 			A3 // Chip Select goes to Analog 3
#define LCD_CD 			A2 // Command/Data goes to Analog 2
#define LCD_WR 			A1 // LCD Write goes to Analog 1
#define LCD_RD 			A0 // LCD Read goes to Analog 0
#define LCD_RS 			A4 // Can alternately just connect to Arduino's reset pin

#define PORTRAIT   		0
#define LANDSCAPE  		1

#define RADS 			0.0174532925

#define YM				6
#define XP				7
#define XM				A1
#define YP				A2

#define TS_LEFT 		893
#define TS_RT 			129
#define TS_TOP 			936
#define TS_BOT			139

#define MINPRESSURE 	200
#define MIDPRESSURE 	300
#define MAXPRESSURE 	900

#define BLACK   		0x0000
#define BLUE    		0x001F
#define RED     		0xF800
#define GREEN   		0x07E0
#define CYAN    		0x07FF
#define MAGENTA 		0xF81F
#define YELLOW  		0xFFE0
#define GREY    		0x5AEB
#define WHITE   		0xFFFF

#define FONT_SIZE_10	1
#define FONT_SIZE_20	2
#define FONT_SIZE_30	3
#define FONT_SIZE_40	4

enum TouchState {
	TS_PRESSED, TS_RELEASED
};

// library interface description
class BPMPage { // @suppress("Class has a virtual method and non-virtual destructor")
		// user-accessible "public" interface
	public:

		virtual void show (void);

		virtual void touch (int pixel_x, int pixel_y, TouchState state) {
		}
		;

		virtual void navigateTo (BPMPage *page);

		virtual void refresh (void) {
		}
		;

		// library-accessible "protected" interface
	protected:

		void drawIcon (int16_t x, int16_t y, const uint8_t *icon, int16_t w, int16_t h, uint16_t color);

		void print (int x, int y, char *format, int size, ...);

		// library-accessible "private" interface
	private:

};

// library interface description
class BPMUserInterface {
		// user-accessible "public" interface
	public:

		void start (void);

		void updateDisplay (void);

		void readTouch (void);

		void showPage (BPMPage *page);

		// library-accessible "protected" interface
	protected:

		void setup (void);

		bool getTouchPosition (void);

		// library-accessible "private" interface
	private:

		BPMPage *activePage;

		TouchScreen ts = TouchScreen(XP, YP, XM, YM, MIDPRESSURE);

		int pixel_x = 0;

		int pixel_y = 0;

};

// library interface description
class BPMLogoPage: public BPMPage { // @suppress("Class has a virtual method and non-virtual destructor")
		// user-accessible "public" interface
	public:

		virtual void show (void);

		// library-accessible "protected" interface
	protected:

		// library-accessible "private" interface
	private:
};

// library interface description
class BPMExceptionPage: public BPMPage { // @suppress("Class has a virtual method and non-virtual destructor")
		// user-accessible "public" interface
	public:

		virtual void show (void);

		// library-accessible "protected" interface
	protected:

		// library-accessible "private" interface
	private:
};

// library interface description
class BPMMainPage: public BPMPage { // @suppress("Class has a virtual method and non-virtual destructor")
		// user-accessible "public" interface
	public:

		virtual void show (void);

		virtual void refresh (void);

		virtual void touch (int pixel_x, int pixel_y, TouchState state);

		// library-accessible "protected" interface
	protected:

		void updateDateTime (DateTime dateTime);

		// library-accessible "private" interface
	private:

		Adafruit_GFX_Button start_btn;

		Adafruit_GFX_Button setup_btn;

		Adafruit_GFX_Button comm_btn;
};

// library interface description
class BPMProcessPage: public BPMPage { // @suppress("Class has a virtual method and non-virtual destructor")
		// user-accessible "public" interface
	public:

		virtual void show (void);

		virtual void refresh (void);

		virtual void touch (int pixel_x, int pixel_y, TouchState state);

		// library-accessible "protected" interface
	protected:

		// library-accessible "private" interface
	private:

		void updateStates (void);

		void updateDateTime (TimeSpan time);

		void drawRing (int x, int y, int r, int t, uint16_t color);

		void initializeCancelBtn (char* label);

		Adafruit_GFX_Button cancel_btn;

		int currentValue = 0;

		int previousValue = 0;

};

// library interface description
class BPMSetupPage: public BPMPage { // @suppress("Class has a virtual method and non-virtual destructor")
		// user-accessible "public" interface
	public:

		virtual void show (void);

		// library-accessible "protected" interface
	protected:

		// library-accessible "private" interface
	private:

};

// library interface description
class BPMCommPage: public BPMPage { // @suppress("Class has a virtual method and non-virtual destructor")
		// user-accessible "public" interface
	public:

		virtual void show (void);

		// library-accessible "protected" interface
	protected:

		// library-accessible "private" interface
	private:

};

// Display
extern BPMUserInterface userInterface;
extern UTFTGLUE tft;

// Pages
extern BPMExceptionPage exceptionPage;
extern BPMLogoPage logoPage;
extern BPMMainPage mainPage;
extern BPMProcessPage processPage;
extern BPMSetupPage setupPage;

#endif
