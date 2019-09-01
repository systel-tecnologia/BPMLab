/*
 File  : BPMPositionSensor.h
 Version : 2.0
 Date  : 30/08/2019
 Project : Systel BPM Position Sensor Grid Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Infrared Matrix Data Transmiter Config:

 */

#ifndef _BPMPositionSensor_H_
#define _BPMPositionSensor_H_

#include "InfraredMTX595D.h"
#include "InfraredRX74ls165.h"

#define HOLE_POKE_BASE_9 	1
#define HOLE_POKE_BASE_10 	3
#define HOLE_POKE_BASE_11 	2

struct SensorData {
	char x[25] = { 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 0 };
	char y[13] = { 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 0 };
	char z[17] ={ 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 0 };
	char h[13] = { 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 0 };
};

// library interface description
class BPMPositionSensor {
		// user-accessible "public" interface
	public:

		BPMPositionSensor ();

		void start(void);

		SensorData read(void);

		void clear(void);

		boolean test(void);

	// library-accessible "protected" interface
	protected:

		void setup(void);

		void readData(InfraredMTX595D irtx, InfraredRX74ls165 irrx, char data[]);

		// library-accessible "private" interface
	private:

		InfraredMTX595D tx;
		InfraredMTX595D ty;
		InfraredMTX595D tz;

		InfraredRX74ls165 rx;
		InfraredRX74ls165 ry;
		InfraredRX74ls165 rz;
		InfraredRX74ls165 rh;
};

#endif
