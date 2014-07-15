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


module dirrlicht.scene.indexbuffer;

import dirrlicht.scene.indexbuffer;
import dirrlicht.scene.meshbuffer;
import dirrlicht.video.material;
import dirrlicht.core.aabbox3d;
import dirrlicht.video.materialflags;
import dirrlicht.scene.hardwarebufferflags;
import dirrlicht.video.vertexindex;

interface IIndexBuffer {
    void* getData();

    IndexType getType();
    void setType(IndexType IndexType);

    uint stride();

    uint size();
    void push_back (uint element);

    //uint operator [](uint index);

    uint getLast();
    void setValue(uint index, uint value);
    void set_used(uint usedNow);
    void reallocate(uint new_size);
    uint allocated_size();

    void* pointer();

    /// get the current hardware mapping hint
    HardwareMappingHint getHardwareMappingHint();

    /// set the hardware mapping hint, for driver
    void setHardwareMappingHint(HardwareMappingHint NewMappingHint );

    /// flags the meshbuffer as changed, reloads hardware buffers
    void setDirty();

    /// Get the currently used ID for identification of changes.
    /** This shouldn't be used for anything outside the VideoDriver. */
    uint getChangedID();
}

class CIndexBuffer : IIndexBuffer {
    void* getData() {
        return Indices.pointer();
    }

    IndexType getType() {
        return Indices.getType();
    }

    void setType(IndexType IndexType) {}

    uint stride() {
        return Indices.stride();
    }

    uint size() {
        return Indices.size();
    }

    void push_back (uint element) {
        Indices.push_back(element);
    }

    //uint operator [](uint index);

    uint getLast() {
        return Indices.getLast();
    }

    void setValue(uint index, uint value) {
        Indices.setValue(index, value);
    }

    void set_used(uint usedNow) {
        Indices.set_used(usedNow);
    }

    void reallocate(uint new_size) {
        Indices.reallocate(new_size);
    }

    uint allocated_size() {
        return Indices.allocated_size();
    }

    void* pointer() {
        return Indices.pointer();
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

    interface IIndexList {
        uint stride();
        uint size();
        void push_back(uint element);
        //u32 operator [](u32 index);
        uint getLast();
        void setValue(uint index, uint value);
        void set_used(uint usedNow);
        void reallocate(uint new_size);
        uint allocated_size();
        void* pointer();
        IndexType getType();
    };

    this(IndexType IndexType) {
        Indices = null;
        MappingHint = HardwareMappingHint.Never;
        ChangedID = 1;
    }

    IIndexList *Indices;
    HardwareMappingHint MappingHint;
    uint ChangedID;
}
