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
enum E_VERTEX_SHADER_TYPE
{
    EVST_VS_1_1 = 0,
    EVST_VS_2_0,
    EVST_VS_2_a,
    EVST_VS_3_0,
    EVST_VS_4_0,
    EVST_VS_4_1,
    EVST_VS_5_0,

    /// This is not a type, but a value indicating how much types there are.
    EVST_COUNT
}

/// Compile target enumeration for the addHighLevelShaderMaterial() method.
enum E_PIXEL_SHADER_TYPE
{
    EPST_PS_1_1 = 0,
    EPST_PS_1_2,
    EPST_PS_1_3,
    EPST_PS_1_4,
    EPST_PS_2_0,
    EPST_PS_2_a,
    EPST_PS_2_b,
    EPST_PS_3_0,
    EPST_PS_4_0,
    EPST_PS_4_1,
    EPST_PS_5_0
}

/// Enum for supported geometry shader types
enum E_GEOMETRY_SHADER_TYPE
{
    EGST_GS_4_0 = 0
}
