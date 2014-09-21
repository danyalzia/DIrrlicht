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

@nogc nothrow extern(C++, irr) {
	/// Possible log levels.
	/** 
	* When used has filter LogLevel.Debug means => log everything and LogLevel.None means => log (nearly) nothing.
	* When used to print logging information LogLevel.Debug will have lowest priority while LogLevel.None
	* messages are never filtered and always printed.
	*/
	enum LogLevel {
		/// Used for printing information helpful in debugging
		Debug,

		/// Useful information to print. For example hardware infos or something started/stopped.
		Information,

		/// Warnings that something isn't as expected and can cause oddities
		Warning,

		/// Something did go wrong.
		Error,

		/// Logs with LogLevel.None will never be filtered.
		/// And used as filter it will remove all logging except LogLevel.None messages.
		None
	}

	/// Interface for logging messages, warnings and errors
	interface ILogger {
		/// Destructor
		void _destructorDoNotUse();

		/// Returns the current set log level.
		LogLevel getLogLevel() const;

		/// Sets a new log level.
		/**
		* With this value, texts which are sent to the logger are filtered
		* out. For example setting this value to LogLevel.Warning, only warnings and
		* errors are printed out. Setting it to LogLevel.Information, which is the
		* default setting, warnings, errors and informational texts are printed
		* out.
		* Params:
		* 	ll=  new log level filter value. 
		*/
		void setLogLevel(LogLevel ll);

		/// Prints out a text into the log
		/**
		* Params:
		* 	text=  Text to print out.
		* 	ll=  Log level of the text. If the text is an error, set
		* it to LogLevel.Error, if it is warning set it to LogLevel.Warning, and if it
		* is just an informational text, set it to LogLevel.Information. Texts are
		* filtered with these levels. If you want to be a text displayed,
		* independent on what level filter is set, use LogLevel.None. 
		*/
		void log(const char* text, LogLevel ll=LogLevel.Information);

		/// Prints out a text into the log
		/**
		* Params:
		* 	text=  Text to print out.
		* 	hint=  Additional info. This string is added after a " :" to the
		* string.
		* 	ll=  Log level of the text. If the text is an error, set
		* it to LogLevel.Error, if it is warning set it to LogLevel.Warning, and if it
		* is just an informational text, set it to LogLevel.Information. Texts are
		* filtered with these levels. If you want to be a text displayed,
		* independent on what level filter is set, use LogLevel.None. 
		*/
		void log(const char* text, const char* hint, LogLevel ll=LogLevel.Information);
		void log(const char* text, const dchar* hint, LogLevel ll=LogLevel.Information);

		/// Prints out a text into the log
		/**
		* Params:
		* 	text=  Text to print out.
		* 	hint=  Additional info. This string is added after a " :" to the
		* string.
		* 	ll=  Log level of the text. If the text is an error, set
		* it to LogLevel.Error, if it is warning set it to LogLevel.Warning, and if it
		* is just an informational text, set it to LogLevel.Information. Texts are
		* filtered with these levels. If you want to be a text displayed,
		* independent on what level filter is set, use LogLevel.None. 
		*/
		void log(const dchar* text, const dchar* hint, LogLevel ll=LogLevel.Information);

		/// Prints out a text into the log
		/**
		* Params:
		* 	text=  Text to print out.
		* 	ll=  Log level of the text. If the text is an error, set
		* it to LogLevel.Error, if it is warning set it to LogLevel.Warning, and if it
		* is just an informational text, set it to LogLevel.Information. Texts are
		* filtered with these levels. If you want to be a text displayed,
		* independent on what level filter is set, use LogLevel.None. 
		*/
		void log(const dchar* text, LogLevel ll=LogLevel.Information);
	}
}

unittest {
	import dirrlicht.compileconfig;
	mixin(Irr_TestBegin);

	with(device.logger) {
		writeln("Log Level: ", getLogLevel);
		setLogLevel(LogLevel.Information);
	}

	mixin(Irr_TestEnd);
}

@nogc nothrow package extern (C):

struct irr_ILogger;
