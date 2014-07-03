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

module dirrlicht.IrrlichtDevice;

import dirrlicht.CompileConfig;
import dirrlicht.core.dimension2d;
import dirrlicht.core.vector2d;
import dirrlicht.video.EDeviceTypes;
import dirrlicht.video.SColor;
import dirrlicht.video.IVideoDriver;
import dirrlicht.video.EDriverTypes;
import dirrlicht.io.IFileSystem;
import dirrlicht.scene.ISceneManager;
import dirrlicht.gui.ICursorControl;
import dirrlicht.gui.IGUIEnvironment;
import dirrlicht.ILogger;
import dirrlicht.video.IVideoModeList;
import dirrlicht.IOSOperator;
import dirrlicht.ITimer;
import dirrlicht.IRandomizer;
import dirrlicht.IEventReceiver;

import std.string;
import std.conv;
import std.utf;

class IrrlichtDevice
{
    this(E_DRIVER_TYPE type, dimension2du dim, uint bits, bool fullscreen, bool stencilbuffer, bool vsync)
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

    IVideoDriver getVideoDriver()
    {
        auto dri = new IVideoDriver(this);
        return dri;
    }

    IFileSystem getFileSystem()
    {
        auto file = new IFileSystem(this);
        return file;
    }

    IGUIEnvironment getGUIEnvironment()
    {
        auto env = new IGUIEnvironment(this);
        return env;
    }

    ISceneManager getSceneManager()
    {
        auto smgr = new ISceneManager(this);
        return smgr;
    }

    ICursorControl getCursorControl()
    {
        auto cursor = new ICursorControl(this);
        return cursor;
    }

    ILogger getLogger()
    {
        auto logger = new ILogger(this);
        return logger;
    }

    IVideoModeList getVideoModeList()
    {
        auto videolist = new IVideoModeList(&this);
        return videolist;
    }

    IOSOperator getOSOperator()
    {
        auto operator = new IOSOperator(this);
        return operator;
    }

    ITimer getTimer()
    {
        auto operator = new ITimer(this);
        return operator;
    }

    IRandomizer getRandomizer()
    {
        auto randomizer = new IRandomizer(this);
        return randomizer;
    }

    void setRandomizer(IRandomizer randomizer)
    {
        irr_IrrlichtDevice_setRandomizer(ptr, cast(irr_IRandomizer*)(randomizer));
    }

    IRandomizer createDefaultRandomizer()
    {
        return cast(IRandomizer)(irr_IrrlichtDevice_createDefaultRandomizer(ptr));
    }

    void setWindowCaption(dstring text)
    {
        irr_IrrlichtDevice_setWindowCaption(ptr, toUTFz!(const(dchar)*)(text));
    }

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

    ECOLOR_FORMAT getColorFormat()
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

    void setEventReceiver(IEventReceiver* receiver)
    {
        irr_IrrlichtDevice_setEventReceiver(ptr, cast(irr_IEventReceiver*)(receiver));
    }

    IEventReceiver getEventReceiver()
    {
        auto receiver = new IEventReceiver(&this);
        return receiver;
    }

    bool postEventFromUser(SEvent event)
    {
        return irr_IrrlichtDevice_postEventFromUser(ptr, cast(irr_SEvent*)(event));
    }

    void setInputReceivingSceneManager(ISceneManager smgr)
    {
        irr_IrrlichtDevice_setInputReceivingSceneManager(ptr, cast(irr_ISceneManager*)(smgr));
    }

    void setResizable(bool value=false)
    {
        irr_IrrlichtDevice_setResizable(ptr, value);
    }

    void setWindowSize(dimension2du dim)
    {
        irr_dimension2du temp = {dim.Width, dim.Height};
        irr_IrrlichtDevice_setWindowSize(ptr, &temp);
    }

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

    bool setGammaRamp(float red, float green, float blue, float relativebrightness, float relativecontrast)
    {
        return irr_IrrlichtDevice_setGammaRamp(ptr, red, green, blue, relativebrightness, relativecontrast);
    }

