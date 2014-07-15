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

module dirrlicht.scene.mesh;

import dirrlicht.compileconfig;
import dirrlicht.scene.scenemanager;
import dirrlicht.scene.meshbuffer;
import dirrlicht.video.material;
import dirrlicht.core.vector3d;
import dirrlicht.core.aabbox3d;
import dirrlicht.video.materialflags;
import dirrlicht.scene.hardwarebufferflags;
import dirrlicht.video.vertexindex;

import std.conv;
import std.string;

class Mesh {
    this(irr_IMesh* ptr) {
    	this.ptr = ptr;
    }
    
    uint getMeshBufferCount() {
        return irr_IMesh_getMeshBufferCount(ptr);
    }

    IMeshBuffer getMeshBuffer(uint nr) {
        auto meshbuffer = irr_IMesh_getMeshBuffer(ptr, nr);
        return cast(IMeshBuffer)meshbuffer;
    }

    MeshBuffer getMeshBuffer(const ref Material material) {
        auto meshbuffer = irr_IMesh_getMeshBufferByMaterial(ptr, material.ptr);
        return new MeshBuffer(meshbuffer);
    }

    aabbox3df getBoundingBox() {
        auto box = irr_IMesh_getBoundingBox(ptr);
        auto min = vector3df(box.MinEdge.x, box.MinEdge.y, box.MinEdge.z);
        auto max = vector3df(box.MaxEdge.x, box.MaxEdge.y, box.MaxEdge.z);
        auto temp = aabbox3df(min, max);
        return temp;
    }

    void setBoundingBox(aabbox3df box) {
        irr_vector3df min = {box.MinEdge.x, box.MinEdge.y, box.MinEdge.z};
        irr_vector3df max = {box.MaxEdge.x, box.MaxEdge.y, box.MaxEdge.z};
        irr_aabbox3df temp = {min, max};
        irr_IMesh_setBoundingBox(ptr, temp);
    }

    void setMaterialFlag(MaterialFlag flag, bool newvalue) {
        irr_IMesh_setMaterialFlag(ptr, flag, newvalue);
    }

    void setHardwareMappingHint(HardwareMappingHint newMappingHint, HardwareBufferType buffer=HardwareBufferType.VertexAndIndex) {
        irr_IMesh_setHardwareMappingHint(ptr, newMappingHint, buffer);
    }

    void setDirty(HardwareBufferType buffer=HardwareBufferType.VertexAndIndex) {
        irr_IMesh_setDirty(ptr, buffer);
    }
    
    alias ptr this;
    irr_IMesh* ptr;
}

/// IMesh example
unittest
{
    mixin(TestPrerequisite);

    /// smgr.getMesh() gives IAnimatedMesh instead so will test IMesh only
    auto mesh = smgr.getMesh("../../media/sydney.md2");
    checkNull(mesh);

    auto count = mesh.getMeshBufferCount();
    debug writeln("BufferCount: ", count);
}

package extern(C):

struct irr_IMesh;
struct irr_SMesh;

uint irr_IMesh_getMeshBufferCount(irr_IMesh* mesh);
irr_IMeshBuffer* irr_IMesh_getMeshBuffer(irr_IMesh* mesh, uint nr);
irr_IMeshBuffer* irr_IMesh_getMeshBufferByMaterial(irr_IMesh* mesh, const irr_SMaterial* material);
irr_aabbox3df irr_IMesh_getBoundingBox(irr_IMesh* mesh);
void irr_IMesh_setBoundingBox(irr_IMesh* mesh, const ref irr_aabbox3df box);
void irr_IMesh_setMaterialFlag(irr_IMesh* mesh, MaterialFlag flag, bool newvalue);
void irr_IMesh_setHardwareMappingHint(irr_IMesh* mesh, HardwareMappingHint newMappingHint, HardwareBufferType buffer=HardwareBufferType.VertexAndIndex);
void irr_IMesh_setDirty(irr_IMesh* mesh, HardwareBufferType buffer=HardwareBufferType.VertexAndIndex);
