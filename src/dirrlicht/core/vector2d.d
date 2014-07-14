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

module dirrlicht.core.vector2d;

struct vector2d(T) {
	@disable this();
	
	this(T x, T y) {
		this.x = x;
		this.y = y;
	}
	
	/// internal use only
    static if (is (T == float)) {
    	this(irr_vector2df v) {
    		x = v.x;
    		y = v.y;
    	}
    }
    	
    else {
    	this(irr_vector2di v) {
    		x = v.x;
    		y = v.y;
    	}
    }
    
    void opOpAssign(string op)(vector2d rhs) {
        mixin("x" ~ op ~ "=rhs.x;");
        mixin("y" ~ op ~ "=rhs.y;");
    }

    vector2d!(T) opBinary(string op)(vector2d!(T) rhs) {
    	return new vector2d(x ~op~ rhs.x, y ~op~ rhs.y);
    }
    
    @property {
    	static if (is(T == int)) {
	    	irr_vector2di ptr() {
	    		return irr_vector2di(x,y);
	    	}
    	}
    	
    	else {
	    	irr_vector2df ptr() {
	    		return irr_vector2df(x,y);
	    	}
    	}
    }
    
    T x, y;
}

alias vector2df = vector2d!(float);
alias vector2di = vector2d!(int);

///
unittest
{
    auto veci = vector2di(2, 4);
    assert(veci.x == 2 && veci.y == 4);

    auto veci2 = vector2di(5, 5);
    veci += veci2;
    assert(veci.x == 7 && veci.y == 9);
    veci -= veci2;
    assert(veci.x == 2 && veci.y == 4);
    veci *= veci2;
    assert(veci.x == 10 && veci.y == 20);
    veci /= veci2;
    assert(veci.x == 2 && veci.y == 4);

    auto vecf = vector2df(2.0, 4.0);
    assert(veci.x == 2.0 && veci.y == 4.0);
}

package extern (C):

struct irr_vector2di {
    int x;
    int y;
}

struct irr_vector2df {
    float x;
    float y;
}
