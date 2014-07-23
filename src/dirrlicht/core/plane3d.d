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

import dirrlicht.compileconfig;
import dirrlicht.core.vector3d;
import dirrlicht.core.simdmath;

import std.traits;

/// Enumeration for intersection relations of 3d objects
enum EIntersectionRelation3D
{
	ISREL3D_FRONT = 0,
	ISREL3D_BACK,
	ISREL3D_PLANAR,
	ISREL3D_SPANNING,
	ISREL3D_CLIPPED
}

/+++
 + Template plane class with some intersection testing methods.
 + It has to be ensured, that the normal is always normalized. The constructors
 + and setters of this class will not ensure this automatically. So any normal
 + passed in has to be normalized in advance. No change to the normal will be
 + made by any of the class methods.
 +/
pure nothrow struct Plane3D(T) if(isNumeric!(T) && (is (T == int) || is (T == float))) {
    this(Vector3D!(T) MPoint, Vector3D!(T) Normal) {
		this.Normal = Normal;
		recalculateD(MPoint);
	}

	this(T px, T py, T pz, T nx, T ny, T nz) {
		Normal = Vector3D!(T)(nx, ny, nz);
		recalculateD(Vector3D!(T)(px, py, pz));
	}

	this(Vector3D!(T) normal, const T d) {
		Normal = normal;
		D = d;
	}

	this(Vector3D!(T) point1, Vector3D!(T) point2, Vector3D!(T) point3) {
		setPlane(point1, point2, point3);
	}

	bool opEqual(Plane3D!(T) other) {
		import std.math : approxEqual;
		return approxEqual(D, other.D) && Normal == other.Normal;
	}

	void setPlane(Vector3D!(T) point, Vector3D!(T) nvector) {
		Normal = nvector;
		recalculateD(point);
	}

	void setPlane(Vector3D!(T) nvect, T d) {
		Normal = nvect;
		D = d;
	}

	void setPlane(Vector3D!(T) point1, Vector3D!(T) point2, Vector3D!(T) point3) {
		// creates the plane from 3 memberpoints
		Normal = (point2 - point1).cross(point3 - point1);
		Normal.normalize();

		recalculateD(point1);
	}
	
	/***
	 * Get an intersection with a 3d line.
	 * Params:
	 * lineVect = Vector of the line to intersect with.
	 * linePoint = Point of the line to intersect with.
	 * outIntersection = Place to store the intersection point, if there is one.
	 * 
	 * Returns: true if there was an intersection, false if there was not.
	 */
	bool getIntersectionWithLine(Vector3D!(T) linePoint, Vector3D!(T) lineVect, out Vector3D!(T) outIntersection) {
		T t2 = Normal.dot(lineVect);

		if (t2 == 0)
			return false;

		T t = -(Normal.dot(linePoint) + D) / t2;
		outIntersection = linePoint + (lineVect * t);
		return true;
	}
	
	/***
	 * Get percentage of line between two points where an intersection with this plane happens.
	 * Only useful if known that there is an intersection.
	 * Params:
	 * linePoint1 = Point1 of the line to intersect with.
	 * linePoint2 = Point2 of the line to intersect with.
	 *
	 * Returns: Where on a line between two points an intersection with this plane happened.
	 * For example, 0.5 is returned if the intersection happened exactly in the middle of the two points.
	 */
	float getKnownIntersectionWithLine(Vector3D!(T) linePoint1,
		Vector3D!(T) linePoint2) {
		Vector3D!(T) vect = linePoint2 - linePoint1;
		float t2 = cast(float)Normal.dot(vect);
		return cast(float)-((Normal.dot(linePoint1) +D) / t2);
	}
	
	/***
	 * Get an intersection with a 3d line, limited between two 3d points.
	 * Params:
	 * linePoint1 = Point 1 of the line.
	 * linePoint2 = Point 2 of the line.
	 * outIntersection = Place to store the intersection point, if there is one.
	 *
	 * Returns: True if there was an intersection, false if there was not.
	 */
	bool getIntersectionWithLimitedLine(U : T)(
		vector3d!U linePoint1,
		vector3d!U linePoint2,
		out vector3d!U outIntersection) {
		return (getIntersectionWithLine(linePoint1, linePoint2 - linePoint1, outIntersection) && 
			outIntersection.isBetweenPoints(linePoint1, linePoint2));
	}

	/***
	 * Classifies the relation of a point to this plane.
	 * Params:
	 * point = Point to classify its relation.
	 *
	 * Returns: ISREL3D_FRONT if the point is in front of the plane,
	 * ISREL3D_BACK if the point is behind of the plane, and
	 * ISREL3D_PLANAR if the point is within the plane. 
	 */
	EIntersectionRelation3D classifyPointRelation(Vector3D!(T) point) {
		immutable T d = Normal.dot(point) + D;

		if (d < -float.epsilon)
			return EIntersectionRelation3D.ISREL3D_BACK;

		if (d > float.epsilon)
			return EIntersectionRelation3D.ISREL3D_FRONT;

		return EIntersectionRelation3D.ISREL3D_PLANAR;
	}

	/// Recalculates the distance from origin by applying a new member point to the plane.
	void recalculateD(Vector3D!(T) MPoint) {
		D = - MPoint.dot(Normal);
	}

	/// Gets a member point of the plane.
	Vector3D!(T) getMemberPoint() {
		return Normal * -D;
	}

	/***
	 * Tests if there is an intersection with the other plane
	 * Returns: True if there is a intersection. 
	 */
	bool existsIntersection(Plane3D!(T) other) {
		Vector3D!(T) cross = other.Normal.cross(Normal);
		return cross.length > float.epsilon;
	}
	
	/***
	 * Intersects this plane with another.
	 * Params:
	 * other = Other plane to intersect with.
	 * outLinePoint = Base point of intersection line.
	 * outLineVect = Vector of intersection.
	 * Returns: True if there is a intersection, false if not. 
	 */
	bool getIntersectionWithPlane()(Plane3D!(T) other,
		out Vector3D!(T) outLinePoint,
		out Vector3D!(T) outLineVect) {
		import std.math : fabs;
		
		immutable T fn00 = Normal.length;
		immutable T fn01 = Normal.dot(other.Normal);
		immutable T fn11 = other.Normal.length;
		immutable double det = fn00*fn11 - fn01*fn01;

		if (fabs(det) < double.epsilon )
			return false;

		immutable double invdet = 1.0 / det;
		immutable double fc0 = (fn11*-D + fn01*other.D) * invdet;
		immutable double fc1 = (fn00*-other.D + fn01*D) * invdet;

		outLineVect = Normal.cross(other.Normal);
		outLinePoint = Normal*cast(T)fc0 + other.Normal*cast(T)fc1;
		return true;
	}

	/// Get the intersection point with two other planes if there is one.
	bool getIntersectionWithPlanes(Plane3D!(T) o1,
		Plane3D!(T) o2,
		out Vector3D!(T) outPoint) {
		Vector3D!(T) linePoint, lineVect;
		if (getIntersectionWithPlane(o1, linePoint, lineVect))
			return o2.getIntersectionWithLine(linePoint, lineVect, outPoint);

		return false;
	}
	
	/***
	 * Test if the triangle would be front or backfacing from any point.
	 * Thus, this method assumes a camera position from
	 * which the triangle is definitely visible when looking into
	 * the given direction.
	 * Note that this only works if the normal is Normalized.
	 * Do not use this method with points as it will give wrong results!
	 * Params:
	 * lookDirection = Look direction.
	 * Returns: True if the plane is front facing and
	 * false if it is backfacing. 
	 */
	bool isFrontFacing(Vector3D!(T) lookDirection) {
		immutable float d = Normal.dot(lookDirection);
		return F32_LOWER_EQUAL_0( d );
	}

	/***
	 * Get the distance to a point.
	 * Note: that this only works if the normal is normalized. 
	 */
	T getDistanceTo(Vector3D!(T) point) {
		return point.dot(Normal) + D;
	}

	 @property {
		static if (is(T == int)) {
			irr_plane3di ptr() {
				return irr_plane3di(irr_vector3di(Normal.x, Normal.y, Normal.z), D);
			}
			alias ptr this;
		}
		else {
			irr_plane3df ptr() {
				return irr_plane3df(irr_vector3df(Normal.x, Normal.y, Normal.z), D);
			}
			alias ptr this;
		}
	}
	
	/// Normal vector of the plane
	Vector3D!(T) Normal;

	/// Distance from origin
	T D;
}

alias plane3df = Plane3D!(float);
alias plane3di = Plane3D!(int);

unittest {
	mixin(Core_TestBegin);

	mixin(Core_TestEnd);
}

extern (C):

struct irr_plane3di {
	irr_vector3di Normal;
	int D;
}

struct irr_plane3df {
	irr_vector3df Normal;
	float D;
}
