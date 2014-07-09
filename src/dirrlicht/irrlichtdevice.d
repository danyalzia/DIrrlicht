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
class IrrlichtDevice
{
    this(DriverType type, dimension2du dim, uint bits, bool fullscreen, bool stencilbuffer, bool vsync)
    {
        ptr = irr_createDevice(type, irr_dimension2du(dim.Width, dim.Height), bits, fullscreen, stencilbuffer, vsync);
    }
    
    bool run()
    {
        return irr_IrrlichtDevice_run(ptr);
    }

    void yield()
    {
        irr_IrrlichtDevice_yield(ptr);
    }

    void sleep(uint timeMs, bool pauseTimer=false)
    {
        irr_IrrlichtDevice_sleep(ptr, timeMs, pauseTimer);
    }

    @property VideoDriver videoDriver() { return new VideoDriver(this); }
    @property FileSystem fileSystem() { return new FileSystem(this); }
    @property GUIEnvironment guiEnvironment() { return new GUIEnvironment(this); }
    @property SceneManager sceneManager() { return new SceneManager(this); }
    @property CursorControl cursorControl() { return new CursorControl(this); }
    @property Logger logger() { return new Logger(this); }
    @property VideoModeList videoModeList() { return new VideoModeList(this); }
    @property OSOperator osOperator() { return new OSOperator(this); }
    @property Timer timer() { return new Timer(this); }
    @property Randomizer randomizer() { return new Randomizer(this); }
    @property void randomizer(Randomizer randomizer) { irr_IrrlichtDevice_setRandomizer(ptr, randomizer.ptr); }

    Randomizer createDefaultRandomizer()
    {
        auto randomizer = irr_IrrlichtDevice_createDefaultRandomizer(ptr);
        return new Randomizer(randomizer);
    }
    
    @property void windowCaption(dstring text) { irr_IrrlichtDevice_setWindowCaption(ptr, toUTFz!(const(dchar)*)(text)); }
    
    bool isWindowActive()
    {
        return irr_IrrlichtDevice_isWindowActive(ptr);
    }

    bool isWindowFocused()
    {
        return irr_IrrlichtDevice_isWindowFocused(ptr);
    }

    bool isWindowMinimized()
    {
        return irr_IrrlichtDevice_isWindowMinimized(ptr);
    }

    bool isFullscreen()
    {
        return irr_IrrlichtDevice_isFullscreen(ptr);
    }

    ColorFormat getColorFormat()
    {
        return irr_IrrlichtDevice_getColorFormat(ptr);
    }

    void closeDevice()
    {
        irr_IrrlichtDevice_closeDevice(ptr);
    }

    string getVersion()
    {
        const char* str = irr_IrrlichtDevice_getVersion(ptr);
        return to!string(str);
    }
    
    @property void eventReceiver(EventReceiver receiver) { eventPtr = new EventReceiver(receiver.ptr); irr_IrrlichtDevice_setEventReceiver(ptr, eventPtr.ptr);   }
    @property EventReceiver eventReceiver() { return eventPtr; }

    bool postEventFromUser(Event event)
    {
        return irr_IrrlichtDevice_postEventFromUser(ptr, event.ptr);
    }

    void setInputReceivingSceneManager(SceneManager smgr)
    {
        irr_IrrlichtDevice_setInputReceivingSceneManager(ptr, smgr.ptr);
    }
    
    @property void resizable(bool value) { irr_IrrlichtDevice_setResizable(ptr, value); }
    
    @property void windowSize(dimension2du dim) { irr_IrrlichtDevice_setWindowSize(ptr, dim.ptr); }

    void minimizeWindow()
    {
        irr_IrrlichtDevice_minimizeWindow(ptr);
    }

    void maximizeWindow()
    {
        irr_IrrlichtDevice_maximizeWindow(ptr);
    }

    void restoreWindow()
    {
        irr_IrrlichtDevice_restoreWindow(ptr);
    }

    vector2di getWindowPosition()
    {
        irr_vector2di temp = irr_IrrlichtDevice_getWindowPosition(ptr);
        auto pos = vector2di(temp.x, temp.y);
        return pos;
    }
    
