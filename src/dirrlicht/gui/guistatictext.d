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

module dirrlicht.gui.guistatictext;

import dirrlicht.compileconfig;
import dirrlicht.gui.guienvironment;
import dirrlicht.gui.guifont;
import dirrlicht.gui.guialignment;
import dirrlicht.core.rect;
import dirrlicht.video.color;

import std.utf;

class GUIStaticText {
    this(irr_IGUIStaticText* ptr) {
    	this.ptr = ptr;
    }
    
    void setOverrideFont(GUIFont font) {
        irr_IGUIStaticText_setOverrideFont(ptr, font.ptr);
    }

    GUIFont getOverrideFont() {
        auto temp = irr_IGUIStaticText_getOverrideFont(ptr);
        return new GUIFont(temp);
    }

    GUIFont getActiveFont() {
        auto temp = irr_IGUIStaticText_getActiveFont(ptr);
        return new GUIFont(temp);
    }

    void setOverrideColor(Color col) {
        irr_IGUIStaticText_setOverrideColor(ptr, col.ptr);
    }

    Color getOverrideColor() {
        auto temp = irr_IGUIStaticText_getOverrideColor(ptr);
        return Color(temp.r, temp.g, temp.b, temp.a);
    }

    void enableOverrideColor(bool enable) {
        irr_IGUIStaticText_enableOverrideColor(ptr, enable);
    }

    bool isOverrideColorEnabled() {
        return irr_IGUIStaticText_isOverrideColorEnabled(ptr);
    }

    void setBackgroundColor(Color color) {
        irr_IGUIStaticText_setBackgroundColor(ptr, color.ptr);
    }

    bool isDrawBackgroundEnabled() {
        return irr_IGUIStaticText_isDrawBackgroundEnabled(ptr);
    }

    Color getBackgroundColor() {
        auto temp = irr_IGUIStaticText_getBackgroundColor(ptr);
        return Color(temp.r, temp.g, temp.b, temp.a);
    }

    void setDrawBorder(bool draw) {
        irr_IGUIStaticText_setDrawBorder(ptr, draw);
    }

    bool isDrawBorderEnabled() {
        return irr_IGUIStaticText_isDrawBorderEnabled(ptr);
    }

    void setTextAlignment(GUIAlignment horizontal, GUIAlignment vertical) {
        irr_IGUIStaticText_setTextAlignment(ptr, horizontal, vertical);
    }

    void setWordWrap(bool enable) {
        irr_IGUIStaticText_setWordWrap(ptr, enable);
    }

    bool isWordWrapEnabled() {
        return irr_IGUIStaticText_isWordWrapEnabled(ptr);
    }

    @property Height() {
        return irr_IGUIStaticText_getTextHeight(ptr);
    }
    
    @property Width() {
        return irr_IGUIStaticText_getTextWidth(ptr);
    }

    bool isTextRestrainedInside() {
        return irr_IGUIStaticText_isTextRestrainedInside(ptr);
    }

    void setRightToLeft(bool rtl) {
        irr_IGUIStaticText_setRightToLeft(ptr, rtl);
    }

    bool isRightToLeft() {
        return irr_IGUIStaticText_isRightToLeft(ptr);
    }
    
	irr_IGUIStaticText* ptr;
}

unittest
{
    mixin(TestPrerequisite);

//    auto text = gui.addStaticText("Hello World!", recti(20,20,200,200), true);
//    assert(text !is null);
//
//    auto col = SColor(255, 0, 0, 0);
//
//    text.setOverrideColor(col);
//
//    auto font = text.getOverrideFont();
//    assert(font !is null);
//
//    auto font2 = text.getActiveFont();
//    assert(font2 !is null);
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
void irr_IGUIStaticText_setTextAlignment(irr_IGUIStaticText* txt, GUIAlignment horizontal, GUIAlignment vertical);
void irr_IGUIStaticText_setWordWrap(irr_IGUIStaticText* txt, bool enable);
bool irr_IGUIStaticText_isWordWrapEnabled(irr_IGUIStaticText* txt);
int irr_IGUIStaticText_getTextHeight(irr_IGUIStaticText* txt);
int irr_IGUIStaticText_getTextWidth(irr_IGUIStaticText* txt);
bool irr_IGUIStaticText_isTextRestrainedInside(irr_IGUIStaticText* txt);
void irr_IGUIStaticText_setRightToLeft(irr_IGUIStaticText* txt, bool rtl);
bool irr_IGUIStaticText_isRightToLeft(irr_IGUIStaticText* txt);
