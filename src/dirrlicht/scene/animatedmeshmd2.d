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

module dirrlicht.scene.animatedmeshmd2;

import dirrlicht.scene.scenemanager;
import dirrlicht.scene.mesh;
import dirrlicht.scene.animatedmesh;

import std.conv;
import std.string;

/// Types of standard md2 animations
enum AnimationTypeMD2
{
    Stand = 0,
    Run,
    Attack,
    PainA,
    PainB,
    PainC,
    Jump,
    Flip,
    Salute,
    Fallback,
    Wave,
    Point,
    CrouchStand,
    CrouchWalk,
    CrouchAttack,
    CrouchPain,
    CrouchDeath,
    DeathFallBack,
    DeathFallForward,
    DeathFallBackSlow,
    Boom,

    /// Not an animation, but amount of animation types.
    Count
}

class AnimatedMeshMD2 : AnimatedMesh
{
	/***
     * class for using some special functions of MD2 meshes
     */
    this(SceneManager _smgr, string file)
    {
        smgr = _smgr;
        super(smgr, file);
    }
    
    /***
     * Internal use only!
     */
    package this(irr_IAnimatedMeshMD2* ptr)
    {
    	this.ptr = ptr;
    	super(cast(irr_IAnimatedMesh*)this.ptr);
    }
    
    /***
     * Get frame loop data for a default MD2 animation type.
     *
     * Params:
     *			l = The EMD2_ANIMATION_TYPE to get the frames for.
     *			outBegin = The returned beginning frame for animation type specified.
     *			outEnd = The returned ending frame for the animation type specified.
     *			outFPS = The number of frames per second, this animation should be played at.
     */
    void getFrameLoop(AnimationTypeMD2 l, ref int outBegin, ref int outEnd, ref int outFPS)
    {
        irr_IAnimatedMeshMD2_getFrameLoop(ptr, l, outBegin, outEnd, outFPS);
    }
    
    /***
     * Get frame loop data for a special MD2 animation type, identified by name.
     *
     * Params:
     *			name = Name of the animation.
     *			outBegin = The returned beginning frame for animation type specified.
     *			outEnd = The returned ending frame for the animation type specified.
     *			outFPS = The number of frames per second, this animation should be played at.
     */
    bool getFrameLoop(string name, ref int outBegin, ref int outEnd, ref int outFPS)
    {
        return irr_IAnimatedMeshMD2_getFrameLoopByName(ptr, toStringz(name), outBegin, outEnd, outFPS);
    }
    
    /***
     * Get amount of md2 animations in this file.
     */
    int getAnimationCount()
    {
        return irr_IAnimatedMeshMD2_getAnimationCount(ptr);
    }
    
    /***
     * Get name of md2 animation.
	 *
     * Params:
     *			nr: Zero based index of animation.
     */
    string getAnimationName(int nr)
    {
        auto str = irr_IAnimatedMeshMD2_getAnimationName(ptr, nr);
        return to!string(str);
    }

    irr_IAnimatedMeshMD2* ptr;
private:
    SceneManager smgr;
}

extern (C):

struct irr_IAnimatedMeshMD2;

void irr_IAnimatedMeshMD2_getFrameLoop(irr_IAnimatedMeshMD2* mesh, AnimationTypeMD2 l, ref int outBegin, ref int outEnd, ref int outFPS);
bool irr_IAnimatedMeshMD2_getFrameLoopByName(irr_IAnimatedMeshMD2* mesh, const char* name, ref int outBegin, ref int outEnd, ref int outFPS);
int irr_IAnimatedMeshMD2_getAnimationCount(irr_IAnimatedMeshMD2* mesh);
const char* irr_IAnimatedMeshMD2_getAnimationName(irr_IAnimatedMeshMD2* mesh, int nr);

