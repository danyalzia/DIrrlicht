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

module dirrlicht.core.plane3d;

import dirrlicht.core.vector3d;

struct plane3d(T) {
    @disable this();
	this(vector3d!(T) Normal, T D) {
		this.Normal = Normal;
		this.D = D;
	}
	
	void opOpAssign(string op)(plane3d rhs) {
        mixin("Normal" ~ op ~ "=rhs.Normal;");
        mixin("D" ~ op ~ "=rhs.D;");
    }

    plane3d!(T) opBinary(string op)(plane3d!(T) rhs) {
    	return new plane3d(Normal ~op~ rhs.Normal, D ~op~ rhs.D); 
    }
    
    @property {
		static if (is(T == int)) {
			irr_plane3di ptr() {
				return irr_plane3di(irr_vector3di(Normal.x, Normal.y, Normal.z), D);
			}
		}
		else {
			irr_plane3df ptr() {
				return irr_plane3df(irr_vector3df(Normal.x, Normal.y, Normal.z), D);
			}
		}
	}
private:
    vector3d!(T) Normal;
    T D;
}

alias plane3df = plane3d!(float);
alias plane3di = plane3d!(int);

extern (C):

struct irr_plane3di {
	irr_vector3di Normal;
	int D;
}

struct irr_plane3df {
	irr_vector3df Normal;
	float D;
}
