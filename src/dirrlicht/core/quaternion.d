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

module dirrlicht.core.quaternion;

import dirrlicht.core.simdmath;
import dirrlicht.core.vector3d;
import dirrlicht.core.matrix4;

pure nothrow @safe struct Quaternion {
	/// Constructor
	this(float x, float y, float z, float w) {
		x = x;
		y = y;
		z = z;
		w = w;
	}

	/// Constructor which converts euler angles (radians) to a Quaternion
	this(float x, float y, float z) {
		set(x, y, z);
	}

	/// Constructor which converts euler angles (radians) to a Quaternion
	this(vector3df vec) {
		set(vec.x, vec.y, vec.z);
	}

	/// Constructor which converts a matrix to a Quaternion
	this(matrix4 mat) {
		opAssign(mat);
	}

	/// Equalilty operator
	bool opEqual(Quaternion other) {
		import std.math : approxEqual;
		return (approxEqual(x, other.x) &&
			approxEqual(y, other.y) &&
			approxEqual(z, other.z) &&
			approxEqual(w, other.w));
	}

	/// Assignment operator
	auto ref Quaternion opAssign(Quaternion other) {
		x = other.x;
		y = other.y;
		z = other.z;
		w = other.w;
		return this;
	}

	/// Matrix assignment operator
	auto ref Quaternion opAssign(matrix4 other) {
		import std.math : sqrt;
		immutable float diag = other[0] + other[5] + other[10] + 1;

		if (diag > 0.0f) {
			immutable float scale = cast(float)(sqrt(diag) * 2.0f); // get scale from diagonal

			// TODO: speed this up
			x = (other[6] - other[9]) / scale;
			y = (other[8] - other[2]) / scale;
			z = (other[1] - other[4]) / scale;
			w = 0.25f * scale;
		}
		else {
			if (other[0]>other[5] && other[0]>other[10]) {
				// 1st element of diag is greatest value
				// find scale according to 1st element, and double it
				immutable float scale = cast(float)(sqrt(1.0f + other[0] - other[5] - other[10]) * 2.0f);

				// TODO: speed this up
				x = 0.25f * scale;
				y = (other[4] + other[1]) / scale;
				z = (other[2] + other[8]) / scale;
				w = (other[6] - other[9]) / scale;
			}
			else if (other[5]>other[10]) {
				// 2nd element of diag is greatest value
				// find scale according to 2nd element, and double it
				immutable float scale = cast(float)(sqrt(1.0f + other[5] - other[0] - other[10]) * 2.0f);

				// TODO: speed this up
				x = (other[4] + other[1]) / scale;
				y = 0.25f * scale;
				z = (other[9] + other[6]) / scale;
				w = (other[8] - other[2]) / scale;
			}
			else {
				// 3rd element of diag is greatest value
				// find scale according to 3rd element, and double it
				immutable float scale = cast(float)(sqrt(1.0f + other[10] - other[0] - other[5]) * 2.0f);

				// TODO: speed this up
				x = (other[8] + other[2]) / scale;
				y = (other[9] + other[6]) / scale;
				z = 0.25f * scale;
				w = (other[1] - other[4]) / scale;
			}
		}

		return normalize();
	}

	/// Add operator
	Quaternion opBinary(string op)(Quaternion other)
	if(op == "+" || op == "-") {
		return Quaternion(mixin("x"~op~"other.x"), mixin("y"~op~"other.y"), mixin("z"~op~"other.z"));
	}

	/// Multiplication operator
	Quaternion opBinary(string op)(Quaternion other)
		if(op == "*") {
		Quaternion tmp;

		tmp.w = (other.w * W) - (other.x * X) - (other.y * Y) - (other.z * Z);
		tmp.x = (other.w * X) + (other.x * W) + (other.y * Z) - (other.z * Y);
		tmp.y = (other.w * Y) + (other.y * W) + (other.z * X) - (other.x * Z);
		tmp.z = (other.w * Z) + (other.z * W) + (other.x * Y) - (other.y * X);

		return tmp;
	}

	/// Multiplication operator with scalar
	Quaternion opBinary(string op)(float s) const
		if(op == "*") {
		return Quaternion(s*x, s*y, s*z, s*w);
	}

	/// Multiplication operator with scalar
	auto ref Quaternion opOpAssign(string op)(float s)
		if(op == "*") {
		x*=s;
		y*=s;
		z*=s;
		w*=s;
		return this;	
	}

	/// Multiplication operator
	vector3df opBinary(string op)(auto ref const vector3df v)
		if(op == "*") {
		// nVidia SDK implementation
		vector3df uv, uuv;
		auto qvec = vector3df(x, y, z);
		uv = qvec.crossProduct(v);
		uuv = qvec.crossProduct(uv);
		uv *= (2.0f * x);
		uuv *= 2.0f;

		return v + uv + uuv;
	}

	/// Multiplication operator
	auto ref Quaternion opOpAssign(string op)(auto ref const Quaternion other)
	if(op == "*") {
		return this = (other * this);
	}

	/// Calculates the dot product
	float dot(Quaternion other) {
		return (x * other.x) + (y * other.y) + (z * other.z) + (w * other.w);
	}

	/// Sets new Quaternion
	auto ref Quaternion set(float x, float y, float z, float w) {
		x = x;
		y = y;
		z = z;
		w = w;
		return this;
	}

	/// Sets new Quaternion based on euler angles (radians)
	auto ref Quaternion set(float x, float y, float z) {
		import std.math : sin, cos;
		double angle;

		angle = x * 0.5;
		immutable sr = sin(angle);
		immutable cr = cos(angle);

		angle = y * 0.5;
		immutable sp = sin(angle);
		immutable cp = cos(angle);

		angle = z * 0.5;
		immutable sy = sin(angle);
		immutable cy = cos(angle);

		immutable cpcy = cp * cy;
		immutable spcy = sp * cy;
		immutable cpsy = cp * sy;
		immutable spsy = sp * sy;

		x = cast(float)(sr * cpcy - cr * spsy);
		y = cast(float)(cr * spcy + sr * cpsy);
		z = cast(float)(cr * cpsy - sr * spcy);
		w = cast(float)(cr * cpcy + sr * spsy);

		return normalize();		
	}

	/// Sets new Quaternion based on euler angles (radians)
	auto ref Quaternion set(vector3df vec) {
		return set(vec.x, vec.y, vec.z);
	}

	/// Sets new Quaternion from other Quaternion
	auto ref Quaternion set(Quaternion quat) {
		return (this = quat);
	}

	/// returns if this Quaternion equals the other one, taking floating point rounding errors into account
	bool equals(Quaternion other,
			const float tolerance = float.epsilon ) {
		import std.math : approxEqual;
		return (approxEqual(x, other.x) &&
			approxEqual(y, other.y) &&
			approxEqual(z, other.z) &&
			approxEqual(w, other.w));
	}

	/// Normalizes the Quaternion
	auto ref Quaternion normalize() {
		import std.math : sqrt;
		immutable n = x*x + y*y + z*z + w*w;

		if (n == 1)
			return this;

		//n = 1.0f / sqrtf(n);
		return (this *= cast(float)(1.0 / sqrt( n )));
	}

	/// Creates a matrix from this Quaternion
	matrix4 getMatrix() {
		matrix4 m;
		getMatrix(m);
		return m;
	}

	/// Creates a matrix from this Quaternion
	void getMatrix()(out matrix4 dest, 
		vector3df center = vector3df(0,0,0))  {
		dest[0] = 1.0f - 2.0f*y*y - 2.0f*z*z;
		dest[1] = 2.0f*x*y + 2.0f*z*w;
		dest[2] = 2.0f*x*z - 2.0f*y*w;
		dest[3] = 0.0f;

		dest[4] = 2.0f*x*y - 2.0f*z*w;
		dest[5] = 1.0f - 2.0f*x*x - 2.0f*z*z;
		dest[6] = 2.0f*z*y + 2.0f*x*w;
		dest[7] = 0.0f;

		dest[8] = 2.0f*x*z + 2.0f*y*w;
		dest[9] = 2.0f*z*y - 2.0f*x*w;
		dest[10] = 1.0f - 2.0f*x*x - 2.0f*y*y;
		dest[11] = 0.0f;

		dest[12] = center.x;
		dest[13] = center.y;
		dest[14] = center.z;
		dest[15] = 1;

		dest.setDefinitelyIdentityMatrix( false );
	}

	/**
	* Creates a matrix from this Quaternion
	* Rotate about a center point
	* shortcut for:
	* Examples:
	* ------
	* Quaternion q;
	* q.rotationFromTo( vin[i].Normal, forward );
	* q.getMatrixCenter( lookat, center, newPos );
	* matrix4 m2;
	* m2.setInverseTranslation ( center );
	* lookat *= m2;
	* matrix4 m3;
	* m2.setTranslation ( newPos );
	* lookat *= m3;
	* ------
	*/
	void getMatrixCenter(out matrix4 dest, 
		vector3df center, 
		vector3df translation) {
		dest[0] = 1.0f - 2.0f*y*y - 2.0f*z*z;
		dest[1] = 2.0f*x*y + 2.0f*z*w;
		dest[2] = 2.0f*x*z - 2.0f*y*w;
		dest[3] = 0.0f;

		dest[4] = 2.0f*x*y - 2.0f*z*w;
		dest[5] = 1.0f - 2.0f*x*x - 2.0f*z*z;
		dest[6] = 2.0f*z*y + 2.0f*x*w;
		dest[7] = 0.0f;

		dest[8] = 2.0f*x*z + 2.0f*y*w;
		dest[9] = 2.0f*z*y - 2.0f*x*w;
		dest[10] = 1.0f - 2.0f*x*x - 2.0f*y*y;
		dest[11] = 0.0f;

		dest.setRotationCenter( center, translation );
	}

	/// Creates a matrix from this Quaternion
	void getMatrix_transposed(out matrix4 dest) {
		dest[0] = 1.0f - 2.0f*y*y - 2.0f*z*z;
		dest[4] = 2.0f*x*y + 2.0f*z*w;
		dest[8] = 2.0f*x*z - 2.0f*y*w;
		dest[12] = 0.0f;

		dest[1] = 2.0f*x*y - 2.0f*z*w;
		dest[5] = 1.0f - 2.0f*x*x - 2.0f*z*z;
		dest[9] = 2.0f*z*y + 2.0f*x*w;
		dest[13] = 0.0f;

		dest[2] = 2.0f*x*z + 2.0f*y*w;
		dest[6] = 2.0f*z*y - 2.0f*x*w;
		dest[10] = 1.0f - 2.0f*x*x - 2.0f*y*y;
		dest[14] = 0.0f;

		dest[3] = 0.0f;
		dest[7] = 0.0f;
		dest[11] = 0.0f;
		dest[15] = 1.0f;

		dest.setDefinitelyIdentityMatrix(false);
	}

	/// Inverts this Quaternion
	auto ref Quaternion makeInverse() {
		x = -x; y = -y; z = -z;
		return this;
	}

	/***
	 * Set this Quaternion to the linear interpolation between two Quaternions
	 * Params:
	 * 	q1=  First Quaternion to be interpolated.
	 * 	q2=  Second Quaternion to be interpolated.
	 * 	time=  Progress of interpolation. For time=0 the result is
	 * q1, for time=1 the result is q2. Otherwise interpolation
	 * between q1 and q2.
	 */
	auto ref Quaternion lerp(
		Quaternion q1, 
		Quaternion q2, float time) {
		immutable scale = 1.0f - time;
		return (this = (q1*scale) + (q2*time));
	}
	
	/***
	 * Set this Quaternion to the result of the spherical interpolation between two Quaternions
	 * Params:
	 * 	q1=  First Quaternion to be interpolated.
	 * 	q2=  Second Quaternion to be interpolated.
	 * 	time=  Progress of interpolation. For time=0 the result is
	 * q1, for time=1 the result is q2. Otherwise interpolation
	 * between q1 and q2.
	 * 	threshold=  To avoid inaccuracies at the end (time=1) the
	 * interpolation switches to linear interpolation at some point.
	 * This value defines how much of the remaining interpolation will
	 * be calculated with lerp. Everything from 1-threshold up will be
	 * linear interpolation.
	 */
	auto ref Quaternion slerp()(
		Quaternion q1, 
		Quaternion q2,
		float time, float threshold=0.05f) {
		float angle = q1.dot(q2);

		// make sure we use the short rotation
		if (angle < 0.0f) {
			q1 *= -1.0f;
			angle *= -1.0f;
		}

		if (angle <= (1-threshold)) { // spherical interpolation
			immutable theta = acos(angle);
			immutable invsintheta = 1.0/(sin(theta));
			immutable scale = sin(theta * (1.0f-time)) * invsintheta;
			immutable invscale = sin(theta * time) * invsintheta;
			return (this = cast(float)((q1*scale) + (q2*invscale)));
		}
		else // linear interploation
			return lerp(q1,q2,time);
	}

	/***
	 * Create Quaternion from rotation angle and rotation axis.
	 * Axis must be unit length.
	 * The Quaternion representing the rotation is
	 * q = cos(A/2)+sin(A/2)*(x*i+y*j+z*k).
	 * Params:
	 * 	angle=  Rotation Angle in radians.
	 * 	axis=  Rotation axis. 
	 */
	auto ref Quaternion fromAngleAxis()(float angle, auto ref const vector3df axis) {
		immutable fHalfAngle = 0.5f*angle;
		immutable fSin = sin(fHalfAngle);
		w = cast(float)cos(fHalfAngle);
		x = cast(float)fSin*axis.x;
		y = cast(float)fSin*axis.y;
		z = cast(float)fSin*axis.z;
		return this;
	}

	/// Fills an angle (radians) around an axis (unit vector)
	void toAngleAxis()(out float angle, 
			vector3df axis) {
		immutable float scale = sqrt(x*x + y*y + z*z);

		if (iszero(scale) || w > 1.0f || w < -1.0f) {
			angle = 0.0f;
			axis.x = 0.0f;
			axis.y = 1.0f;
			axis.z = 0.0f;
		}
		else {
			immutable float invscale = 1/scale;
			angle = cast(float)(2.0f * acos(W));
			axis.x = x * invscale;
			axis.y = y * invscale;
			axis.z = z * invscale;
		}
	}

	/// Output this Quaternion to an euler angle (radians)
	void toEuler(out vector3df euler) {
		import std.math : approxEqual, atan2, PI, asin;
		immutable double sqw = w*w;
		immutable double sqx = x*x;
		immutable double sqy = y*y;
		immutable double sqz = z*z;
		immutable double test = 2.0 * (y*w - x*z);

		if (approxEqual(test, 1.0, 0.000001)) {
			// heading = rotation about z-axis
			euler.z = cast(float) (-2.0*atan2(x, w));
			// bank = rotation about x-axis
			euler.x = 0;
			// attitude = rotation about y-axis
			euler.y = cast(float)(PI/2.0);
		}
		
		else if (approxEqual(test, -1.0, 0.000001)) {
			// heading = rotation about z-axis
			euler.z = cast(float)(2.0*atan2(x, w));
			// bank = rotation about x-axis
			euler.x = 0;
			// attitude = rotation about y-axis
			euler.y = cast(float)(PI/-2.0);
		}
		else {
			// heading = rotation about z-axis
			euler.z = cast(float)atan2(2.0 * (x*y +z*w),(sqx - sqy - sqz + sqw));
			// bank = rotation about x-axis
			euler.x = cast(float)atan2(2.0 * (y*z +x*w),(-sqx - sqy + sqz + sqw));
			// attitude = rotation about y-axis
			euler.y = cast(float)asin(clamp(test, -1.0, 1.0) );
		}
	}

	/// Set Quaternion to identity
	auto ref Quaternion makeIdentity() {
		w = 1.0f;
		x = 0.0f;
		y = 0.0f;
		z = 0.0f;
		return this;		
	}

	/// Set Quaternion to represent a rotation from one vector to another.
	auto ref quaternion rotationFromTo()(
		vector3df from, 
		vector3df to) {
		// Based on Stan Melax's article in Game Programming Gems
		// Copy, since cannot modify local
		vector3df v0 = from;
		vector3df v1 = to;
		v0.normalize();
		v1.normalize();

		immutable float d = v0.dotProduct(v1);
		if (d >= 1.0f) { // If dot == 1, vectors are the same
			return makeIdentity();
		}
		else if (d <= -1.0f) { // exactly opposite
			auto axis = vector3df(1.0f, 0.f, 0.f);
			axis = axis.crossProduct(v0);
			if (axis.getLength()==0) {
				axis.set(0.f,1.f,0.f);
				axis.crossProduct(v0);
			}
			// same as fromAngleAxis(core::PI, axis).normalize();
			return set(axis.X, axis.Y, axis.z, 0).normalize();
		}

		immutable float s = sqrtf( (1+d)*2 ); // optimize inv_sqrt
		immutable float invs = 1.f / s;
		immutable vector3df c = v0.cross(v1)*invs;
		return set(c.x, c.y, c.z, s * 0.5f).normalize();
	}

	/// Quaternion elements.
	float x = 0.0f; // vectorial (imaginary) part
	float y = 0.0f;
	float z = 0.0f;
	float w = 0.0f; // real part
}
