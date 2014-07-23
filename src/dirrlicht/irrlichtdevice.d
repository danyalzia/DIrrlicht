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

module dirrlicht.irrlichtdevice;

import dirrlicht.compileconfig;
import dirrlicht.core.dimension2d;
import dirrlicht.core.vector2d;
import dirrlicht.core.array;
import dirrlicht.video.devicetypes;
import dirrlicht.video.color;
import dirrlicht.video.videodriver;
import dirrlicht.video.drivertypes;
import dirrlicht.io.filesystem;
import dirrlicht.scene.scenemanager;
import dirrlicht.gui.cursorcontrol;
import dirrlicht.gui.guienvironment;
import dirrlicht.logger;
import dirrlicht.video.videomodelist;
import dirrlicht.osoperator;
import dirrlicht.timer;
import dirrlicht.randomizer;
import dirrlicht.eventreceiver;

import std.string : toStringz;
import std.conv : to;
import std.utf : toUTFz;

/+++
 + The Irrlicht device. You can create it with createDevice() or createDeviceEx().
 + This is the most important class of the Irrlicht Engine. You can
 + access everything in the engine if you have a pointer to an instance of
 + this class.  There should be only one instance of this class at any
 + time.
 +/
class IrrlichtDevice {
	invariant() {
		assert(ptr != null);
	}
	
    this(irr_IrrlichtDevice* ptr)
    in {
		assert(ptr != null);
	}
    out(result) {
		assert(result.ptr != null);
	}
	body {
    	this.ptr = ptr;
    }
	
    ~this() {
    	drop();
    }
	
	/***
	 * Runs the device.
	 * Also increments the virtual timer by calling
	 * Timer.tick();. You can prevent this
	 * by calling Timer.stop(); before and Timer.start() after
	 * calling IrrlichtDevice.run(). Returns false if device wants
	 * to be deleted. Use it in this way:
	 * while(device.run())
	 * {
		// draw everything here
	 * }
	 * If you want the device to do nothing if the window is inactive
	 * (recommended), use the slightly enhanced code shown at isWindowActive().

	 * Note if you are running Irrlicht inside an external, custom
	 * created window: Calling IrrlichtDevice.run() will cause Irrlicht to
	 * dispatch windows messages internally.
	 * If you are running Irrlicht in your own custom window, you can
	 * also simply use your own message loop using GetMessage,
	 * DispatchMessage and whatever and simply don't use this method.
	 * But note that Irrlicht will not be able to fetch user input
	 * then. See IrrlichtCreationParameters.WindowId for more
	 * informations and example code.
	 */
    bool run() {
        return irr_IrrlichtDevice_run(ptr);
    }

	/***
	 * Cause the device to temporarily pause execution and let other processes run.
	 * This should bring down processor usage without major
	 * performance loss for Irrlicht
	 */
    void yield() {
        irr_IrrlichtDevice_yield(ptr);
    }

	/***
	 * Pause execution and let other processes to run for a specified amount of time.
	 * It may not wait the full given time, as sleep may be interrupted
	 * Paarams:
	 *  timeMs = Time to sleep for in milisecs.
	 *  pauseTimer = If true, pauses the device timer while sleeping
	 */
    void sleep(uint timeMs, bool pauseTimer=false) {
        irr_IrrlichtDevice_sleep(ptr, timeMs, pauseTimer);
    }
    
