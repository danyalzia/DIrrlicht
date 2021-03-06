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

module dirrlicht.scene.meshscenenode;

import dirrlicht.compileconfig;
import dirrlicht.scene.scenenode;
import dirrlicht.scene.scenemanager;
import dirrlicht.scene.mesh;
import dirrlicht.scene.shadowvolumescenenode;

class MeshSceneNode : SceneNode { 
	mixin DefaultSceneNode;
	
    this(irr_IMeshSceneNode* ptr) {
    	this.ptr = ptr;
    	c_ptr = cast(irr_ISceneNode*)ptr;
    }
    
    void setMesh(Mesh mesh) {
        irr_IMeshSceneNode_setMesh(ptr, cast(irr_IMesh*)(mesh.c_ptr));
    }

    Mesh getMesh() {
        auto mesh = irr_IMeshSceneNode_getMesh(ptr);
        Mesh m;
        //m.c_ptr = mesh;
        return m;
    }

    ShadowVolumeSceneNode addShadowVolumeSceneNode(Mesh shadowMesh=null, int id=-1, bool zfailmethod=true, float infinity=1000.0f){
        auto shadow = irr_IMeshSceneNode_addShadowVolumeSceneNode(ptr, cast(irr_IMesh*)(shadowMesh.c_ptr), id, zfailmethod, infinity);
        return new CShadowVolumeSceneNode(shadow);
    }

    void setReadOnlyMaterials(bool readonly) {
        irr_IMeshSceneNode_setReadOnlyMaterials(ptr, readonly);
    }

    bool isReadOnlyMaterials() {
        return irr_IMeshSceneNode_isReadOnlyMaterials(ptr);
    }

	@property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
    irr_IMeshSceneNode* ptr;
}

unittest
{
    mixin(TestPrerequisite);
    //auto mesh = smgr.getMesh("../../media/sydney.md2");
}

extern (C):

struct irr_IMeshSceneNode;

void irr_IMeshSceneNode_setMesh(irr_IMeshSceneNode* node, irr_IMesh* mesh);
irr_IMesh* irr_IMeshSceneNode_getMesh(irr_IMeshSceneNode* node);
irr_IShadowVolumeSceneNode* irr_IMeshSceneNode_addShadowVolumeSceneNode(irr_IMeshSceneNode* node, const irr_IMesh* shadowMesh=null, int id=-1, bool zfailmethod=true, float infinity=1000.0f);
void irr_IMeshSceneNode_setReadOnlyMaterials(irr_IMeshSceneNode* node, bool readonly);
bool irr_IMeshSceneNode_isReadOnlyMaterials(irr_IMeshSceneNode* node);
