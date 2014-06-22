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

module dirrlicht.core.vector3d;

import std.math;
import core.simd;

/***********************************
 * SIMD recognized 3D vector class. The fourth component is unused and set to 0.
 * Params:
 *  x = x component
 *  y = y component
 *  z = z component
 */

struct vector3d(T)
{
    @disable this();
    this(T x, T y, T z)
    {
        vec.array = [x, y, z, 0];
    }
    this(T n)
    {
		vec.array = [n, n, n, n];
	}

	@property T x() { return cast(T)vec.array[0]; }
	@property T y() { return cast(T)vec.array[1]; }
	@property T z() { return cast(T)vec.array[2]; }

	T getLength()
	{
		return cast(T)vec.array[2];
	}

	T dotProduct()
	{
		return cast(T)vec.array[2];
	}

private:
    float4 vec;

    int dummy0, dummy1, dummy2, dummy3;
}

alias vector3df = vector3d!(float);
alias vector3di = vector3d!(int);

/** Usage: */
unittest
{
	auto vecf = vector3df(4.0,4.0,4.0);
	assert(vecf.x == 4.0 && vecf.y == 4.0 && vecf.z == 4.0);

	auto veci = vector3di(4,4,4);
	assert(veci.x == 4 && veci.y == 4 && veci.z == 4);
}
