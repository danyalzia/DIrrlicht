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

module dirrlicht.scene.CDynamicMeshBuffer;

import dirrlicht.video.S3DVertex;
import dirrlicht.video.SVertexIndex;
import dirrlicht.scene.IVertexBuffer;
import dirrlicht.scene.IIndexBuffer;
import dirrlicht.video.SMaterial;
import dirrlicht.core.aabbox3d;
import dirrlicht.scene.CVertexBuffer;
import dirrlicht.scene.CIndexBuffer;
import dirrlicht.core.vector3d;

class CDynamicMeshBuffer
{
    this(E_VERTEX_TYPE vertexType, E_INDEX_TYPE indexType)
    {
        VertexBuffer=new CVertexBuffer(vertexType);
        IndexBuffer=new CIndexBuffer(indexType);

        BoundingBox = aabbox3df(vector3df(0,0,0), vector3df(0,0,0));
    }

    IVertexBuffer getVertexBuffer()
    {
        return VertexBuffer;
    }

    IIndexBuffer getIndexBuffer()
    {
        return IndexBuffer;
    }

    void setVertexBuffer(IVertexBuffer newVertexBuffer)
    {
        VertexBuffer=newVertexBuffer;
    }

    void setIndexBuffer(IIndexBuffer newIndexBuffer)
    {
        IndexBuffer=newIndexBuffer;
    }

    SMaterial getMaterial()
    {
        return Material;
    }

    aabbox3df getBoundingBox()
    {
        return BoundingBox;
    }

    void setBoundingBox(aabbox3df box)
    {
        BoundingBox = box;
    }

    SMaterial Material;
    aabbox3df BoundingBox;
private:
    IVertexBuffer VertexBuffer;
    IIndexBuffer IndexBuffer;
}