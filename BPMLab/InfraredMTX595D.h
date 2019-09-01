/*
 File  : InfraredMTX595D.h
 Version : 2.0
 Date  : 20/08/2019
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
#define PIN_CLK_LB    36 	// CLK_LB    36  // SRCLK 74HC595x PIN (11)SRCLK (11)
#define PIN_LATCH_LB  38 	// LATCH_LB  38  // RCLK  74HC595x PIN (12)RCLK (12)
#define PIN_DATA_LB   40  	// DATA_LB   40  // SER   74HC595x PIN (14)SER (14)

#define PIN_CLK_SG    30 	// CLK_SG    30  // SRCLK 74HC595x PIN (11)SRCLK (11)
#define PIN_LATCH_SG  32 	// LATCH_SG  32  // RCLK  74HC595x PIN (12)RCLK (12)
#define PIN_DATA_SG   34 	// DATA_SG   34  // SER   74HC595x PIN (14)SER (14)
#else
#define PIN_CLK_LB   13 	// CLK_LB    13  // SRCLK 74HC595x PIN (11)
#define PIN_LATCH_LB 12 	// LATCH_LB  12  // RCLK  74HC595x PIN (12)
#define PIN_DATA_LB  11  	// DATA_LB   11  // SER   74HC595x PIN (14)

#define PIN_CLK_SG   10 	// CLK_SG    10  // SRCLK 74HC595x PIN (11)
#define PIN_LATCH_SG 9 		// LATCH_SG  9   // RCLK  74HC595x PIN (12)
#define PIN_DATA_SG  8 		// DATA_SG   8   // SER   74HC595x PIN (14)
#endif

#define CLOCK 0
#define LATCH 1
#define DATA  2

// library interface description
class InfraredMTX595D: public DataSenderDevice {
	// user-accessible "public" interface
public:

	InfraredMTX595D();

	void start(byte *segments, byte *lightBeans, int segmentSize,
			int lightBeamSize);

	void start(byte *latchSegmentPins, byte *latchLightBeamPins, byte *segments,
			byte *lightBeans, int segmentSize, int lightBeamSize);

	void write(int index, byte data);

	void write(const int segment, const int lightBeam, byte data);

	void clear();

	int getLightBeamCount();

	int getSegmentCount();

	// library-accessible "protected" interface
protected:

	void setup(void);

	void write(byte *latchPins, const byte data);

	// library-accessible "private" interface
private:

	int lightBeamCount = 0;

	int segmentCount = 0;

	byte *selectLightBeans = 0;

	byte *selectedSegments = 0;

	byte *segmentPins = 0;

	byte *lightBeamPins = 0;

};

#endif

