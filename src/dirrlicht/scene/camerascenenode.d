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

module dirrlicht.scene.camerascenenode;

import dirrlicht.core.dimension2d;
import dirrlicht.irrlichtdevice;
import dirrlicht.io.filesystem;
import dirrlicht.video.color;
import dirrlicht.video.videodriver;
import dirrlicht.scene.scenemanager;
import dirrlicht.scene.scenenode;
import dirrlicht.scene.animatedmeshscenenode;
import dirrlicht.core.vector3d;

class CameraSceneNode : SceneNode {
	mixin DefaultSceneNode;
	
    this(irr_ICameraSceneNode* ptr) {
    	this.ptr = ptr;
    	irrPtr = cast(irr_ISceneNode*)ptr;
    }
    
    alias ptr this;
    irr_ICameraSceneNode* ptr;
}

extern (C):

struct irr_ICameraSceneNode;
