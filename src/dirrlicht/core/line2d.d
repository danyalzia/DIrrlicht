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

module dirrlicht.core.line2d;

import dirrlicht.core.vector2d;

struct line2d(T) {
    @disable this();
    this(T xa, T ya, T xb, T yb) {
        start = vector2d!(T)(xa, ya);
        end = vector2d!(T)(xb, yb);
    }

    this(vector2d!(T) start, vector2d!(T) end) {
        this.start = start;
        this.end = end;
    }
    vector2d!(T) start;
    vector2d!(T) end;
}

extern (C):

struct irr_line2d;
