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

module dirrlicht.video.materialflags;

/// Material flags
enum MaterialFlag
{
    /// Draw as wireframe or filled triangles? Default: false
    wireframe = 0x1,

    /// Draw as point cloud or filled triangles? Default: false
    pointCloud = 0x2,

    /// Flat or Gouraud shading? Default: true
    gouraudShading = 0x4,

    /// Will this material be lighted? Default: true
    lighting = 0x8,

    /// Is the ZBuffer enabled? Default: true
    zBuffer = 0x10,

    /// May be written to the zbuffer or is it readonly. Default: true
    /** This flag is ignored, if the material type is a transparent type. */
    zWrite = 0x20,

    /// Is backface culling enabled? Default: true
    backFaceCulling = 0x40,

    /// Is frontface culling enabled? Default: false
    /** Overrides EMF_BACK_FACE_CULLING if both are enabled. */
    frontFaceCulling = 0x80,

    /// Is bilinear filtering enabled? Default: true
    bilinearFilter = 0x100,

    /// Is trilinear filtering enabled? Default: false
    /** If the trilinear filter flag is enabled,
    the bilinear filtering flag is ignored. */
    trilinearFilter = 0x200,

    /// Is anisotropic filtering? Default: false
    /** In Irrlicht you can use anisotropic texture filtering in
    conjunction with bilinear or trilinear texture filtering
    to improve rendering results. Primitives will look less
    blurry with this flag switched on. */
    anisotropicFilter = 0x400,

    /// Is fog enabled? Default: false
    fog = 0x800,

    /// Normalizes normals. Default: false
    /** You can enable this if you need to scale a dynamic lighted
    model. Usually, its normals will get scaled too then and it
    will get darker. If you enable the EMF_NORMALIZE_NORMALS flag,
    the normals will be normalized again, and the model will look
    as bright as it should. */
    normalizeNormals = 0x1000,

    /// Access to all layers texture wrap settings. Overwrites separate layer settings.
    textureWrap = 0x2000,

    /// AntiAliasing mode
    antiAliasing = 0x4000,

    /// ColorMask bits, for enabling the color planes
    colorMask = 0x8000,

    /// ColorMaterial enum for vertex color interpretation
    colorMaterial = 0x10000,

    /// Flag for enabling/disabling mipmap usage
    mipmaps = 0x20000,

    /// Flag for blend operation
    blendOperation = 0x40000,

    /// Flag for polygon offset
    polygonOffset = 0x80000,

    /// Flag for blend factor
    blendFactor = 0x160000
}
