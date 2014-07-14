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

module dirrlicht.video.shadertypes;

/// Compile target enumeration for the addHighLevelShaderMaterial() method.
enum VertexShaderType {
    VS_1_1 = 0,
    VS_2_0,
    VS_2_0a,
    VS_3_0,
    VS_4_0,
    VS_4_1,
    VS_5_0,

    /// This is not a type, but a value indicating how much types there are.
    Count
}

/// Compile target enumeration for the addHighLevelShaderMaterial() method.
enum PixelShaderType {
    PS_1_1 = 0,
    PS_1_2,
    PS_1_3,
    PS_1_4,
    PS_2_0,
    PS_2_0a,
    PS_2_0b,
    PS_3_0,
    PS_4_0,
    PS_4_1,
    PS_5_0,
}

/// Enum for supported geometry shader types
enum GeometryShaderType {
    GS_4_0 = 0
}
