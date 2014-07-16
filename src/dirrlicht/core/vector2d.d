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

import std.traits;

pure nothrow @safe struct vector2d(T) if(isNumeric!(T) && (is (T == int) || is (T == float))) {
	@disable this();
	
	this(T x, T y) {
		this.x = x;
		this.y = y;
	}

	this(T n) {
		this.x = n;
		this.y = n;
	}

	this(vector2d!(T) rhs) {
		x = cast(T)rhs.x;
		y = cast(T)rhs.y;
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

	vector2d!(T) opUnary(string op)() const
	if (op == "-") {
		return vector2d!(T)(-x, -y);
	}

	vector2d!(T) opBinary(string op)(vector2d!(T) rhs) const {
    	mixin("return vector2d!(T)(x" ~op~ "cast(T)rhs.x, y" ~op~ "cast(T)rhs.y);");
    }

    vector2d!(T) opBinary(string op)(T scalar) const {
		mixin("return vector2d!(T)(x" ~op~ "cast(T)scalar, y" ~op~ "cast(T)scalar);");
    }

    void opOpAssign(string op)(T scalar) {
        mixin("x" ~ op ~ "=scalar;");
        mixin("y" ~ op ~ "=scalar;");
    }
    
    void opOpAssign(string op)(vector2d rhs) {
        mixin("x" ~ op ~ "=rhs.x;");
        mixin("y" ~ op ~ "=rhs.y;");
    }

    bool opEquals(vector2d rhs) const {
    	return (x == cast(T)rhs.x, y == cast(T)rhs.y);
    }

    vector2d!(T) set(T nx, T ny) {
		x = nx;
		y = ny;
		return this;
	}

	vector2d!(T) set(vector2d!(T) other) {
		x = cast(T)other.x;
		y = cast(T)other.y;
		return this;
	}

	
    @property {
		T length() const {
			import std.math, std.conv;
			return cast(T)sqrt(cast(float)(x*x + y*y));
		}

		T lengthSQ() const {
			import std.math;
			return x*x + y*y;
		}

		double angleTrig() const {
			import std.math;
			if (y == 0)
				return x < 0 ? 180 : 0;
			else
			if (x == 0)
				return y < 0 ? 270 : 90;

			if (y > 0)
				if (x > 0)
					return atan(cast(double)y/cast(double)x) * 180.0/PI;
				else
					return 180.0-atan(cast(double)y/-cast(double)x) * 180.0/PI;
			else
				if (x > 0)
					return 360.0-atan(-cast(double)y/cast(double)x) * 180.0/PI;
				else
					return 180.0+atan(-cast(double)y/-cast(double)x) * 180.0/PI;
		}
		
		double angle() const {
			import std.math, std.algorithm;
			if (x == 0)
				return x < 0 ? 180 : 0;
			else if (x == 0)
				return y < 0 ? 90 : 270;

			auto clamp = (double value, double low, double high) => min(max(value, low), high);
			const double tmp = clamp(y / sqrt(cast(double)(x*x + y*y)), -1.0, 1.0);
			const double angle = atan(sqrt(1 - tmp*tmp) / tmp) * 180.0/PI;

			if (x>0 && y>0)
				return angle + 270;
			else
			if (x>0 && y<0)
				return angle + 90;
			else
			if (x<0 && y<0)
				return 90 - angle;
			else
			if (x<0 && y>0)
				return 270 - angle;

			return angle;
		}
	
		vector2d!(T) normalize() {
			import std.math : sqrt;
			if (length == 0 )
				return this;
			auto tempLength = 1.0 / sqrt(cast(float)length);
			x = cast(T)(x * tempLength);
			y = cast(T)(y * tempLength);
			return this;
		}
		
    	static if (is(T == int)) {
	    	irr_vector2di ptr() {
	    		return irr_vector2di(x,y);
	    	}
	    	alias ptr this;
    	}
    	
    	else {
	    	irr_vector2df ptr() {
	    		return irr_vector2df(x,y);
	    	}
	    	alias ptr this;
    	}
    }

	T dot(vector2d!(T) other) {
		return x*other.x + y*other.y;
	}

	T distanceFrom(vector2d!(T) other) {
		return vector2d!(T)(x - other.x, y - other.y).length;
	}

	T distanceFromSQ(vector2d!(T) other) {
		return vector2d!(T)(x - other.x, y - other.y).lengthSQ;
	}

	vector2d!(T) rotateBy(double degrees, vector2d!(T) center) {
		import std.math : cos, sin, PI;
		degrees *= PI/180;
		const double cs = cos(degrees);
		const double sn = sin(degrees);

		x -= center.x;
		y -= center.y;

		set(cast(T)(x*cs - y*sn), cast(T)(x*sn + y*cs));

		x += center.x;
		y += center.y;
		return this;
	}

	double getAngleWith(vector2d!(T) b) const {
		import std.math : sqrt, atan, PI;
		double tmp = cast(double)(x*b.x + y*b.y);

		if (tmp == 0.0)
			return 90.0;

		tmp = tmp / sqrt(cast(double)((x*x + y*y) * (b.x*b.x + b.y*b.y)));
		if (tmp < 0.0)
			tmp = -tmp;
		if ( tmp > 1.0 )
			tmp = 1.0;

		return atan(sqrt(1 - tmp*tmp) / tmp) * 180.0/PI;
	}
	
	bool isBetweenPoints(vector2d!(T) begin, vector2d!(T) end) const {
		if (begin.x != end.y)	{
			return ((begin.x <= x && x <= end.x) ||
				(begin.x >= x && x >= end.x));
		}
		else {
			return ((begin.y <= y && y <= end.y) ||
				(begin.y >= y && y >= end.y));
		}
	}
	
	vector2d!(T) getInterpolated(vector2d!(T) other, double d) const {
		double inv = 1.0f - d;
		return vector2d!(T)(cast(T)(other.x*inv + x*d), cast(T)(other.y*inv + x*d));
	}
	
	vector2d!(T) getInterpolated_quadratic(vector2d!(T) v2, vector2d!(T) v3, double d) const {
			const double inv = 1.0f - d;
			const double mul0 = inv * inv;
			const double mul1 = 2.0f * d * inv;
			const double mul2 = d * d;
	
			return vector2d!(T)(cast(T)(x * mul0 + v2.x * mul1 + v3.x * mul2),
						cast(T)(y * mul0 + v2.y * mul1 + v3.y * mul2));
	}
	
    vector2d!(T) interpolate(vector2d!(T) a, vector2d!(T) b, double d) {
		x = cast(T)(cast(double)b.x + ( ( a.x - b.x ) * d ));
		y = cast(T)(cast(double)b.y + ( ( a.y - b.y ) * d ));
		return this;
	}
	
    T x, y;
}

alias vector2df = vector2d!(float);
alias vector2di = vector2d!(int);

/// vector2d example
unittest {
    auto veci = vector2di(2, 4);
    assert(veci.x == 2 && veci.y == 4);
	assert(veci == vector2di(2, 4));
	
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
    assert(vecf.x == 2.0 && vecf.y == 4.0);
    assert(vecf == vector2df(2.0, 4.0));

	// Testing pure function calling pure struct
    pure nothrow squareVec(T)(immutable vector2d!(T) a, immutable vector2d!(T) b) {
		import std.algorithm;
		return vector2d!(T)(a + b);
	}

	import std.stdio;
	squareVec(vector2df(4,4), vector2df(4,4)).writeln;

	auto vecs = vector2df(vector2df(2,2));
	auto n = vecs.dot = squareVec(vector2df(4,4), vector2df(4,4));
	n.writeln;

	vecs.rotateBy(64, vector2df(4,4));
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
