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

/***********************************
 * Helper functions for SIMD based core classes
 * GDC Assembly isn't supported yet!
 */

module dirrlicht.core.SIMDMath;

import core.cpuid;
import std.math;
import std.stdio;
public import core.simd;
public import dirrlicht.CompileConfig;

/// DMD doesn't support simd types for x86, the padding in GDC isn't working yet!
static if (DigitalMars || GDC)
{
    alias float4 = float[4];
    alias int4 = int[4];
}

pure nothrow float SQRT(float n)
{
    static if(DigitalMars || LDC)
    {
        asm
        {
            fld n;
            fsqrt;
            fst n;
        }
        return n;
    }

    else
    {
        return sqrt(n);
    }
}

pure nothrow float[4] SQRT(float[4] vec)
{
    static if(DigitalMars || LDC)
    {
        asm
        {
            movups XMM0, vec;
            sqrtps XMM0, XMM0;
            movups vec, XMM0;
        }

        return vec;
    }

    else
    {
        foreach(ref arr; vec)
        {
            arr = sqrt(arr);
        }

        return vec;
    }
}

pure nothrow float4 SQRT(float4 vec)
{
    static if(DigitalMars || LDC)
    {
        asm
        {
            movups XMM0, vec;
            sqrtps XMM0, XMM0;
            movups vec, XMM0;
        }

        return vec;
    }

    else
    {
        foreach(ref arr; vec)
        {
            arr = sqrt(arr);
        }

        return vec;
    }
}

///
unittest
{
    auto a = SQRT(4);
    assert(a == 2);
    debug writeln("SQRT(4): ", a);

    float arr[4] = [4,4,4,4];
    arr = SQRT(arr);
    assert(arr == [2,2,2,2]);
    debug writeln("SQRT([4,4,4,4]): ", arr);

    float4 vec = [4,4,4,4];
    vec = SQRT(vec);
    assert(vec.array == [2,2,2,2]);
    debug writeln("SQRT(float4[4,4,4,4]): ", vec.array);
}

pure nothrow int FLOOR(float n)
{
    static if(DigitalMars || LDC)
    {
		const float h = 0.5f;
		int t;

        asm
        {
            fld n;
            fsub h;
            fistp t;
        }

        return t;
    }

    else
    {

    }
}

///
unittest
{
    int a = FLOOR(2.5);
    assert(a == 2);
    debug writeln("(a = FLOOR(2.5)= ", a);
}

pure nothrow void MOV(T)(T n)
{
    static if(DigitalMars || LDC)
    {
        asm
        {
            mov EAX, n;
        }
    }

    else
    {

    }
}
