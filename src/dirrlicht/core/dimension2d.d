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

module dirrlicht.core.dimension2d;

import dirrlicht.compileconfig;
import dirrlicht.core.vector2d;
import std.traits;

/+++
 + Specifies a 2 dimensional size
 +/
pure nothrow struct Dimension2D(T) if(isNumeric!(T) && (is (T == uint) || is (T == int) || is (T == float) || is (T == double))) {
    /// Constructor with width and height
	this(const T width, const T height) {
		Width = width;
		Height = height;
	}

	this(ref const Vector2D!(T) other) {	
		Width = other.x;
		Height = other.y;
	}

	/// Use this constructor only where you are sure that 
	/// conversion is valid.
	this(U)(ref const Dimension2D!(U) other) {
		Width = cast(T)other.Width;
		Height = cast(T)other.Height;
	}

	static if (is(T==uint)) {
		this(irr_dimension2du d) {
			Width = d.Width;
			Height = d.Height;
		}
	}
	
	ref Dimension2D!(T) opAssign(U)(ref const Dimension2D!(U) other) {
		Width = cast(T)other.Width;
		Height = cast(T)other.Height;
		return this;
	}

	/// Equality operator
	bool opEqual(ref const Dimension2D!(T) other) const {
		return Width == other.Width &&
			Height == other.Height;
	}

	bool opEqual(ref const Vector2D!(T) other) const {
		return other.x == Width && other.y == Height;
	}

	/// Set to new values
	Dimension2D!(T) set(ref const T width, ref const T height) {
		Width = width;
		Height = height;
		return this;
	}

	/// Divide width and height by scalar
	ref Dimension2D!(T) opOpAssign(string op)(ref const T scale)
		if(op == "/") {
		Width /= scale;
		Height /= scale;
		return this;
	}

	/// Divide width and height by scalar
	Dimension2D!(T) opBinary(string op)(const T scale)
		if(op == "/") {
		return Dimension2D!(T)(Width/scale, Height/scale);
	}

	/// Multiply width and height by scalar
	ref Dimension2D!(T) opOpAssign(string op)(ref const T scale) const
		if(op == "*") {
		Width *= scale;
		Height *= scale;
		return this;
	}

	/// Multiply width and height by scalar
	Dimension2D!(T) opBinary(string op)(ref const T scale) const
		if(op == "*") {
		return Dimension2D!(T)(Width*sacle, Height*scale);
	}

	/// Add another dimension to this one
	auto ref Dimension2D!(T) opOpAssign(string op)(const Dimension2D other)
		if(op == "+") {
		Width += other.Width;
		Height += other.Height;
		return this;
	}

	/// Add two dimensions
	Dimension2D!(T) opBinary(string op)(const Dimension2D!(T) other) const
		if(op == "+") {
		return Dimension2D!(T)(Width+other.Width, Height+other.Height);
	}

	/// Subtract a dimension from this one
	auto ref Dimension2D!(T) opOpAssign(string op)(const Dimension2D!(T) other)
		if(op == "-") {
		Width -=  other.Width;
		Height -= other.Height;
		return this;
	}

	/// Subtract a dimension from another
	Dimension2D!(T) opBinary(string op)(const Dimension2D!(T) other) const {
		return Dimension2D!(T)(Width-other.Width, Height-other.Height);
	}

	/// Get area
	T getArea() const {
		return Width*Height;
	}
	
	/***
	 * Get the optimal size according to some properties
	 * This is a function often used for texture dimension
	 * calculations. The function returns the next larger or
	 * smaller dimension which is a power-of-two dimension
	 * (2^n,2^m) and/or square (Width=Height).
	 * Params:
	 *  requirePowerOfTwo = Forces the result to use only
	 *  powers of two as values.
	 *  requireSquare = Makes width==height in the result
	 *  larger = Choose whether the result is larger or
	 *  smaller than the current dimension. If one dimension
	 *  need not be changed it is kept with any value of larger.
	 *  maxValue = Maximum texturesize. if value > 0 size is
	 *  clamped to maxValue
	 * 
	 * Returns: The optimal dimension under the given
	 * constraints. 
	 */
	Dimension2D!(T) getOptimalSize(
		bool requirePowerOfTwo = true,
		bool requireSquare = false,
		bool larger = true,
		uint maxValue = 0) const {
			
		uint i = 1;
		uint j = 1;

		if(requirePowerOfTwo) {
			while(i < cast(uint)Width) {
				i <<= 1;
			}
			if(!larger && i!=1 && i!=cast(uint)Width) {
				i >>= 1;
			}

			while(j < cast(uint)Height) {
				j <<= 1;
			}
			if(!larger && j!=1 && j!=cast(uint)Height) {
				j >>= 1;
			}
		} else {
			i = cast(uint)Width;
			j = cast(uint)Height;
		}

		if(requireSquare) {
			if((larger && (i>j)) || (!larger && (i<j))) {
				j = i;
			}
			else {
				i = j;
			}
		}

		if(maxValue > 0 && i > maxValue)
			i = maxValue;

		if(maxValue > 0 && j > maxValue)
			j = maxValue;

		return Dimension2D!(T)(cast(T)i, cast(T)j);
	}
	
	/***
	 * Get the interpolated dimension
	 * Params:
	 *  other = Other dimension to interpolate with.
	 *  d = Value between 0.0f and 1.0f.
	 *
	 * Returns: Interpolated dimension. 
	 */
	Dimension2D!(T) getInterpolated(const Dimension2D!(T) other, float d) const {
		float inv = (1.0f - d);
		return Dimension2D!(T)( cast(T)(other.Width*inv + Width*d), cast(T)(other.Height*inv + Height*d));
	}
		
    /// internal use only
    @property {
	    static if (is (T == float)) {
	    	irr_dimension2df ptr() {
	    		return irr_dimension2df(Width, Height);
	    	}
	    	alias ptr this;
	    }
	    else static if (is (T == double)) {
	    	irr_dimension2df ptr() {
	    		return irr_dimension2df(cast(float)Width, cast(float)Height);
	    	}
	    	alias ptr this;
	    }
	    else static if (is (T == int)) {
	    	irr_dimension2di ptr() {
	    		return irr_dimension2di(Width, Height);
	    	}
	    	alias ptr this;
	    }
	    else {
			irr_dimension2du ptr() {
	    		return irr_dimension2du(Width, Height);
	    	}
	    	alias ptr this;
		}
    }

    /// Width of the dimension
	T Width;

	/// Height of the dimension
	T Height;
}

alias dimension2di = Dimension2D!(int);
alias dimension2du = Dimension2D!(uint);
alias dimension2df = Dimension2D!(float);

unittest {
	mixin(Core_TestBegin);

	mixin(Core_TestEnd);
}

package extern(C):

struct irr_dimension2di {
    int Width;
    int Height;
}

struct irr_dimension2du {
    uint Width;
    uint Height;
}

struct irr_dimension2df {
    float Width;
    float Height;
}
