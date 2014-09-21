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

@nogc nothrow extern(C++, irr) {
	/// Interface for getting and manipulating the virtual time
	interface ITimer {
		/// Returns current real time in milliseconds of the system.
		/**
		* This value does not start with 0 when the application starts.
		* For example in one implementation the value returned could be the
		* amount of milliseconds which have elapsed since the system was started.
		*/
		uint getRealTime() const;
		
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

		RealTimeDate getRealTimeAndDate() const;

		/// Returns current virtual time in milliseconds.
		/**
		* This value starts with 0 and can be manipulated using setTime(),
		* stopTimer(), startTimer(), etc. This value depends on the set speed of
		* the timer if the timer is stopped, etc. If you need the system time,
		* use getRealTime() 
		*/
		uint getTime() const;

		/// sets current virtual time
		void setTime(uint time);

		/// Stops the virtual timer.
		/**
		* The timer is reference counted, which means everything which calls
		* stop() will also have to call start(), otherwise the timer may not
		* start/stop correctly again. 
		*/
		void stop();
		
		/// Starts the virtual timer.
		/**
		* The timer is reference counted, which means everything which calls
		* stop() will also have to call start(), otherwise the timer may not
		* start/stop correctly again. 
		*/
		void start();

		/// Sets the speed of the timer
		/**
		* The speed is the factor with which the time is running faster or
		* slower then the real system time. 
		*/
		void setSpeed(float speed = 1.0f);

		/// Returns current speed of the timer
		/**
		* The speed is the factor with which the time is running faster or
		* slower then the real system time. 
		*/
		float getSpeed() const;

		/// Returns if the virtual timer is currently stopped
		bool isStopped() const;

		/// Advances the virtual time
		/**
		* Makes the virtual timer update the time value based on the real
		* time. This is called automatically when calling IrrlichtDevice.run(),
		* but you can call it manually if you don't use this method. 
		*/
		void tick();
	}
}

unittest {
	import dirrlicht.compileconfig;
	mixin(Irr_TestBegin);

	with (device.timer) {
		with(getRealTimeAndDate) {
			writeln("Real Time: ", getRealTime);
			writeln("Hour: ", Hour);
			writeln("Minute: ", Minute);
			writeln("Second: ", Second);
			writeln("Year: ", Year);
			writeln("Month: ", Month);
			writeln("Day: ", Day);
			writeln("Weekday: ", Weekday);
			writeln("Yearday: ", Yearday);
			writeln("IsDST: ", IsDST);
		}
		writeln("Time: ", getTime());
		setTime(20);
		stop();
		start();
		setSpeed(5);
		writeln("Speed: ", getSpeed);
		isStopped();
		tick();
	}
	
	mixin(Irr_TestEnd);
}

@nogc nothrow package extern(C):

struct irr_ITimer;
