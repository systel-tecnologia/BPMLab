/*
 File  : BPMPositionSensor.h
 Version : 1.0
 Date  : 05/03/2019
 Project : Systel BPM Position Sensor Grid Support Arduino Library
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
 
 Infrared Octet Data Receiver
 
 For Uno:
 DATA 1  6       // bit 0 Data Receiver
 DATA 2  7		// bit 1 Data Receiver
 DATA 3  8		// bit 2 Data Receiver
 DATA 4  9		// bit 3 Data Receiver
 DATA 5  10		// bit 4 Data Receiver
 DATA 6  11		// bit 5 Data Receiver	
 DATA 7  12		// bit 6 Data Receiver
 DATA 8  13		// bit 7 Data Receiver
 
 For Mega:
 DATA 1  A8      // bit 0 Data Receiver
 DATA 2  A9		// bit 1 Data Receiver
 DATA 3  A10		// bit 2 Data Receiver
 DATA 4  A11		// bit 3 Data Receiver
 DATA 5  A12		// bit 4 Data Receiver
 DATA 6  A13		// bit 5 Data Receiver	
 DATA 7  A14		// bit 6 Data Receiver
 DATA 8  A15		// bit 7 Data Receiver		

 */

#ifndef _BPMPositionSensor_H_
#define _BPMPositionSensor_H_

#include "InfraredMTX595D.h"
#include "InfraredOctLM339.h"

struct SensorData {
		int value[7][8] = {
				{ -1 - 1, -1, -1, -1, -1, -1, -1 },
				{ -1 - 1, -1, -1, -1, -1, -1, -1 },
				{ -1 - 1, -1, -1, -1, -1, -1, -1 },
				{ -1 - 1, -1, -1, -1, -1, -1, -1 },
				{ -1 - 1, -1, -1, -1, -1, -1, -1 },
				{ -1 - 1, -1, -1, -1, -1, -1, -1 },
				{ -1 - 1, -1, -1, -1, -1, -1, -1 } };
};

struct PositionData {
		int x = -1;
		int y = -1;
		int z = -1;
		int heigth = 0;
		int width = 0;
};

// library interface description
class BPMPositionSensor {
		// user-accessible "public" interface
	public:

		BPMPositionSensor ();

		void start (void);

		SensorData readData (void);

		PositionData read (void);

		void clear (void);

		boolean test (void);

		// library-accessible "protected" interface
	protected:

		void setup (void);

		// library-accessible "private" interface
	private:

		InfraredOctLM339 rx;

		InfraredMTX595D tx;

};

#endif
