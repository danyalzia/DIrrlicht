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

module dirrlicht.gui.IGUIImage;

import dirrlicht.gui.IGUIEnvironment;
import dirrlicht.video.ITexture;
import dirrlicht.core.vector2d;

class IGUIImage
{
    this(IGUIEnvironment _env, ITexture texture, vector2di pos)
    {
        env = _env;
        auto tempPos = irr_vector2di(pos.x, pos.y);
        ptr = irr_IGUIEnvironment_addImage(env.ptr, cast(irr_ITexture*)texture, tempPos);
    }

	irr_IGUIImage* ptr;
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

    env.addImage(driver.getTexture("../../wall.bmp"), vector2di(20,20));
}

extern (C):

struct irr_IGUIImage;