    @property {
		/***
		 * Provides access to the video driver for drawing 3d and 2d geometry.
		 * Return: Pointer the video driver.
		 */
	    VideoDriver videoDriver() {
			driver_ = new VideoDriver(irr_IrrlichtDevice_getVideoDriver(ptr));
			return driver_;
		}

		/***
		 * Provides access to the virtual file system.
		 * Return: Pointer to the file system.
		 */
	    FileSystem fileSystem() {
			filesystem_ = new FileSystem(irr_IrrlichtDevice_getFileSystem(ptr));
			return filesystem_;
		}

		/***
		 * Provides access to the 2d user interface environment.
		 * Return: Pointer to the gui environment.
		 */
	    GUIEnvironment guiEnvironment() {
			gui_ = new GUIEnvironment(irr_IrrlichtDevice_getGUIEnvironment(ptr));
			return gui_;
		}

		/***
		 * Provides access to the scene manager.
		 * Return: Pointer to the scene manager.
		 */
	    SceneManager sceneManager() {
			smgr_ = new SceneManager(irr_IrrlichtDevice_getSceneManager(ptr));
			return smgr_;
		}

		/***
		 * Provides access to the cursor control.
		 * Return: Pointer to the mouse cursor control interface.
		 */
	    CursorControl cursorControl() {
			cursorctl_ = new CursorControl(irr_IrrlichtDevice_getCursorControl(ptr));
			return cursorctl_;
		}

		/***
		 * Provides access to the message logger.
		 * Return: Pointer to the logger.
		 */
	    Logger logger() {
			logger_ = new Logger(irr_IrrlichtDevice_getLogger(ptr));
			return logger_;
		}
		
		/***
		 * Gets a list with all video modes available.
		 * If you are confused now, because you think you have to
		 * create an Irrlicht Device with a video mode before being able
		 * to get the video mode list, let me tell you that there is no
		 * need to start up an Irrlicht Device with Direct3D9,
		 * OpenGL or Software: For this (and for lots of other
		 * reasons) the null driver, Null exists.
		 * Return: Pointer to a list with all video modes supported
		 * by the gfx adapter.
		 */
	    VideoModeList videoModeList() {
			videoModeList_ = new VideoModeList(irr_IrrlichtDevice_getVideoModeList(ptr));
			return videoModeList_;
		}

		/***
		 * Provides access to the operation system operator object.
		 * The OS operator provides methods for
		 * getting system specific informations and doing system
		 * specific operations, such as exchanging data with the clipboard
		 * or reading the operation system version.
		 * Return: Pointer to the OS operator.
		 */
	    OSOperator osOperator() {
			osOperator_ = new OSOperator(irr_IrrlichtDevice_getOSOperator(ptr));
			return osOperator_;
		}

		/***
		 * Provides access to the engine's timer.
		 * The system time can be retrieved by it as
		 * well as the virtual time, which also can be manipulated.
		 * Return: Pointer to the ITimer object.
		 */
	    Timer timer() {
			timer_ = new Timer(irr_IrrlichtDevice_getTimer(ptr));
			return timer_;
		}

		/***
		 * Provides access to the engine's currently set randomizer.
		 * Return: Pointer to the IRandomizer object.
		 */
	    Randomizer randomizer() { return new Randomizer(irr_IrrlichtDevice_getRandomizer(ptr)); }

		/***
		 * Sets a new randomizer.
		 * Params:
		 *  randomizer = Pointer to the new IRandomizer object. This object is
		 * grab()'ed by the engine and will be released upon the next randomizer
		 * call or upon device destruction. */
	    void randomizer(Randomizer randomizer) in { assert(randomizer.ptr != null); } body { irr_IrrlichtDevice_setRandomizer(ptr, randomizer.ptr); }
    }


    /***
     * Creates a new default randomizer.
	 * The default randomizer provides the random sequence known from previous
	 * Irrlicht versions and is the initial randomizer set on device creation.
	 * Return: Pointer to the default Randomizer object.
	 */
    Randomizer createDefaultRandomizer() {
        auto randomizer = irr_IrrlichtDevice_createDefaultRandomizer(ptr);
        return new Randomizer(randomizer);
    }

	/***
     * Sets the caption of the window.
     * Params:
     *  text =  New text of the window caption.
     */
    @property void windowCaption(string text) { irr_IrrlichtDevice_setWindowCaption(ptr, toUTFz!(const(dchar)*)(text)); }
    
    /***
     * Sets the caption of the window through unicode dstring.
     * Params:
     *  text =  New text of the window caption.
     */
    @property void windowCaption(dstring text) { irr_IrrlichtDevice_setWindowCaption(ptr, toUTFz!(const(dchar)*)(text)); }

    /***
     * Returns if the window is active.
	 * If the window is inactive,
	 * nothing needs to be drawn. So if you don't want to draw anything
	 * when the window is inactive, create your drawing loop this way:
	 * while(device.run())
	 * {
	 * if (device.isWindowActive())
	 * {
	 * // draw everything here
	 * }
	 * else
	 * device->yield();
	 * }
	 * return True if window is active.
	 */
    bool isWindowActive() {
        return irr_IrrlichtDevice_isWindowActive(ptr);
    }

	/***
	 * Checks if the Irrlicht window has focus
	 * Return: True if window has focus.
	 */
    bool isWindowFocused() {
        return irr_IrrlichtDevice_isWindowFocused(ptr);
    }

