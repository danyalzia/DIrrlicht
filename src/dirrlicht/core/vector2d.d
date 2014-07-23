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

import dirrlicht.compileconfig;
import dirrlicht.core.dimension2d;
import std.traits;

/+++
 + 2d vector template class with lots of operators and methods.
 +/
pure nothrow struct Vector2D(T) if(isNumeric!(T) && (is (T == uint) || is (T == int) || is (T == float) || is (T == double))) {
	/// Constructor with two different values
	this(T x, T y) {
		this.x = x;
		this.y = y;
	}

	/// Constructor with the same value for both members
	this(T n) {
		this.x = n;
		this.y = n;
	}

	/// Copy constructor
	this(ref const Vector2D!(T) other) {
		x = cast(T)other.x;
		y = cast(T)other.y;
	}

	this(ref const Dimension2D!T other) {
		x = other.Width;
		y = other.Height;
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

	Vector2D!(T) opUnary(string op)() const
	if (op == "-") {
		return Vector2D!(-x, -y);
	}

	Vector2D!(T) opBinary(string op)(ref const Vector2D!(T) rhs) const {
    	mixin("return Vector2D!(T)(x" ~op~ "cast(T)rhs.x, y" ~op~ "cast(T)rhs.y);");
    }

	Vector2D!(T) opBinary(string op)(ref const Dimension2D!(T) rhs) const {
    	mixin("return Vector2D!(T)(x" ~op~ "cast(T)rhs.Width, y" ~op~ "cast(T)rhs.Height);");
    }
    
    Vector2D!(T) opBinary(string op)(const T scalar) const {
		mixin("return Vector2D!(T)(x" ~op~ "cast(T)scalar, y" ~op~ "cast(T)scalar);");
    }

    Vector2D!(T) opOpAssign(string op)(const T scalar) {
        mixin("x" ~ op ~ "=scalar;");
        mixin("y" ~ op ~ "=scalar;");
        return this;
    }
    
    Vector2D!(T) opOpAssign(string op)(ref const Vector2D!(T) rhs) {
        mixin("x" ~ op ~ "=rhs.x;");
        mixin("y" ~ op ~ "=rhs.y;");
        return this;
    }

    Vector2D!(T) opOpAssign(string op)(ref const Dimension2D!(T) rhs) {
        mixin("x" ~ op ~ "=rhs.Width;");
        mixin("y" ~ op ~ "=rhs.Height;");
        return this;
    }

	/// sort in order X, Y. Equality with rounding tolerance.
	int opCmp(ref const Vector2D!T other) const {
		if ((x<other.x && x != other.x) ||
			(x != other.x && y<other.y && y != other.y)) {
			return -1;
		}
		
		if ((x>other.x && x != other.x) ||
			(x == other.x && y>other.y && y != other.y)) {
			return 1;
		}

		return 0;
	}

	bool opEquals(Vector2D!(T) rhs) const {
    	return (x == cast(T)rhs.x, y == cast(T)rhs.y);
    }
    
    bool opEquals(ref const Vector2D!(T) rhs) const {
    	return (x == cast(T)rhs.x, y == cast(T)rhs.y);
    }
	
	/***
	 * Checks if this vector equals ther other one.
	 *	Takes floating point rounding errors into account.
	 *	Params:
	 *	other = Vector to compare with.
	 *
	 *   Returns: True if the two vector are (almost) equal, else false.
	 */
	bool equals(ref const Vector2D!(T) other) const {
		return x == other.x && y == other.y;
	}

    Vector2D!(T) set(T nx, T ny) {
		x = nx;
		y = ny;
		return this;
	}

	Vector2D!(T) set(ref const Vector2D!(T) other) {
		x = cast(T)other.x;
		y = cast(T)other.y;
		return this;
	}

	private enum RADTODEG64 = 57.2957795;
	
    @property {
		/***
		 * Gets the length of the vector.
		 *	Returns: The length of the vector.
		 */
		T length() const {
			import std.math, std.conv;
			return cast(T)sqrt(cast(float)(x*x + y*y));
		}
	
		/***
		 * Get the squared length of this vector
		 *	This is useful vecause it is much faster than getLength().
		 *	Returns: The squared length of the vector.
		 */
		T lengthSQ() const {
			import std.math;
			return x*x + y*y;
		}
	
		/***
		 * Calculates the angle of this vector in degrees in the trigonometric sense.
		 * 0 is to the right (3 o'clock), values increase counter-clockwise.
		 * This method has been suggested by Pr3t3nd3r.
		 * Returns: a value between 0 and 360.
		 */
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
	
		/***
		 * Calculates the angle or this vector in degrees in the counter trigonometric sense.
		 * 0 is to the right (3 o'clock), values increase clockwise.
		 * Returns: a value between 0 and 360.
		 */
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
	
		/***
		 * Normalize the vector
		 * The null vector is left untouched.
		 * Returns: Reference to this vector, after normalization.
		 */
		ref Vector2D!(T) normalize() {
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
	
	/***
	 * Get the dot product of this vector with another.
	 *	Params: 
	 *	other = Other vector to take dot product with.
	 *
	 *	Returns: The dot product of the two vectors.
	 */
	T dot(ref const Vector2D!(T) other) const {
		return x*other.x + y*other.y;
	}

	/// ditto
	T dot(Vector2D!(T) other) const {
		return dot(other);
	}
	
	/***
	 * Gets distance from another point.
	 * Here, the vector is interpreted as a point in 2-dimensional space.
	 * Params:
	 * other = Other vector to measure from.
	 *
	 * Returns: Distance from other point.
	 */
	T distanceFrom(ref const Vector2D!(T) other) const {
		return Vector2D!(T)(x - other.x, y - other.y).length;
	}
	
	/***
	 * Returns squared distance from another point
	 * Here, the vector is interpreted as a pint in 2-dimensional space.
	 * Params:
	 * other = Other vector to measure from.
	 *
	 * Returns: Squared distance from other point.
	 */
	T distanceFromSQ(ref const Vector2D!(T) other) const {
		return Vector2D!(T)(x - other.x, y - other.y).lengthSQ;
	}
	
	/***
	 * Rotates the point anticlockwise around a center by an amount of degrees.
	 * Params:
	 * degrees = Amount of degrees to rotate by, anticlockwise.
	 * center = center
	 *
	 * Returns: This vector after transformation.
	 */
	Vector2D!(T) rotateBy(double degrees, ref const Vector2D!(T) center) {
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

	/// ditto
	Vector2D!(T) rotateBy(double degrees, Vector2D!(T) center) {
		return rotateBy(degrees, center);
	}
	
	/***
	 * Calculates the angle between this vector and antoer one in degree.
	 * Params:
	 * b = Other vector to test with.
	 * 
	 * Returns: a value between 0 and 90.
	 */
	double getAngleWith(ref const Vector2D!(T) b) const {
		import std.math : sqrt, atan, PI;
		double tmp = cast(double)(x*b.x + y*b.y);

		if (tmp == 0.0)
			return 90.0;

		tmp = tmp / sqrt(cast(double)((x*x + y*y) * (b.x*b.x + b.y*b.y)));
		if (tmp < 0.0)
			tmp = -tmp;
		if ( tmp > 1.0 )
			tmp = 1.0;

		return atan(sqrt(1 - tmp*tmp) / tmp) * RADTODEG64;
	}
	
	/***
	 * Returns if this vector interpreted as a poin is on a line between two other points.
	 * It is assumed that the point is on the line
	 * Params:
	 * begin = Beginning vector to compare between.
	 * end = Ending vector to compare between.
	 * Returns: True if this vector is between begin and end, false if not.
	 */
	bool isBetweenPoints(ref const Vector2D!(T) begin, ref const Vector2D!(T) end) const {
		if (begin.x != end.y)	{
			return ((begin.x <= x && x <= end.x) ||
				(begin.x >= x && x >= end.x));
		}
		else {
			return ((begin.y <= y && y <= end.y) ||
				(begin.y >= y && y >= end.y));
		}
	}
	
	/***
	 * Creates an interpolated vector between this vector and another vector.
	 * Params: 
	 *  other = The other vector to interpolate with.
	 *  d = Interpolation value between 0.0f (all the other vector) and 1.0f (all this vector).
	 * 
	 * Note that this is the opposite direction of interpolation to getInterpolated_quadratic()
	 *
	 * Returns: An interpolated vector.  This vector is not modified. 
	 */
	Vector2D!(T) getInterpolated(ref const Vector2D!(T) other, double d) const {
		double inv = 1.0f - d;
		return Vector2D!(T)(cast(T)(other.x*inv + x*d), cast(T)(other.y*inv + x*d));
	}
	
	/***
	 * Creates a quadratically interpolated vector between this and two other vectors.
	 * Params: 
	 *  v2 = Second vector to interpolate with.
	 *  v3 = Third vector to interpolate with (maximum at 1.0f)
	 *  d = Interpolation value between 0.0f (all this vector) and 1.0f (all the 3rd vector).
	 * 
	 * Note that this is the opposite direction of interpolation to getInterpolated() and interpolate()
	 * Returns: An interpolated vector. This vector is not modified. 
	 */
	Vector2D!(T) getInterpolated_quadratic(ref const Vector2D!(T) v2, ref const Vector2D!(T) v3, double d) const {
			const double inv = 1.0f - d;
			const double mul0 = inv * inv;
			const double mul1 = 2.0f * d * inv;
			const double mul2 = d * d;
	
			return Vector2D!(T)(cast(T)(x * mul0 + v2.x * mul1 + v3.x * mul2),
						cast(T)(y * mul0 + v2.y * mul1 + v3.y * mul2));
	}
	
	/***
	 *  Sets this vector to the linearly interpolated vector between a and b.
	 * Params:
	 * a = first vector to interpolate with, maximum at 1.0f
	 * b = second vector to interpolate with, maximum at 0.0f
	 * d = Interpolation value between 0.0f (all vector b) and 1.0f (all vector a)
	 *
	 * Note that this is the opposite direction of interpolation to getInterpolated_quadratic()
	 */
    Vector2D!(T) interpolate(ref const Vector2D!(T) a, ref const Vector2D!(T) b, double d) {
		x = cast(T)(cast(double)b.x + ( ( a.x - b.x ) * d ));
		y = cast(T)(cast(double)b.y + ( ( a.y - b.y ) * d ));
		return this;
	}

	Vector2D!(T) opBinaryRight(string op)(const T scalar) const
	if(op == "*") {
		return this*scalar;
	}

	/// X coordinate of vector;
    T x;
    
    /// Y coordinate of vector;
    T y;
}

alias vector2df = Vector2D!(float);
alias vector2di = Vector2D!(int);

/// vector2d example
unittest {
	mixin(Core_TestBegin);
	
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
    pure nothrow squareVec(T)(immutable Vector2D!(T) a, immutable Vector2D!(T) b) {
		import std.algorithm;
		return Vector2D!(T)(a + b);
	}

	import std.stdio;
	squareVec(vector2df(4,4), vector2df(4,4)).writeln;

	mixin(Core_TestEnd);
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
