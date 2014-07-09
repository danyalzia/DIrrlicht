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

module dirrlicht.logger;

import dirrlicht.irrlichtdevice;

/// Possible log levels.
/// When used has filter ELL_DEBUG means => log everything and ELL_NONE means => log (nearly) nothing.
/// When used to print logging information ELL_DEBUG will have lowest priority while ELL_NONE
/// messages are never filtered and always printed.
enum LogLevel
{
	/// Used for printing information helpful in debugging
	debugging,

	/// Useful information to print. For example hardware infos or something started/stopped.
	information,

	/// Warnings that something isn't as expected and can cause oddities
	warning,

	/// Something did go wrong.
	error,

	/// Logs with ELL_NONE will never be filtered.
	/// And used as filter it will remove all logging except ELL_NONE messages.
	none
}

class Logger
{
    this(IrrlichtDevice dev)
    {
        device = dev;
        ptr = irr_IrrlichtDevice_getLogger(device.ptr);
    }
    
    this(irr_ILogger* ptr)
    {
    	this.ptr = ptr;
    }
    
    irr_ILogger* ptr;
private:
    IrrlichtDevice device;
}

package extern (C):

struct irr_ILogger;
