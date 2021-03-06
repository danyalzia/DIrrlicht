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

module dirrlicht.scene.bonescenenode;

/// Enumeration for different bone animation modes
enum BoneAnimationMode
{
    /// The bone is usually animated, unless it's parent is not animated
    Automatic=0,

    /// The bone is animated by the skin, if it's parent is not animated then animation will resume from this bone onward
    Animated,

    /// The bone is not animated by the skin
    NotAnimated,

    /// Not an animation mode, just here to count the available modes
    Count

}

enum BoneSkinningSpace
{
    /// local skinning, standard
    Local=0,

    /// global skinning
    Global,

    Count
}

import dirrlicht.scene.scenenode;

interface BoneSceneNode : SceneNode {
	@property void* c_ptr();
	@property void c_ptr(void* ptr);
}

class CBoneSceneNode : BoneSceneNode {
	mixin DefaultSceneNode;
	this(irr_IBoneSceneNode* ptr) {
		this.ptr = ptr;
		c_ptr = cast(irr_ISceneNode*)this.ptr;
	}

	@property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
	irr_IBoneSceneNode* ptr;
}

extern (C):

struct irr_IBoneSceneNode;