	/***
	 * Checks if the Irrlicht window is minimized
	 * Return: True if window is minimized.
	 */
    bool isWindowMinimized() {
        return irr_IrrlichtDevice_isWindowMinimized(ptr);
    }

	/***
	 * Checks if the Irrlicht window is running in fullscreen mode
	 * Return: True if window is fullscreen.
	 */
    bool isFullscreen() {
        return irr_IrrlichtDevice_isFullscreen(ptr);
    }

	/***
	 * Get the current color format of the window
	 * Return: Color format of the window.
	 */
    ColorFormat getColorFormat() {
        return irr_IrrlichtDevice_getColorFormat(ptr);
    }

	/***
	 * Notifies the device that it should close itself.
	 * IrrlichtDevice.run() will always return false after closeDevice() was called.
	 */
    void closeDevice() {
        irr_IrrlichtDevice_closeDevice(ptr);
    }

	/***
	 * Get the version of the engine.
	 * The returned string
	 * will look like this: "1.2.3" or this: "1.2".
	 * Return: String which contains the version.
	 */
    string getVersion() {
        const char* str = irr_IrrlichtDevice_getVersion(ptr);
        return to!string(str);
    }
	
	/***
	 * Sends a user created event to the engine.
	 * Is is usually not necessary to use this. However, if you
	 * are using an own input library for example for doing joystick
	 * input, you can use this to post key or mouse input events to
	 * the engine. Internally, this method only delegates the events
	 * further to the scene manager and the GUI environment.
	 */
    bool postEventFromUser(Event event) {
        return irr_IrrlichtDevice_postEventFromUser(ptr, event);
    }

	/***
	 * Sets the input receiving scene manager.
	 * If set to null, the main scene manager (returned by
	 * GetSceneManager()) will receive the input
	 * Params:
	 *  smgr =  New scene manager to be used.
	 */
    void setInputReceivingSceneManager(SceneManager smgr) {
        irr_IrrlichtDevice_setInputReceivingSceneManager(ptr, smgr.ptr);
    }

    /***
     * Sets if the window should be resizable in windowed mode.
     * The default is false. This method only works in windowed
     * mode.
     * Params:
     *  value = Flag whether the window should be resizable.
     */
    @property void resizable(bool value) { irr_IrrlichtDevice_setResizable(ptr, value); }

    /***
     * Resize the render window.
     * This will only work in windowed mode and is not yet supported on all systems.
     * It does set the drawing/clientDC size of the window, the window decorations are added to that.
     * You get the current window size with getScreenSize() (might be unified in future)
	 */
    @property void windowSize(dimension2du dim) { irr_IrrlichtDevice_setWindowSize(ptr, dim.ptr); }

	/// Minimizes the window if possible
    void minimizeWindow() {
        irr_IrrlichtDevice_minimizeWindow(ptr);
    }

	/// Maximizes the window if possible.
    void maximizeWindow() {
        irr_IrrlichtDevice_maximizeWindow(ptr);
    }

	/// Restore the window to normal size if possible.
    void restoreWindow() {
        irr_IrrlichtDevice_restoreWindow(ptr);
    }

	/// Get the position of the frame on-screen
    vector2di getWindowPosition() {
        irr_vector2di temp = irr_IrrlichtDevice_getWindowPosition(ptr);
        auto pos = vector2di(temp.x, temp.y);
        return pos;
    }

    /***
     * Activate any joysticks, and generate events for them.
     * Irrlicht contains support for joysticks, but does not generate joystick events by default,
     * as this would consume joystick info that 3rd party libraries might rely on. Call this method to
     * activate joystick support in Irrlicht and to receive JoystickEvent events.
     * Params:
     *  joystickInfo =  On return, this will contain an array of each joystick that was found and activated.
     * return true if joysticks are supported on this device and false if joysticks are not supported or support is compiled out.
	 */
    bool activateJoysticks(JoystickInfo[] joystickInfo) {
    	irr_array temp;
    	temp.data = joystickInfo.ptr;
    	return irr_IrrlichtDevice_activateJoysticks(ptr, &temp);
    }
    
    /// Set the current Gamma Value for the Display
    bool setGammaRamp(float red, float green, float blue, float relativebrightness, float relativecontrast) {
        return irr_IrrlichtDevice_setGammaRamp(ptr, red, green, blue, relativebrightness, relativecontrast);
    }
    
