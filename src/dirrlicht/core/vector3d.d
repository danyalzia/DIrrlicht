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

/++++
+ SIMD recognized 3D vector class. The fourth component is unused and set to 0.
+/

module dirrlicht.core.vector3d;

import dirrlicht.core.simdmath;
import std.traits;

struct vector3d(T) {
static if(__traits(isArithmetic, T)) {
    @disable this();
    this(T x, T y, T z) {
        vec = [x, y, z, 0];
    }

    this(T n) {
        vec = [n, n, n, n];
    }
    
    /// internal use only
    static if (is (T == float)) {
    	this(irr_vector3df v) {
    		vec = [v.x, v.y, v.z, 0];
    	}
    }
    	
    else
    {
    	this(irr_vector3di v)
    	{
    		vec = [v.x, v.y, v.z, 0];
    	}
    }
    
    static if (DigitalMars || GDC) {
        this(float4 vec) {
            this.vec = cast(T[])vec;
        }

        this(int4 vec) {
            this.vec = cast(T[])vec;
        }
    }

    else {
        this(float4 vec) {
            this.vec = vec;
        }

        this(int4 vec) {
            this.vec = vec;
        }
    }

    void opOpAssign(string op)(vector3d vector) {
        static if (is (T == int)) {
            static if (LDC) {
                mixin("vec.array[0]" ~ op ~ "=vector.vec.array[0];");
                mixin("vec.array[1]" ~ op ~ "=vector.vec.array[1];");
                mixin("vec.array[2]" ~ op ~ "=vector.vec.array[2];");
            }

            else {
                mixin("vec[0]" ~ op ~ "=vector.vec[0];");
                mixin("vec[1]" ~ op ~ "=vector.vec[1];");
                mixin("vec[2]" ~ op ~ "=vector.vec[2];");
            }
        }
        else {
            static if (LDC) {
                mixin("vec" ~ op ~ "=vector.vec;");
            }
            else {
                mixin("vec[0]" ~ op ~ "=vector.vec[0];");
                mixin("vec[1]" ~ op ~ "=vector.vec[1];");
                mixin("vec[2]" ~ op ~ "=vector.vec[2];");
            }
        }
    }

    vector3d!(T) opBinary(string op)(vector3d!(T) rhs) {
    	mixin("return new vector3d(vec" ~ op ~ "rhs.vec);");
    }

    vector3d!(T) set(T nx, T ny, T nz) {
        vec = [nx, ny, nz, 0];
        return vector3d(vec);
    }

    /** Very slow! */
    @property T length() {
        return cast(T)(SQRT(cast(float)lengthSQ));
    }

    /** Very slow! */
    @property T lengthSQ() {
        static if (DigitalMars || GDC) {
            return cast(T)(vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2]);
        }

        else {
            return cast(T)(vec.array[0]*vec.array[0] + vec.array[1]*vec.array[1] + vec.array[2]*vec.array[2]);
        }
    }

    /** Extremely slow! */
    T dotProduct(vector3d!(T) other) {
        static if (DigitalMars || GDC) {
            return cast(T)(vec[0]*other.vec[0] + vec[1]*other.vec[1] + vec[2]*other.vec[2]);
        }

        else {
            return cast(T)(vec.array[0]*other.vec.array[0] + vec.array[1]*other.vec.array[1] + vec.array[2]*other.vec.array[2]);
        }
    }

    T getDistanceFrom(vector3d!(T) other) {
        static if (DigitalMars || GDC) {
            float4 arr;
            for (int i = 0; i < 4; i++) {
                arr = vec[i] - other.vec[i];
            }

            return vector3d(arr).length;
        }

        else {
            return vector3d(vec - other.vec).length;
        }

    }

    T getDistanceFromSQ(vector3d!(T) other) {
        static if (DigitalMars || GDC) {
            float4 arr;
            foreach(i; 0..4) {
                arr = vec[i] - other.vec[i];
            }

            return vector3d(arr).lengthSQ;
        }

        else {
            return vector3d(vec - other.vec).lengthSQ;
        }

    }

    vector3d!(T) crossProduct(vector3d!(T) p) {
        return vector3d(vec);
    }

    bool isBetweenPoints(vector3d!(T) begin, vector3d!(T) end) {
        return true;
        //const T f = (end - begin).getLengthSQ();
        //return getDistanceFromSQ(begin) <= f && getDistanceFromSQ(end) <= f;
    }

