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

module dirrlicht.core.vector3d;

import dirrlicht.compileconfig;
import dirrlicht.core.simdmath;
import std.math;
import std.traits;

pure nothrow struct Vector3D(T) if(isNumeric!(T) && (is (T == int) || is (T == float) || is (T == double))) {
    
    this(T x, T y, T z) {
        vec = [x, y, z, 0];
    }

    this(T n) {
        vec = [n, n, n, n];
    }

    this(ref const Vector3D!(T) rhs) {
		vec = cast(T[4])rhs.vec;
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
    
    this(float[4] vec) {
		import std.conv;
		this.vec = cast(typeof(this.vec))vec[0..$];
	}

	this(double[4] vec) {
		this.vec = cast(typeof(this.vec))vec[0..$];
	}
	
	this(int[4] vec) {
		this.vec = cast(typeof(this.vec))vec[0..$];
	}
	
	Vector3D!(T) opUnary(string op)() const
	if (op == "-") {
		return Vector3D!(T)(-x, -y, -z);
	}

	ref Vector3D!(T) opUnary(string op)() const
	if (op == "*") {
		return *this;
	}
	
	Vector3D!(T) opBinary(string op)(ref const Vector3D!(T) rhs) const
	if(op == "+" || op == "-" || op == "*" || op == "/") {
		return Vector3D!T(mixin("x "~op~" rhs.x"), mixin("y "~op~" rhs.y"), mixin("z "~op~" rhs.z"));
    }

	/// ditto
	Vector3D!(T) opBinary(string op)(Vector3D!(T) rhs) const
	if(op == "+" || op == "-" || op == "*" || op == "/") {
		return Vector3D!T(mixin("x "~op~" rhs.x"), mixin("y "~op~" rhs.y"), mixin("z "~op~" rhs.z"));
    }
    
    Vector3D!(T) opBinary(string op)(const T scalar) const
    if(op == "+" || op == "-" || op == "*" || op == "/") {
		return Vector3D!T(mixin("x "~op~" scalar"), mixin("y "~op~" scalar"), mixin("z "~op~" scalar"));
    }

    void opOpAssign(string op)(const T scalar) {
		mixin("vec[0]" ~op~ "=scalar;");
		mixin("vec[1]" ~op~ "=scalar;");
		mixin("vec[2]" ~op~ "=scalar;");
    }
    
    void opOpAssign(string op)(ref const Vector3D!(T) vector) {
		mixin("vec[0]" ~ op ~ "=vector.vec[0];");
		mixin("vec[1]" ~ op ~ "=vector.vec[1];");
		mixin("vec[2]" ~ op ~ "=vector.vec[2];");
    }

	Vector3D!(T) opBinaryRight(string op)(const T scalar) const
	if(op == "*") {
		return Vector3D!T(scalar * x, scalar * y, scalar * z);
	}
	
	/// sort in order X, Y, Z. Equality with rounding tolerance.
	/// Difference must be above rounding tolerance.
	int opCmp(ref const Vector3D!T other) const {
		if ((x<other.x && !approxEqual(x, other.x)) ||
					(approxEqual(x, other.x) && y<other.y && !approxEqual(y, other.y)) ||
					(approxEqual(x, other.x) && approxEqual(y, other.y) && z<other.z && !approxEqual(z, other.z))) {
			return -1;
		}
		else if ((x>other.x && !approxEqual(x, other.x)) ||
					(approxEqual(x, other.x) && y>other.y && !approxEqual(y, other.y)) ||
					(approxEqual(x, other.x) && approxEqual(y, other.y) && z>other.z && !approxEqual(z, other.z))) {
			return 1;
		}
		else
			return 0;
	}
	
    bool opEquals(ref const Vector3D!(T) rhs) const {
		return (vec == rhs.vec);
    }

	bool equals(ref const Vector3D!(T) other, double tolerance = 1e-05) const {
		import std.math : approxEqual;
		return approxEqual(x, other.x, tolerance) &&
		approxEqual(y, other.y, tolerance) &&
		approxEqual(z, other.z, tolerance);
	}
	
    Vector3D!(T) set(const T nx, const T ny, const T nz) {
		vec = [nx, ny, nz, 0];
		return this;
	}

	Vector3D!(T) set(ref const Vector3D!(T) other) {
		vec = other.vec;
		return this;
	}
   
    
	/** Very slow! */
	@property T length() const {
		return cast(T)(SQRT(cast(float)lengthSQ));
	}
	
	/** Very slow! */
	@property T lengthSQ() const {
		return cast(T)(vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2]);
	}

	@property ref Vector3D!(T) normalize() {
        auto length = cast(T)(length);
        static if (is (T == float))
            float[4] mul = [length, length, length, 0];
		else static if (is (T == double))
            double[4] mul = [length, length, length, 0];
        else
            int[4] mul = [length, length, length, 0];

        for (int i = 0; i < 4; i++) {
			vec[i] *= mul[i];
		}
		
        return *this;
    }

    @property ref Vector3D!(T) length(T newlength) {
        normalize();
        static if (is (T == float)) {
            float[4] vec2 = [newlength, newlength, newlength, 0];
        }
        
        else static if (is (T == double)) {
			double[4] vec2 = [newlength, newlength, newlength, 0];
		}
		
        else {
            int[4] vec2 = [newlength, newlength, newlength, 0];
        }

		foreach(i; 0..4) {
			vec[i] *= vec2[i];
		}
		
        return *this;
    }
	
	
	/** Extremely slow! */
	T dot(ref const Vector3D!(T) other) const {
		return cast(T)(vec[0]*other.vec[0] + vec[1]*other.vec[1] + vec[2]*other.vec[2]);
	}

    T distanceFrom(ref const Vector3D!(T) other) const {
        float[4] arr;
		for (int i = 0; i < 4; i++) {
			arr = vec[i] - other.vec[i];
		}

		return Vector3D!(T)(arr).length;
    }

    T distanceFromSQ(ref const Vector3D!(T) other) const {
        float[4] arr;
		foreach(i; 0..4) {
			arr = vec[i] - other.vec[i];
		}
		return Vector3D!(T)(arr).length;
    }

    Vector3D!(T) cross(ref const Vector3D!(T) p) const {
        return Vector3D!T(y * p.z - z * p.y, z * p.x - x * p.z, x * p.y - y * p.x);
    }

	Vector3D!(T) cross(Vector3D!(T) p) const {
        return cross(p);
    }
    
    bool isBetweenPoints(ref const Vector3D!(T) begin, ref const Vector3D!(T) end) const {
        return true;
        //const T f = (end - begin).getLengthSQ();
        //return getDistanceFromSQ(begin) <= f && getDistanceFromSQ(end) <= f;
    }

	@property T x() const { return cast(T)vec[0]; }
	@property T y() const { return cast(T)vec[1]; }
	@property T z() const { return cast(T)vec[2]; }

	@property void x(T n) { vec[0] = n; }
	@property void y(T n) { vec[1] = n; }
	@property void z(T n) { vec[2] = n; }
	
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
        float[4] vec;
    else static if (is (T == double))
		double[4] vec;
	else
        int[4] vec;
}

alias vector3df = Vector3D!(float);
alias vector3di = Vector3D!(int);

/// Vector3D example
unittest {
	mixin(Core_TestBegin);
	
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

    mixin(Core_TestEnd);
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
