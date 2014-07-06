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

/** Has some useful methods used with occlusion culling or clipping.
*/
module dirrlicht.core.aabbox3d;

import dirrlicht.core.SIMDMath;
import dirrlicht.core.vector3d;

struct aabbox3d(T)
{
    @disable this();
    this(vector3d!(T) min, vector3d!(T) max)
    {
        MinEdge = min;
        MaxEdge = max;
    }

    this(vector3d!(T) init)
    {
        MinEdge = init;
        MaxEdge = init;
    }

    void opOpAssign(string op)(aabbox3d rhs)
    {
        mixin("MinEdge" ~ op ~ "=rhs.MinEdge;");
        mixin("MaxEdge" ~ op ~ "=rhs.MaxEdge;");
    }

    aabbox3d!(T) opBinary(string op)(aabbox3d!(T) rhs)
    {
        static if (op == "+")
        {
            return new aabbox3d(MinEdge + rhs.MinEdge, MaxEdge + rhs.MaxEdge);
        }

        else static if (op == "-")
        {
            return new aabbox3d(MinEdge - rhs.MinEdge, MaxEdge - rhs.MaxEdge);
        }

        else static if (op == "*")
        {
            return new aabbox3d(MinEdge * rhs.MinEdge, MaxEdge * rhs.MaxEdge);
        }

        else static if (op == "/")
        {
            return new aabbox3d(MinEdge / rhs.MinEdge, MaxEdge / rhs.MaxEdge);
        }
    }
    
    /// internal use only
    static if (is (T == float))
    {
    	@property irr_aabbox3df ptr()
    	{
    		return irr_aabbox3df(MinEdge.ptr, MaxEdge.ptr);
    	}
    }
    
    else
    {
    	@property irr_aabbox3di ptr()
    	{
    		return irr_aabbox3di(MinEdge.ptr, MaxEdge.ptr);
    	}
    }	
    
    vector3d!(T) MinEdge;
    vector3d!(T) MaxEdge;
}

alias aabbox3df = aabbox3d!(float);
alias aabbox3di = aabbox3d!(int);

/// example
unittest
{
    auto box = aabbox3di(vector3di(2,2,2), vector3di(4,4,4));
    assert(box.MinEdge.x == 2 || box.MinEdge.y == 2 || box.MinEdge.z == 2
    || box.MaxEdge.x == 4 || box.MaxEdge.y == 4 || box.MaxEdge.z == 4);

    auto box2 = aabbox3di(vector3di(4,4,4), vector3di(6,6,6));
    box += box2;
    assert(box.MinEdge.x == 6 || box.MinEdge.y == 6 || box.MinEdge.z == 6
    || box.MaxEdge.x == 10 || box.MaxEdge.y == 10 || box.MaxEdge.z == 10);

    box -= box2;
    assert(box.MinEdge.x == 2 || box.MinEdge.y == 2 || box.MinEdge.z == 2
    || box.MaxEdge.x == 4 || box.MaxEdge.y == 4 || box.MaxEdge.z == 4);

    box *= box2;
    assert(box.MinEdge.x == 8 || box.MinEdge.y == 8 || box.MinEdge.z == 8
    || box.MaxEdge.x == 24 || box.MaxEdge.y == 24 || box.MaxEdge.z == 24);

    box /= box2;
    assert(box.MinEdge.x == 2 || box.MinEdge.y == 2 || box.MinEdge.z == 2
    || box.MaxEdge.x == 4 || box.MaxEdge.y == 4 || box.MaxEdge.z == 4);
}

package extern(C):

struct irr_aabbox3di
{
    irr_vector3di MinEdge;
    irr_vector3di MaxEdge;
}

struct irr_aabbox3df
{
    irr_vector3df MinEdge;
    irr_vector3df MaxEdge;
}
