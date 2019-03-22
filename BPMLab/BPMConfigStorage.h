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
#include <StorageDevice.h>

struct ConfigurationData {
		int fileIndex = 0;
		int totalProcessSeconds = 60;
		int boundRate = 115200;
		int modeCron = 0;
};

// library interface description
class BPMConfigStorage: public StorageDevice {
		// user-accessible "public" interface
	public:

		BPMConfigStorage ();

		void start (void);

		ConfigurationData load (void);

		void save (ConfigurationData data);

		// library-accessible "protected" interface
	protected:

		void setup (void);

		void read (uint8_t* data, uint8_t size, uint8_t address);

		void write (uint8_t address, uint8_t data);

		void write (uint8_t address, uint8_t* data, uint8_t size);

		// library-accessible "private" interface
	private:
};

#endif
