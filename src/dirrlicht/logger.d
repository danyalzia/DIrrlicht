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

import std.utf : toUTFz;

/// Possible log levels.
/// When used has filter ELL_DEBUG means => log everything and ELL_NONE means => log (nearly) nothing.
/// When used to print logging information ELL_DEBUG will have lowest priority while ELL_NONE
/// messages are never filtered and always printed.
enum LogLevel {
	/// Used for printing information helpful in debugging
	Debug,

	/// Useful information to print. For example hardware infos or something started/stopped.
	Information,

	/// Warnings that something isn't as expected and can cause oddities
	Warning,

	/// Something did go wrong.
	Error,

	/// Logs with ELL_NONE will never be filtered.
	/// And used as filter it will remove all logging except ELL_NONE messages.
	None
}

/// Interface for logging messages, warnings and errors
interface Logger {
    /// Returns the current set log level.
    LogLevel getLogLevel();
    
    /***
     * Sets a new log level.
	 * With this value, texts which are sent to the logger are filtered
	 * out. For example setting this value to Warning, only warnings and
	 * errors are printed out. Setting it to Information, which is the
	 * default setting, warnings, errors and informational texts are printed
	 * out.
	 * Params:
     *			 ll = new log level filter value.
     */
    void setLogLevel(LogLevel ll);
    
    /***
     * Prints out a text into the log
	 * Params: 
     *			text = Text to print out.
     *			ll = Log level of the text. If the text is an error, set
	 * it to Error, if it is warning set it to Warning, and if it
	 * is just an informational text, set it to Information. Texts are
	 * filtered with these levels. If you want to be a text displayed,
	 * independent on what level filter is set, use None.
     */
    void log(string text, LogLevel ll=LogLevel.Information);
    
    /***
     * Prints out a text into the log
	 * Params: 
     *			text = Text to print out.
     *			hint = Additional info. This string is added after a " :" to the string.
     *			ll = Log level of the text. If the text is an error, set
	 * it to Error, if it is warning set it to Warning, and if it
	 * is just an informational text, set it to Information. Texts are
	 * filtered with these levels. If you want to be a text displayed,
	 * independent on what level filter is set, use None.
     */
    void log(string text, string hint, LogLevel ll=LogLevel.Information);
    
    /***
     * Prints out a text into the log
	 * Params: 
     *			text = Text to print out.
     *			hint = Additional info. This string is added after a " :" to the string.
     *			ll = Log level of the text. If the text is an error, set
	 * it to Error, if it is warning set it to Warning, and if it
	 * is just an informational text, set it to Information. Texts are
	 * filtered with these levels. If you want to be a text displayed,
	 * independent on what level filter is set, use None.
     */
    void log(string text, dstring hint, LogLevel ll=LogLevel.Information);
    
    /***
     * Prints out a text into the log
	 * Params: 
     *			text = Text to print out.
     *			hint = Additional info. This string is added after a " :" to the string.
     *			ll = Log level of the text. If the text is an error, set
	 * it to Error, if it is warning set it to Warning, and if it
	 * is just an informational text, set it to Information. Texts are
	 * filtered with these levels. If you want to be a text displayed,
	 * independent on what level filter is set, use None.
     */
    void log(dstring text, dstring hint, LogLevel ll=LogLevel.Information);
    
    /***
     * Prints out a text into the log
	 * Params: 
     *			text = Text to print out.
     *			ll = Log level of the text. If the text is an error, set
	 * it to Error, if it is warning set it to Warning, and if it
	 * is just an informational text, set it to Information. Texts are
	 * filtered with these levels. If you want to be a text displayed,
	 * independent on what level filter is set, use None.
     */
    void log(dstring text, LogLevel ll=LogLevel.Information);

    @property void* c_ptr();
    @property void c_ptr(void* ptr);
}

class CLogger : Logger {
    this(irr_ILogger* ptr)
    out(result) {
		assert(result.ptr != null);
	}
	body {
    	this.ptr = ptr;
    }
    
    LogLevel getLogLevel() {
    	return irr_ILogger_getLogLevel(ptr);
    }
	
    void setLogLevel(LogLevel ll) {
    	irr_ILogger_setLogLevel(ptr, ll);
    }
	
    void log(string text, LogLevel ll=LogLevel.Information) {
    	irr_ILogger_log1(ptr, text.toStringz, ll);
    }
    
    void log(string text, string hint, LogLevel ll=LogLevel.Information) {
    	irr_ILogger_log2(ptr, text.toStringz, hint.toStringz, ll);
    }
    
    void log(string text, dstring hint, LogLevel ll=LogLevel.Information) {
    	irr_ILogger_log3(ptr, text.toStringz, hint.toUTFz!(const(dchar)*), ll);
    }
	
    void log(dstring text, dstring hint, LogLevel ll=LogLevel.Information) {
    	irr_ILogger_log4(ptr, text.toUTFz!(const(dchar)*), hint.toUTFz!(const(dchar)*), ll);
    }
	
    void log(dstring text, LogLevel ll=LogLevel.Information) {
    	irr_ILogger_log5(ptr, text.toUTFz!(const(dchar)*), ll);
    }

	@property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
    irr_ILogger* ptr;
}

unittest {
	import dirrlicht.compileconfig;
    mixin(TestPrerequisite);
    auto logg = device.logger;
    with (logg) {
        getLogLevel();
        setLogLevel(LogLevel.Debug);
        log("Logging.."); 
    }
}

package extern (C):

struct irr_ILogger;

LogLevel irr_ILogger_getLogLevel(irr_ILogger* logger);
void irr_ILogger_setLogLevel(irr_ILogger* logger, LogLevel ll);
void irr_ILogger_log1(irr_ILogger* logger, const char* text, LogLevel ll=LogLevel.Information);
void irr_ILogger_log2(irr_ILogger* logger, const char* text, const char* hint, LogLevel ll=LogLevel.Information);
void irr_ILogger_log3(irr_ILogger* logger, const char* text, const dchar* hint, LogLevel ll=LogLevel.Information);
void irr_ILogger_log4(irr_ILogger* logger, const dchar* text, const dchar* hint, LogLevel ll=LogLevel.Information);
void irr_ILogger_log5(irr_ILogger* logger, const dchar* text, LogLevel ll=LogLevel.Information);
