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

pure nothrow @safe struct Vector3D(T) if(isNumeric!(T) && (is (T == int) || is (T == float) || is (T == double))) {
    
    this(T x, T y, T z) {
        vec = [x, y, z, 0];
    }

    this(T n) {
        vec = [n, n, n, n];
    }

    this(Vector3D!(T) rhs) {
		static if (DigitalMars || GDC) {
			vec = cast(T[4])rhs.vec;
		}
		else {
			static if (is(T == float))
				vec = cast(float4)rhs.vec;
			else static if (is(T == double))
				vec = cast(double4)rhs.vec;
			else
				vec = cast(int4)rhs.vec;
		}
	}
	
    /// internal use only
    static if (is (T == float)) {
    	this(irr_vector3df v) {
    		vec = [v.x, v.y, v.z, 0];
    	}
    }
    
    else {
    	this(irr_vector3di v) {
    		vec = [v.x, v.y, v.z, 0];
    	}
    }
    
    static if (DigitalMars || GDC) {
        this(float4 vec) {
			import std.conv;
            this.vec = cast(typeof(this.vec))vec[0..$];
        }

		this(double4 vec) {
			this.vec = cast(typeof(this.vec))vec[0..$];
        }
        
        this(int4 vec) {
            this.vec = cast(typeof(this.vec))vec[0..$];
        }
    }

    else {
        this(float4 vec) {
            this.vec = vec;
        }

		this(double4 vec) {
            this.vec = vec;
        }
        
        this(int4 vec) {
            this.vec = vec;
        }
    }

	Vector3D!(T) opUnary(string op)() const
	if (op == "-") {
		return Vector3D!(T)(-x, -y, -z);
	}

	Vector3D!(T) opBinary(string op)(Vector3D!(T) rhs)
	if(op == "+" || op == "-" || op == "*" || op == "/") {
		return Vector3D!T(mixin("x "~op~" rhs.x"), mixin("y "~op~" rhs.y"), mixin("z "~op~" rhs.z"));
    }

    Vector3D!(T) opBinary(string op)(T scalar)
    if(op == "+" || op == "-" || op == "*" || op == "/") {
		return Vector3D!T(mixin("x "~op~" scalar"), mixin("y "~op~" scalar"), mixin("z "~op~" scalar"));
    }

    void opOpAssign(string op)(T scalar) {
        mixin("vec" ~ op ~ "=[scalar,scalar,scalar,0];");
    }
    
    void opOpAssign(string op)(Vector3D!(T) vector) {
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

    bool opEquals(Vector3D!(T) rhs) {
		static if (DigitalMars || GDC) {
			return (vec == rhs.vec);
		}
		else {
			return (vec.array == rhs.vec.array);
		}
    }

	bool equals(Vector3D!(T) other, double tolerance = 1e-05)
	{
		import std.math : approxEqual;
		return approxEqual(x, other.x, tolerance) &&
		approxEqual(y, other.y, tolerance) &&
		approxEqual(z, other.z, tolerance);
	}
	
    Vector3D!(T) set(T nx, T ny, T nz) {
		vec = [nx, ny, nz, 0];
		return this;
	}

	Vector3D!(T) set(Vector3D!(T) other) {
		vec = other.vec;
		return this;
	}

   
    @property {
		 /** Very slow! */
		T length() {
			return cast(T)(SQRT(cast(float)lengthSQ));
		}
		
		/** Very slow! */
		T lengthSQ() {
			static if (DigitalMars || GDC) {
				return cast(T)(vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2]);
			}

			else {
				return cast(T)(vec.array[0]*vec.array[0] + vec.array[1]*vec.array[1] + vec.array[2]*vec.array[2]);
			}
		}

		Vector3D!(T) normalize() {
	        auto length = cast(T)(length);
	        static if (is (T == float))
	            float4 mul = [length, length, length, 0];
			else static if (is (T == double))
	            double4 mul = [length, length, length, 0];
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
	
	        return Vector3D!(T)(vec);
	    }
	
	    Vector3D!(T) length(T newlength) {
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
	        else static if (is (T == double)) {
				double4 vec2 = [newlength, newlength, newlength, 0];
			}
			
	        else {
	            int4 vec2 = [newlength, newlength, newlength, 0];
	        }
	
	        return Vector3D!(T)(vec);
	    }
	}
	
	/** Extremely slow! */
	T dot(Vector3D!(T) other) {
		static if (DigitalMars || GDC) {
			return cast(T)(vec[0]*other.vec[0] + vec[1]*other.vec[1] + vec[2]*other.vec[2]);
		}

		else {
			return cast(T)(vec.array[0]*other.vec.array[0] + vec.array[1]*other.vec.array[1] + vec.array[2]*other.vec.array[2]);
		}
	}

    T distanceFrom(Vector3D!(T) other) {
        static if (DigitalMars || GDC) {
            float4 arr;
            for (int i = 0; i < 4; i++) {
                arr = vec[i] - other.vec[i];
            }

            return Vector3D!(T)(arr).length;
        }

        else {
            return Vector3D!(T)(vec - other.vec).length;
        }

    }

    T distanceFromSQ(Vector3D!(T) other) {
        static if (DigitalMars || GDC) {
            float4 arr;
            foreach(i; 0..4) {
                arr = vec[i] - other.vec[i];
            }

            return Vector3D!(T)(arr).lengthSQ;
        }

        else {
            return Vector3D!(T)(vec - other.vec).lengthSQ;
        }

    }

    Vector3D!(T) cross(Vector3D!(T) p) {
        return Vector3D!(T)(vec);
    }

    bool isBetweenPoints(Vector3D!(T) begin, Vector3D!(T) end) {
        return true;
        //const T f = (end - begin).getLengthSQ();
        //return getDistanceFromSQ(begin) <= f && getDistanceFromSQ(end) <= f;
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

	/** get the SIMD vector */
	static if (is (T == float)) {
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
	}

	static if (is (T == double)) {
		static if (DigitalMars || GDC) {
			@property double4 vecSIMD() {
				return cast(double[4])vec;
			}
		}

		else {
			@property double4 vecSIMD() {
				return vec;
			}
		}
	}
	
	else {
		static if (DigitalMars || GDC) {
			@property int4 vecSIMD() {
				return cast(int[4])vec;
			}
		}

		else {
			@property int4 vecSIMD() {
				return vec;
			}
		}
	}
	
    /// internal use only
    static if (is (T == float)) {
    	@property irr_vector3df ptr() {
    		return irr_vector3df(x,y,z);
    	}
    }

    else static if (is (T == double)) {
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
    else static if (is (T == double))
		double4 vec;
	else
        int4 vec;

    /** Padding for correctly passing vectors into function on x86*/
    static if (LDC)
        void* padding[12];
}

alias vector3df = Vector3D!(float);
alias vector3di = Vector3D!(int);

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
