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

import std.math;
import std.traits;

/+++
 + 2D line between two points with intersection methods.
 +/
pure nothrow @safe struct Line2D(T) if(isNumeric!(T) && (is (T == int) || is (T == uint) || is (T == float))) {
	/// Constructor for line between the two points.
	this(T xa, T ya, T xb, T yb) {
		start = Vector2D!(T)(xa, xb);
		end = Vector2D!(T)(xb, yb);
	}

	/// Constructor for line between the two points given as vectors.
	this(ref const Vector2D!(T) start, ref const Vector2D!(T) end) {
		this.start = start;
		this.end = end;
	}

	/// Copy constructor.
	this(ref const Line2D!(T) other) {
		start = other.start;
		end = other.end;
	}

	Line2D!(T) opBinary(string op)(ref const Vector2D!(T) point) const
	if(op == "+" || op == "-") {
		return Line2D!(T)(mixin("start"~op~"point"), mixin("end"~op~"point"));
	}

	Line2D!(T) opOpAssign(string op)(ref const Vector2D!(T) point) const
	if(op == "+" || op == "-") {
		mixin("start"~op~"= point;");
		mixin("end"~op~"= point;");
		return this;
	}

	bool opEqual()(ref const Line2D!(T) other) const {
		return (start==other.start && end==other.end) ||
		(end==other.start && start==other.end);
	}

	/// Set this line to new line going through the two points.
	void setLine(ref const T xa, ref const T ya, ref const T xb, ref const T yb) {
		start.set(xa, ya); end.set(xb, yb);
	}

	/// Set this line to new line going through the two points.
	void setLine(ref const Vector2D!(T) nstart, ref const Vector2D!(T) nend) {
		start.set(nstart);
		end.set(nend);
	}

	/// Set this line to new line given as parameter.
	void setLine(ref const Line2D!(T) line) {
		start.set(line.start);
		end.set(line.end);
	}

	/***
	 * Get length of line
	 * Returns: Length of the line.
	 */
	T length() const {
		return start.distanceFrom(end);
	}

	/***
	 * Get squared length of the line
	 * Returns: Squared length of line.
	 */
	T lengthSQ() const {
		return start.distanceFromSQ(end);
	}

	/***
	 * Get middle of the line
	 * Returns: center of the line.
	 */
	Vector2D!(T) getMiddle() const {
		return (start + end)/cast(T)2;
	}

	/***
	 * Get the vector of the line.
	 * Returns: The vector of the line.
	 */
	Vector2D!(T) getVector() const {
		return Vector2D!(T)(end.x - start.x, end.y - start.y);
	}

	/***
	 * Tests if this line intersects with another line.
	 * Params:
	 * l= Other line to test intersection with.
	 * checkOnlySegments= Default is to check intersection between the begin and endpoints.
	 * When set to false the function will check for the first intersection point when extending the lines.
	 * outVec= If there is an intersection, the location of the
	 * intersection will be stored in this vector.
	 * Returns: True if there is an intersection, false if not.
	 */
	bool intersectWith(ref const Line2D!(T) l, ref Vector2D!(T) outVec, bool checkOnlySegments=true) const {
		// Uses the method given at:
		// http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
		immutable float commonDenominator = cast(float)(l.end.y - l.start.y)*(end.x - start.x) -
		(l.end.x - l.start.x)*(end.y - start.y);

		immutable float numeratorA = cast(float)(l.end.x - l.start.x)*(start.y - l.start.y) -
		(l.end.y - l.start.y)*(start.x -l.start.x);

		immutable float numeratorB = cast(float)(end.x - start.x)*(start.y - l.start.y) -
		(end.y - start.y)*(start.x -l.start.x);

		if(approxEqual(commonDenominator, 0.0f))
		{
			// The lines are either coincident or parallel
			// if both numerators are 0, the lines are coincident
			if(approxEqual(numeratorA, 0.0f) && approxEqual(numeratorB, 0.0f))
			{
				// Try and find a common endpoint
				if(l.start == start || l.end == start)
				outVec = start;
				else if(l.end == end || l.start == end)
				outVec = end;
				// now check if the two segments are disjunct
				else if (l.start.x>start.x && l.end.x>start.x && l.start.x>end.x && l.end.x>end.x)
				return false;
				else if (l.start.y>start.y && l.end.y>start.y && l.start.y>end.y && l.end.y>end.y)
				return false;
				else if (l.start.x<start.x && l.end.x<start.x && l.start.x<end.x && l.end.x<end.x)
				return false;
				else if (l.start.y<start.y && l.end.y<start.y && l.start.y<end.y && l.end.y<end.y)
				return false;
				// else the lines are overlapping to some extent
				else {
					// find the points which are not contributing to the
					// common part
					Vector2D!(T) maxp;
					Vector2D!(T) minp;
					if ((start.x>l.start.x && start.x>l.end.x && start.x>end.x) || (start.y>l.start.y && start.y>l.end.y && start.y>end.y))
						maxp=start;
					else if ((end.x>l.start.x && end.x>l.end.x && end.x>start.x) || (end.y>l.start.y && end.y>l.end.y && end.y>start.y))
						maxp=end;
					else if ((l.start.x>start.x && l.start.x>l.end.x && l.start.x>end.x) || (l.start.y>start.y && l.start.y>l.end.y && l.start.y>end.y))
						maxp=l.start;
					else
						maxp=l.end;
					if (maxp != start && ((start.x<l.start.x && start.x<l.end.x && start.x<end.x) || (start.y<l.start.y && start.y<l.end.y && start.y<end.y)))
						minp=start;
					else if (maxp != end && ((end.x<l.start.x && end.x<l.end.x && end.x<start.x) || (end.y<l.start.y && end.y<l.end.y && end.y<start.y)))
						minp=end;
					else if (maxp != l.start && ((l.start.x<start.x && l.start.x<l.end.x && l.start.x<end.x) || (l.start.y<start.y && l.start.y<l.end.y && l.start.y<end.y)))
						minp=l.start;
					else
						minp=l.end;

					// one line is contained in the other. Pick the center
					// of the remaining points, which overlap for sure
					outVec = Vector2D!(T)(0);
					if (start != maxp && start != minp)
						outVec += start;
					if (end != maxp && end != minp)
						outVec += end;
					if (l.start != maxp && l.start != minp)
						outVec += l.start;
					if (l.end != maxp && l.end != minp)
						outVec += l.end;
						
						outVec.x = cast(T)(outVec.x/2.0);
						outVec.y = cast(T)(outVec.y/2.0);
				}

					return true; // coincident
			}

				return false; // parallel
		}

		// Get the point of intersection on this line, checking that
		// it is within the line segment.
		immutable float uA = numeratorA / commonDenominator;
		if(checkOnlySegments && (uA < 0 || uA > 1) )
			return false; // Outside the line segment

		immutable float uB = numeratorB / commonDenominator;
		if(checkOnlySegments && (uB < 0 || uB > 1))
			return false; // Outside the line segment

		// Calculate the intersection point.
		outVec.x = cast(T)(start.x + uA * (end.x - start.x));
		outVec.y = cast(T)(start.y + uA * (end.y - start.y));
		return true;
	}
	
	/***
	 * Get unit vector of the line.
	 * Returns: Unit vector of this line.
	 */
	Vector2D!(T) getUnitVector() const {
		T len = cast(T)(1.0 / length);
		return Vector2D!(T)((end.x - start.x) * len, (end.y - start.y) * len);
	}
	
	/***
	 * Get angle between this line and given line.
	 * Params:
	 * l= Other line for test.
	 * Returns: Angle in degrees.
	 */
	double getAngleWith()(ref const Line2D!(T) l) const {
		Vector2D!(T) vect = getVector();
		Vector2D!(T) vect2 = l.getVector();
		return vect.getAngleWith(vect2);
	}

	/**
	 * Tells us if the given point lies to the left, right, or on the line.
	 * Returns: 0 if the point is on the line
	 * <0 if to the left, or >0 if to the right.
	 */
	T getPointOrientation(ref const Vector2D!(T) point) const {
		return ((end.x - start.x) * (point.y - start.y) -
		(point.x - start.x) * (end.y - start.y));
	}

	/***
	 * Check if the given point is a member of the line
	 * Returns: True if point is between start and end, else false.
	 */
	bool isPointOnLine(ref const Vector2D!(T) point) const {
		T d = getPointOrientation(point);
		return (d == 0 && point.isBetweenPoints(start, end));
	}

	/***
	 * Check if the given point is between start and end of the line.
	 * Assumes that the point is already somewhere on the line.
	 */
	bool isPointBetweenStartAndEnd(ref const Vector2D!(T) point) const {
		return point.isBetweenPoints(start, end);
	}

	/**
	 * Get the closest point on this line to a point
	 * Params:
	 *  point = point
	 *  checkOnlySegments = Default (true) is to return a point on the line-segment (between begin and end) of the line.
	 * When set to false the function will check for the first the closest point on the the line even when outside the segment.
	 */
	Vector2D!(T) getClosestPoint(ref const Vector2D!(T) point, bool checkOnlySegments=true) const {
		auto c = Vector2D!double(cast(double)(point.x-start.x), cast(double)(point.y- start.y));
		auto v = Vector2D!double(cast(double)(end.x-start.x), cast(double)(end.y-start.y));
		double d = v.length;
		if (d == 0)	// can't tell much when the line is just a single point
			return start;
		v /= d;
		double t = v.dot(c);

		if (checkOnlySegments) {
			if (t < 0) return Vector2D!(T)(cast(T)start.x, cast(T)start.y);
			if (t > d) return Vector2D!(T)(cast(T)end.x, cast(T)end.y);
		}

		v *= t;
		return Vector2D!(T)(cast(T)(start.x + v.x), cast(T)(start.y + v.y));
	}

	/// Start point of the line.
	Vector2D!(T) start;
	/// End point of the line.
	Vector2D!(T) end;
}

/// Alias for float line2d
alias line2df = Line2D!float;

/// Alias for int line2d
alias line2di = Line2D!int;

/// Alias for uint line2d
alias line2du = Line2D!uint;

extern (C):

struct irr_line2d;
