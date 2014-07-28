/*
    DIrrlicht - D Bindings for Irrlicht Engine

    Copyright (C) 2014- Danyal Zia (catofdanyal@yahoo.com)

    This software is provided 'as-is', without any express or
    implied warranty. In no event will the authors be held
    liable for any damages arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute
    it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented;
       you must not claim that you wrote the original software.
       If you use this software in a product, an acknowledgment
       in the product documentation would be appreciated but
       is not required.

    2. Altered source versions must be plainly marked as such,
       and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any
       source distribution.
*/

module dirrlicht.io.readfile;

import std.conv : to;

/+++
 + Interface providing read acess to a file.
 +/
interface ReadFile {
	/***
	 * Reads an amount of bytes from the file.
	 * Params:
	 *  buffer = Pointer to buffer where read bytes are written to.
	 * 	sizeToRead = Amount of bytes to read from the file.
	 * Return: How many bytes were read.
	 */
	int read(void* buffer, uint sizeToRead);

	/***
	 * Changes position in file
	 * Params:
	 *  finalPos = Destination position in the file.
	 *  relativeMovement = If set to true, the position in the file is
	 * 		changed relative to current position. Otherwise the position is changed
	 * 		from beginning of file.
	 * Return: True if successful, otherwise false.
	 */
	bool seek(long finalPos, bool relativeMovement=false);

	/***
	 * Get size of file.
	 * Return: Size of the file in bytes.
	 */
	long getSize();

	/***
	 * Get the current position in the file.
	 * Return: Current position in the file in bytes.
	 */
	long getPos();

	/***
	 * Get name of file.
	 * Return: File name as zero terminated character string.
	 */
	string getFileName();
	
	@property void* c_ptr();
	@property void c_ptr(void* ptr);
}

class CReadFile : ReadFile {
    this(irr_IReadFile* ptr)
    in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }

	int read(void* buffer, uint sizeToRead) {
		return irr_IReadFile_read(ptr, buffer, sizeToRead);
	}
	
	bool seek(long finalPos, bool relativeMovement=false) {
		return irr_IReadFile_seek(ptr, finalPos, relativeMovement);
	}
	
	long getSize() {
		return irr_IReadFile_getSize(ptr);
	}
	
	long getPos() {
		return irr_IReadFile_getPos(ptr);
	}
	
	string getFileName() {
		auto temp = irr_IReadFile_getFileName(ptr);
		return temp.to!string;
	}
	
	@property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
    irr_IReadFile* ptr;
}

unittest {
	import dirrlicht.compileconfig;
	mixin(TestPrerequisite);
}

package extern (C):

struct irr_IReadFile;

int irr_IReadFile_read(irr_IReadFile* file, void* buffer, uint sizeToRead);
bool irr_IReadFile_seek(irr_IReadFile* file, long finalPos, bool relativeMovement=false);
long irr_IReadFile_getSize(irr_IReadFile* file);
long irr_IReadFile_getPos(irr_IReadFile* file);
const(char*) irr_IReadFile_getFileName(irr_IReadFile* file);
