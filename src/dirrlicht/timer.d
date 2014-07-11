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

/+ A timer module useful for time dependent tasks
+
+/

module dirrlicht.timer;

import dirrlicht.irrlichtdevice;

/+++
 + Class for getting and manipulating the virtual time
 +/ 
class Timer
{
	enum WeekDay
	{
		Sunday=0,
		Monday,
		Tuesday,
		Wednesday,
		Thursday,
		Friday,
		Saturday
	}

	struct RealTimeDate
	{
		// Hour of the day, from 0 to 23
		uint Hour;
		// Minute of the hour, from 0 to 59
		uint Minute;
		// Second of the minute, due to extra seconds from 0 to 61
		uint Second;
		// Year of the gregorian calender
		int Year;
		// Month of the year, from 1 to 12
		uint Month;
		// Day of the month, from 1 to 31
		uint Day;
		// Weekday for the current day
		WeekDay Weekday;
		// Day of the year, from 1 to 366
		uint Yearday;
		// Whether daylight saving is on
		bool IsDST;
	}
	
    this(irr_ITimer* ptr)
    {
    	this.ptr = ptr;
    }
    
    irr_ITimer* ptr;
private:
    IrrlichtDevice device;
}

package extern(C):

struct irr_ITimer;
