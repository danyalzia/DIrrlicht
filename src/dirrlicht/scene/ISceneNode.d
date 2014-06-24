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

module dirrlicht.scene.ISceneNode;

import dirrlicht.c.core;
import dirrlicht.c.scene;
import dirrlicht.scene.ISceneManager;
import dirrlicht.core.vector3d;
import dirrlicht.video.EMaterialFlags;
import dirrlicht.video.ITexture;

class ISceneNode
{
    this(ISceneNode parent, ISceneManager s, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1,1,1))
    {
        smgr = s;

    }

    void setMaterialFlag(E_MATERIAL_FLAG flag, bool newvalue)
    {
        irr_ISceneNode_setMaterialFlag(ptr, flag, newvalue);
    }

    void setMaterialTexture(int n, ITexture texture)
    {
        irr_ISceneNode_setMaterialTexture(ptr, n, texture.ptr);
    }

    void setPosition(vector3df pos)
    {
        irr_vector3df temp = {pos.x, pos.y, pos.z};
        irr_ISceneNode_setPosition(ptr, temp);
    }

    irr_ISceneNode* ptr;
private:
    ISceneManager smgr;
}
