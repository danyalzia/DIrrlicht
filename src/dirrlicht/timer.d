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

import dirrlicht.compileconfig;
import dirrlicht.irrlichtdevice;

/+++
 + Class for getting and manipulating the virtual time
 +/ 
class Timer {
    this(irr_ITimer* ptr)
    in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }
    
    uint getRealTime() {
    	return irr_ITimer_getRealTime(ptr);
    }
    
    RealTimeDate getRealTimeAndDate() {
    	return irr_ITimer_getRealTimeAndDate(ptr);
    }
    
    /***
     * Returns current virtual time in milliseconds.
	 * This value starts with 0 and can be manipulated using setTime(),
	 * stopTimer(), startTimer(), etc. This value depends on the set speed of
	 * the timer if the timer is stopped, etc. If you need the system time,
	 * use getRealTime()
     */
    uint getTime() {
    	return irr_ITimer_getTime(ptr);
    }
    
    /// sets current virtual time
    void setTime(uint time) {
    	irr_ITimer_setTime(ptr, time);
    }
    
    /***
     * Stops the virtual timer.
	 * The timer is reference counted, which means everything which calls
	 * stop() will also have to call start(), otherwise the timer may not
	 * start/stop correctly again.
     */
    void stop() {
    	irr_ITimer_stop(ptr);
    }
    
    /***
     * Starts the virtual timer.
	 * The timer is reference counted, which means everything which calls
	 * stop() will also have to call start(), otherwise the timer may not
	 * start/stop correctly again.
     */
    void start() {
    	irr_ITimer_start(ptr);
    }
    
    /***
     * Sets the speed of the timer
	 * The speed is the factor with which the time is running faster or
	 * slower then the real system time.
     */
    void setSpeed(float speed = 1.0f) {
    	return irr_ITimer_setSpeed(ptr, speed);
    }
    
    /***
     * Returns current speed of the timer
	 * The speed is the factor with which the time is running faster or
	 * slower then the real system time.
     */
    float getSpeed() {
    	return irr_ITimer_getSpeed(ptr);
    }
    
    /// Returns if the virtual timer is currently stopped
    bool isStopped() {
    	return irr_ITimer_isStopped(ptr);
    }
    
    /***
     * Advances the virtual time
	 * Makes the virtual timer update the time value based on the real
	 * time. This is called automatically when calling IrrlichtDevice::run(),
	 * but you can call it manually if you don't use this method.
     */
    void tick() {
    	irr_ITimer_tick(ptr);
    }
    
	irr_ITimer* ptr;
}

unittest {
	mixin(TestPrerequisite);
	auto timer = device.timer;
	assert(timer !is null);
	assert(timer.ptr != null);

	with (timer) {
		getRealTime().writeln;
		getRealTimeAndDate().writeln;
		getTime().writeln;
		setTime(2);
		stop();
		start();
		setSpeed(2);
		getSpeed().writeln;
		isStopped().writeln;
		tick();
	}
}

package extern(C):

struct irr_ITimer;

enum WeekDay {
	Sunday=0,
	Monday,
	Tuesday,
	Wednesday,
	Thursday,
	Friday,
	Saturday
}

struct RealTimeDate {
	/// Hour of the day, from 0 to 23
	uint Hour;
	/// Minute of the hour, from 0 to 59
	uint Minute;
	/// Second of the minute, due to extra seconds from 0 to 61
	uint Second;
	/// Year of the gregorian calender
	int Year;
	/// Month of the year, from 1 to 12
	uint Month;
	/// Day of the month, from 1 to 31
	uint Day;
	/// Weekday for the current day
	WeekDay Weekday;
	/// Day of the year, from 1 to 366
	uint Yearday;
	/// Whether daylight saving is on
	bool IsDST;
}
	
uint irr_ITimer_getRealTime(irr_ITimer* timer);
RealTimeDate irr_ITimer_getRealTimeAndDate(irr_ITimer* timer);
uint irr_ITimer_getTime(irr_ITimer* timer);
void irr_ITimer_setTime(irr_ITimer* timer, uint time);
void irr_ITimer_stop(irr_ITimer* timer);
void irr_ITimer_start(irr_ITimer* timer);
void irr_ITimer_setSpeed(irr_ITimer* timer, float speed = 1.0f);
float irr_ITimer_getSpeed(irr_ITimer* timer);
bool irr_ITimer_isStopped(irr_ITimer* timer);
void irr_ITimer_tick(irr_ITimer* timer);
