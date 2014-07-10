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

module dirrlicht.scene.animatedmesh;

import dirrlicht.compileconfig;
import dirrlicht.scene.mesh;
import dirrlicht.irrlichtdevice;
import dirrlicht.scene.scenemanager;
import dirrlicht.scene.meshbuffer;
import dirrlicht.video.material;
import dirrlicht.core.aabbox3d;
import dirrlicht.video.materialflags;
import dirrlicht.scene.hardwarebufferflags;
import dirrlicht.video.vertexindex;

import std.conv;

/// Possible types of (animated) meshes.
enum AnimatedMeshType
{
    /// Unknown animated mesh type.
    unknown = 0,

    /// Quake 2 MD2 model file
    MD2,

    /// Quake 3 MD3 model file
    MD3,

    /// Maya .obj static model
    OBJ,

    /// Quake 3 .bsp static Map
    BSP,

    /// 3D Studio .3ds file
    _3DS,

    /// My3D Mesh, the file format by Zhuck Dimitry
    MY3D,

    /// Pulsar LMTools .lmts file. This Irrlicht loader was written by Jonas Petersen
    LMTS,

    /// Cartography Shop .csm file. This loader was created by Saurav Mohapatra.
    CSM,

    /// .oct file for Paul Nette's FSRad or from Murphy McCauley's Blender .oct exporter.
    /// The oct file format contains 3D geometry and lightmaps and
    /// can be loaded directly by Irrlicht
    OCT,

    /// Halflife MDL model file
    MDL_HalfLife,

    /// generic skinned mesh
    Skinned
}

/+++ 
 + Class for an animated mesh.
 +/
class AnimatedMesh : Mesh
{
    this(SceneManager _smgr, string file)
    in
    {
    	assert(_smgr.ptr != null);
    }
    body
    {
        smgr = _smgr;
        super(smgr, file);
        ptr = cast(irr_IAnimatedMesh*)super.ptr;
    }
    
    this(irr_IAnimatedMesh* ptr)
    {
    	this.ptr = ptr;
    	super(cast(irr_IMesh*)this.ptr);
    }
    
    /***
     * Gets the frame count of the animated mesh.
	 * Returns: The amount of frames. If the amount is 1,
	 * 			it is a static, non animated mesh.
     */
    uint getFrameCount()
    {
        return irr_IAnimatedMesh_getFrameCount(ptr);
    }
    
    /***
     * Gets the animation speed of the animated mesh.
	 * Returns: The number of frames per second to play the
	 *			animation with by default. If the amount is 0,
	 * 			it is a static, non animated mesh.
     */
    float getAnimationSpeed()
    {
        return irr_IAnimatedMesh_getAnimationSpeed(ptr);
    }
    
    /**
     * Sets the animation speed of the animated mesh.
	 * Params:
	 *			fps =  Number of frames per second to play the
	 *			animation with by default. If the amount is 0,
	 *			it is not animated. The actual speed is set in the
	 *			scene node the mesh is instantiated in.
     */
    void setAnimationSpeed(float fps)
    {
        irr_IAnimatedMesh_setAnimationSpeed(ptr, fps);
    }
    
    /***
     *	Returns the IMesh interface for a frame.
	 *
     *	Params:
     * 			frame = Frame number as zero based index. The maximum
     * 			frame number is getFrameCount() - 1;
	 * 			
     *			detailLevel = Level of detail. 0 is the lowest, 255 the
	 * 			highest level of detail. Most meshes will ignore the detail level.
	 *
	 * 			startFrameLoop = Because some animated meshes (.MD2) are
	 * 			blended between 2 static frames, and maybe animated in a loop,
	 * 			the startFrameLoop and the endFrameLoop have to be defined, to
	 * 			prevent the animation to be blended between frames which are
	 * 			outside of this loop.
	 * 			If startFrameLoop and endFrameLoop are both -1, they are ignored.
	 *
	 * 			endFrameLoop = see startFrameLoop.
	 *
	 * Returns: the animated mesh based on a detail level.
     */
    Mesh getMesh(int frame, int detailLevel=255, int startFrameLoop=-1, int endFrameLoop=-1)
    {
        auto temp = irr_IAnimatedMesh_getMesh(ptr, detailLevel, startFrameLoop, endFrameLoop);
        return new Mesh(temp);
    }

    AnimatedMeshType getMeshType()
    {
        return AnimatedMeshType.unknown;
    }

    irr_IAnimatedMesh* ptr;
private:
    SceneManager smgr;
}

unittest
{
    mixin(TestPrerequisite);

    /// IAnimatedMesh test starts here
    auto mesh = smgr.getMesh("../../media/sydney.md2");
    assert(mesh !is null);
    assert(mesh.ptr != null);

    auto count = mesh.getFrameCount();
    debug writeln("Framecount: ", count);

    auto animspeed = mesh.getAnimationSpeed();
    debug writeln("AnimationSpeed: ", animspeed);

    mesh.setAnimationSpeed(60);
    auto mesh2 = mesh.getMesh(60);
    assert(mesh2 !is null);
    assert(mesh2.ptr != null);
}

package extern (C):

struct irr_IAnimatedMesh;

uint irr_IAnimatedMesh_getFrameCount(irr_IAnimatedMesh* mesh);
float irr_IAnimatedMesh_getAnimationSpeed(irr_IAnimatedMesh* mesh);
void irr_IAnimatedMesh_setAnimationSpeed(irr_IAnimatedMesh* mesh, float fps);
irr_IMesh* irr_IAnimatedMesh_getMesh(irr_IAnimatedMesh* mesh, int frame, int detailLevel=255, int startFrameLoop=-1, int endFrameLoop=-1);

