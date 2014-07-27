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

module dirrlicht.timer;

import dirrlicht.compileconfig;
import dirrlicht.irrlichtdevice;

/+++
 + Interface for getting and manipulating the virtual time
 +/
interface Timer {
    uint getRealTime();
    RealTimeDate getRealTimeAndDate();
    /***
     * Returns current virtual time in milliseconds.
	 * This value starts with 0 and can be manipulated using setTime(),
	 * stopTimer(), startTimer(), etc. This value depends on the set speed of
	 * the timer if the timer is stopped, etc. If you need the system time,
	 * use getRealTime()
     */
    uint getTime();
    
    /// sets current virtual time
    void setTime(uint time);
    
    /***
     * Stops the virtual timer.
	 * The timer is reference counted, which means everything which calls
	 * stop() will also have to call start(), otherwise the timer may not
	 * start/stop correctly again.
     */
    void stop();
    
    /***
     * Starts the virtual timer.
	 * The timer is reference counted, which means everything which calls
	 * stop() will also have to call start(), otherwise the timer may not
	 * start/stop correctly again.
     */
    void start();
    
    /***
     * Sets the speed of the timer
	 * The speed is the factor with which the time is running faster or
	 * slower then the real system time.
     */
    void setSpeed(float speed = 1.0f);
    
    /***
     * Returns current speed of the timer
	 * The speed is the factor with which the time is running faster or
	 * slower then the real system time.
     */
    float getSpeed();
    
    /// Returns if the virtual timer is currently stopped
    bool isStopped();
    
    /***
     * Advances the virtual time
	 * Makes the virtual timer update the time value based on the real
	 * time. This is called automatically when calling IrrlichtDevice::run(),
	 * but you can call it manually if you don't use this method.
     */
    void tick();

    @property void* c_ptr();
    @property void c_ptr(void* ptr);
}

/+++
 + Implementation of Timer
 +/
class CTimer : Timer {
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
	
    uint getTime() {
    	return irr_ITimer_getTime(ptr);
    }
    
    void setTime(uint time) {
    	irr_ITimer_setTime(ptr, time);
    }
    
    void stop() {
    	irr_ITimer_stop(ptr);
    }
	
    void start() {
    	irr_ITimer_start(ptr);
    }
	
    void setSpeed(float speed = 1.0f) {
    	return irr_ITimer_setSpeed(ptr, speed);
    }
	
    float getSpeed() {
    	return irr_ITimer_getSpeed(ptr);
    }
    
    bool isStopped() {
    	return irr_ITimer_isStopped(ptr);
    }
	
    void tick() {
    	irr_ITimer_tick(ptr);
    }

    @property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
	
private:
	irr_ITimer* ptr;
}

unittest {
	mixin(TestPrerequisite);
	auto timer = device.timer;
	assert(timer !is null);
	assert(timer.c_ptr != null);

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
