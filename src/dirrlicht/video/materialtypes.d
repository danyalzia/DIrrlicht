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

module dirrlicht.video.materialtypes;

/// Abstracted and easy to use fixed function/programmable pipeline material modes.
enum MaterialType {
    /// Standard solid material.
    /// Only first texture is used, which is supposed to be the
    /// diffuse material.
    Solid = 0,

    /// Solid material with 2 texture layers.
    /// The second is blended onto the first using the alpha value
    /// of the vertex colors. This material is currently not implemented in OpenGL.
    Solid2Layer,

    /// Material type with standard lightmap technique
    /// There should be 2 textures: The first texture layer is a
    /// diffuse map, the second is a light map. Dynamic light is
    /// ignored.
    LightMap,

    /// Material type with lightmap technique like EMT_LIGHTMAP.
    /// But lightmap and diffuse texture are added instead of modulated.
    LightMapAdd,

    /// Material type with standard lightmap technique
    /// There should be 2 textures: The first texture layer is a
    /// diffuse map, the second is a light map. Dynamic light is
    /// ignored. The texture colors are effectively multiplied by 2
    /// for brightening. Like known in DirectX as D3DTOP_MODULATE2X.
    LightMapM2,

    /// Material type with standard lightmap technique
    /// There should be 2 textures: The first texture layer is a
    /// diffuse map, the second is a light map. Dynamic light is
    /// ignored. The texture colors are effectively multiplyied by 4
    /// for brightening. Like known in DirectX as D3DTOP_MODULATE4X.
    LightMapM4,

    /// Like EMT_LIGHTMAP, but also supports dynamic lighting.
    LightMapLighting,

    /// Like EMT_LIGHTMAP_M2, but also supports dynamic lighting.
    LightMapLightingM2,

    /// Like EMT_LIGHTMAP_4, but also supports dynamic lighting.
    LightMapLightingM4,

    /// Detail mapped material.
    /// The first texture is diffuse color map, the second is added
    /// to this and usually displayed with a bigger scale value so that
    /// it adds more detail. The detail map is added to the diffuse map
    /// using ADD_SIGNED, so that it is possible to add and substract
    /// color from the diffuse map. For example a value of
    /// (127,127,127) will not change the appearance of the diffuse map
    /// at all. Often used for terrain rendering.
    DetailMap,

    /// Look like a reflection of the environment around it.
    /// To make this possible, a texture called 'sphere map' is
    /// used, which must be set as the first texture.
    SphereMap,

    /// A reflecting material with an optional non reflecting texture layer.
    /// The reflection map should be set as first texture.
    Reflection2Layer,

    /// A transparent material.
    /// Only the first texture is used. The new color is calculated
    /// by simply adding the source color and the dest color. This
    /// means if for example a billboard using a texture with black
    /// background and a red circle on it is drawn with this material,
    /// the result is that only the red circle will be drawn a little
    /// bit transparent, and everything which was black is 100%
    /// transparent and not visible. This material type is useful for
    /// particle effects.
    TransparentAddColor,

    /// Makes the material transparent based on the texture alpha channel.
    /// The final color is blended together from the destination
    /// color and the texture color, using the alpha channel value as
    /// blend factor. Only first texture is used. If you are using
    /// this material with small textures, it is a good idea to load
    /// the texture in 32 bit mode
    /// (video::IVideoDriver::setTextureCreationFlag()). Also, an alpha
    /// ref is used, which can be manipulated using
    /// SMaterial::MaterialTypeParam. This value controls how sharp the
    /// edges become when going from a transparent to a solid spot on
    /// the texture.
    TransparentAlphaChannel,

    /// Makes the material transparent based on the texture alpha channel.
    /// If the alpha channel value is greater than 127, a
    /// pixel is written to the target, otherwise not. This
    /// material does not use alpha blending and is a lot faster
    /// than EMT_TRANSPARENT_ALPHA_CHANNEL. It is ideal for drawing
    /// stuff like leafes of plants, because the borders are not
    /// blurry but sharp. Only first texture is used. If you are
    /// using this material with small textures and 3d object, it
    /// is a good idea to load the texture in 32 bit mode
    /// (video::IVideoDriver::setTextureCreationFlag()).
    TransparentAlphaChannelRef,

