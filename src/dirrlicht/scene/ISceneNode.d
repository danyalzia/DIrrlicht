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
import dirrlicht.video.EMaterialTypes;
import dirrlicht.video.ITexture;
import dirrlicht.scene.ISceneNodeAnimator;
import dirrlicht.video.SMaterial;
import dirrlicht.scene.ITriangleSelector;
import dirrlicht.scene.ESceneNodeTypes;
import dirrlicht.io.IAttributes;
import dirrlicht.io.IAttributeExchangingObject;
import dirrlicht.c.io;

class ISceneNode
{
    this(ISceneNode parent, ISceneManager s, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1,1,1))
    {
        smgr = s;
    }

    void addAnimator(ISceneNodeAnimator animator)
    {
        auto animptr = cast(irr_ISceneNodeAnimator*)(animator);
        irr_ISceneNode_addAnimator(ptr, animptr);
    }

//    ISceneNodeAnimator[] getAnimators()
//    {
//        auto list = cast(ISceneNodeAnimator[])irr_ISceneNode_getAnimators(ptr);
//        return list;
//    }

    void removeAnimator(ISceneNodeAnimator animator)
    {
        auto animptr = cast(irr_ISceneNodeAnimator*)(animator);
        irr_ISceneNode_removeAnimator(ptr, animptr);
    }

    void removeAnimators()
    {
        irr_ISceneNode_removeAnimators(ptr);
    }

    SMaterial getMaterial(uint num)
    {
        SMaterial mat = new SMaterial(this, num);
        return cast(SMaterial)(mat);
    }

    void setMaterialFlag(E_MATERIAL_FLAG flag, bool newvalue)
    {
        irr_ISceneNode_setMaterialFlag(ptr, flag, newvalue);
    }

    void setMaterialTexture(int n, ITexture texture)
    {
        irr_ISceneNode_setMaterialTexture(ptr, n, texture.ptr);
    }

    void setMaterialType(E_MATERIAL_TYPE newType)
    {
        irr_ISceneNode_setMaterialType(ptr, newType);
    }

    vector3df getScale()
    {
        auto temp = irr_ISceneNode_getScale(ptr);
        auto scale = vector3df(temp.x, temp.y, temp.z);
        return scale;
    }

    void setScale(vector3df scale)
    {
        irr_vector3df temp = {scale.x, scale.y, scale.z};
        irr_ISceneNode_setScale(ptr, temp);
    }

    vector3df getRotation()
    {
        auto temp = irr_ISceneNode_getRotation(ptr);
        auto rot = vector3df(temp.x, temp.y, temp.z);
        return rot;
    }

    void setRotation(vector3df rotation)
    {
        irr_vector3df temp = {rotation.x, rotation.y, rotation.z};
        irr_ISceneNode_setRotation(ptr, temp);
    }

    vector3df getPosition()
    {
        auto temp = irr_ISceneNode_getPosition(ptr);
        auto pos = vector3df(temp.x, temp.y, temp.z);
        return pos;
    }

    void setPosition(vector3df pos)
    {
        irr_vector3df temp = {pos.x, pos.y, pos.z};
        irr_ISceneNode_setPosition(ptr, temp);
    }

    vector3df getAbsolutePosition()
    {
        auto temp = irr_ISceneNode_getAbsolutePosition(ptr);
        auto pos = vector3df(temp.x, temp.y, temp.z);
        return pos;
    }

    void setAutomaticCulling(uint state)
    {
        irr_ISceneNode_setAutomaticCulling(ptr, state);
    }

    uint getAutomaticCulling()
    {
        return irr_ISceneNode_getAutomaticCulling(ptr);
    }

    void setDebugDataVisible(uint state)
    {
        irr_ISceneNode_setDebugDataVisible(ptr, state);
    }

    uint isDebugDataVisible()
    {
        return irr_ISceneNode_isDebugDataVisible(ptr);
    }

    void setIsDebugObject(bool debugObject)
    {
        irr_ISceneNode_setIsDebugObject(ptr, debugObject);
    }

    bool isDebugObject()
    {
        return irr_ISceneNode_isDebugObject(ptr);
    }

//    const ref ISceneNode[] getChildren()
//    {
//        irr_ISceneNode_getChildren(ptr);
//    }

    void setParent(ISceneNode newParent)
    {
        irr_ISceneNode_setParent(ptr, cast(irr_ISceneNode*)newParent);
    }

    ITriangleSelector getTriangleSelector()
    {
        auto temp = cast(ITriangleSelector)irr_ISceneNode_getTriangleSelector(ptr);
        return temp;
    }

    void setTriangleSelector(ITriangleSelector selector)
    {
        irr_ISceneNode_setTriangleSelector(ptr, cast(irr_ITriangleSelector*)selector);
    }

    void updateAbsolutePosition()
    {
        irr_ISceneNode_updateAbsolutePosition(ptr);
    }

    ISceneNode getParent()
    {
        auto temp = cast(ISceneNode)irr_ISceneNode_getParent(ptr);
        return temp;
    }

    ESCENE_NODE_TYPE getType()
    {
        return irr_ISceneNode_getType(ptr);
    }

//    void serializeAttributes(out IAttributes att, SAttributeReadWriteOptions options=SAttributeReadWriteOptions(0, null))
//    {
//        irr_SAttributeReadWriteOptions temp = {options, options};
//        irr_ISceneNode_serializeAttributes(ptr, cast(irr_IAttributes*)att, cast(irr_SAttributeReadWriteOptions*)options);
//    }

    ISceneManager getSceneManager()
    {
        return cast(ISceneManager)irr_ISceneNode_getSceneManager(ptr);
    }

    irr_ISceneNode* ptr;
private:
    ISceneManager smgr;
}
