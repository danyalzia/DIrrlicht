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

module dirrlicht.core.SIMDMath;

import core.cpuid;
import std.math;
public import core.simd;

/***********************************
 * Helper functions for SIMD based core classes
 * GDC Assembly isn't supported yet!
 */

float SQRT(float n)
{
    version(LDC)
    {
        asm
        {
            fld n;
            fsqrt;
            fst n;
        }
        return n;
    }

    version(DigitalMars)
    {
        asm
        {
            fld n;
            fsqrt;
            fst n;
        }
        return n;
    }

    version(GNU)
    {
        return sqrt(n);
    }
}

/** Not implemented yet! */
int FLOOR(int n)
{
    version(LDC)
    {
        return cast(int)(n);
    }

    version(DigitalMars)
    {
        return cast(int)(n);
    }

    version(GNU)
    {
        return cast(int)(n);
    }
}