    bool getGammaRamp(out float red, out float green, out float blue, out float relativebrightness, out float relativecontrast)
    {
        return irr_IrrlichtDevice_getGammaRamp(ptr, red, green, blue, relativebrightness, relativecontrast);
    }

    void setDoubleClickTime(uint timeMs)
    {
        irr_IrrlichtDevice_setDoubleClickTime(ptr, timeMs);
    }

    uint getDoubleClickTime()
    {
        return irr_IrrlichtDevice_getDoubleClickTime(ptr);
    }

    void clearSystemMessages()
    {
        irr_IrrlichtDevice_clearSystemMessages(ptr);
    }

    E_DEVICE_TYPE getType()
    {
        return irr_IrrlichtDevice_getType(ptr);
    }

    bool isDriverSupported(E_DRIVER_TYPE type)
    {
        return irr_IrrlichtDevice_isDriverSupported(ptr, type);
    }

    irr_IrrlichtDevice* ptr;
}

IrrlichtDevice createDevice(E_DRIVER_TYPE type, dimension2du dim, uint bits = 16, bool fullscreen = false, bool stencilbuffer = false, bool vsync = false)
{
    auto device = new IrrlichtDevice(type, dim, bits, fullscreen, stencilbuffer, vsync);
    return device;
}

/// IrrlichtDevice example
unittest
{
    mixin(TestPrerequisite);
}

package extern (C):

struct irr_IrrlichtDevice;

irr_IrrlichtDevice* irr_createDevice(E_DRIVER_TYPE driver, irr_dimension2du res, uint bits = 16, bool fullscreen = false, bool stencilbuffer = false, bool vsync = false, irr_IEventReceiver* receiver=null);
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
ECOLOR_FORMAT irr_IrrlichtDevice_getColorFormat(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_closeDevice(irr_IrrlichtDevice* device);
const char* irr_IrrlichtDevice_getVersion(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_setEventReceiver(irr_IrrlichtDevice* device, irr_IEventReceiver* receiver);
irr_IEventReceiver* irr_IrrlichtDevice_getEventReceiver(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_postEventFromUser(irr_IrrlichtDevice* device, irr_SEvent* event);
void irr_IrrlichtDevice_setInputReceivingSceneManager(irr_IrrlichtDevice* device, irr_ISceneManager* smgr);
void irr_IrrlichtDevice_setResizable(irr_IrrlichtDevice* device, bool value = false);
void irr_IrrlichtDevice_setWindowSize(irr_IrrlichtDevice* device, irr_dimension2du* size);
void irr_IrrlichtDevice_minimizeWindow(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_maximizeWindow(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_restoreWindow(irr_IrrlichtDevice* device);
irr_vector2di irr_IrrlichtDevice_getWindowPosition(irr_IrrlichtDevice* device);
//bool activateJoysticks
bool irr_IrrlichtDevice_setGammaRamp(irr_IrrlichtDevice* device, float red, float green, float blue, float relativebrightness, float relativecontrast);
bool irr_IrrlichtDevice_getGammaRamp(irr_IrrlichtDevice* device, ref float red, ref float green, ref float blue, ref float relativebrightness, ref float relativecontrast);
void irr_IrrlichtDevice_setDoubleClickTime(irr_IrrlichtDevice* device, uint timeMs);
uint irr_IrrlichtDevice_getDoubleClickTime(irr_IrrlichtDevice* device);
void irr_IrrlichtDevice_clearSystemMessages(irr_IrrlichtDevice* device);
E_DEVICE_TYPE irr_IrrlichtDevice_getType(irr_IrrlichtDevice* device);
bool irr_IrrlichtDevice_isDriverSupported(irr_IrrlichtDevice* device, E_DRIVER_TYPE type);
void irr_IrrlichtDevice_drop(irr_IrrlichtDevice* device);
