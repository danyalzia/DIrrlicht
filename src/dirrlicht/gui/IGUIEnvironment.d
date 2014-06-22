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

module dirrlicht.gui.IGUIEnvironment;

import dirrlicht.c.gui;
import dirrlicht.c.irrlicht;
import dirrlicht.c.core;

import dirrlicht.IrrlichtDevice;
import dirrlicht.core.dimension2d;
import dirrlicht.core.rect;

class IGUIEnvironment
{
    this(IrrlichtDevice dev)
    {
        device = dev;
        env = irr_IrrlichtDevice_getGUIEnvironment(device.ptr);
    }

    void addStaticText(const wchar* text, recti rec, bool border=false)
    {
        irr_recti re = irr_recti(rec.x, rec.y, rec.x1, rec.y1);
        const wchar* txt = "Hello World!";
        irr_IGUIEnvironment_addStaticText(env, text, re, border);
    }

    void drawAll()
    {
        irr_IGUIEnvironment_drawAll(env);
    }
private:
    IrrlichtDevice device;
    irr_IGUIEnvironment* env;
};
