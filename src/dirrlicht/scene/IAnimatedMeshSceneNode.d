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

import dirrlicht.CompileConfig;
import dirrlicht.IrrlichtDevice;
import dirrlicht.core.vector3d;
import dirrlicht.scene.IBoneSceneNode;
import dirrlicht.scene.ISceneNodeAnimator;
import dirrlicht.scene.ISceneManager;
import dirrlicht.scene.ISceneNode;
import dirrlicht.scene.IShadowVolumeSceneNode;
import dirrlicht.scene.IMesh;
import dirrlicht.scene.IAnimatedMesh;
import dirrlicht.scene.IAnimatedMeshMD2;
import dirrlicht.scene.IAnimatedMeshMD3;
import dirrlicht.scene.IAnimatedMeshSceneNode;
import dirrlicht.video.ITexture;
import dirrlicht.video.EMaterialFlags;

enum E_JOINT_UPDATE_ON_RENDER
{
    /// do nothing
    EJUOR_NONE = 0,

    /// get joints positions from the mesh (for attached nodes, etc)
    EJUOR_READ,

    /// control joint positions in the mesh (eg. ragdolls, or set the animation from animateJoints() )
    EJUOR_CONTROL
}

class IAnimatedMeshSceneNode : ISceneNode
{
    this(ISceneManager _smgr, IAnimatedMesh mesh, ISceneNode parent=null, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f), bool alsoAddIfMeshPointerZero=false)
    {
        smgr = _smgr;
        auto temppos = irr_vector3df(position.x, position.y, position.z);
        auto temprot = irr_vector3df(rotation.x, rotation.y, rotation.z);
        auto tempscale = irr_vector3df(scale.x, scale.y, scale.z);

        if (parent is null)
            super.ptr = cast(irr_ISceneNode*)irr_ISceneManager_addAnimatedMeshSceneNode(smgr.ptr, mesh.ptr, null, id, temppos, temprot, tempscale, alsoAddIfMeshPointerZero);
        else
            super.ptr = cast(irr_ISceneNode*)irr_ISceneManager_addAnimatedMeshSceneNode(smgr.ptr, mesh.ptr, parent.ptr, id, temppos, temprot, tempscale, alsoAddIfMeshPointerZero);
        ptr = cast(irr_IAnimatedMeshSceneNode*)super.ptr;
    }

    void setMD2Animation(EMD2_ANIMATION_TYPE value)
    {
        irr_IAnimatedMeshSceneNode_setMD2Animation(ptr, value);
    }

    void setFrameLoop(int begin, int end)
    {
        irr_IAnimatedMeshSceneNode_setFrameLoop(ptr, begin, end);
    }

    void setAnimationSpeed(float fps)
    {
        irr_IAnimatedMeshSceneNode_setAnimationSpeed(ptr, fps);
    }

    irr_IAnimatedMeshSceneNode* ptr;
private:
    ISceneManager smgr;
}

unittest
{
mixin(TestPrerequisite);

    /// IAnimatedMesh test starts here
    auto mesh = smgr.getMesh("../../media/sydney.md2");
    assert(mesh !is null);
    assert(mesh.ptr != null);

    auto node = smgr.addAnimatedMeshSceneNode(mesh);
    assert(node !is null);
    assert(node.ptr != null);
}

package extern (C):

struct irr_IAnimatedMeshSceneNode;
struct irr_IAnimationEndCallBack;

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