    /// Makes the material transparent based on the vertex alpha value.
    TransparentVertexAlpha,

    /// A transparent reflecting material with an optional additional non reflecting texture layer.
    /// The reflection map should be set as first texture. The
    /// transparency depends on the alpha value in the vertex colors. A
    /// texture which will not reflect can be set as second texture.
    /// Please note that this material type is currently not 100%
    /// implemented in OpenGL.
    TransparentReflection2Layer,

    /// A solid normal map renderer.
    /// First texture is the color map, the second should be the
    /// normal map. Note that you should use this material only when
    /// drawing geometry consisting of vertices of type
    /// S3DVertexTangents (EVT_TANGENTS). You can convert any mesh into
    /// this format using IMeshManipulator::createMeshWithTangents()
    /// (See SpecialFX2 Tutorial). This shader runs on vertex shader
    /// 1.1 and pixel shader 1.1 capable hardware and falls back to a
    /// fixed function lighted material if this hardware is not
    /// available. Only two lights are supported by this shader, if
    /// there are more, the nearest two are chosen.
    NormalMapSolid,

    /// A transparent normal map renderer.
    /// First texture is the color map, the second should be the
    /// normal map. Note that you should use this material only when
    /// drawing geometry consisting of vertices of type
    /// S3DVertexTangents (EVT_TANGENTS). You can convert any mesh into
    /// this format using IMeshManipulator::createMeshWithTangents()
    /// (See SpecialFX2 Tutorial). This shader runs on vertex shader
    /// 1.1 and pixel shader 1.1 capable hardware and falls back to a
    /// fixed function lighted material if this hardware is not
    /// available. Only two lights are supported by this shader, if
    /// there are more, the nearest two are chosen.
    NormalMapTransparentAddColor,

    /// A transparent (based on the vertex alpha value) normal map renderer.
    /// First texture is the color map, the second should be the
    /// normal map. Note that you should use this material only when
    /// drawing geometry consisting of vertices of type
    /// S3DVertexTangents (EVT_TANGENTS). You can convert any mesh into
    /// this format using IMeshManipulator::createMeshWithTangents()
    /// (See SpecialFX2 Tutorial). This shader runs on vertex shader
    /// 1.1 and pixel shader 1.1 capable hardware and falls back to a
    /// fixed function lighted material if this hardware is not
    /// available.  Only two lights are supported by this shader, if
    /// there are more, the nearest two are chosen.
    NormalMapTransparentVertexAlpha,

    /// Just like EMT_NORMAL_MAP_SOLID, but uses parallax mapping.
    /// Looks a lot more realistic. This only works when the
    /// hardware supports at least vertex shader 1.1 and pixel shader
    /// 1.4. First texture is the color map, the second should be the
    /// normal map. The normal map texture should contain the height
    /// value in the alpha component. The
    /// IVideoDriver::makeNormalMapTexture() method writes this value
    /// automatically when creating normal maps from a heightmap when
    /// using a 32 bit texture. The height scale of the material
    /// (affecting the bumpiness) is being controlled by the
    /// SMaterial::MaterialTypeParam member. If set to zero, the
    /// default value (0.02f) will be applied. Otherwise the value set
    /// in SMaterial::MaterialTypeParam is taken. This value depends on
    /// with which scale the texture is mapped on the material. Too
    /// high or low values of MaterialTypeParam can result in strange
    /// artifacts.
    ParallaxMapSolid,

    /// A material like EMT_PARALLAX_MAP_SOLID, but transparent.
    /// Using EMT_TRANSPARENT_ADD_COLOR as base material.
    ParallaxMapTransparentAddColor,

    /// A material like EMT_PARALLAX_MAP_SOLID, but transparent.
    /// Using EMT_TRANSPARENT_VERTEX_ALPHA as base material.
    ParallaxMapTransparentVertexAlpha,

    /// BlendFunc = source * sourceFactor + dest * destFactor ( E_BLEND_FUNC )
    /// Using only first texture. Generic blending method.
    OneTextureBlend
}
