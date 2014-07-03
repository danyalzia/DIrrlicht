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

module dirrlicht.scene.IAnimatedMesh;

import dirrlicht.CompileConfig;
import dirrlicht.scene.IMesh;
import dirrlicht.IrrlichtDevice;
import dirrlicht.scene.ISceneManager;
import dirrlicht.scene.IMeshBuffer;
import dirrlicht.video.SMaterial;
import dirrlicht.core.aabbox3d;
import dirrlicht.video.EMaterialFlags;
import dirrlicht.scene.EHardwareBufferFlags;
import dirrlicht.video.SVertexIndex;

import std.conv;

/// Possible types of (animated) meshes.
enum E_ANIMATED_MESH_TYPE
{
    /// Unknown animated mesh type.
    EAMT_UNKNOWN = 0,

    /// Quake 2 MD2 model file
    EAMT_MD2,

    /// Quake 3 MD3 model file
    EAMT_MD3,

    /// Maya .obj static model
    EAMT_OBJ,

    /// Quake 3 .bsp static Map
    EAMT_BSP,

    /// 3D Studio .3ds file
    EAMT_3DS,

    /// My3D Mesh, the file format by Zhuck Dimitry
    EAMT_MY3D,

    /// Pulsar LMTools .lmts file. This Irrlicht loader was written by Jonas Petersen
    EAMT_LMTS,

    /// Cartography Shop .csm file. This loader was created by Saurav Mohapatra.
    EAMT_CSM,

    /// .oct file for Paul Nette's FSRad or from Murphy McCauley's Blender .oct exporter.
    /** The oct file format contains 3D geometry and lightmaps and
    can be loaded directly by Irrlicht */
    EAMT_OCT,

    /// Halflife MDL model file
    EAMT_MDL_HALFLIFE,

    /// generic skinned mesh
    EAMT_SKINNED
}

class IAnimatedMesh : IMesh
{
    this(ISceneManager _smgr, string file)
    {
        smgr = _smgr;
        super(smgr, file);
        ptr = cast(irr_IAnimatedMesh*)super.ptr;
    }

    uint getFrameCount()
    {
        return irr_IAnimatedMesh_getFrameCount(ptr);
    }

    float getAnimationSpeed()
    {
        return irr_IAnimatedMesh_getAnimationSpeed(ptr);
    }

    void setAnimationSpeed(float fps)
    {
        irr_IAnimatedMesh_setAnimationSpeed(ptr, fps);
    }

    IMesh getMesh(int frame, int detailLevel=255, int startFrameLoop=-1, int endFrameLoop=-1)
    {
        auto temp = irr_IAnimatedMesh_getMesh(ptr, detailLevel, startFrameLoop, endFrameLoop);
        return cast(IMesh)(temp);
    }

    E_ANIMATED_MESH_TYPE getMeshType()
    {
        return E_ANIMATED_MESH_TYPE.EAMT_UNKNOWN;
    }

    ISceneManager smgr;
    irr_IAnimatedMesh* ptr;
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

