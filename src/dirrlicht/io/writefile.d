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

module dirrlicht.io.writefile;

import std.conv : to;

/+++
 + Interface providing write access to a file.
 +/
interface WriteFile {
	/***
	 * Writes an amount of bytes to the file.
	 * Params:
	 *  buffer = Pointer to buffer of bytes to write.
	 * 	sizeToRead = Amount of bytes to write to the file.
	 * Return: How much bytes were written.
	 */
	int write(const void* buffer, uint sizeToWrite);

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

class CWriteFile : WriteFile {
    this(irr_IWriteFile* ptr)
    in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }

	int write(const void* buffer, uint sizeToWrite) {
		return irr_IWriteFile_write(ptr, buffer, sizeToWrite);
	}
	
	bool seek(long finalPos, bool relativeMovement=false) {
		return irr_IWriteFile_seek(ptr, finalPos, relativeMovement);
	}
	
	long getPos() {
		return irr_IWriteFile_getPos(ptr);
	}
	
	string getFileName() {
		auto temp = irr_IWriteFile_getFileName(ptr);
		return temp.to!string;
	}
	
	@property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
    irr_IWriteFile* ptr;
}

unittest {
	import dirrlicht.compileconfig;
	mixin(TestPrerequisite);
}

package extern (C):

struct irr_IWriteFile;

int irr_IWriteFile_write(irr_IWriteFile* file, const void* buffer, uint sizeToWrite);
bool irr_IWriteFile_seek(irr_IWriteFile* file, long finalPos, bool relativeMovement=false);
long irr_IWriteFile_getPos(irr_IWriteFile* file);
const(char*) irr_IWriteFile_getFileName(irr_IWriteFile* file);
