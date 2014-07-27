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

interface SceneNode {
	void addAnimator(SceneNodeAnimator animator);
    void removeAnimator(SceneNodeAnimator animator);
    void removeAnimators();
    Material getMaterial(uint num);
    void setMaterialFlag(MaterialFlag flag, bool newvalue);
    void setMaterialTexture(int n, Texture texture);
    void setMaterialType(MaterialType newType);
    @property {
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
    SceneNodeType getType();
    SceneManager getSceneManager();
    @property void* c_ptr();
    @property void c_ptr(void* ptr);
}

/// stub for SceneNode interface
mixin template DefaultSceneNode() {
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
	
    void addAnimator(SceneNodeAnimator animator) {
        irr_ISceneNode_addAnimator(cast(irr_ISceneNode*)(ptr), animator.ptr);
    }

    void removeAnimator(SceneNodeAnimator animator) {
        irr_ISceneNode_removeAnimator(cast(irr_ISceneNode*)(ptr), animator.ptr);
    }

    void removeAnimators() {
        irr_ISceneNode_removeAnimators(cast(irr_ISceneNode*)(ptr));
    }

    Material getMaterial(uint num) {
        return new Material(irr_ISceneNode_getMaterial(cast(irr_ISceneNode*)(ptr), num));
    }

    void setMaterialFlag(MaterialFlag flag, bool newvalue) {
        irr_ISceneNode_setMaterialFlag(cast(irr_ISceneNode*)(ptr), flag, newvalue);
    }

    void setMaterialTexture(int n, Texture texture) {
        irr_ISceneNode_setMaterialTexture(cast(irr_ISceneNode*)(ptr), n, texture.ptr);
    }

    void setMaterialType(MaterialType newType) {
        irr_ISceneNode_setMaterialType(cast(irr_ISceneNode*)(ptr), newType);
    }
    
    @property {
	    vector3df scale() {
	        auto temp = irr_ISceneNode_getScale(cast(irr_ISceneNode*)(ptr));
	        return vector3df(temp.x, temp.y, temp.z);
	    }
	
	    void scale(vector3df scale) {
	        irr_vector3df temp = {scale.x, scale.y, scale.z};
	        irr_ISceneNode_setScale(cast(irr_ISceneNode*)(ptr), temp);
	    }
	
	    vector3df rotation() {
	        auto temp = irr_ISceneNode_getRotation(cast(irr_ISceneNode*)(ptr));
	        auto rot = vector3df(temp.x, temp.y, temp.z);
	        return rot;
	    }
	
	    void rotation(vector3df rotation) {
	        irr_vector3df temp = {rotation.x, rotation.y, rotation.z};
	        irr_ISceneNode_setRotation(cast(irr_ISceneNode*)(ptr), temp);
	    }
	
	    vector3df position() {
	        auto temp = irr_ISceneNode_getPosition(cast(irr_ISceneNode*)(ptr));
	        return vector3df(temp.x, temp.y, temp.z);
	    }
	
	    void position(vector3df pos) {
	        irr_ISceneNode_setPosition(cast(irr_ISceneNode*)(ptr), pos.ptr);
	    }
    }
    
    vector3df getAbsolutePosition() {
        auto temp = irr_ISceneNode_getAbsolutePosition(cast(irr_ISceneNode*)(ptr));
        auto pos = vector3df(temp.x, temp.y, temp.z);
        return pos;
    }

    void setAutomaticCulling(uint state) {
        irr_ISceneNode_setAutomaticCulling(cast(irr_ISceneNode*)(ptr), state);
    }

    uint getAutomaticCulling() {
        return irr_ISceneNode_getAutomaticCulling(cast(irr_ISceneNode*)(ptr));
    }

    void setDebugDataVisible(uint state) {
        irr_ISceneNode_setDebugDataVisible(cast(irr_ISceneNode*)(ptr), state);
    }

    uint isDebugDataVisible() {
        return irr_ISceneNode_isDebugDataVisible(cast(irr_ISceneNode*)(ptr));
    }

    void setIsDebugObject(bool debugObject) {
        irr_ISceneNode_setIsDebugObject(cast(irr_ISceneNode*)(ptr), debugObject);
    }

    bool isDebugObject() {
        return irr_ISceneNode_isDebugObject(cast(irr_ISceneNode*)(ptr));
    }

    void setParent(SceneNode newParent) {
        irr_ISceneNode_setParent(cast(irr_ISceneNode*)(ptr), cast(irr_ISceneNode*)newParent.c_ptr);
    }

    TriangleSelector getTriangleSelector() {
        auto temp = irr_ISceneNode_getTriangleSelector(cast(irr_ISceneNode*)(ptr));
        return new TriangleSelector(temp);
    }

    void setTriangleSelector(TriangleSelector selector) {
        irr_ISceneNode_setTriangleSelector(cast(irr_ISceneNode*)(ptr), selector.ptr);
    }

    void updateAbsolutePosition() {
        irr_ISceneNode_updateAbsolutePosition(cast(irr_ISceneNode*)(ptr));
    }

    SceneNode* getParent() {
        auto temp = irr_ISceneNode_getParent(cast(irr_ISceneNode*)(ptr));
        SceneNode* node;
        return node;
    }

    SceneNodeType getType() {
        return irr_ISceneNode_getType(cast(irr_ISceneNode*)(ptr));
    }

    SceneManager getSceneManager() {
        auto temp = irr_ISceneNode_getSceneManager(cast(irr_ISceneNode*)(ptr));
        return new SceneManager(temp);
    }
}

unittest {
    mixin(TestPrerequisite);
	
    auto mesh = smgr.getMesh("../media/sydney.md2");
    assert(mesh !is null);
    assert(mesh.c_ptr != null);
    
    auto node = smgr.addAnimatedMeshSceneNode(mesh);
    assert(node !is null);
    assert(node.c_ptr != null);

    with(node) {
        setMaterialFlag(MaterialFlag.Lighting, false);
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
SceneNodeType irr_ISceneNode_getType(irr_ISceneNode* node);
void irr_ISceneNode_serializeAttributes(irr_ISceneNode* node, irr_IAttributes*, irr_SAttributeReadWriteOptions*);
void irr_ISceneNode_deserializeAttributes(irr_ISceneNode* node, irr_IAttributes*, irr_SAttributeReadWriteOptions*);
irr_ISceneNode* irr_ISceneNode_clone(irr_ISceneNode* node, irr_ISceneNode*, irr_ISceneManager*);
irr_ISceneManager* irr_ISceneNode_getSceneManager(irr_ISceneNode* node);
