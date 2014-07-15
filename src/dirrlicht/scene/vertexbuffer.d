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

module dirrlicht.scene.vertexbuffer;

import dirrlicht.scene.vertexbuffer;
import dirrlicht.scene.meshbuffer;
import dirrlicht.video.material;
import dirrlicht.core.aabbox3d;
import dirrlicht.video.materialflags;
import dirrlicht.scene.hardwarebufferflags;
import dirrlicht.video.vertexindex;
import dirrlicht.video.vertex;

interface IVertexBuffer {
    void* getData();
    VertexType getType();
    void setType(VertexType vertexType);
    uint stride();
    uint size();
    void push_back(S3DVertex element);

    //S3DVertex operator [](const uint index);

    S3DVertex getLast();
    void set_used(uint usedNow);
    void reallocate(uint new_size);
    uint allocated_size();
    S3DVertex* pointer();

    /// get the current hardware mapping hint
    HardwareMappingHint getHardwareMappingHint();

    /// set the hardware mapping hint, for driver
    void setHardwareMappingHint(HardwareMappingHint NewMappingHint);

    /// flags the meshbuffer as changed, reloads hardware buffers
    void setDirty();

    /// Get the currently used ID for identification of changes.
    /** This shouldn't be used for anything outside the VideoDriver. */
    uint getChangedID();
}

class CVertexBuffer : IVertexBuffer {
    void* getData() {
        return Vertices.pointer();
    }

    VertexType getType() {
        return Vertices.getType();
    }

    void setType(VertexType vertexType) { }

    uint stride() {
        return Vertices.stride();
    }

    uint size() {
        return Vertices.size();
    }

    void push_back(S3DVertex element) {
        Vertices.push_back(element);
    }

    //S3DVertex operator [](const uint index);

    S3DVertex getLast() {
        return Vertices.getLast();
    }

    void set_used(uint usedNow) {
        Vertices.set_used(usedNow);
    }

    void reallocate(uint new_size) {
        Vertices.reallocate(new_size);
    }

    uint allocated_size() {
        return Vertices.allocated_size();
    }

    S3DVertex* pointer() {
        return Vertices.pointer();
    }

    /// get the current hardware mapping hint
    HardwareMappingHint getHardwareMappingHint() {
        return MappingHint;
    }

    /// set the hardware mapping hint, for driver
    void setHardwareMappingHint(HardwareMappingHint NewMappingHint) {
        MappingHint=NewMappingHint;
    }

    /// flags the meshbuffer as changed, reloads hardware buffers
    void setDirty() {
        ++ChangedID;
    }

    /// Get the currently used ID for identification of changes.
    /** This shouldn't be used for anything outside the VideoDriver. */
    uint getChangedID() {
        return ChangedID;
    }

    interface IVertexList {
        uint stride();
        uint size();
        void push_back(S3DVertex element);
        //u32 operator [](u32 index);
        S3DVertex getLast();
        void set_used(uint usedNow);
        void reallocate(uint new_size);
        uint allocated_size();
        S3DVertex* pointer();
        VertexType getType();
    };

    this(VertexType vertexType) {
        Vertices = null;
        MappingHint = HardwareMappingHint.Never;
        ChangedID = 1;
    }

    IVertexList *Vertices;
    HardwareMappingHint MappingHint;
    uint ChangedID;
}
