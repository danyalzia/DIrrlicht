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

module dirrlicht.scene.animatedmeshscenenode;

import dirrlicht.compileconfig;
import dirrlicht.irrlichtdevice;
import dirrlicht.core.vector3d;
import dirrlicht.scene.bonescenenode;
import dirrlicht.scene.scenenodeanimator;
import dirrlicht.scene.scenemanager;
import dirrlicht.scene.scenenode;
import dirrlicht.scene.shadowvolumescenenode;
import dirrlicht.scene.mesh;
import dirrlicht.scene.animatedmesh;
import dirrlicht.scene.animatedmeshmd2;
import dirrlicht.scene.animatedmeshmd3;
import dirrlicht.scene.animatedmeshscenenode;
import dirrlicht.video.texture;
import dirrlicht.video.materialflags;

import std.conv;
import std.string;

enum JointUpdateOnRender {
    /// do nothing
    None = 0,

    /// get joints positions from the mesh (for attached nodes, etc)
    Read,

    /// control joint positions in the mesh (eg. ragdolls, or set the animation from animateJoints() )
    Control
}

/+++
 + Callback interface for catching events of ended animations.
 + Implement this interface and use
 + setAnimationEndCallback() to be able to
 + be notified if an animation playback has ended.
 +/
class AnimatedEndCallBack {
	this(irr_IAnimationEndCallBack* ptr) {
		this.ptr = ptr;
	}
	
	alias ptr this;
	irr_IAnimationEndCallBack* ptr;
}

/+++
 + Scene node capable of displaying an animated mesh and its shadow.
 + The shadow is optional: If a shadow should be displayed too, just
 + call createShadowVolumeSceneNode().
 +/
class AnimatedMeshSceneNode : SceneNode {
	mixin DefaultSceneNode;

	this(irr_IAnimatedMeshSceneNode* ptr) {
    	this.ptr = ptr;
    	irrPtr = cast(irr_ISceneNode*)this.ptr;
    }
    
    void setCurrentFrame(float frame) {
    	irr_IAnimatedMeshSceneNode_setCurrentFrame(ptr, frame);
    }
		
	/***
     * The default is 0 - MaximalFrameCount of the mesh.
     * Params:
     *			begin = Start frame number of the loop.
	 *			end = End frame number of the loop.
	 *
	 * Returns: True if successful, false if not.		
     */
    bool setFrameLoop(int begin, int end) {
    	return irr_IAnimatedMeshSceneNode_setFrameLoop(ptr, begin, end);
    }
    
    /***
     * Sets the speed with which the animation is played.
     * Params:
     *			framesPerSecond = Frames per second played.
     */
    void setAnimationSpeed(float framesPerSecond) {
    	irr_IAnimatedMeshSceneNode_setAnimationSpeed(ptr, framesPerSecond);
    }
    
    /***
     * Gets the speed with which the animation is played.
     */
    float getAnimationSpeed() {
    	return irr_IAnimatedMeshSceneNode_getAnimationSpeed(ptr);
    }
    
    /***
     * Creates shadow volume scene node as child of this node.
	 * The shadow can be rendered using the ZPass or the zfail
	 * method. ZPass is a little bit faster because the shadow volume
	 * creation is easier, but with this method there occur ugly
	 * looking artifacs when the camera is inside the shadow volume.
	 * These error do not occur with the ZFail method.
     *
     * Params:
     *			shadowMesh = Optional custom mesh for shadow volume.
     *
     *			id = Id of the shadow scene node. This id can be used to identify the node later.
     *
     *			zfailmethod = If set to true, the shadow will use the zfail method, if not, zpass is used.
     *
     *			infinity = Value used by the shadow volume algorithm to
     *			scale the shadow volume (for zfail shadow volume we support only
     *			finite shadows, so camera zfar must be larger than shadow back cap,
     *			which is depend on infinity parameter).
     *
     * Returns: Pointer to the created shadow scene node. This pointer
	 * 			should not be dropped. See IReferenceCounted::drop() for more
	 *			information.
     *		
     */
    ShadowVolumeSceneNode addShadowVolumeSceneNode(Mesh shadowMesh=null,
			int id=-1, bool zfailmethod=true, float infinity=1000.0f) {
    	irr_IShadowVolumeSceneNode* temp;
    	if (shadowMesh is null) {
    		temp = irr_IAnimatedMeshSceneNode_addShadowVolumeSceneNode(ptr);
    	}
    	else {
    		temp = irr_IAnimatedMeshSceneNode_addShadowVolumeSceneNode(ptr, shadowMesh.ptr, id, zfailmethod, infinity);
    	}
    	
    	return new ShadowVolumeSceneNode(temp);
    }
    
