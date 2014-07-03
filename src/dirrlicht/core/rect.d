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

module dirrlicht.core.rect;

import dirrlicht.core.vector2d;

struct rect(T)
{
    @disable this();

    this(T x, T y, T x2, T y2)
    {
        UpperLeftCorner = vector2d!(T)(x, y);
        LowerRightCorner = vector2d!(T)(x2, y2);
    }

    this(vector2d!(T) upper, vector2d!(T) lower)
    {
        UpperLeftCorner = upper;
        LowerRightCorner = lower;
    }

    void opOpAssign(string op)(rect rhs)
    {
        mixin("UpperLeftCorner" ~ op ~ "=rhs.UpperLeftCorner;");
        mixin("LowerRightCorner" ~ op ~ "=rhs.LowerRightCorner;");
    }

    rect!(T) opBinary(string op)(rect!(T) rhs)
    {
        static if (op == "+")
        {
            return new rect(UpperLeftCorner + rhs.UpperLeftCorner, LowerRightCorner + rhs.LowerRightCorner);
        }

        else static if (op == "-")
        {
            return new rect(UpperLeftCorner - rhs.UpperLeftCorner, LowerRightCorner - rhs.LowerRightCorner);
        }

        else static if (op == "*")
        {
            return new rect(UpperLeftCorner * rhs.UpperLeftCorner, LowerRightCorner * rhs.LowerRightCorner);
        }

        else static if (op == "/")
        {
            return new rect(UpperLeftCorner / rhs.UpperLeftCorner, LowerRightCorner / rhs.LowerRightCorner);
        }
    }

    @property T x()
    {
        return UpperLeftCorner.x;
    };
    @property T y()
    {
        return UpperLeftCorner.y;
    };
    @property T x1()
    {
        return LowerRightCorner.x;
    };
    @property T y1()
    {
        return LowerRightCorner.y;
    };

    @property T x(T _x)
    {
        return UpperLeftCorner.x = _x;
    };
    @property T y(T _y)
    {
        return UpperLeftCorner.y = _y;
    };
    @property T x1(T _x)
    {
        return LowerRightCorner.x = _x;
    };
    @property T y1(T _y)
    {
        return LowerRightCorner.y = _y;
    };

    vector2d!(T) UpperLeftCorner;
    vector2d!(T) LowerRightCorner;
}

alias recti = rect!(int);
alias rectf = rect!(float);

///
unittest
{
    auto rec = recti(4, 4, 4, 4);
    assert(rec.x == 4 || rec.y == 4 || rec.x1 == 4 || rec.y1 == 4);
    rec += recti(4,4,4,4);
    assert(rec.x == 8 || rec.y == 8 || rec.x1 == 8 || rec.y1 == 8);
}

package extern (C):

    struct irr_recti
{
    int x;
    int y;
    int x1;
    int y1;
}

struct irr_rectf
{
    float x;
    float y;
    float x1;
    float y1;
}
