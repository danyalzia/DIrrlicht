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

/** Has some useful methods used with occlusion culling or clipping.
*/
module dirrlicht.core.aabbox3d;

import dirrlicht.core.simdmath;
import dirrlicht.core.vector3d;
import dirrlicht.core.line3d;
import std.traits;

pure nothrow @safe struct AABBox3D(T) if(isNumeric!(T) && (is (T == int) || is (T == float))) {
    this(Vector3D!(T) min, Vector3D!(T) max) {
        MinEdge = min;
        MaxEdge = max;
    }

    this(Vector3D!(T) init) {
        MinEdge = init;
        MaxEdge = init;
    }

	this(T minx, T miny, T minz, T maxx, T maxy, T maxz) {
		MinEdge = Vector3D!(T)(minx, miny, minz);
		MaxEdge = Vector3D!(T)(maxx, maxy, maxz);
	}
	
    void opOpAssign(string op)(AABBox3D!(T) rhs) {
        mixin("MinEdge" ~ op ~ "=rhs.MinEdge;");
        mixin("MaxEdge" ~ op ~ "=rhs.MaxEdge;");
    }

    AABBox3D!(T) opBinary(string op)(AABBox3D!(T) rhs)
    if(op == "+" || op == "-" || op == "*" || op == "/") {
    	return new AABBox3D!(T)(mixin("MinEdge" ~op~ "rhs.MinEdge"), mixin("MaxEdge" ~op~ "rhs.MaxEdge")); 
    }
    
    /// internal use only
    @property {
	    static if (is (T == float)) {
	    	irr_aabbox3df ptr() {
	    		return irr_aabbox3df(MinEdge.ptr, MaxEdge.ptr);
	    	}
	    }
	    else {
	    	irr_aabbox3di ptr() {
	    		return irr_aabbox3di(MinEdge.ptr, MaxEdge.ptr);
	    	}
	    }	
    }

    void reset(T x, T y, T z) {
		MaxEdge.set(x,y,z);
		MinEdge = MaxEdge;
	}

	void reset(AABBox3D!(T) initValue) {
		this = initValue;
	}

	void reset(Vector3D!(T) initValue) {
		MaxEdge = initValue;
		MinEdge = initValue;
	}

	void addInternalPoint(Vector3D!(T) p) {
		addInternalPoint(p.x, p.y, p.z);
	}

	void addInternalBox(AABBox3D!(T) b) {
		addInternalPoint(b.MaxEdge);
		addInternalPoint(b.MinEdge);
	}

	void addInternalPoint(T x, T y, T z) {
		if (x>MaxEdge.x) MaxEdge.x = x;
		if (y>MaxEdge.x) MaxEdge.x = y;
		if (z>MaxEdge.x) MaxEdge.x = z;

		if (x<MinEdge.x) MinEdge.x = x;
		if (y<MinEdge.x) MinEdge.y = y;
		if (z<MinEdge.x) MinEdge.z = z;
	}

	//! Get center of the bounding box
	/** \return Center of the bounding box. */
	Vector3D!(T) getCenter() {
		return (MinEdge + MaxEdge) / 2;
	}

	//! Get extent of the box (maximal distance of two points in the box)
	/** \return Extent of the bounding box. */
	Vector3D!(T) getExtent() {
		return MaxEdge - MinEdge;
	}

	//! Get radius of the bounding sphere
	/** \return Radius of the bounding sphere. */
	T getRadius() {
		const T radius = getExtent().length / 2;
		return radius;
	}

	//! Check if the box is empty.
	/** This means that there is no space between the min and max edge.
	\return True if box is empty, else false. */
	bool isEmpty() {
		return MinEdge.equals(MaxEdge);
	}

	//! Get the volume enclosed by the box in cubed units
	T getVolume() {
		Vector3D!(T) e = getExtent();
		return e.x * e.y * e.z;
	}

	//! Get the surface area of the box in squared units
	T getArea() {
		Vector3D!(T) e = getExtent();
		return 2*(e.x*e.y + e.x*e.z + e.y*e.z);
	}

	//! Stores all 8 edges of the box into an array
	/** \param edges: Pointer to array of 8 edges. */
	void getEdges(Vector3D!(T)[8] edges)
	{
		Vector3D!(T) middle = getCenter();
		Vector3D!(T) diag = middle - MaxEdge;

		/*
		Edges are stored in this way:
		Hey, am I an ascii artist, or what? :) niko.
			   /3--------/7
			  / |       / |
			 /  |      /  |
			1---------5   |
			|  /2- - -|- -6
			| /       |  /
			|/        | /
			0---------4/
		*/

		edges[0].set(middle.x + diag.x, middle.y + diag.y, middle.z + diag.z);
		edges[1].set(middle.x + diag.x, middle.y - diag.y, middle.z + diag.z);
		edges[2].set(middle.x + diag.x, middle.y + diag.y, middle.z - diag.z);
		edges[3].set(middle.x + diag.x, middle.y - diag.y, middle.z - diag.z);
		edges[4].set(middle.x - diag.x, middle.y + diag.y, middle.z + diag.z);
		edges[5].set(middle.x - diag.x, middle.y - diag.y, middle.z + diag.z);
		edges[6].set(middle.x - diag.x, middle.y + diag.y, middle.z - diag.z);
		edges[7].set(middle.x - diag.x, middle.y - diag.y, middle.z - diag.z);
	}

	//! Repairs the box.
	/** Necessary if for example MinEdge and MaxEdge are swapped. */
	void repair() {
		T t;

		if (MinEdge.x > MaxEdge.x)
			{ t=MinEdge.x; MinEdge.x = MaxEdge.x; MaxEdge.x=t; }
		if (MinEdge.y > MaxEdge.y)
			{ t=MinEdge.y; MinEdge.y = MaxEdge.y; MaxEdge.y=t; }
		if (MinEdge.z > MaxEdge.z)
			{ t=MinEdge.z; MinEdge.z = MaxEdge.z; MaxEdge.z=t; }
	}

	//! Calculates a new interpolated bounding box.
	/** d=0 returns other, d=1 returns this, all other values blend between
	the two boxes.
	\param other Other box to interpolate between
	\param d Value between 0.0f and 1.0f.
	\return Interpolated box. */
	AABBox3D!(T) getInterpolated(AABBox3D!(T) other, float d) {
		float inv = 1.0f - d;
		return AABBox3D!(T)((other.MinEdge*cast(T)inv) + (MinEdge*cast(T)d),
			(other.MaxEdge*cast(T)inv) + (MaxEdge*cast(T)d));
	}

	//! Determines if a point is within this box.
	/** Border is included (IS part of the box)!
	\param p: Point to check.
	\return True if the point is within the box and false if not */
	bool isPointInside(Vector3D!(T) p) {
		return (p.x >= MinEdge.x && p.x <= MaxEdge.x &&
			p.y >= MinEdge.y && p.y <= MaxEdge.y &&
			p.z >= MinEdge.z && p.z <= MaxEdge.z);
	}

	//! Determines if a point is within this box and not its borders.
	/** Border is excluded (NOT part of the box)!
	\param p: Point to check.
	\return True if the point is within the box and false if not. */
	bool isPointTotalInside(Vector3D!(T) p) {
		return (p.x > MinEdge.x && p.x < MaxEdge.x &&
			p.y > MinEdge.y && p.y < MaxEdge.y &&
			p.z > MinEdge.z && p.z < MaxEdge.z);
	}

	//! Check if this box is completely inside the 'other' box.
	/** \param other: Other box to check against.
	\return True if this box is completly inside the other box,
	otherwise false. */
	bool isFullInside(AABBox3D!(T) other) {
		return (MinEdge.x >= other.MinEdge.x && MinEdge.y >= other.MinEdge.y && MinEdge.z >= other.MinEdge.z &&
			MaxEdge.x <= other.MaxEdge.x && MaxEdge.y <= other.MaxEdge.y && MaxEdge.z <= other.MaxEdge.z);
	}

	//! Returns the intersection of this box with another, if possible.
	AABBox3D!(T) intersect(AABBox3D!(T) other) {
		import std.algorithm : min, max;
		AABBox3D!(T) out_;
	
		if (!intersectsWithBox(other))
			return out_;

		
		out_.MaxEdge.x = min(MaxEdge.x, other.MaxEdge.x);
		out_.MaxEdge.y = min(MaxEdge.y, other.MaxEdge.y);
		out_.MaxEdge.z = min(MaxEdge.z, other.MaxEdge.z);

		out_.MinEdge.x = max(MinEdge.x, other.MinEdge.x);
		out_.MinEdge.y = max(MinEdge.y, other.MinEdge.y);
		out_.MinEdge.z = max(MinEdge.z, other.MinEdge.z);

		return out_;
	}

	//! Determines if the axis-aligned box intersects with another axis-aligned box.
	/** \param other: Other box to check a intersection with.
	\return True if there is an intersection with the other box,
	otherwise false. */
	bool intersectsWithBox(AABBox3D!(T) other) {
		return (MinEdge.x <= other.MaxEdge.x && MinEdge.y <= other.MaxEdge.y && MinEdge.z <= other.MaxEdge.z &&
			MaxEdge.x >= other.MinEdge.x && MaxEdge.y >= other.MinEdge.y && MaxEdge.z >= other.MinEdge.z);
	}

	//! Tests if the box intersects with a line
	/** \param line: Line to test intersection with.
	\return True if there is an intersection , else false. */
	bool intersectsWithLine(Line3D!(T) line) {
		return intersectsWithLine(line.getMiddle(), line.getVector().normalize,
				cast(T)(line.length * 0.5));
	}

	//! Tests if the box intersects with a line
	/** \param linemiddle Center of the line.
	\param linevect Vector of the line.
	\param halflength Half length of the line.
	\return True if there is an intersection, else false. */
	bool intersectsWithLine(Vector3D!(T) linemiddle,
				Vector3D!(T) linevect, T halflength) {

		import std.math : fabs;
		
		Vector3D!(T) e = getExtent() * cast(T)0.5;
		Vector3D!(T) t = getCenter() - linemiddle;

		if ((fabs(t.x) > e.x + halflength * fabs(linevect.x)) ||
			(fabs(t.y) > e.y + halflength * fabs(linevect.y)) ||
			(fabs(t.z) > e.z + halflength * fabs(linevect.z)) )
			return false;

		T r = e.y * cast(T)fabs(linevect.z) + e.z * cast(T)fabs(linevect.y);
		if (fabs(t.y*linevect.z - t.z*linevect.y) > r )
			return false;

		r = e.x * cast(T)fabs(linevect.z) + e.z * cast(T)fabs(linevect.x);
		if (fabs(t.z*linevect.x - t.x*linevect.z) > r )
			return false;

		r = e.x * cast(T)fabs(linevect.y) + e.y * cast(T)fabs(linevect.x);
		if (fabs(t.x*linevect.y - t.y*linevect.x) > r)
			return false;

		return true;
	}
	
    Vector3D!(T) MinEdge;
    Vector3D!(T) MaxEdge;
}

