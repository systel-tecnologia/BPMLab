/*
 File  : BPMHolePokeSensor.h
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel BPM Hole Poke Sensor Grid Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 SD Card Data Logger
 
 */

#ifndef _BPMHolePokeSensor_H_
#define _BPMHolePokeSensor_H_

// library interface description
class BPMHolePokeSensor {
		// user-accessible "public" interface
	public:

		BPMHolePokeSensor ();

		void start (void);

		boolean test (void);

		int read();

		// library-accessible "protected" interface
	protected:

		void setup (void);

		// library-accessible "private" interface
	private:

		int lastHolePokeSensorState = 0;
};

#endif
