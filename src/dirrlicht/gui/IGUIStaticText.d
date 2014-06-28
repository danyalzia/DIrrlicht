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
import dirrlicht.gui.IGUIFont;
import dirrlicht.gui.EGUIAlignment;
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

    void setOverrideFont(IGUIFont font)
    {
        irr_IGUIStaticText_setOverrideFont(ptr, cast(irr_IGUIFont*)font);
    }

    IGUIFont getOverrideFont()
    {
        auto temp = irr_IGUIStaticText_getOverrideFont(ptr);
        return cast(IGUIFont)temp;
    }

    IGUIFont getActiveFont()
    {
        auto temp = irr_IGUIStaticText_getActiveFont(ptr);
        return cast(IGUIFont)temp;
    }

    void setOverrideColor(SColor col)
    {
        auto temp = irr_SColor(col.a, col.b, col.g, col.r);
        irr_IGUIStaticText_setOverrideColor(ptr, temp);
    }

    SColor getOverrideColor()
    {
        auto temp = irr_IGUIStaticText_getOverrideColor(ptr);
        return SColor(temp.a, temp.b, temp.g, temp.r);
    }

    void enableOverrideColor(bool enable)
    {
        irr_IGUIStaticText_enableOverrideColor(ptr, enable);
    }

    bool isOverrideColorEnabled()
    {
        return irr_IGUIStaticText_isOverrideColorEnabled(ptr);
    }

    void setBackgroundColor(SColor color)
    {
        irr_IGUIStaticText_setBackgroundColor(ptr, irr_SColor(color.a, color.b, color.g, color.r));
    }

    bool isDrawBackgroundEnabled()
    {
        return irr_IGUIStaticText_isDrawBackgroundEnabled(ptr);
    }

    SColor getBackgroundColor()
    {
        auto temp = irr_IGUIStaticText_getBackgroundColor(ptr);
        return SColor(temp.a, temp.b, temp.g, temp.r);
    }

    void setDrawBorder(bool draw)
    {
        irr_IGUIStaticText_setDrawBorder(ptr, draw);
    }

    bool isDrawBorderEnabled()
    {
        return irr_IGUIStaticText_isDrawBorderEnabled(ptr);
    }

    void setTextAlignment(EGUI_ALIGNMENT horizontal, EGUI_ALIGNMENT vertical)
    {
        irr_IGUIStaticText_setTextAlignment(ptr, horizontal, vertical);
    }

    void setWordWrap(bool enable)
    {
        irr_IGUIStaticText_setWordWrap(ptr, enable);
    }

    bool isWordWrapEnabled()
    {
        return irr_IGUIStaticText_isWordWrapEnabled(ptr);
    }

    @property Height() { return irr_IGUIStaticText_getTextHeight(ptr); }
    @property Width() { return irr_IGUIStaticText_getTextWidth(ptr); }

    bool isTextRestrainedInside()
    {
        return irr_IGUIStaticText_isTextRestrainedInside(ptr);
    }

    void setRightToLeft(bool rtl)
    {
        irr_IGUIStaticText_setRightToLeft(ptr, rtl);
    }

    bool isRightToLeft()
    {
        return irr_IGUIStaticText_isRightToLeft(ptr);
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

    auto text = env.addStaticText("Hello World!", recti(20,20,200,200), true);
    assert(text !is null);

    auto col = SColor(255, 0, 0, 0);

    text.setOverrideColor(col);

    auto font = text.getOverrideFont();
    assert(font !is null);

    auto font2 = text.getActiveFont();
    assert(font2 !is null);
}

extern (C):

struct irr_IGUIStaticText;

void irr_IGUIStaticText_setOverrideFont(irr_IGUIStaticText* txt, irr_IGUIFont* font);
irr_IGUIFont* irr_IGUIStaticText_getOverrideFont(irr_IGUIStaticText* txt);
irr_IGUIFont* irr_IGUIStaticText_getActiveFont(irr_IGUIStaticText* txt);
void irr_IGUIStaticText_setOverrideColor(irr_IGUIStaticText* txt, irr_SColor col);
irr_SColor irr_IGUIStaticText_getOverrideColor(irr_IGUIStaticText* txt);
void irr_IGUIStaticText_enableOverrideColor(irr_IGUIStaticText* txt, bool enable);
bool irr_IGUIStaticText_isOverrideColorEnabled(irr_IGUIStaticText* txt);
void irr_IGUIStaticText_setBackgroundColor(irr_IGUIStaticText* txt, irr_SColor color);
void irr_IGUIStaticText_setDrawBackground(irr_IGUIStaticText* txt, bool draw);
bool irr_IGUIStaticText_isDrawBackgroundEnabled(irr_IGUIStaticText* txt);
irr_SColor irr_IGUIStaticText_getBackgroundColor(irr_IGUIStaticText* txt);
void irr_IGUIStaticText_setDrawBorder(irr_IGUIStaticText* txt, bool draw);
bool irr_IGUIStaticText_isDrawBorderEnabled(irr_IGUIStaticText* txt);
void irr_IGUIStaticText_setTextAlignment(irr_IGUIStaticText* txt, EGUI_ALIGNMENT horizontal, EGUI_ALIGNMENT vertical);
void irr_IGUIStaticText_setWordWrap(irr_IGUIStaticText* txt, bool enable);
bool irr_IGUIStaticText_isWordWrapEnabled(irr_IGUIStaticText* txt);
int irr_IGUIStaticText_getTextHeight(irr_IGUIStaticText* txt);
int irr_IGUIStaticText_getTextWidth(irr_IGUIStaticText* txt);
bool irr_IGUIStaticText_isTextRestrainedInside(irr_IGUIStaticText* txt);
void irr_IGUIStaticText_setRightToLeft(irr_IGUIStaticText* txt, bool rtl);
bool irr_IGUIStaticText_isRightToLeft(irr_IGUIStaticText* txt);
