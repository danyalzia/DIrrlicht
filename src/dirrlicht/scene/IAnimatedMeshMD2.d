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

module dirrlicht.scene.IAnimatedMeshMD2;

import dirrlicht.scene.ISceneManager;
import dirrlicht.scene.IMesh;
import dirrlicht.scene.IAnimatedMesh;

import std.conv;
import std.string;

/// Types of standard md2 animations
enum EMD2_ANIMATION_TYPE
{
    EMAT_STAND = 0,
    EMAT_RUN,
    EMAT_ATTACK,
    EMAT_PAIN_A,
    EMAT_PAIN_B,
    EMAT_PAIN_C,
    EMAT_JUMP,
    EMAT_FLIP,
    EMAT_SALUTE,
    EMAT_FALLBACK,
    EMAT_WAVE,
    EMAT_POINT,
    EMAT_CROUCH_STAND,
    EMAT_CROUCH_WALK,
    EMAT_CROUCH_ATTACK,
    EMAT_CROUCH_PAIN,
    EMAT_CROUCH_DEATH,
    EMAT_DEATH_FALLBACK,
    EMAT_DEATH_FALLFORWARD,
    EMAT_DEATH_FALLBACKSLOW,
    EMAT_BOOM,

    /// Not an animation, but amount of animation types.
    EMAT_COUNT
}

class IAnimatedMeshMD2 : IAnimatedMesh
{
	/***
     * class for using some special functions of MD2 meshes
     */
    this(ISceneManager _smgr, string file)
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
    void getFrameLoop(EMD2_ANIMATION_TYPE l, ref int outBegin, ref int outEnd, ref int outFPS)
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
    ISceneManager smgr;
}

extern (C):

struct irr_IAnimatedMeshMD2;

void irr_IAnimatedMeshMD2_getFrameLoop(irr_IAnimatedMeshMD2* mesh, EMD2_ANIMATION_TYPE l, ref int outBegin, ref int outEnd, ref int outFPS);
bool irr_IAnimatedMeshMD2_getFrameLoopByName(irr_IAnimatedMeshMD2* mesh, const char* name, ref int outBegin, ref int outEnd, ref int outFPS);
int irr_IAnimatedMeshMD2_getAnimationCount(irr_IAnimatedMeshMD2* mesh);
const char* irr_IAnimatedMeshMD2_getAnimationName(irr_IAnimatedMeshMD2* mesh, int nr);

