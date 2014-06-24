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

module dirrlicht.c.video;
import dirrlicht.c.core;
import dirrlicht.c.irrlicht;
import dirrlicht.c.io;

import dirrlicht.video.EDriverFeatures;

extern (C)
{
    struct irr_SColor
    {
        int a;
        int b;
        int g;
        int r;
    };

    struct irr_ITexture;
    struct irr_IVideoModeList;
    struct irr_IrrlichtDevice;
    struct irr_IVideoDriver;
    struct irr_Attributes;

    bool irr_IVideoDriver_beginScene(irr_IVideoDriver* driver, bool backBuffer, bool zBuffer, irr_SColor color);
    bool irr_IVideoDriver_endScene(irr_IVideoDriver* driver);
    bool irr_IVideoDriver_queryFeature(irr_IVideoDriver* driver, E_VIDEO_DRIVER_FEATURE feature);
    void irr_IVideoDriver_disableFeature(irr_IVideoDriver* driver, E_VIDEO_DRIVER_FEATURE feature, bool flag=true);
    const irr_Attributes* irr_IVideoDriver_getDriverAttributes(irr_IVideoDriver* driver);
    bool irr_IVideoDriver_checkDriverReset(irr_IVideoDriver* driver);

    irr_ITexture* irr_IVideoDriver_getTexture(irr_IVideoDriver* driver, const char* file);
    int irr_IVideoDriver_getFPS(irr_IVideoDriver* driver);
    const(dchar)* irr_IVideoDriver_getName(irr_IVideoDriver* driver);
}
