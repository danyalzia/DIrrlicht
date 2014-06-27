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

module dirrlicht.gui.IGUIStaticText;

import dirrlicht.gui.IGUIEnvironment;
import dirrlicht.core.rect;
import dirrlicht.video.SColor;

import std.utf;

class IGUIStaticText
{
    this(IGUIEnvironment _env, dstring text, recti rec, bool border=false)
    {
        env = _env;
        auto re = irr_recti(rec.x, rec.y, rec.x1, rec.y1);
        ptr = irr_IGUIEnvironment_addStaticText(env.ptr, toUTFz!(const(dchar)*)(text), re, border);
    }

    void setOverrideColor(SColor col)
    {
        auto temp = irr_SColor(col.a, col.b, col.g, col.r);
        irr_IGUIStaticText_setOverrideColor(ptr, &temp);
    }

	irr_IGUIStaticText* ptr;
private:
	IGUIEnvironment env;
}

unittest
{
    import dirrlicht;
    import dirrlicht.core;
    import dirrlicht.video;
    import dirrlicht.gui;

    auto device = createDevice(E_DRIVER_TYPE.EDT_OPENGL, dimension2du(800,600));
    assert(device !is null);

    auto driver = device.getVideoDriver();
    assert(driver !is null);
    auto env = device.getGUIEnvironment();
    assert(env !is null);

    env.addStaticText("Hello World!", recti(20,20,200,200), true);
}

extern (C):

struct irr_IGUIStaticText;

void irr_IGUIStaticText_setOverrideColor(irr_IGUIStaticText* txt, irr_SColor* col);
