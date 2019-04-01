/*
 File  : InfraredMTX595D.h
 Version : 1.0
 Date  : 04/03/2019
 Project : Systel BPM Data Transmiter InfraRed Matrix Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Infrared Matrix Data Transmiter Config
 
 For Uno:
 CLK_ROW    13  // SRCLK 74HC595x PIN (11)
 LATCH_ROW  12  // RCLK  74HC595x PIN (12) 
 DATA_ROW   11  // SER   74HC595x PIN (14)

 CLK_COL    10  // SRCLK 74HC595x PIN (11)
 LATCH_COL  11  // RCLK  74HC595x PIN (12) 
 DATA_COL   12  // SER   74HC595x PIN (14)

 For Mega:
 CLK_ROW    36  // SRCLK 74HC595x PIN (11)
 LATCH_ROW  38  // RCLK  74HC595x PIN (12) 
 DATA_ROW   40  // SER   74HC595x PIN (14)

 CLK_COL    30  // SRCLK 74HC595x PIN (11)
 LATCH_COL  32  // RCLK  74HC595x PIN (12) 
 DATA_COL   34  // SER   74HC595x PIN (14)

 */

#ifndef _InfraredMTX595D_H_
#define _InfraredMTX595D_H_

#include <Arduino.h>
#include <DataSenderDevice.h>

#if defined(__AVR_ATmega2560__)
#define PIN_CLK_ROW    36 	// CLK_ROW    36  // SRCLK 74HC595x PIN (11)SRCLK (11)
#define PIN_LATCH_ROW  38 	// LATCH_ROW  38  // RCLK  74HC595x PIN (12)RCLK (12) 
#define PIN_DATA_ROW   40  	// DATA_ROW   40  // SER   74HC595x PIN (14)SER (14)

#define PIN_CLK_COL    30 	// CLK_COL    30  // SRCLK 74HC595x PIN (11)SRCLK (11)
#define PIN_LATCH_COL  32 	// LATCH_COL  32  // RCLK  74HC595x PIN (12)RCLK (12) 
#define PIN_DATA_COL   34 	// DATA_COL   34  // SER   74HC595x PIN (14)SER (14)
#else
#define PIN_CLK_ROW    13 	// CLK_ROW    13  // SRCLK 74HC595x PIN (11)
#define PIN_LATCH_ROW  12 	// LATCH_ROW  12  // RCLK  74HC595x PIN (12) 
#define PIN_DATA_ROW   11  	// DATA_ROW   11  // SER   74HC595x PIN (14)

#define PIN_CLK_COL    10 	// CLK_COL    10  // SRCLK 74HC595x PIN (11)
#define PIN_LATCH_COL  9 	// LATCH_COL  9   // RCLK  74HC595x PIN (12) 
#define PIN_DATA_COL   8 	// DATA_COL   8   // SER   74HC595x PIN (14)
#endif

#define CLOCK 0
#define LATCH 1
#define DATA  2

#define DEFAULT_COL_COUNT  	7			// Colunms Sensor Grid Size
#define DEFAULT_ROW_COUNT  	8			// Rows Sensor Grid Size 

// library interface description
class InfraredMTX595D: public DataSenderDevice {
		// user-accessible "public" interface
	public:

		InfraredMTX595D ();

		void start (void);

		void start (int colsCount, int rowsCount);

		void start (byte *latchColPins, byte *latchRowPins, int colsCount, int rowsCount);

		void write (int col, int row, int data);

		void clear ();

		int getColsSize ();

		int getRowsSize ();

		// library-accessible "protected" interface
	protected:

		void setup (void);

		void write (byte *latchPins, const byte data);

		// library-accessible "private" interface
	private:

		int rows = 0;

		int cols = 0;

		byte *colPins = 0;

		byte *rowPins = 0;

};

#endif

