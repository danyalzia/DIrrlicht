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

module dirrlicht.scene.ICameraSceneNode;

import dirrlicht.core.dimension2d;
import dirrlicht.IrrlichtDevice;
import dirrlicht.io.IFileSystem;
import dirrlicht.video.SColor;
import dirrlicht.video.IVideoDriver;
import dirrlicht.scene.ISceneManager;
import dirrlicht.scene.ISceneNode;
import dirrlicht.scene.IAnimatedMeshSceneNode;
import dirrlicht.core.vector3d;

class ICameraSceneNode : ISceneNode
{
    this(ISceneManager _smgr, IAnimatedMeshSceneNode* node, vector3df pos, vector3df lookAt)
    {
        smgr = _smgr;
        if (node != null)
            super.ptr = cast(irr_ISceneNode*)irr_ISceneManager_addCameraSceneNode(smgr.smgr, cast(irr_IAnimatedMeshSceneNode*)node.ptr, irr_vector3df(pos.x, pos.y, pos.z), irr_vector3df(lookAt.x, lookAt.y, lookAt.z));
        else
            super.ptr = cast(irr_ISceneNode*)irr_ISceneManager_addCameraSceneNode(smgr.smgr, null, irr_vector3df(pos.x, pos.y, pos.z), irr_vector3df(lookAt.x, lookAt.y, lookAt.z));
    }

    /// CameraNodeFPS
    this(ISceneManager _smgr)
    {
        smgr = _smgr;
        super.ptr = cast(irr_ISceneNode*)irr_ISceneManager_addCameraSceneNodeFPS(smgr.smgr);
    }

    ISceneManager smgr;
    irr_ICameraSceneNode* ptr;
}

extern (C):

struct irr_ICameraSceneNode;
