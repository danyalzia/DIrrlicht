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

import dirrlicht.c.irrlicht;
import dirrlicht.c.core;
import dirrlicht.c.scene;

import dirrlicht.core.dimension2d;
import dirrlicht.core.vector2d;
import dirrlicht.video.IVideoDriver;
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

import std.conv;

class IrrlichtDevice
{
    this(E_DRIVER_TYPE type, dimension2du dim)
    {
        device = irr_createDevice(type, irr_dimension2du(dim.Width, dim.Height));
    }

    bool run()
    {
        return irr_IrrlichtDevice_run(device);
    }

	void yield()
	{
		irr_IrrlichtDevice_yield(device);
	}

	void sleep(uint timeMs, bool pauseTimer=false)
	{
		irr_IrrlichtDevice_sleep(device, timeMs, pauseTimer);
	}

    IVideoDriver getVideoDriver()
    {
        IVideoDriver dri = new IVideoDriver(&this);
        return cast(IVideoDriver)(dri);
    }

    IFileSystem getFileSystem()
    {
        IFileSystem file = new IFileSystem(&this);
        return cast(IFileSystem)(file);
    }

    IGUIEnvironment getGUIEnvironment()
    {
        IGUIEnvironment env = new IGUIEnvironment(&this);
        return cast(IGUIEnvironment)(env);
    }

    ISceneManager getSceneManager()
    {
        ISceneManager smgr = new ISceneManager(&this);
        return cast(ISceneManager)(smgr);
    }

    ICursorControl getCursorControl()
    {
        ICursorControl cursor = new ICursorControl(&this);
        return cast(ICursorControl)(cursor);
    }

    ILogger getLogger()
    {
        ILogger logger = new ILogger(&this);
        return cast(ILogger)(logger);
    }

    IVideoModeList getVideoModeList()
    {
        IVideoModeList videolist = new IVideoModeList(&this);
        return cast(IVideoModeList)(videolist);
    }

    IOSOperator getOSOperator()
    {
        IOSOperator operator = new IOSOperator(&this);
        return cast(IOSOperator)(operator);
    }

    ITimer getTimer()
    {
        ITimer operator = new ITimer(&this);
        return cast(ITimer)(operator);
    }

    IRandomizer getRandomizer()
    {
        IRandomizer randomizer = new IRandomizer(&this);
        return cast(IRandomizer)(randomizer);
    }

    void setRandomizer(IRandomizer* randomizer)
    {
        irr_IrrlichtDevice_setRandomizer(device, cast(irr_IRandomizer*)(randomizer));
    }

    IRandomizer createDefaultRandomizer()
    {
        return cast(IRandomizer)(irr_IrrlichtDevice_createDefaultRandomizer(device));
    }

    void setWindowCaption(string text)
    {
        wstring temp = cast(wstring)text.ptr;
        irr_IrrlichtDevice_setWindowCaption(device, temp.ptr);
    }

    bool isWindowActice()
    {
        return irr_IrrlichtDevice_isWindowActive(device);
    }

    bool isWindowFocused()
    {
        return irr_IrrlichtDevice_isWindowFocused(device);
    }

    bool isWindowMinimized()
    {
        return irr_IrrlichtDevice_isWindowMinimized(device);
    }

    bool isFullscreen()
    {
        return irr_IrrlichtDevice_isFullscreen(device);
    }

    ECOLOR_FORMAT getColorFormat()
    {
        return irr_IrrlichtDevice_getColorFormat(device);
    }

    void closeDevice()
    {
        irr_IrrlichtDevice_closeDevice(device);
    }

    string getVersion()
    {
        const char* str = irr_IrrlichtDevice_getVersion(device);
        return to!string(str);
    }

    void setEventReceiver(IEventReceiver* receiver)
    {
        irr_IrrlichtDevice_setEventReceiver(device, cast(irr_IEventReceiver*)(receiver));
    }

    IEventReceiver getEventReceiver()
    {
        IEventReceiver receiver = new IEventReceiver(&this);
        return cast(IEventReceiver)(receiver);
    }

    bool postEventFromUser(SEvent* event)
    {
        return irr_IrrlichtDevice_postEventFromUser(device, cast(irr_SEvent*)(event));
    }

    void setInputReceivingSceneManager(ISceneManager* smgr)
    {
        irr_IrrlichtDevice_setInputReceivingSceneManager(device, cast(irr_ISceneManager*)(smgr));
    }

    void setResizable(bool value=false)
    {
        irr_IrrlichtDevice_setResizable(device, value);
    }

    void setWindowSize(dimension2d!(uint) dim)
    {
        irr_dimension2du temp = {dim.Width, dim.Height};
        irr_IrrlichtDevice_setWindowSize(device, &temp);
    }

    void minimizeWindow()
    {
        irr_IrrlichtDevice_minimizeWindow(device);
    }

    void maximizeWindow()
    {
        irr_IrrlichtDevice_maximizeWindow(device);
    }

    void restoreWindow()
    {
        irr_IrrlichtDevice_restoreWindow(device);
    }

    vector2d!(int) getWindowPosition()
    {
        irr_vector2di temp = irr_IrrlichtDevice_getWindowPosition(device);
        auto pos = vector2d!(int)(temp.x, temp.y);
        return pos;
    }

    bool setGammaRamp(float red, float green, float blue, float relativebrightness, float relativecontrast)
    {
        return irr_IrrlichtDevice_setGammaRamp(device, red, green, blue, relativebrightness, relativecontrast);
    }

    bool getGammaRamp(out float red, out float green, out float blue, out float relativebrightness, out float relativecontrast)
    {
        return irr_IrrlichtDevice_getGammaRamp(device, red, green, blue, relativebrightness, relativecontrast);
    }

    void setDoubleClickTime(uint timeMs)
    {
        irr_IrrlichtDevice_setDoubleClickTime(device, timeMs);
    }

    uint getDoubleClickTime()
    {
        return irr_IrrlichtDevice_getDoubleClickTime(device);
    }

    void clearSystemMessages()
    {
        irr_IrrlichtDevice_clearSystemMessages(device);
    }

    E_DEVICE_TYPE getType()
    {
        return irr_IrrlichtDevice_getType(device);
    }

    bool isDriverSupported(E_DRIVER_TYPE type)
    {
        return irr_IrrlichtDevice_isDriverSupported(device, type);
    }

    irr_IrrlichtDevice* device;
}

IrrlichtDevice createDevice(E_DRIVER_TYPE type, dimension2du dim)
{
    auto device = new IrrlichtDevice(type, dim);
    return device;
}