    vector3d!(T) normalize() {
        auto length = cast(T)(length);
        static if (is (T == float))
            float4 mul = [length, length, length, 0];
        else
            int4 mul = [length, length, length, 0];

        static if (is (T == float)) {
            static if(DigitalMars || GDC) {
                float4 arr;
                for (int i = 0; i < 4; i++) {
                    vec[i] *= mul[i];
                }
            }

            else {
                vec *= mul;
            }
        }

        else static if (is (T == int)) {
            static if(DigitalMars || GDC) {
                int4 arr;
                for (int i = 0; i < 4; i++) {
                    vec[i] *= mul[i];
                }
            }

            /// No multiply implemented yet for int4
            else {
                int4 arr;
                for (int i = 0; i < 4; i++) {
                    vec.array[i] *= mul.array[i];
                }
            }
        }

        return vector3d(vec);
    }

    vector3d!(T) setLength(T newlength) {
        normalize();
        static if (is (T == float)) {
            float4 vec2 = [newlength, newlength, newlength, 0];
            static if (DigitalMars || GDC) {
                foreach(i; 0..4)
                vec[i] *= vec2[i];
            }

            else {
                vec *= vec2;
            }

        }
        else {
            int4 vec2 = [newlength, newlength, newlength, 0];
        }

        return vector3d(vec);
    }

    static if (DigitalMars || GDC) {
		@property {
			T x() { return cast(T)vec[0]; }
			T y() { return cast(T)vec[1]; }
			T z() { return cast(T)vec[2]; }

			void x(T n) { vec[0] = n; }
			void y(T n) { vec[1] = n; }
			void z(T n) { vec[2] = n; }
		}
    }

    else {
		@property {
			T x() { return cast(T)vec.array[0]; }
			T y() { return cast(T)vec.array[1]; }
			T z() { return cast(T)vec.array[2]; }

			void x(T n) { vec.array[0] = n; }
			void y(T n) { vec.array[1] = n; }
			void z(T n) { vec.array[2] = n; }
		}
    }

    /** get the SIMD float4 */
    static if (DigitalMars || GDC) {
        @property float4 vecSIMD() {
            return cast(float[4])vec;
        }
    }

    else {
        @property float4 vecSIMD() {
            return vec;
        }
    }

    /// internal use only
    static if (is (T == float)) {
    	@property irr_vector3df ptr() {
    		return irr_vector3df(x,y,z);
    	}
    }
    	
    else {
    	@property irr_vector3di ptr() {
    		return irr_vector3di(x,y,z);
    	}
    }
private:
    static if (is (T == float))
        float4 vec;
    else
        int4 vec;

    /** Padding for correctly passing vectors into function on x86*/
    static if (LDC)
        void* padding[12];
}
}

alias vector3df = vector3d!(float);
alias vector3di = vector3d!(int);

///
unittest
{
    auto vecf = vector3df(4.0, 4.0, 4.0);
    assert(vecf.x == 4.0 && vecf.y == 4.0 && vecf.z == 4.0);
    auto vecf2 = vector3df(5.0, 5.0, 5.0);
    vecf = vecf2;
    assert(vecf.x == 5.0 || vecf.y == 5.0  || vecf.z == 5.0 );
    vecf += vecf2;
    assert(vecf.x == 10.0 || vecf.y == 10.0  || vecf.z == 10.0 );
    vecf -= vecf2;
    assert(vecf.x == 5.0 || vecf.y == 5.0  || vecf.z == 5.0 );
    vecf *= vecf2;
    assert(vecf.x == 25.0 || vecf.y == 25.0  || vecf.z == 25.0 );
    vecf /= vecf2;
    assert(vecf.x == 5.0 || vecf.y == 5.0  || vecf.z == 5.0 );

    auto veci = vector3di(4,4,4);
    assert(veci.x == 4 && veci.y == 4 && veci.z == 4);
    auto veci2 = vector3di(5,5,5);
    veci = veci2;
    assert(veci.x == 5 || veci.y == 5  || veci.z == 5 );
    veci += veci2;
    assert(veci.x == 10 || veci.y == 10  || veci.z == 10 );
    veci -= veci2;
    assert(veci.x == 5 || veci.y == 5  || veci.z == 5 );
    veci *= veci2;
    assert(veci.x == 25 || veci.y == 25  || veci.z == 25 );
    veci /= veci2;
    assert(veci.x == 5 || veci.y == 5  || veci.z == 5 );
}

package extern (C):

struct irr_vector3di {
    int x;
    int y;
    int z;
}

struct irr_vector3df {
    float x;
    float y;
    float z;
}
