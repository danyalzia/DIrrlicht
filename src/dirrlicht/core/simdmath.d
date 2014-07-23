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

module dirrlicht.core.simdmath;

import core.cpuid;
import std.math;
import std.traits;
import std.stdio;
public import core.simd;
public import dirrlicht.compileconfig;

/// Constant for converting from degrees to radians
enum DEGTORAD = PI / 180.0;

/// constant for converting from radians to degrees (formally known as GRAD_PI)
enum RADTODEG = 180.0 / PI;

static int F32_AS_S32(float f)	{return (*(cast(int *) &(f)));}
static uint F32_AS_U32(float f)	{return (*(cast(uint *) &(f)));}
static uint* F32_AS_U32_POINTER(ref float f)	{return ( (cast(uint *) &(f)));}

enum F32_VALUE_0 =	0x00000000;
enum F32_VALUE_1 =	0x3f800000;
enum F32_SIGN_BIT =	0x80000000U;
enum F32_EXPON_MANTISSA =	0x7FFFFFFFU;

@trusted static bool	F32_LOWER_0(float f)	{return (F32_AS_U32(f) > F32_SIGN_BIT);}
@trusted static bool	F32_LOWER_EQUAL_0(float f)	{return (F32_AS_S32(f) <= F32_VALUE_0);}
@trusted static bool	F32_GREATER_0(float f)	{return (F32_AS_S32(f) > F32_VALUE_0);}
@trusted static bool	F32_GREATER_EQUAL_0(float f)	{return (F32_AS_U32(f) <= F32_SIGN_BIT);}
@trusted static bool	F32_EQUAL_1(float f)	{return (F32_AS_U32(f) == F32_VALUE_1);}
@trusted static bool	F32_EQUAL_0(float f)	{return ( (F32_AS_U32(f) & F32_EXPON_MANTISSA ) == F32_VALUE_0);}

// only same sign
static bool	F32_A_GREATER_B(float a, float b)	{return (F32_AS_S32((a)) > F32_AS_S32((b)));}

/// returns if a equals zero, taking rounding errors into account
@trusted bool iszero(T)(const T a, const T tolerance = T.epsilon)
	if(isFloatingPoint!T) {
	return approxEqual(a, 0.0, tolerance);
}

/// returns if a equals zero, taking rounding errors into account
bool iszero(T)(const T a, const T tolerance = 0)
	if(isIntegral!T && isUnsigned!T)
{
	return a <= tolerance;
}

/// returns if a equals zero, taking rounding errors into account
@trusted bool iszero(T)(const T a, const T tolerance = 0)
	if(isIntegral!T && !isUnsigned!T)
{
	static if(is(T == int))
		return ( a & 0x7ffffff ) <= tolerance;
	else
		return fabs(a) <= tolerance;
}

@trusted T clamp(T)(inout(T) val, inout(T) minv, inout(T) maxv)
{
	return cast(T)fmax(fmin(val, maxv), minv);
}

pure nothrow @trusted float SQRT(float n)
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

static if (LDC)
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

    static if (LDC)
    {
        float4 vec = [4,4,4,4];
        vec = SQRT(vec);
        assert(vec.array == [2,2,2,2]);
        debug writeln("SQRT(float4[4,4,4,4]): ", vec.array);
    }
}

pure nothrow int FLOOR(float n) {
    static if(DigitalMars || LDC) {
        const float h = 0.5f;
        int t;

        asm {
            fld n;
            fsub h;
            fistp t;
        }

        return t;
    }

    else
    {
        return cast(int)n;
    }
}

///
unittest
{
    int a = FLOOR(2.5);
    assert(a == 2);
    debug writeln("(a = FLOOR(2.5)= ", a);
}
