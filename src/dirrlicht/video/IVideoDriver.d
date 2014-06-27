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

module dirrlicht.video.IVideoDriver;

import dirrlicht.core.dimension2d;
import dirrlicht.IrrlichtDevice;
import dirrlicht.io.IFileSystem;
import dirrlicht.video.SColor;
import dirrlicht.video.ITexture;
import dirrlicht.video.EDriverFeatures;
import dirrlicht.io.IAttributes;
import dirrlicht.video.SMaterial;
import dirrlicht.video.ITexture;

import std.conv;
import std.utf;
import std.string;

class IVideoDriver
{
    this(IrrlichtDevice dev)
    {
        device = dev;
        ptr = irr_IrrlichtDevice_getVideoDriver(device.ptr);
    }

    bool beginScene(bool backBuffer, bool zBuffer, SColor col)
    {
        return irr_IVideoDriver_beginScene(ptr, backBuffer, zBuffer, irr_SColor(col.a, col.b, col.g, col.r));
    }

    bool endScene()
    {
        return irr_IVideoDriver_endScene(ptr);
    }

    ITexture getTexture(string file)
    {
        ITexture texture = new ITexture(this, file);
        return cast(ITexture)(texture);
    }

    int getFPS()
    {
        return irr_IVideoDriver_getFPS(ptr);
    }

    dstring getName()
    {
        auto temp = irr_IVideoDriver_getName(ptr);
        dstring text = temp[0..strlen(temp)].idup;
        return text;
    }

    IrrlichtDevice device;
    irr_IVideoDriver* ptr;
}

/// strlen for dchar*
size_t strlen(const(dchar)* str)
{
    size_t n = 0;
    for (; str[n] != 0; ++n) {}
    return n;
}



package extern(C):

struct irr_IVideoDriver;

bool irr_IVideoDriver_beginScene(irr_IVideoDriver* driver, bool backBuffer, bool zBuffer, irr_SColor color);
bool irr_IVideoDriver_endScene(irr_IVideoDriver* driver);
bool irr_IVideoDriver_queryFeature(irr_IVideoDriver* driver, E_VIDEO_DRIVER_FEATURE feature);
void irr_IVideoDriver_disableFeature(irr_IVideoDriver* driver, E_VIDEO_DRIVER_FEATURE feature, bool flag=true);
const irr_IAttributes* irr_IVideoDriver_getDriverAttributes(irr_IVideoDriver* driver);
bool irr_IVideoDriver_checkDriverReset(irr_IVideoDriver* driver);

irr_ITexture* irr_IVideoDriver_getTexture(irr_IVideoDriver* driver, const char* file);
int irr_IVideoDriver_getFPS(irr_IVideoDriver* driver);
const(dchar)* irr_IVideoDriver_getName(irr_IVideoDriver* driver);
