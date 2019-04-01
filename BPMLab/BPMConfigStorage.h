/*
 File  : BPMConfigStorage.h
 Version : 1.0
 Date  : 13/03/2019
 Project : Systel Storage EEPROM Devices Configuration Data Support Arduino Library
 Author  : Daniel Valentin - dtvalentin@gmail.com
 
 Storage EEPROM Devices Configuration Data
 
 */

#ifndef _BPMConfigStorage_H_
#define _BPMConfigStorage_H_

#include <Arduino.h>

#define INIT_DATA_FLAG					63

#define INIT_DATA_FLAG_ADDRESS			1

#define DATA_STORE_ADDRESS				10

struct ConfigurationData {
		int fileIndex = 1;
		int totalProcessSeconds = 180;
		unsigned long boundRate = 115200;
		int modeCron = 0;
		int modified = 0;
};

// library interface description
class BPMConfigStorage {
		// user-accessible "public" interface
	public:

		BPMConfigStorage ();

		void start (void);

		ConfigurationData load (void);

		void save (ConfigurationData data);

		void reset (void);

		// library-accessible "protected" interface
	protected:

		void setup (void);

		// library-accessible "private" interface
	private:
};

#endif
