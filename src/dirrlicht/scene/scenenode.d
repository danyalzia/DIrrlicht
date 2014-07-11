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

module dirrlicht.scene.scenenode;

import dirrlicht.compileconfig;
import dirrlicht.scene.scenenodeanimator;
import dirrlicht.scene.scenemanager;
import dirrlicht.core.list;
import dirrlicht.core.vector3d;
import dirrlicht.video.materialflags;
import dirrlicht.video.materialtypes;
import dirrlicht.video.texture;
import dirrlicht.scene.scenenodeanimator;
import dirrlicht.video.material;
import dirrlicht.scene.triangleselector;
import dirrlicht.scene.scenenodetypes;
import dirrlicht.io.attributes;
import dirrlicht.io.attributeexchangingobject;

interface SceneNode
{
	void addAnimator(SceneNodeAnimator animator);
    void removeAnimator(SceneNodeAnimator animator);
    void removeAnimators();
    Material getMaterial(uint num);
    void setMaterialFlag(MaterialFlag flag, bool newvalue);
    void setMaterialTexture(int n, Texture texture);
    void setMaterialType(MaterialType newType);
    @property
    {
	    vector3df scale();
	    void scale(vector3df scale);
	    vector3df rotation();
	    void rotation(vector3df rotation);
	    vector3df position();
	    void position(vector3df pos);
    }
    
    vector3df getAbsolutePosition();
    void setAutomaticCulling(uint state);
    uint getAutomaticCulling();
    void setDebugDataVisible(uint state);
    uint isDebugDataVisible();
    void setIsDebugObject(bool debugObject);
    bool isDebugObject();
    void setParent(SceneNode newParent);
    TriangleSelector getTriangleSelector();
    void setTriangleSelector(TriangleSelector selector);
    void updateAbsolutePosition();
    SceneNode* getParent();
    ESCENE_NODE_TYPE getType();
    SceneManager getSceneManager();
    @property irr_ISceneNode* irrPtr();
    @property void irrPtr(irr_ISceneNode* ptr);
}

mixin template DefaultSceneNode()
{
    import dirrlicht.compileconfig;
	import dirrlicht.scene.scenenodeanimator;
	import dirrlicht.scene.scenemanager;
	import dirrlicht.core.list;
	import dirrlicht.core.vector3d;
	import dirrlicht.video.materialflags;
	import dirrlicht.video.materialtypes;
	import dirrlicht.video.texture;
	import dirrlicht.scene.scenenodeanimator;
	import dirrlicht.video.material;
	import dirrlicht.scene.triangleselector;
	import dirrlicht.scene.scenenodetypes;
	import dirrlicht.io.attributes;
	import dirrlicht.io.attributeexchangingobject;
	
    void addAnimator(SceneNodeAnimator animator)
    {
        irr_ISceneNode_addAnimator(irrPtr, animator.ptr);
    }

    void removeAnimator(SceneNodeAnimator animator)
    {
        irr_ISceneNode_removeAnimator(irrPtr, animator.ptr);
    }

    void removeAnimators()
    {
        irr_ISceneNode_removeAnimators(irrPtr);
    }

    Material getMaterial(uint num)
    {
        return new Material(irr_ISceneNode_getMaterial(irrPtr, num));
    }

    void setMaterialFlag(MaterialFlag flag, bool newvalue)
    {
        irr_ISceneNode_setMaterialFlag(irrPtr, flag, newvalue);
    }

    void setMaterialTexture(int n, Texture texture)
    {
        irr_ISceneNode_setMaterialTexture(irrPtr, n, texture.ptr);
    }

    void setMaterialType(MaterialType newType)
    {
        irr_ISceneNode_setMaterialType(irrPtr, newType);
    }

    
    @property
    {
	    vector3df scale()
	    {
	        auto temp = irr_ISceneNode_getScale(irrPtr);
	        return vector3df(temp.x, temp.y, temp.z);
	    }
	
	    void scale(vector3df scale)
	    {
	        irr_vector3df temp = {scale.x, scale.y, scale.z};
	        irr_ISceneNode_setScale(irrPtr, temp);
	    }
	
	    vector3df rotation()
	    {
	        auto temp = irr_ISceneNode_getRotation(irrPtr);
	        auto rot = vector3df(temp.x, temp.y, temp.z);
	        return rot;
	    }
	
	    void rotation(vector3df rotation)
	    {
	        irr_vector3df temp = {rotation.x, rotation.y, rotation.z};
	        irr_ISceneNode_setRotation(irrPtr, temp);
	    }
	
	    vector3df position()
	    {
	        auto temp = irr_ISceneNode_getPosition(irrPtr);
	        return vector3df(temp.x, temp.y, temp.z);
	    }
	
	    void position(vector3df pos)
	    {
	        irr_ISceneNode_setPosition(irrPtr, pos.ptr);
	    }
    }
    
    vector3df getAbsolutePosition()
    {
        auto temp = irr_ISceneNode_getAbsolutePosition(irrPtr);
        auto pos = vector3df(temp.x, temp.y, temp.z);
        return pos;
    }

    void setAutomaticCulling(uint state)
    {
        irr_ISceneNode_setAutomaticCulling(irrPtr, state);
    }

    uint getAutomaticCulling()
    {
        return irr_ISceneNode_getAutomaticCulling(irrPtr);
    }

    void setDebugDataVisible(uint state)
    {
        irr_ISceneNode_setDebugDataVisible(irrPtr, state);
    }

    uint isDebugDataVisible()
    {
        return irr_ISceneNode_isDebugDataVisible(irrPtr);
    }

    void setIsDebugObject(bool debugObject)
    {
        irr_ISceneNode_setIsDebugObject(irrPtr, debugObject);
    }

    bool isDebugObject()
    {
        return irr_ISceneNode_isDebugObject(irrPtr);
    }

    void setParent(SceneNode newParent)
    {
        irr_ISceneNode_setParent(irrPtr, newParent.irrPtr);
    }

    TriangleSelector getTriangleSelector()
    {
        auto temp = irr_ISceneNode_getTriangleSelector(irrPtr);
        return new TriangleSelector(temp);
    }

    void setTriangleSelector(TriangleSelector selector)
    {
        irr_ISceneNode_setTriangleSelector(irrPtr, selector.ptr);
    }

    void updateAbsolutePosition()
    {
        irr_ISceneNode_updateAbsolutePosition(irrPtr);
    }

    SceneNode* getParent()
    {
        auto temp = irr_ISceneNode_getParent(irrPtr);
        SceneNode* node;
        return node;
    }

    ESCENE_NODE_TYPE getType()
    {
        return irr_ISceneNode_getType(irrPtr);
    }

    SceneManager getSceneManager()
    {
        auto temp = irr_ISceneNode_getSceneManager(irrPtr);
        return new SceneManager(temp);
    }
    
    @property irr_ISceneNode* irrPtr()
    {
    	return irrPtr_;
    }
    
    @property void irrPtr(irr_ISceneNode* ptr)
    {
    	irrPtr_ = ptr;
    }
    
    irr_ISceneNode* irrPtr_;
private:
    SceneManager smgr;
}

