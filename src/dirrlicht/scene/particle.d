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

module dirrlicht.scene.particle;

import dirrlicht.core.vector3d;
import dirrlicht.video.color;
import dirrlicht.core.dimension2d;

/// Struct for holding particle data
struct Particle
{
    /// Position of the particle
    vector3df pos;

    /// Direction and speed of the particle
    vector3df vector;

    /// Start life time of the particle
    uint startTime;

    /// End life time of the particle
    uint endTime;

    /// Current color of the particle
    Color color;

    /// Original color of the particle.
    /** That's the color of the particle it had when it was emitted. */
    Color startColor;

    /// Original direction and speed of the particle.
    /** The direction and speed the particle had when it was emitted. */
    vector3df startVector;

    /// Scale of the particle.
    /** The current scale of the particle. */
    dimension2df size;

    /// Original scale of the particle.
    /** The scale of the particle when it was emitted. */
    dimension2df startSize;
}