    bool activateJoysticks(irr_IrrlichtDevice* device, JoystickInfo[] joystickInfo)
    {
    	irr_array temp;
    	temp.data = joystickInfo.ptr;
    	return irr_IrrlichtDevice_activateJoysticks(ptr, &temp);
    }
    
    /// Set the current Gamma Value for the Display
    bool setGammaRamp(float red, float green, float blue, float relativebrightness, float relativecontrast)
    {
        return irr_IrrlichtDevice_setGammaRamp(ptr, red, green, blue, relativebrightness, relativecontrast);
    }
    
    /// Get the current Gamma Value for the Display
    bool getGammaRamp(out float red, out float green, out float blue, out float relativebrightness, out float relativecontrast)
    {
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
    void clearSystemMessages()
    {
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
    bool isDriverSupported(DriverType type)
    {
        return irr_IrrlichtDevice_isDriverSupported(ptr, type);
    }
    
    void drop()
    {
        irr_IrrlichtDevice_drop(ptr);
    }
    
    EventReceiver eventPtr;
	irr_IrrlichtDevice* ptr;
}

auto createDevice(DriverType type, dimension2du dim, uint bits = 16, bool fullscreen = false, bool stencilbuffer = false, bool vsync = false)
{
	return new IrrlichtDevice(type, dim, bits, fullscreen, stencilbuffer, vsync);
}

/// IrrlichtDevice example
unittest
{
    mixin(TestPrerequisite);

    try
    {
        with (device)
        {
            run();
            yield();
            sleep(1);
            auto videodriver = videoDriver;
            assert(videodriver !is null);
            assert(videodriver.ptr != null);

            auto filesystem = fileSystem;
            assert(filesystem !is null);
            assert(filesystem.ptr != null);

            auto guienv = guiEnvironment;
            assert(guienv !is null);
            assert(guienv.ptr != null);

            auto scenemgr = scenemanager;
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

            auto OSoperator = osoperator;
            assert(OSoperator !is null);
            assert(OSoperator.ptr != null);

            auto Timer = timer;
            assert(Timer !is null);
            assert(Timer.ptr != null);

            auto randomizer1 = randomizer;
            assert(randomizer1 !is null);
            assert(randomizer1.ptr != null);

            setRandomizer(randomizer);
            createDefaultRandomizer();
            setWindowCaption("Hello");
            isWindowActive();
            isWindowFocused();
            isWindowMinimized();
            isFullscreen();
            //getColorFormat();
            closeDevice();
            getVersion();
            auto reventreceiver = getEventReceiver();
            assert(reventreceiver !is null);
            //assert(reventreceiver.ptr != null);

//            setEventReceiver(reventreceiver);
//            setInputReceivingSceneManager(smgr);
//            setResizable(true);
//            setWindowSize(dimension2du(800,600));
//            minimizeWindow();
//            maximizeWindow();
//            restoreWindow();
//            getWindowPosition();
//            float red;
//            float green;
//            float blue;
//            float bright;
//            float contrast;
//            setGammaRamp(red, green, blue, bright, contrast);
//            getGammaRamp(red, green, blue, bright, contrast);
//            setDoubleClickTime(1);
//            getDoubleClickTime();
//            clearSystemMessages();
//            getType();
//            isDriverSupported(E_DRIVER_TYPE.EDT_OPENGL);
//            drop();
        }
    }

    catch (std.exception.ErrnoException exc)
    {
        writeln("(Could not read from file; assuming 1)");
    }
}

package extern (C):

struct irr_IrrlichtDevice;

irr_IrrlichtDevice* irr_createDevice(DriverType driver, irr_dimension2du res, uint bits = 16, bool fullscreen = false, bool stencilbuffer = false, bool vsync = false, irr_IEventReceiver* receiver=null);
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
const char* irr_IrrlichtDevice_getVersion(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_setEventReceiver(irr_IrrlichtDevice* device, irr_IEventReceiver* receiver);
irr_IEventReceiver* irr_IrrlichtDevice_getEventReceiver(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_postEventFromUser(irr_IrrlichtDevice* device, irr_SEvent* event);
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
E_DEVICE_TYPE irr_IrrlichtDevice_getType(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_isDriverSupported(irr_IrrlichtDevice* device, DriverType type);
void irr_IrrlichtDevice_drop(irr_IrrlichtDevice* device);
