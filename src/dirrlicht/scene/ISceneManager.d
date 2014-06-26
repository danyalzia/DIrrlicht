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

module dirrlicht.scene.ISceneManager;

import dirrlicht.c.scene;
import dirrlicht.c.irrlicht;
import dirrlicht.IrrlichtDevice;
import dirrlicht.scene.IMesh;
import dirrlicht.scene.IAnimatedMesh;
import dirrlicht.scene.IAnimatedMeshSceneNode;
import dirrlicht.scene.ICameraSceneNode;
import dirrlicht.core.vector3d;

class ISceneManager
{
    this(IrrlichtDevice dev)
    {
        device = dev;
        smgr = irr_IrrlichtDevice_getSceneManager(device.ptr);
    }

//    IAnimatedMesh getMesh(string filename)
//    {
//        IAnimatedMesh mesh = new IAnimatedMesh(this, filename);
//        return mesh;
//    }

    IAnimatedMeshSceneNode addAnimatedMeshSceneNode(IAnimatedMesh mesh)
    {
        IAnimatedMeshSceneNode meshnode = new IAnimatedMeshSceneNode(this, mesh);
        return cast(IAnimatedMeshSceneNode)(meshnode);
    }

    ICameraSceneNode addCameraSceneNode(IAnimatedMeshSceneNode* node, vector3df pos, vector3df lookAt)
    {
        ICameraSceneNode cameranode = new ICameraSceneNode(this, node, pos, lookAt);
        return cast(ICameraSceneNode)(cameranode);
    }

    ICameraSceneNode addCameraSceneNodeFPS()
    {
        ICameraSceneNode cameranode = new ICameraSceneNode(this);
        return cast(ICameraSceneNode)(cameranode);
    }

    void drawAll()
    {
        irr_ISceneManager_drawAll(smgr);
    }

    IrrlichtDevice device;
    irr_ISceneManager* smgr;
}
