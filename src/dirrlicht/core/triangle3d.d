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

module dirrlicht.core.triangle3d;

import dirrlicht.core.simdmath;
import dirrlicht.core.vector3d;

import std.traits;

pure nothrow @safe struct Triangle3D(T) if(isNumeric!(T) && (is (T == int) || is (T == float))) {
    /// Constructor for triangle with given three vertices
	this(Vector3D!(T) v1, Vector3D!(T) v2, Vector3D!(T) v3) {
		pointA = v1;
		pointB = v2;
		pointC = v3;
	}

	/// Equality operator
	bool opEqual()(auto ref const triangle3d!T other) {
		return other.pointA==pointA && other.pointB==pointB && other.pointC==pointC;
	}
	
	/***
	 * Determines if the triangle is totally inside a bounding box.
	 * Params:
	 * 			box=  Box to check.
	 * Returns: True if triangle is within the box, otherwise false. 
	 */
	bool isTotalInsideBox()(auto ref const aabbox3d!T box) const {
		return (box.isPointInside(pointA) &&
			box.isPointInside(pointB) &&
			box.isPointInside(pointC));
	}

	/// Determines if the triangle is totally outside a bounding box.
	/**
	* Params:
	* box=  Box to check.
	* Returns: True if triangle is outside the box, otherwise false. 
	*/
	bool isTotalOutsideBox()(AABBox3D!(T) box) {
		return ((pointA.x > box.MaxEdge.x && pointB.x > box.MaxEdge.x && pointC.x > box.MaxEdge.x) ||
			(pointA.y > box.MaxEdge.y && pointB.y > box.MaxEdge.y && pointC.y > box.MaxEdge.y) ||
			(pointA.z > box.MaxEdge.z && pointB.z > box.MaxEdge.z && pointC.z > box.MaxEdge.z) ||
			(pointA.x < box.MinEdge.x && pointB.x < box.MinEdge.x && pointC.x < box.MinEdge.x) ||
			(pointA.y < box.MinEdge.y && pointB.y < box.MinEdge.y && pointC.y < box.MinEdge.y) ||
			(pointA.z < box.MinEdge.z && pointB.z < box.MinEdge.z && pointC.z < box.MinEdge.z));
	}

	/***
	 * Get the closest point on a triangle to a point on the same plane.
	 * Params:
	 * 	p=  Point which must be on the same plane as the triangle.
	 * Returns: The closest point of the triangle 
	 */
	Vector3D!(T) closestPointOnTriangle()(Vector3D!(T) p) {
		immutable Vector3D!(T) rab = line3d!T(pointA, pointB).getClosestPoint(p);
		immutable Vector3D!(T) rbc = line3d!T(pointB, pointC).getClosestPoint(p);
		immutable Vector3D!(T) rca = line3d!T(pointC, pointA).getClosestPoint(p);

		immutable T d1 = rab.getDistanceFrom(p);
		immutable T d2 = rbc.getDistanceFrom(p);
		immutable T d3 = rca.getDistanceFrom(p);

		if (d1 < d2)
			return d1 < d3 ? rab : rca;

		return d2 < d3 ? rbc : rca;
	}

	/***
	 * Check if a point is inside the triangle (border-points count also as inside)
	 *
	 * Params:
	 *  p Point to test. Assumes that this point is already
	 * on the plane of the triangle.
	 * Return: True if the point is inside the triangle, otherwise false.
	 */
	bool isPointInside()(Vector3D!(T) p) {
		immutable af64 = vector3d!double(cast(double)pointA.x, cast(double)pointA.y, cast(double)pointA.z);
		immutable bf64 = vector3d!double(cast(double)pointB.x, cast(double)pointB.y, cast(double)pointB.z);
		immutable cf64 = vector3d!double(cast(double)pointC.x, cast(double)pointC.y, cast(double)pointC.z);
		immutable pf64 = vector3d!double(cast(double)p.x, cast(double)p.y, cast(double)p.z);
		return (isOnSameSide(pf64, af64, bf64, cf64) &&
				isOnSameSide(pf64, bf64, af64, cf64) &&
				isOnSameSide(pf64, cf64, af64, bf64));
	}

	/***
	 * Check if a point is inside the triangle (border-points count also as inside)
	 * This method uses a barycentric coordinate system.
	 * It is faster than isPointInside but is more susceptible to floating point rounding
	 * errors. This will especially be noticable when the FPU is in single precision mode
	 * (which is for example set on default by Direct3D).
	 * Params:
	 * 	p=  Point to test. Assumes that this point is already
	 * on the plane of the triangle.
	 * Returns: True if point is inside the triangle, otherwise false. 
	 */
	bool isPointInsideFast()(Vector3D!(T) p) {
		immutable Vector3D!(T) a = pointC - pointA;
		immutable Vector3D!(T) b = pointB - pointA;
		immutable Vector3D!(T) c = p - pointA;

		immutable double dotAA = a.dotProduct( a);
		immutable double dotAB = a.dotProduct( b);
		immutable double dotAC = a.dotProduct( c);
		immutable double dotBB = b.dotProduct( b);
		immutable double dotBC = b.dotProduct( c);

		// get coordinates in barycentric coordinate system
		immutable double invDenom =  1/(dotAA * dotBB - dotAB * dotAB);
		immutable double u = (dotBB * dotAC - dotAB * dotBC) * invDenom;
		immutable double v = (dotAA * dotBC - dotAB * dotAC ) * invDenom;

		// We count border-points as inside to keep downward compatibility.
		// Rounding-error also needed for some test-cases.
		return (u > -float.epsilon) && (v >= 0) && (u + v < 1+float.epsilon);
	}


	/***
	 * Get an intersection with a 3d line.
	 * Params:
	 * 	line=  Line to intersect with.
	 * 	outIntersection=  Place to store the intersection point, if there is one.
	 * Returns: True if there was an intersection, false if not. 
	 */
	bool getIntersectionWithLimitedLine()(Line3D!(T) line,
		out Vector3D!(T) outIntersection) {
		return getIntersectionWithLine(line.start,
			line.getVector(), outIntersection) &&
			outIntersection.isBetweenPoints(line.start, line.end);
	}


	/***
	 * Get an intersection with a 3d line.
	 * Please note that also points are returned as intersection which
	 * are on the line, but not between the start and end point of the line.
	 * If you want the returned point be between start and end
	 * use getIntersectionWithLimitedLine().
	 * Params:
	 * 	linePoint=  Point of the line to intersect with.
	 * 	lineVect=  Vector of the line to intersect with.
	 * 	outIntersection=  Place to store the intersection point, if there is one.
	 * Returns: True if there was an intersection, false if there was not. 
	 */
	bool getIntersectionWithLine()(auto ref const Vector3D!(T) linePoint,
		auto ref const Vector3D!(T) lineVect, out Vector3D!(T) outIntersection) {
		if (getIntersectionOfPlaneWithLine(linePoint, lineVect, outIntersection))
			return isPointInside(outIntersection);

		return false;
	}
	
	/***
	 * Calculates the intersection between a 3d line and the plane the triangle is on.
	 * Params:
	 * 	lineVect=  Vector of the line to intersect with.
	 * 	linePoint=  Point of the line to intersect with.
	 * 	outIntersection=  Place to store the intersection point, if there is one.
	 * Returns: True if there was an intersection, else false. 
	 */
	bool getIntersectionOfPlaneWithLine()(Vector3D!(T) linePoint, Vector3D!(T) lineVect, out Vector3D!(T) outIntersection) {
		// Work with double to get more precise results (makes enough difference to be worth the casts).
		immutable linePointf64 = vector3d!double(linePoint.x, linePoint.y, linePoint.z);
		immutable lineVectf64  = vector3d!double(lineVect.x, lineVect.y, lineVect.z);
		vector3d!double outIntersectionf64;

		auto trianglef64 = triangle3d!double(vector3d!double(cast(double)pointA.x, cast(double)pointA.y, cast(double)pointA.z)
									,vector3d!double(cast(double)pointB.x, cast(double)pointB.y, cast(double)pointB.z)
									, vector3d!double(cast(double)pointC.x, cast(double)pointC.y, cast(double)pointC.z));
		immutable vector3d!double normalf64 = trianglef64.getNormal().normalize();
		double t2;

		if ( iszero( t2 = normalf64.dotProduct(lineVectf64) ) )
			return false;

		double d = trianglef64.pointA.dotProduct(normalf64);
		double t = -(normalf64.dotProduct(linePointf64) - d) / t2;
		outIntersectionf64 = linePointf64 + (lineVectf64 * t);

		outIntersection.x = cast(T)outIntersectionf64.x;
		outIntersection.y = cast(T)outIntersectionf64.y;
		outIntersection.z = cast(T)outIntersectionf64.z;
		return true;
	}

	/***
	 * Get the normal of the triangle.
	 * Please note: The normal is not always normalized. 
	 */
	Vector3D!(T) getNormal() const {
		return (pointB - pointA).crossProduct(pointC - pointA);
	}
	
	/***
	 * Test if the triangle would be front or backfacing from any point.
	 * Thus, this method assumes a camera position from which the
	 * triangle is definitely visible when looking at the given direction.
	 * Do not use this method with points as it will give wrong results!
	 * Params:
	 * 	lookDirection=  Look direction.
	 * Returns: True if the plane is front facing and false if it is backfacing. 
	 */
	bool isFrontFacing()(Vector3D!(T) lookDirection) {
		immutable Vector3D!(T) n = getNormal().normalize();
		immutable float d = cast(float)n.dotProduct(lookDirection);
		return F32_LOWER_EQUAL_0(d);
	}

	/// Get the plane of this triangle.
	Plane3D!(T) getPlane() {
		return plane3d!T(pointA, pointB, pointC);
	}

	/// Get the area of the triangle
	double getArea() {
		return (pointB - pointA).crossProduct(pointC - pointA).getLength() * 0.5;
	}

	/// sets the triangle's points
	void set()(Vector3D!(T) a, Vector3D!(T) b, Vector3D!(T) c) {
		pointA = a;
		pointB = b;
		pointC = c;
	}

	/// the first point of the triangle
	Vector3D!(T) pointA;
	/// the second point of the triangle
	Vector3D!(T) pointB;
	/// the third point of the triangle
	Vector3D!(T) pointC;

	// Using double instead of !T to avoid integer overflows when T=int (maybe also less floating point troubles).
	private bool isOnSameSide()(Vector3D!(double) p1, Vector3D!(double) p2, Vector3D!(double) a, Vector3D!(double) b) {
		Vector3D!double bminusa = b - a;
		Vector3D!double cp1 = bminusa.crossProduct(p1 - a);
		Vector3D!double cp2 = bminusa.crossProduct(p2 - a);
		double res = cp1.dotProduct(cp2);
		if ( res < 0 )
		{
			// This catches some floating point troubles.
			// Unfortunately slightly expensive and we don't really know the best epsilon for iszero.
			vector3d!double cp1 = bminusa.normalize().crossProduct((p1 - a).normalize());
			if ( 	iszero(cp1.x, cast(double)float.epsilon)
				&& 	iszero(cp1.y, cast(double)float.epsilon)
				&& 	iszero(cp1.z, cast(double)float.epsilon) )
			{
				res = 0.f;
			}
		}
		return (res >= 0.0f);
	}
}

package extern (C):

struct irr_triangle3di {
    irr_vector3di pointA;
    irr_vector3di pointB;
    irr_vector3di pointC;
}

struct irr_triangle3df {
    irr_vector3df pointA;
    irr_vector3df pointB;
    irr_vector3df pointC;
}