    /// Get the current Gamma Value for the Display
    bool getGammaRamp(out float red, out float green, out float blue, out float relativebrightness, out float relativecontrast) {
        return irr_IrrlichtDevice_getGammaRamp(ptr, red, green, blue, relativebrightness, relativecontrast);
    }
    
    /***
     * Set the maximal elapsed time between 2 clicks to generate doubleclicks for the mouse. It also affects tripleclick behavior.
	 *  When set to 0 no double- and tripleclicks will be generated.
	 *	Params: timeMs = maximal time in milliseconds for two consecutive clicks to be recognized as double click
	 */
    @property void doubleClickTime(uint timeMs) { irr_IrrlichtDevice_setDoubleClickTime(ptr, timeMs); }
    
    /***
     * Get the maximal elapsed time between 2 clicks to generate double- and tripleclicks for the mouse.
	 * When return value is 0 no double- and tripleclicks will be generated.
	 */
    @property uint doubleClickTime() { return irr_IrrlichtDevice_getDoubleClickTime(ptr); }
    
    /***
     * Remove messages pending in the system message loop
	 * This function is usually used after messages have been buffered for a longer time, for example
	 * when loading a large scene. Clearing the message loop prevents that mouse- or buttonclicks which users
	 * have pressed in the meantime will now trigger unexpected actions in the gui. <br>
	 * So far the following messages are cleared:<br>
	 * Win32: All keyboard and mouse messages<br>
	 * Linux: All keyboard and mouse messages<br>
	 * All other devices are not yet supported here.<br>
	 * The function is still somewhat experimental, as the kind of messages we clear is based on just a few use-cases.
	 * If you think further messages should be cleared, or some messages should not be cleared here, then please tell us.
	 */
    void clearSystemMessages() {
        irr_IrrlichtDevice_clearSystemMessages(ptr);
    }
    
    /***
     * Get the type of the device.
	 * This allows the user to check which windowing system is currently being
	 * used.
     */
    @property DeviceType type() { return irr_IrrlichtDevice_getType(ptr); }
    
    /***
     * Check if a driver type is supported by the engine.
	 * Even if true is returned the driver may not be available
	 * for a configuration requested when creating the device.
     */
    bool isDriverSupported(DriverType type) {
        return irr_IrrlichtDevice_isDriverSupported(ptr, type);
    }
    
    void drop() {
        irr_IrrlichtDevice_drop(ptr);
    }
    
    //alias ptr this;
	irr_IrrlichtDevice* ptr;

private:
	VideoDriver driver_;
	FileSystem filesystem_;
	GUIEnvironment gui_;
	SceneManager smgr_;
	CursorControl cursorctl_;
	Logger logger_;
	VideoModeList videoModeList_;
	OSOperator osOperator_;
	Timer timer_;
	Randomizer randomizer_;
}

auto createDevice(DriverType type, dimension2du dim, uint bits = 16, bool fullscreen = false, bool stencilbuffer = false, bool vsync = false) {
	return new IrrlichtDevice(irr_createDevice(type, dim.ptr, bits, fullscreen, stencilbuffer, vsync, null));
}

/// IrrlichtDevice example
unittest {
    mixin(TestPrerequisite);

    try {
        with (device) {
            run();
            yield();
            //sleep(1);
            auto videodriver = videoDriver;
            assert(videodriver !is null);
            assert(videodriver.ptr != null);

            auto filesystem = fileSystem;
            assert(filesystem !is null);
            assert(filesystem.ptr != null);

            auto guienv = guiEnvironment;
			assert(guienv !is null);
            assert(guienv.ptr != null);

            auto scenemgr = sceneManager;
            assert(scenemgr !is null);
            assert(scenemgr.ptr != null);

            auto cursorcontrol = cursorControl;
            assert(cursorcontrol !is null);
            assert(cursorcontrol.ptr != null);

            auto Logger = logger;
            assert(Logger !is null);
            assert(Logger.ptr != null);

            auto videolist = videoModeList;
            assert(videolist !is null);
            assert(videolist.ptr != null);

            auto OSoperator = osOperator;
            assert(OSoperator !is null);
            assert(OSoperator.ptr != null);

            auto Timer = timer;
            assert(Timer !is null);
            assert(Timer.ptr != null);

            auto randomizer1 = randomizer;
            assert(randomizer1 !is null);
            assert(randomizer1.ptr != null);
            
            randomizer = randomizer;
            createDefaultRandomizer();
            windowCaption = "Hello";
            isWindowActive();
            isWindowFocused();
            isWindowMinimized();
            isFullscreen();
            //getColorFormat();
            closeDevice();
            getVersion();
        }
    }

    catch (std.exception.ErrnoException exc) {
        writeln("Error: IrrlichtDevice");
    }
}

