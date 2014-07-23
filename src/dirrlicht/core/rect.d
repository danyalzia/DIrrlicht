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

module dirrlicht.core.rect;

import dirrlicht.compileconfig;
import dirrlicht.core.vector2d;

import std.traits;

/+++
 + Rectangle template.
 + Mostly used by 2D GUI elements and for 2D drawing methods.
 + It has 2 positions instead of position and dimension and a fast
 + method for collision detection with other rectangles and points.
 + 
 + Coordinates are (0,0) for top-left corner, and increasing to the right
 + and to the bottom.
 +/
pure nothrow struct Rect(T) if(isNumeric!(T) && (is (T == int) || is (T == float))) {
	/// Constructor with two corners
	this(T x, T y, T x2, T y2) {
		UpperLeftCorner = Vector2D!(T)(x, y);
		LowerRightCorner = Vector2D!(T)(x2, y2);
	}

	/// Constructor with two corners
	this(ref const Vector2D!(T) upperLeft, ref const Vector2D!(T) lowerRight) {
		UpperLeftCorner = upperLeft;
		LowerRightCorner = lowerRight;
	}
	
	/// Constructor with upper left corner and dimension
	this(U)(ref const Vector2D!(T) pos, ref const Dimension2D!(U) size) {
		UpperLeftCorner = pos;
		LowerRightCorner = Vector2D!(T)(pos.x + size.Width, pos.y + size.Height);
	}

	/// Move right/left by given numbers
	Rect!(T) opBinary(string op)(ref const Vector2D!(T) pos)
	if(op == "+" || op == "-") {
		rect!T ret = this;
		mixin("return ret "~op~"= pos;");
	}

	/// Questionable!!!!!!!
	Rect!(T) opBinary(string op)(Rect!(T) rhs)
	if(op == "+" || op == "-") {
		return Rect!(T)(mixin("UpperLeftCorner.x" ~op~ "rhs.UpperLeftCorner.x"), mixin("UpperLeftCorner.y" ~op~ "rhs.UpperLeftCorner.y"));
	}
	
	/// Move right/left by given numbers
	ref Rect!(T) opOpAssign(string op)(ref const Vector2D!(T) pos)
	if(op == "+" || op == "-")
	{
		mixin("UpperLeftCorner "~op~"= pos;");
		mixin("LowerRightCorner "~op~"= pos;");
		return this;
	}

	/// Questionable!!!!!!!
	Rect!(T) opOpAssign(string op)(Rect!(T) rhs)
	if(op == "+" || op == "-")
	{
		mixin("UpperLeftCorner "~op~"= rhs.UpperLeftCorner;");
		mixin("LowerRightCorner "~op~"= rhs.LowerRightCorner;");
		return this;
	}
	
	/// equality operator
	bool opEqual(ref const Rect!(T) other) const {
		return (UpperLeftCorner == other.UpperLeftCorner &&
			LowerRightCorner == other.LowerRightCorner);
	}

	/// Compares by areas
	int opCmp(ref const Rect!(T) other) const {
		if (getArea() < other.getArea()) {
			return -1;
		}
		else if (getArea() > other.getArea()) {
			return 1;
		}
		
		return 0;
	}

	/// Returns size of rectangle
	T getArea() const {
		return getWidth() * getHeight();
	}

	/***
	 * Returns if a 2d point is within this rectangle.
	 *	Params:
	 *	pos = Position to test if it lies within this rectangle.
	 *
	 *	Returns:
	 *	True if the position is within the rectangle, false if not.
	 */
	bool isPointInside(ref const Vector2D!(T) pos) const {
		return (UpperLeftCorner.x <= pos.x &&
			UpperLeftCorner.y <= pos.y &&
			LowerRightCorner.x >= pos.x &&
			LowerRightCorner.y >= pos.y);
	}

	/***
	 * Check if the rectangle collides with another rectangle.
	 *	Params:
	 *	other = Rectangle to test collision with
	 *	
	 *	Returns: True if the rectangles collide.
	 */
	bool isRectCollided(ref const Rect!T other) const {
		return (LowerRightCorner.y > other.UpperLeftCorner.y &&
			UpperLeftCorner.y < other.LowerRightCorner.y &&
			LowerRightCorner.x > other.UpperLeftCorner.x &&
			UpperLeftCorner.x < other.LowerRightCorner.x);
	}
	
	/***
	 * Clips this rectangle with another one.
	 *	Params:
	 *	other = Rectangle to clip with
	 */
	void clipAgainst(ref const Rect!(T) other) {
		if (other.LowerRightCorner.x < LowerRightCorner.x)
			LowerRightCorner.x = other.LowerRightCorner.x;
		if (other.LowerRightCorner.y < LowerRightCorner.y)
			LowerRightCorner.y = other.LowerRightCorner.y;

		if (other.UpperLeftCorner.x > UpperLeftCorner.x)
			UpperLeftCorner.x = other.UpperLeftCorner.x;
		if (other.UpperLeftCorner.y > UpperLeftCorner.y)
			UpperLeftCorner.y = other.UpperLeftCorner.y;

		// correct possible invalid rect resulting from clipping
		if (UpperLeftCorner.y > LowerRightCorner.y)
			UpperLeftCorner.y = LowerRightCorner.y;
		if (UpperLeftCorner.x > LowerRightCorner.x)
			UpperLeftCorner.x = LowerRightCorner.x;
	}

	/***
	 * Moves this rectangle to fit inside another one.
	 * Returns: True on success, false if not possible.
	 */
	bool constrainTo(ref const Rect!(T) other) {
		if (other.getWidth() < getWidth() || other.getHeight() < getHeight())
			return false;

		T diff = other.LowerRightCorner.x - LowerRightCorner.x;
		if (diff < 0) {
			LowerRightCorner.x += diff;
			UpperLeftCorner.x += diff;
		}

		diff = other.LowerRightCorner.y - LowerRightCorner.y;
		if (diff < 0) {
			LowerRightCorner.y += diff;
			UpperLeftCorner.y += diff;
		}

		diff = UpperLeftCorner.x - other.UpperLeftCorner.x;
		if (diff < 0) {
			UpperLeftCorner.x -= diff;
			LowerRightCorner.x -= diff;
		}

		diff = UpperLeftCorner.y - other.UpperLeftCorner.y;
		if (diff < 0) {
			UpperLeftCorner.y -= diff;
			LowerRightCorner.y -= diff;
		}

		return true;
	}

	/// Get width of rectangle
	T getWidth() const {
		return LowerRightCorner.x - UpperLeftCorner.x;
	}

	/// Get height of rectangle
	T getHeight() const {
		return LowerRightCorner.y - UpperLeftCorner.y;
	}

	/// If the lower right corner of the rect is smaller then upper left, the points are swapped.
	void repair() {
		if (LowerRightCorner.x < UpperLeftCorner.x) {
			std.algorithm.swap(LowerRightCorner.x, UpperLeftCorner.x);
		}

		if (LowerRightCorner.y < UpperLeftCorner.y) {
			std.algorithm.swap(LowerRightCorner.y, UpperLeftCorner.y);
		}
	}

	/***
	 * Returns if the rect is valid to draw
	 * It would be invalid if the UpperLeftCorner is lower or more
	 * right than the LowerRightCorner.
	 */
	bool isValid() const {
		return ((LowerRightCorner.x >= UpperLeftCorner.x) &&
			(LowerRightCorner.y >= UpperLeftCorner.y));
	}

	/// Get the center of the rectangle
	Vector2D!(T) getCenter() const {
		return Vector2D!(T)(
			(UpperLeftCorner.x + LowerRightCorner.x) / 2,
			(UpperLeftCorner.y + LowerRightCorner.y) / 2);
	}

	/// Get the dimensions of the rectangle
	Vector2D!(T) getSize() const {
		return Vector2D!(T)(getWidth(), getHeight());
	}
	
	/***
	 * Adds a point to the rectangle
	 * Causes the rectangle to grow bigger if point is outside 
	 * the box.
	 *
	 * Params:
	 * p = Point to add to the box.
	 */
	void addInternalPoint(ref const Vector2D!(T) p) {
		addInternalPoint(p.x, p.y);
	}

	/***
	 * Adds a point to the bounding rectangle
	 * Causes the rectangle to grow bigger if point is outside
	 * ther box.
	 *
	 * Params:
	 * x = X-Coordinate of the point to add to this box.
	 * y = Y-Coordinate of the point ot add to this box.
	 */
	void addInternalPoint(T x, T y) {
		if (x > LowerRightCorner.x)
			LowerRightCorner.x = x;
		if (y > LowerRightCorner.y)
			LowerRightCorner.y = y;

		if (x < UpperLeftCorner.x)
			UpperLeftCorner.x = x;
		if (y < UpperLeftCorner.y)
			UpperLeftCorner.y = y;
	}

	@property {
		T x() { return UpperLeftCorner.x; }
		T y() { return UpperLeftCorner.y; }
		T x1() { return UpperLeftCorner.x; }
		T y1() { return UpperLeftCorner.y; }

		T x(T _x) { return UpperLeftCorner.x = _x; }
		T y(T _y) { return UpperLeftCorner.y = _y; }
		T x1(T _x1) { return UpperLeftCorner.x = _x1; }
		T y1(T _y1) { return UpperLeftCorner.y = _y1; }

		static if (is(T == int)) {
			irr_recti ptr() {
				return irr_recti(x,y,x1,y1);
			}
		}
		else {
			irr_rectf ptr() {
				return irr_rectf(x,y,x1,y1);
			}
		}
    }
    
	/// Upper left corner
	Vector2D!(T) UpperLeftCorner;

	/// Lower right corner
	Vector2D!(T) LowerRightCorner;
}

alias recti = Rect!(int);
alias rectf = Rect!(float);

/// Rect example
unittest {
	mixin(Core_TestBegin);
	
    auto rec = recti(4, 4, 4, 4);
    assert(rec.x == 4 || rec.y == 4 || rec.x1 == 4 || rec.y1 == 4);
    rec += recti(4,4,4,4);
    assert(rec.x == 8 || rec.y == 8 || rec.x1 == 8 || rec.y1 == 8);

    mixin(Core_TestEnd);
}

package extern (C):

struct irr_recti {
    int x;
    int y;
    int x1;
    int y1;
}

struct irr_rectf {
    float x;
    float y;
    float x1;
    float y1;
}
