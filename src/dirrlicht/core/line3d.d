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

module dirrlicht.core.line3d;

import dirrlicht.core.vector3d;

import std.math;
import std.traits;

/+++
 + 3D line between two points with intersection methods.
 +/
pure nothrow @safe struct Line3D(T) if(isNumeric!(T) && (is (T == int) || is (T == float))) {
    this(T xa, T ya, T za, T xb, T yb, T zb) {
        start = Vector3D!(T)(xa, ya, za);
        end = Vector3D!(T)(xb, yb, zb);
    }

    this(ref const Vector3D!(T) start, ref const Vector3D!(T) end) {
        this.start = start;
        this.end = end;
    }

	Line3D!(T) opBinary(string op)(ref const Vector3D!(T) point)
	if(op == "+" || op == "-") {
		return line3d!T(mixin("start "~op~" point"), mixin("end "~op~" point"));
	}

	ref Line3D!(T) opOpAssign(string op)(ref const Vector3D!(T) point)
	if(op == "+" || op == "-") {
		mixin("start "~op~"= point;");
		mixin("end "~op~"= point;");
		return this;
	}

	bool opEqual(ref const Line3D!(T) other){
		return (start == other.start && end == other.end) || (end == other.start && start == other.end);
	}

	/// Set this line to a new line going through the two points.
	void setLine(ref const T xa, ref const T ya, ref const T za, ref const T xb, ref const T yb, ref const T zb) {
		start.set(xa, ya, za);
		end.set(xb, yb, zb);
	}

	/// Set this line to a new line going through the two points.
	void setLine(ref const Vector3D!(T) nstart, ref const Vector3D!(T) nend)
	{
		start.set(nstart);
		end.set(nend);
	}

	/// Set this line to new line given as parameter.
	void setLine(ref const Line3D!(T) line) {
		start.set(line.start);
		end.set(line.end);
	}

	@property {
		/***
		 * Get length of line
		 *
		 * Returns: Length of line.
		 */
		T length() const {
			return start.distanceFrom(end);
		}

		/***
		 * Get squared length of line
		 *
		 * Returns: Squared length of line.
		 */
		T lengthSQ() const {
			return start.distanceFromSQ(end);
		}
	}
	
	/***
	 * Get middle of line
	 *
	 * Returns: Center of line.
	 */
	Vector3D!(T) getMiddle() const {
		return (start + end)/cast(T)2;
	}

	/***
	 * Get vector of line
	 *
	 * Returns: vector of line.
	 */
	Vector3D!(T) getVector() const {
		return end - start;
	}

	/***
	 * Check if the give point is between start and end of the line
	 *
	 * Assumes that the point is already somewhere on the line.
	 * Params:
	 * point = Th point to test.
	 *
	 * Returns: True if point is on the line between start and end, else false.
	 */
	bool isPointBetweenStartAndEnd(ref const Vector3D!(T) point) const {
		return point.isBetweenPoints(start, end);
	}

	/***
	 *  Get the closest point on this line to a point
	 *
	 * Params:
	 * point = Th point to compare to
	 * Returns: The nearest point which is part of the line.
	 */
	Vector3D!(T) getClosestPoint(ref const Vector3D!(T) point) const {
		Vector3D!(T) c = point - start;
		Vector3D!(T) v = end - start;
		T d = cast(T)v.length;
		v /= d;
		T t = v.dot(c);

		if (t < cast(T)0.0)
		return start;
		if (t > d)
		return end;

		v *= t;
		return start + v;
	}

	/***
	 * Check if the line intersects with a sphere
	 *
	 * Params:
	 * sorigin = Origin of the shpere.
	 * sradius = Readius of the sphere.
	 * outdistance = The distance to the first inersection point
	 *
	 * Returns: True if there is an intersection.
	 * If there is one, the distance to the first intersection point
	 * is stored in outdistance.
	 */
	bool getIntersectionWithSphere(ref const Vector3D!(T) sorigin, T sradius, ref double outdistance) const {
		immutable Vector3D!(T) q = sorigin - start;
		T c = q.length;
		T v = q.dot(getVector().normalize);
		T d = sradius * sradius - (c*c - v*v);

		if (d < 0.0)
		{
			outdistance = 0.0;
			return false;
		}

		outdistance = v - cast(double)sqrt(cast(double)d);
		return true;
	}

	/// Start point of line
    Vector3D!(T) start;
    /// End point of line
    Vector3D!(T) end;
}

extern (C):

struct irr_line3d;