alias aabbox3df = AABBox3D!(float);
alias aabbox3di = AABBox3D!(int);

/// AABBox3D Example
unittest
{
    auto box = aabbox3di(vector3di(2,2,2), vector3di(4,4,4));
    assert(box.MinEdge.x == 2 || box.MinEdge.y == 2 || box.MinEdge.z == 2
    || box.MaxEdge.x == 4 || box.MaxEdge.y == 4 || box.MaxEdge.z == 4);

    auto box2 = aabbox3di(vector3di(4,4,4), vector3di(6,6,6));
    box += box2;
    assert(box.MinEdge.x == 6 || box.MinEdge.y == 6 || box.MinEdge.z == 6
    || box.MaxEdge.x == 10 || box.MaxEdge.y == 10 || box.MaxEdge.z == 10);

    box -= box2;
    assert(box.MinEdge.x == 2 || box.MinEdge.y == 2 || box.MinEdge.z == 2
    || box.MaxEdge.x == 4 || box.MaxEdge.y == 4 || box.MaxEdge.z == 4);

    box *= box2;
    assert(box.MinEdge.x == 8 || box.MinEdge.y == 8 || box.MinEdge.z == 8
    || box.MaxEdge.x == 24 || box.MaxEdge.y == 24 || box.MaxEdge.z == 24);

    box /= box2;
    assert(box.MinEdge.x == 2 || box.MinEdge.y == 2 || box.MinEdge.z == 2
    || box.MaxEdge.x == 4 || box.MaxEdge.y == 4 || box.MaxEdge.z == 4);
}

package extern(C):

struct irr_aabbox3di {
    irr_vector3di MinEdge;
    irr_vector3di MaxEdge;
}

struct irr_aabbox3df {
    irr_vector3df MinEdge;
    irr_vector3df MaxEdge;
}