unittest
{
    mixin(TestPrerequisite);


    auto mesh = smgr.getMesh("../../media/sydney.md2");
    assert(mesh.ptr != null);
    auto node = smgr.addAnimatedMeshSceneNode(mesh);

    with(node)
    {
        assert(ptr != null);
        setMaterialFlag(E_MATERIAL_FLAG.EMF_LIGHTING, false);
    }
}

extern (C):

struct irr_ISceneNode;

void irr_ISceneNode_addAnimator(irr_ISceneNode* node, irr_ISceneNodeAnimator* animator);
//irr_list* irr_ISceneNode_getAnimators(irr_ISceneNode* node);
void irr_ISceneNode_removeAnimator(irr_ISceneNode* node, irr_ISceneNodeAnimator* animator);
void irr_ISceneNode_removeAnimators(irr_ISceneNode* node);
ref irr_SMaterial* irr_ISceneNode_getMaterial(irr_ISceneNode* node, uint num);
uint irr_ISceneNode_getMaterialCount(irr_ISceneNode* node);
void irr_ISceneNode_setMaterialFlag(irr_ISceneNode* node, MaterialFlag flag, bool newvalue);
void irr_ISceneNode_setMaterialTexture(irr_ISceneNode* node, int c, irr_ITexture* texture);
void irr_ISceneNode_setMaterialType(irr_ISceneNode* node, MaterialType newType);
irr_vector3df irr_ISceneNode_getScale(irr_ISceneNode* node);
void irr_ISceneNode_setScale(irr_ISceneNode* node, irr_vector3df scale);
irr_vector3df irr_ISceneNode_getRotation(irr_ISceneNode* node);
void irr_ISceneNode_setRotation(irr_ISceneNode* node, irr_vector3df rotation);
irr_vector3df irr_ISceneNode_getPosition(irr_ISceneNode* node);
void irr_ISceneNode_setPosition(irr_ISceneNode* node, irr_vector3df newpos);
irr_vector3df irr_ISceneNode_getAbsolutePosition(irr_ISceneNode* node);
void irr_ISceneNode_setAutomaticCulling(irr_ISceneNode* node, uint state);
uint irr_ISceneNode_getAutomaticCulling(irr_ISceneNode* node);
void irr_ISceneNode_setDebugDataVisible(irr_ISceneNode* node, uint state);
uint irr_ISceneNode_isDebugDataVisible(irr_ISceneNode* node);
void irr_ISceneNode_setIsDebugObject(irr_ISceneNode* node, bool debugObject);
bool irr_ISceneNode_isDebugObject(irr_ISceneNode* node);
//irr_list* irr_ISceneNode_getChildren(irr_ISceneNode* node);
void irr_ISceneNode_setParent(irr_ISceneNode* node, irr_ISceneNode* newParent);
irr_ITriangleSelector* irr_ISceneNode_getTriangleSelector(irr_ISceneNode* node);
void irr_ISceneNode_setTriangleSelector(irr_ISceneNode* node, irr_ITriangleSelector* selector);
void irr_ISceneNode_updateAbsolutePosition(irr_ISceneNode* node);
irr_ISceneNode* irr_ISceneNode_getParent(irr_ISceneNode* node);
ESCENE_NODE_TYPE irr_ISceneNode_getType(irr_ISceneNode* node);
void irr_ISceneNode_serializeAttributes(irr_ISceneNode* node, irr_IAttributes*, irr_SAttributeReadWriteOptions*);
void irr_ISceneNode_deserializeAttributes(irr_ISceneNode* node, irr_IAttributes*, irr_SAttributeReadWriteOptions*);
irr_ISceneNode* irr_ISceneNode_clone(irr_ISceneNode* node, irr_ISceneNode*, irr_ISceneManager*);
irr_ISceneManager* irr_ISceneNode_getSceneManager(irr_ISceneNode* node);
