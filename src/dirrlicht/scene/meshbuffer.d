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

module dirrlicht.scene.meshbuffer;

import dirrlicht.video.material;
import dirrlicht.video.vertex;
import dirrlicht.video.vertexindex;
import dirrlicht.core.aabbox3d;
import dirrlicht.core.vector3d;
import dirrlicht.core.vector2d;
import dirrlicht.scene.hardwarebufferflags;

interface IMeshBuffer
{
    ref Material getMaterial();
    const ref Material getMaterial();
    VertexType getVertexType();
    const void* getVertices();
    void* getVertices();
    uint getVertexCount();
    IndexType getIndexType();
    const ushort* getIndices();
    ushort* getIndices();
    uint getIndexCount();
    const ref aabbox3df getBoundingBox();
    void setBoundingBox(const ref aabbox3df box);
    void recalculateBoundingBox();
    const ref vector3df getPosition(uint i);
    ref vector3df getPosition(uint i);
    const ref vector3df getNormal(uint i);
    ref vector3df getNormal(uint i);
    const ref vector2df getTCoords(uint i);
    ref vector2df getTCoords(uint i);
    void append(const void* vertices, uint numVertices, const ushort* indices, uint numIndices);
    void append(const IMeshBuffer* other);
    E_HARDWARE_MAPPING getHardwareMappingHint_Vertex();
    E_HARDWARE_MAPPING getHardwareMappingHint_Index();
    void setHardwareMappingHint(E_HARDWARE_MAPPING newMappingHint, E_BUFFER_TYPE buffer=E_BUFFER_TYPE.EBT_VERTEX_AND_INDEX);
    void setDirty(E_BUFFER_TYPE buffer=E_BUFFER_TYPE.EBT_VERTEX_AND_INDEX);
    uint getChangedID_Vertex();
    uint getChangedID_Index();
}

class MeshBuffer
{
	this(irr_IMeshBuffer* ptr)
	{
		this.ptr = ptr;
	}
	
	irr_IMeshBuffer* ptr;
}

extern (C):

struct irr_IMeshBuffer;
