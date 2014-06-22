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

module dirrlicht.scene.IAnimatedMeshSceneNode;

import dirrlicht.c.scene;
import dirrlicht.c.irrlicht;
import dirrlicht.c.video;
import dirrlicht.IrrlichtDevice;
import dirrlicht.scene.ISceneManager;
import dirrlicht.scene.IAnimatedMesh;
import dirrlicht.scene.IAnimatedMeshSceneNode;
import dirrlicht.video.ITexture;

class IAnimatedMeshSceneNode
{
    this(ISceneManager _smgr, IAnimatedMesh _mesh)
    {
        smgr = _smgr;
        mesh = irr_ISceneManager_addAnimatedMeshSceneNode(smgr.smgr, _mesh.mesh);
    }

    void setMaterialFlag(E_MATERIAL_FLAG flag, bool newvalue)
    {
        irr_IAnimatedMeshSceneNode_setMaterialFlag(mesh, flag, newvalue);
    }

    void setMD2Animation(EMD2_ANIMATION_TYPE value)
    {
        irr_IAnimatedMeshSceneNode_setMD2Animation(mesh, value);
    }

    void setMaterialTexture(int n, ITexture texture)
    {
        irr_IAnimatedMeshSceneNode_setMaterialTexture(mesh, n, texture.ptr);
    }

    ISceneManager smgr;
    irr_IAnimatedMeshSceneNode* mesh;
};
