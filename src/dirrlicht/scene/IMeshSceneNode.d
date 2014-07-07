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

module dirrlicht.scene.IMeshSceneNode;

import dirrlicht.CompileConfig;
import dirrlicht.scene.ISceneNode;
import dirrlicht.scene.ISceneManager;
import dirrlicht.scene.IMesh;
import dirrlicht.scene.IShadowVolumeSceneNode;

class IMeshSceneNode : ISceneNode
{ 
    this(irr_IMeshSceneNode* ptr)
    {
    	this.ptr = ptr;
    	super(cast(irr_ISceneNode*)ptr);
    }
    
    void setMesh(IMesh mesh)
    {
        irr_IMeshSceneNode_setMesh(ptr, mesh.ptr);
    }

    IMesh getMesh()
    {
        auto mesh = irr_IMeshSceneNode_getMesh(ptr);
        return cast(IMesh)mesh;
    }

    IShadowVolumeSceneNode addShadowVolumeSceneNode(IMesh shadowMesh=null, int id=-1, bool zfailmethod=true, float infinity=1000.0f)
    {
        auto shadow = irr_IMeshSceneNode_addShadowVolumeSceneNode(ptr, shadowMesh.ptr, id, zfailmethod, infinity);
        return cast(IShadowVolumeSceneNode)shadow;
    }

    void setReadOnlyMaterials(bool readonly)
    {
        irr_IMeshSceneNode_setReadOnlyMaterials(ptr, readonly);
    }

    bool isReadOnlyMaterials()
    {
        return irr_IMeshSceneNode_isReadOnlyMaterials(ptr);
    }

    irr_IMeshSceneNode* ptr;
private:
    ISceneManager smgr;
}

unittest
{
    mixin(TestPrerequisite);
    auto mesh = smgr.getMesh("../../media/sydney.md2");
}

extern (C):

struct irr_IMeshSceneNode;

void irr_IMeshSceneNode_setMesh(irr_IMeshSceneNode* node, irr_IMesh* mesh);
irr_IMesh* irr_IMeshSceneNode_getMesh(irr_IMeshSceneNode* node);
irr_IShadowVolumeSceneNode* irr_IMeshSceneNode_addShadowVolumeSceneNode(irr_IMeshSceneNode* node, const irr_IMesh* shadowMesh=null, int id=-1, bool zfailmethod=true, float infinity=1000.0f);
void irr_IMeshSceneNode_setReadOnlyMaterials(irr_IMeshSceneNode* node, bool readonly);
bool irr_IMeshSceneNode_isReadOnlyMaterials(irr_IMeshSceneNode* node);
