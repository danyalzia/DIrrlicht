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

module dirrlicht.io.attributestypes;

/// Types of attributes available for IAttributes
enum AttributeType {
    /// integer attribute
    Int = 0,

    /// float attribute
    Float,

    /// string attribute
    String,

    /// boolean attribute
    Bool,

    /// enumeration attribute
    Enum,

    /// color attribute
    Color,

    /// floating point color attribute
    Colorf,

    /// 3d vector attribute
    Vector3d,

    /// 2d position attribute
    Position2d,

    /// vector 2d attribute
    Vector2d,

    /// rectangle attribute
    Rect,

    /// matrix attribute
    Matrix,

    /// quaternion attribute
    Quaternion,

    /// 3d bounding box
    BBox,

    /// plane
    Plane,

    /// 3d triangle
    triangle3d,

    /// line 2d
    Line2d,

    /// line 3d
    Line3d,

    /// array of stringws attribute
    StringArray,

    /// array of float
    FloatArray,

    /// array of int
    IntArray,

    /// binary data attribute
    Binary,

    /// texture reference attribute
    Texture,

    /// user pointer void*
    Pointer,

    /// dimension attribute
    Dimension2d
}
