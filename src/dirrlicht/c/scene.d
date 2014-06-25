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

module dirrlicht.c.scene;

import dirrlicht.c.irrlicht;
import dirrlicht.c.core;
import dirrlicht.c.io;
import dirrlicht.c.video;
import dirrlicht.video.EMaterialFlags;
import dirrlicht.scene.ESceneNodeTypes;
import dirrlicht.scene.IAnimatedMeshMD2;
import dirrlicht.video.EMaterialTypes;

extern (C)
{
    enum E_JOINT_UPDATE_ON_RENDER
    {
        EJUOR_NONE = 0,
        EJUOR_READ,
        EJUOR_CONTROL
    };

    struct irr_IMesh;
    struct irr_IAnimatedMesh;
    struct irr_ISceneNode;
    struct irr_IAnimatedMeshSceneNode;
    struct irr_ICameraSceneNode;
    struct irr_ISceneManager;
    struct irr_ITriangleSelector;

    irr_ICameraSceneNode* irr_ISceneManager_addCameraSceneNode(irr_ISceneManager* smgr, irr_IAnimatedMeshSceneNode* parent, irr_vector3df pos, irr_vector3df lookAt);
    irr_ICameraSceneNode* irr_ISceneManager_addCameraSceneNodeFPS(irr_ISceneManager* smgr);
    irr_ISceneNode* irr_ISceneManager_addSphereSceneNode(irr_ISceneManager* smgr);
    irr_ISceneNode* irr_ISceneManager_addCubeSceneNode(irr_ISceneManager* smgr);
    void irr_ISceneManager_drawAll(irr_ISceneManager* smgr);

    struct irr_ISceneNodeAnimator;

    irr_ISceneNodeAnimator* irr_ISceneManager_createFlyCircleAnimator(irr_ISceneManager* smgr, const ref irr_vector3df center, float radius=100);
    irr_ISceneNodeAnimator* irr_ISceneManager_createFlyStraightAnimator(irr_ISceneManager* smgr, const ref irr_vector3df startPoint, const ref irr_vector3df endPoint, uint timeForWay, bool loop=false, bool pingpong = false);

    struct irr_IAttributes;
    struct irr_IShadowVolumeSceneNode;
    struct irr_IBoneSceneNode;
    struct irr_IAnimationEndCallBack;
    struct irr_SMD3QuaternionTag;

    void irr_ISceneNode_addAnimator(irr_ISceneNode* node, irr_ISceneNodeAnimator* animator);
    const ref irr_list irr_ISceneNode_getAnimators(irr_ISceneNode* node);
    void irr_ISceneNode_removeAnimator(irr_ISceneNode* node, irr_ISceneNodeAnimator* animator);
    void irr_ISceneNode_removeAnimators(irr_ISceneNode* node);
    irr_SMaterial* irr_ISceneNode_getMaterial(irr_ISceneNode* node, uint num);
    uint irr_ISceneNode_getMaterialCount(irr_ISceneNode* node);
    void irr_ISceneNode_setMaterialFlag(irr_ISceneNode* node, E_MATERIAL_FLAG flag, bool newvalue);
    void irr_ISceneNode_setMaterialTexture(irr_ISceneNode* node, int c, irr_ITexture* texture);
    void irr_ISceneNode_setMaterialType(irr_ISceneNode* node, E_MATERIAL_TYPE newType);
    const ref irr_vector3df irr_ISceneNode_getScale(irr_ISceneNode* node);
    void irr_ISceneNode_setScale(irr_ISceneNode* node, const ref irr_vector3df scale);
    const ref irr_vector3df irr_ISceneNode_getRotation(irr_ISceneNode* node);
    void irr_ISceneNode_setRotation(irr_ISceneNode* node, const ref irr_vector3df rotation);
    const ref irr_vector3df irr_ISceneNode_getPosition(irr_ISceneNode* node);
    void irr_ISceneNode_setPosition(irr_ISceneNode* node, const ref irr_vector3df newpos);
    irr_vector3df irr_ISceneNode_getAbsolutePosition(irr_ISceneNode* node);
    void irr_ISceneNode_setAutomaticCulling(irr_ISceneNode* node, uint state);
    uint irr_ISceneNode_getAutomaticCulling(irr_ISceneNode* node);
    void irr_ISceneNode_setDebugDataVisible(irr_ISceneNode* node, uint state);
    uint irr_ISceneNode_isDebugDataVisible(irr_ISceneNode* node);
    void irr_ISceneNode_setIsDebugObject(irr_ISceneNode* node, bool debugObject);
    bool irr_ISceneNode_isDebugObject(irr_ISceneNode* node);
    const ref irr_list irr_ISceneNode_getChildren(irr_ISceneNode* node);
    void irr_ISceneNode_setParent(irr_ISceneNode* node, irr_ISceneNode* newParent);
    irr_ITriangleSelector* irr_ISceneNode_getTriangleSelector(irr_ISceneNode* node);
    void irr_ISceneNode_setTriangleSelector(irr_ISceneNode* node, irr_ITriangleSelector* selector);
    void irr_ISceneNode_updateAbsolutePosition(irr_ISceneNode* node);
    irr_ISceneNode* irr_ISceneNode_getParent(irr_ISceneNode* node);
    ESCENE_NODE_TYPE irr_ISceneNode_getType(irr_ISceneNode* node);
    void irr_ISceneNode_serializeAttributes(irr_ISceneNode* node, irr_IAttributes* ou, irr_SAttributeReadWriteOptions* options=null);
    void irr_ISceneNode_deserializeAttributes(irr_ISceneNode* node, irr_IAttributes* i, irr_SAttributeReadWriteOptions* options=null);
    irr_ISceneNode* irr_ISceneNode_clone(irr_ISceneNode* node, irr_ISceneNode* newParent=null, irr_ISceneManager* newManager=null);
    irr_ISceneManager* irr_ISceneNode_getSceneManager(irr_ISceneNode* node);

    void irr_IAnimatedMeshSceneNode_addAnimator(irr_IAnimatedMeshSceneNode* node, irr_ISceneNodeAnimator* animator);
    const ref irr_list irr_IAnimatedMeshSceneNode_getAnimators(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_removeAnimator(irr_IAnimatedMeshSceneNode* node, irr_ISceneNodeAnimator* animator);
    irr_IAnimatedMesh* irr_ISceneManager_getMesh(irr_ISceneManager* smgr, const(char)* file);
    irr_IAnimatedMeshSceneNode* irr_ISceneManager_addAnimatedMeshSceneNode(irr_ISceneManager* smgr, irr_IAnimatedMesh* mesh);
    void irr_IAnimatedMeshSceneNode_setPosition(irr_IAnimatedMeshSceneNode* node, const ref irr_vector3df newpos);
    void irr_IAnimatedMeshSceneNode_setMaterialFlag(irr_IAnimatedMeshSceneNode* node, E_MATERIAL_FLAG flag, bool newvalue);
    void irr_IAnimatedMeshSceneNode_setMaterialTexture(irr_IAnimatedMeshSceneNode* node, int c, irr_ITexture* texture);
    void irr_IAnimatedMeshSceneNode_setScale(irr_IAnimatedMeshSceneNode* node, const ref irr_vector3df scale);
    void irr_IAnimatedMeshSceneNode_setRotation(irr_IAnimatedMeshSceneNode* node, const ref irr_vector3df rotation);

    void irr_IAnimatedMeshSceneNode_setCurrentFrame(irr_IAnimatedMeshSceneNode* node, float frame);
    void irr_IAnimatedMeshSceneNode_setFrameLoop(irr_IAnimatedMeshSceneNode* node, int begin, int end);
    void irr_IAnimatedMeshSceneNode_setAnimationSpeed(irr_IAnimatedMeshSceneNode* node, float framesPerSecond);
    float irr_IAnimatedMeshSceneNode_getAnimationSpeed(irr_IAnimatedMeshSceneNode* node);
    irr_IShadowVolumeSceneNode* irr_IAnimatedMeshSceneNode_addShadowVolumeSceneNode(irr_IAnimatedMeshSceneNode* node, const irr_IMesh* shadowMesh=null, int id=-1, bool zfailmethod=true, float infinity=1000.0f);
    irr_IBoneSceneNode* irr_IAnimatedMeshSceneNode_getJointNode(irr_IAnimatedMeshSceneNode* node, const char* jointName);
    irr_IBoneSceneNode* irr_IAnimatedMeshSceneNode_getJointNodeByID(irr_IAnimatedMeshSceneNode* node, uint jointID);
    uint irr_IAnimatedMeshSceneNode_getJointCount(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_setMD2Animation(irr_IAnimatedMeshSceneNode* node, EMD2_ANIMATION_TYPE value);
    bool irr_IAnimatedMeshSceneNode_setMD2AnimationByName(irr_IAnimatedMeshSceneNode* node, const char* animationName);
    float irr_IAnimatedMeshSceneNode_getFrameNr(irr_IAnimatedMeshSceneNode* node);
    int irr_IAnimatedMeshSceneNode_getStartFrame(irr_IAnimatedMeshSceneNode* node);
    int irr_IAnimatedMeshSceneNode_getEndFrame(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_setLoopMode(irr_IAnimatedMeshSceneNode* node, bool playAnimationLooped);
    bool irr_IAnimatedMeshSceneNode_getLoopMode(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_setAnimationEndCallback(irr_IAnimatedMeshSceneNode* node, irr_IAnimationEndCallBack* callback=null);
    void irr_IAnimatedMeshSceneNode_setReadOnlyMaterials(irr_IAnimatedMeshSceneNode* node, bool readonly);
    bool irr_IAnimatedMeshSceneNode_isReadOnlyMaterials(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_setMesh(irr_IAnimatedMeshSceneNode* node, irr_IAnimatedMesh* mesh);
    irr_IAnimatedMesh* irr_IAnimatedMeshSceneNode_getMesh(irr_IAnimatedMeshSceneNode* node);
    const irr_SMD3QuaternionTag* irr_IAnimatedMeshSceneNode_getMD3TagTransformation(irr_IAnimatedMeshSceneNode* node, const char* tagname);
    void irr_IAnimatedMeshSceneNode_setJointMode(irr_IAnimatedMeshSceneNode* node, E_JOINT_UPDATE_ON_RENDER mode);
    void irr_IAnimatedMeshSceneNode_setTransitionTime(irr_IAnimatedMeshSceneNode* node, float Time);
    void irr_IAnimatedMeshSceneNode_animateJoints(irr_IAnimatedMeshSceneNode* node, bool CalculateAbsolutePositions=true);
    void irr_IAnimatedMeshSceneNode_setRenderFromIdentity(irr_IAnimatedMeshSceneNode* node, bool On);
}