    BoneSceneNode getJointNode(string jointName) {
    	auto temp = irr_IAnimatedMeshSceneNode_getJointNode(ptr, jointName.toStringz);
    	return new  BoneSceneNode(temp);
    }
    
    BoneSceneNode getJointNode(uint jointID) {
    	auto temp = irr_IAnimatedMeshSceneNode_getJointNodeByID(ptr, jointID);
    	return new  BoneSceneNode(temp);
    }
    
    uint getJointCount() {
    	return irr_IAnimatedMeshSceneNode_getJointCount(ptr);
    }
    
    void setMD2Animation(AnimationTypeMD2 anim) {
    	irr_IAnimatedMeshSceneNode_setMD2Animation(ptr, anim);
    }
    
    bool setMD2Animation(string animationName) {
    	return irr_IAnimatedMeshSceneNode_setMD2AnimationByName(ptr, animationName.toStringz);
    }
    
    /***
     * Returns the currently displayed frame number.
     */
    float getFrameNr() {
    	return irr_IAnimatedMeshSceneNode_getFrameNr(ptr);
    }
    
    /***
     * Returns the current start frame number.
     */
    int getStartFrame() {
    	return irr_IAnimatedMeshSceneNode_getStartFrame(ptr);
    }
    
    /***
     * Returns the current end frame number.
     */
    int getEndFrame() {
    	return irr_IAnimatedMeshSceneNode_getEndFrame(ptr);
    }
    
    /***
     * Sets looping mode which is on by default.
	 * If set to false, animations will not be played looped.
     */
    void setLoopMode(bool playAnimationLooped) {
    	irr_IAnimatedMeshSceneNode_setLoopMode(ptr, playAnimationLooped);
    }
    
    /***
     * returns the current loop mode
	 * When true the animations are played looped
	 */
    bool getLoopMode() {
    	return irr_IAnimatedMeshSceneNode_getLoopMode(ptr);
    }
    
    /***
     * Sets a callback interface which will be called if an animation playback has ended.
	 * Set this to 0 to disable the callback again.
	 * Please note that this will only be called when in non looped
	 * mode, see setLoopMode().
     */
    void setAnimationEndCallback(AnimatedEndCallBack callback=null) {
    	irr_IAnimatedMeshSceneNode_setAnimationEndCallback(ptr, callback.ptr);
    }
    
    /***
     * Sets if the scene node should not copy the materials of the mesh but use them in a read only style.
     * In this way it is possible to change the materials a mesh
	 * causing all mesh scene nodes referencing this mesh to change
	 * too.
     */
    void setReadOnlyMaterials(bool readonly) {
    	irr_IAnimatedMeshSceneNode_setReadOnlyMaterials(ptr, readonly);
    }
    
    /***
     * Returns if the scene node should not copy the materials of the mesh but use them in a read only style
     */
    bool isReadOnlyMaterials() {
    	return irr_IAnimatedMeshSceneNode_isReadOnlyMaterials(ptr);
    }
    
    /***
     * Sets a new mesh
     */
    void setMesh(AnimatedMesh mesh) {
    	irr_IAnimatedMeshSceneNode_setMesh(ptr, mesh.ptr);
    }
    
    /***
     * Returns the current mesh
     *
     * Returns: Mesh		
     */
    AnimatedMesh getMesh() {
    	auto temp = irr_IAnimatedMeshSceneNode_getMesh(ptr);
    	return new AnimatedMesh(temp);
    }
    
    /***
     * Get the absolute transformation for a special MD3 Tag if the mesh is a md3 mesh, or the absolutetransformation if it's a normal scenenode
     *
     * Params:
     *			tagname = name
     */
	MD3QuaternionTag getMD3TagTransformation(string tagname) {
    	auto temp = irr_IAnimatedMeshSceneNode_getMD3TagTransformation(ptr, tagname.toStringz);
    	return new MD3QuaternionTag(cast(irr_SMD3QuaternionTag*)temp);
    }
    
