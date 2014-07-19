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

module dirrlicht.gui.guienvironment;

import dirrlicht.irrlichtdevice;
import dirrlicht.gui.guistatictext;
import dirrlicht.gui.guiimage;
import dirrlicht.video.color;
import dirrlicht.video.texture;
import dirrlicht.core.vector2d;
import dirrlicht.core.dimension2d;
import dirrlicht.core.rect;

import std.string;
import std.conv;
import std.utf;

class GUIEnvironment {
    this(irr_IGUIEnvironment* ptr)
    out(result) {
		assert(result.ptr != null);
	}
	body {
    	this.ptr = ptr;
    }
    
    GUIStaticText addStaticText(dstring text, recti rec, bool border=false) {
        auto temp = irr_IGUIEnvironment_addStaticText(ptr, toUTFz!(const(dchar)*)(text), rec.ptr, border);
        return new GUIStaticText(temp);
    }

    GUIImage addImage(Texture texture, vector2di pos) {
        auto temp = irr_IGUIEnvironment_addImage(ptr, texture.ptr, pos.ptr);
        return new GUIImage(temp);
    }

    void drawAll() {
        irr_IGUIEnvironment_drawAll(ptr);
    }
    
    alias ptr this;
    irr_IGUIEnvironment* ptr;
}

package extern (C):

struct irr_IGUIEnvironment;

irr_IGUIStaticText* irr_IGUIEnvironment_addStaticText(irr_IGUIEnvironment* env, const(dchar)* text, irr_recti rectangle, bool border=false);
irr_IGUIImage* irr_IGUIEnvironment_addImage(irr_IGUIEnvironment* env, irr_ITexture* textures, irr_vector2di pos);

void irr_IGUIEnvironment_drawAll(irr_IGUIEnvironment* env);
