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

#define HP_PORT_PIN01 		42
#define HP_PORT_PIN02 		44
#define HP_PORT_PIN03 		46
#define HP_PORT_PIN04 		48
#define HP_PORT_PIN05 		50
#define HP_PORT_PIN06 		52
#define HP_PORT_PIN07 		43
#define HP_PORT_PIN08 		45
#define HP_PORT_PIN09 		47
#define HP_PORT_PIN10 		49
#define HP_PORT_PIN11 		51

#define HP_ENAB_PIN			53

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

};

#endif
