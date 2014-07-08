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
enum AttributeType
{
    /// integer attribute
    int_ = 0,

    /// float attribute
    float_,

    /// string attribute
    string_,

    /// boolean attribute
    bool_,

    /// enumeration attribute
    enum_,

    /// color attribute
    color_,

    /// floating point color attribute
    colorf,

    /// 3d vector attribute
    vector3d,

    /// 2d position attribute
    position2d,

    /// vector 2d attribute
    vector2d,

    /// rectangle attribute
    rect,

    /// matrix attribute
    matrix,

    /// quaternion attribute
    quaternion,

    /// 3d bounding box
    bbox,

    /// plane
    plane,

    /// 3d triangle
    triangle3d,

    /// line 2d
    line2d,

    /// line 3d
    line3d,

    /// array of stringws attribute
    stringArray,

    /// array of float
    floatArray,

    /// array of int
    intArray,

    /// binary data attribute
    binary,

    /// texture reference attribute
    texture,

    /// user pointer void*
    pointer,

    /// dimension attribute
    dimension2d
}