    /***
     * Set how the joints should be updated on render
     *
     * Params:
     *			mode = mode
     */
    void setJointMode(JointUpdateOnRender mode) {
    	irr_IAnimatedMeshSceneNode_setJointMode(ptr, mode);
    }
    
    /***
     * Sets the transition time in seconds
     * 
	 * Note: This needs to enable joints, and setJointmode set to
	 * EJUOR_CONTROL. You must call animateJoints(), or the mesh will
	 * not animate.
	 *
     * Params:
     *			time = transition time
     */
    void setTransitionTime(float time) {
    	irr_IAnimatedMeshSceneNode_setTransitionTime(ptr, time);
    }
    
	/***
     * Animates the joints in the mesh based on the current frame.
     * 
	 * Also takes in to account transitions.
	 *
     * Params:
     *			CalculateAbsolutePositions = set flag
     */
    void animateJoints(bool CalculateAbsolutePositions=true) {
    	irr_IAnimatedMeshSceneNode_animateJoints(ptr, CalculateAbsolutePositions);
    }
    
    /***
     * Render mesh ignoring its transformation. Culling is unaffected.
     * Params:
     *			On = set flag
     */
    void setRenderFromIdentity(bool On) {
    	irr_IAnimatedMeshSceneNode_setRenderFromIdentity(ptr, On);
    }
    
    irr_IAnimatedMeshSceneNode* ptr;
}

/// example IAnimatedMeshSceneNode
unittest
{
    mixin(TestPrerequisite);

    /// IAnimatedMesh test starts here
    //auto mesh = smgr.getMesh("../../media/sydney.md2");
    //assert(mesh !is null);
    //assert(mesh.ptr != null);

    //auto node = smgr.addAnimatedMeshSceneNode(mesh);
    //assert(node !is null);
    //assert(node.ptr != null);

    //node.setMD2Animation(AnimationTypeMD2.Stand);
    //node.setMaterialFlag(MaterialFlag.Lighting, false);
}

package extern (C):

struct irr_IAnimationEndCallBack;
struct irr_IAnimatedMeshSceneNode;

void irr_IAnimatedMeshSceneNode_setCurrentFrame(irr_IAnimatedMeshSceneNode* node, float frame);
bool irr_IAnimatedMeshSceneNode_setFrameLoop(irr_IAnimatedMeshSceneNode* node, int begin, int end);
void irr_IAnimatedMeshSceneNode_setAnimationSpeed(irr_IAnimatedMeshSceneNode* node, float framesPerSecond);
float irr_IAnimatedMeshSceneNode_getAnimationSpeed(irr_IAnimatedMeshSceneNode* node);
irr_IShadowVolumeSceneNode* irr_IAnimatedMeshSceneNode_addShadowVolumeSceneNode(irr_IAnimatedMeshSceneNode* node, const irr_IMesh* shadowMesh=null, int id=-1, bool zfailmethod=true, float infinity=1000.0f);
irr_IBoneSceneNode* irr_IAnimatedMeshSceneNode_getJointNode(irr_IAnimatedMeshSceneNode* node, const char* jointName);
irr_IBoneSceneNode* irr_IAnimatedMeshSceneNode_getJointNodeByID(irr_IAnimatedMeshSceneNode* node, uint jointID);
uint irr_IAnimatedMeshSceneNode_getJointCount(irr_IAnimatedMeshSceneNode* node);
void irr_IAnimatedMeshSceneNode_setMD2Animation(irr_IAnimatedMeshSceneNode* node, AnimationTypeMD2 value);
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
const(irr_SMD3QuaternionTag*) irr_IAnimatedMeshSceneNode_getMD3TagTransformation(irr_IAnimatedMeshSceneNode* node, const(char*) tagname);
void irr_IAnimatedMeshSceneNode_setJointMode(irr_IAnimatedMeshSceneNode* node, JointUpdateOnRender mode);
void irr_IAnimatedMeshSceneNode_setTransitionTime(irr_IAnimatedMeshSceneNode* node, float Time);
void irr_IAnimatedMeshSceneNode_animateJoints(irr_IAnimatedMeshSceneNode* node, bool CalculateAbsolutePositions=true);
void irr_IAnimatedMeshSceneNode_setRenderFromIdentity(irr_IAnimatedMeshSceneNode* node, bool On);
