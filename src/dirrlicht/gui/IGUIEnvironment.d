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

import dirrlicht.IrrlichtDevice;
import dirrlicht.gui.IGUIStaticText;
import dirrlicht.gui.IGUIImage;
import dirrlicht.video.SColor;
import dirrlicht.video.ITexture;
import dirrlicht.core.vector2d;
import dirrlicht.core.dimension2d;
import dirrlicht.core.rect;

import std.string;
import std.conv;
import std.utf;

class IGUIEnvironment
{
    this(IrrlichtDevice dev)
    {
        device = dev;
        ptr = irr_IrrlichtDevice_getGUIEnvironment(device.ptr);
    }

    IGUIStaticText addStaticText(dstring text, recti rec, bool border=false)
    {
        auto statictext = new IGUIStaticText(this, text, rec, border);
        return statictext;
    }

    IGUIImage addImage(ITexture texture, vector2di pos)
    {
        auto image = new IGUIImage(this, texture, pos);
        return image;
    }

    void drawAll()
    {
        irr_IGUIEnvironment_drawAll(ptr);
    }

    irr_IGUIEnvironment* ptr;
private:
    IrrlichtDevice device;
}

package extern (C):

    struct irr_IGUIEnvironment;

irr_IGUIStaticText* irr_IGUIEnvironment_addStaticText(irr_IGUIEnvironment* env, const(dchar)* text, const ref irr_recti rectangle, bool border=false);
irr_IGUIImage* irr_IGUIEnvironment_addImage(irr_IGUIEnvironment* env, irr_ITexture* textures, irr_vector2di pos);

void irr_IGUIEnvironment_drawAll(irr_IGUIEnvironment* env);
