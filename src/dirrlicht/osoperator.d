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

module dirrlicht.osoperator;

import dirrlicht.irrlichtdevice;

/+++
 + The Operating system operator provides operation system specific methods and informations.
 +/
interface OSOperator {
    /// Get the current operation system version as string.
    string getOperatingSystemVersion();
    
    /// Copies text to the clipboard
    void copyToClipboard(string text);
    
    /// Get text from the clipboard
    string getTextFromClipboard();
    
    /***
     * Get the processor speed in megahertz
	 * Params:
     *			 MHz = The integer variable to store the speed in.
	 * Return: True if successful, false if not
     */
    bool getProcessorSpeedMHz(uint* MHz);
    
    /***
     * Get the total and available system RAM
	 * Params:
     *			 Total =  will contain the total system memory
     *			 Avail = will contain the available memory
	 * Return: 	 True if successful, false if not
     */
    bool getSystemMemory(uint* Total, uint* Avail);

    @property void* c_ptr();
    @property void c_ptr(void* ptr);
}

class COSOperator : OSOperator {
    this(irr_IOSOperator* ptr)
    out(result) {
		assert(result.ptr != null);
	}
	body {
    	this.ptr = ptr;
    }
    
    string getOperatingSystemVersion() {
    	return irr_IOSOperator_getOperatingSystemVersion(ptr).to!string;
    }
    
    void copyToClipboard(string text) {
    	irr_IOSOperator_copyToClipboard(ptr, text.toStringz);
    }
    
    string getTextFromClipboard() {
    	return irr_IOSOperator_getTextFromClipboard(ptr).to!string;
    }
	
    bool getProcessorSpeedMHz(uint* MHz) {
    	return irr_IOSOperator_getProcessorSpeedMHz(ptr, MHz);
    }
	
    bool getSystemMemory(uint* Total, uint* Avail) {
    	return irr_IOSOperator_getSystemMemory(ptr, Total, Avail);
    }

	@property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
    irr_IOSOperator* ptr;
}

package extern (C):

struct irr_IOSOperator;

const(char*) irr_IOSOperator_getOperatingSystemVersion(irr_IOSOperator* op);
void irr_IOSOperator_copyToClipboard(irr_IOSOperator* op, const(char*) text);
const(char*) irr_IOSOperator_getTextFromClipboard(irr_IOSOperator* op);
bool irr_IOSOperator_getProcessorSpeedMHz(irr_IOSOperator* op, uint* MHz);
bool irr_IOSOperator_getSystemMemory(irr_IOSOperator* op, uint* Total, uint* Avail);