package extern (C):

struct irr_IrrlichtDevice;

irr_IrrlichtDevice* irr_createDevice(DriverType driver, irr_dimension2du res, uint bits = 16, bool fullscreen = false, bool stencilbuffer = false, bool vsync = false, EventReceiver receiver=null);
bool irr_IrrlichtDevice_run(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_yield(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_sleep(irr_IrrlichtDevice* device, uint timeMs, bool pauseTimer=false);
irr_IVideoDriver* irr_IrrlichtDevice_getVideoDriver(irr_IrrlichtDevice* device);
irr_IFileSystem* irr_IrrlichtDevice_getFileSystem(irr_IrrlichtDevice* device);
irr_IGUIEnvironment* irr_IrrlichtDevice_getGUIEnvironment(irr_IrrlichtDevice* device);
irr_ISceneManager* irr_IrrlichtDevice_getSceneManager(irr_IrrlichtDevice* device);
irr_ICursorControl* irr_IrrlichtDevice_getCursorControl(irr_IrrlichtDevice* device);
irr_ILogger* irr_IrrlichtDevice_getLogger(irr_IrrlichtDevice* device);
irr_IVideoModeList* irr_IrrlichtDevice_getVideoModeList(irr_IrrlichtDevice* device);
irr_IOSOperator* irr_IrrlichtDevice_getOSOperator(irr_IrrlichtDevice* device);
irr_ITimer* irr_IrrlichtDevice_getTimer(irr_IrrlichtDevice* device);
irr_IRandomizer* irr_IrrlichtDevice_getRandomizer(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_setRandomizer(irr_IrrlichtDevice* device, irr_IRandomizer* randomizer);
irr_IRandomizer* irr_IrrlichtDevice_createDefaultRandomizer(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_setWindowCaption(irr_IrrlichtDevice* device, const(dchar)* text);
bool irr_IrrlichtDevice_isWindowActive(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_isWindowFocused(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_isWindowMinimized(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_isFullscreen(irr_IrrlichtDevice* device);
ColorFormat irr_IrrlichtDevice_getColorFormat(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_closeDevice(irr_IrrlichtDevice* device);
const(char*) irr_IrrlichtDevice_getVersion(irr_IrrlichtDevice* device);
//void irr_IrrlichtDevice_setEventReceiver(irr_IrrlichtDevice* device, irr_IEventReceiver* receiver);
//irr_IEventReceiver* irr_IrrlichtDevice_getEventReceiver(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_postEventFromUser(irr_IrrlichtDevice* device, Event event);
void irr_IrrlichtDevice_setInputReceivingSceneManager(irr_IrrlichtDevice* device, irr_ISceneManager* smgr);
void irr_IrrlichtDevice_setResizable(irr_IrrlichtDevice* device, bool value = false);
void irr_IrrlichtDevice_setWindowSize(irr_IrrlichtDevice* device, irr_dimension2du size);
void irr_IrrlichtDevice_minimizeWindow(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_maximizeWindow(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_restoreWindow(irr_IrrlichtDevice* device);
irr_vector2di irr_IrrlichtDevice_getWindowPosition(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_activateJoysticks(irr_IrrlichtDevice* device, irr_array* joystickInfo);
bool irr_IrrlichtDevice_setGammaRamp(irr_IrrlichtDevice* device, float red, float green, float blue, float relativebrightness, float relativecontrast);
bool irr_IrrlichtDevice_getGammaRamp(irr_IrrlichtDevice* device, ref float red, ref float green, ref float blue, ref float relativebrightness, ref float relativecontrast);
void irr_IrrlichtDevice_setDoubleClickTime(irr_IrrlichtDevice* device, uint timeMs);
uint irr_IrrlichtDevice_getDoubleClickTime(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_clearSystemMessages(irr_IrrlichtDevice* device);
DeviceType irr_IrrlichtDevice_getType(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_isDriverSupported(irr_IrrlichtDevice* device, DriverType type);
void irr_IrrlichtDevice_drop(irr_IrrlichtDevice* device);
