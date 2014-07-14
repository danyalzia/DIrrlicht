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


module dirrlicht.video.driverfeatures;

/// enumeration for querying features of the video driver.
enum DriverFeature
{
    /// Is driver able to render to a surface?
    RenderToTarget = 0,

    /// Is hardeware transform and lighting supported?
    HardwareTL,

    /// Are multiple textures per material possible?
    Multitexture,

    /// Is driver able to render with a bilinear filter applied?
    BilinearFilter,

    /// Can the driver handle mip maps?
    Mipmap,

    /// Can the driver update mip maps automatically?
    MipmapAutoUpdate,

    /// Are stencilbuffers switched on and does the device support stencil buffers?
    StencilBuffer,

    /// Is Vertex Shader 1.1 supported?
    VertexShader_1_1,

    /// Is Vertex Shader 2.0 supported?
    VertexShader_2_0,

    /// Is Vertex Shader 3.0 supported?
    VertexShader_3_0,

    /// Is Pixel Shader 1.1 supported?
    PixelShader_1_1,

    /// Is Pixel Shader 1.2 supported?
    PixelShader_1_2,

    /// Is Pixel Shader 1.3 supported?
    PixelShader_1_3,

    /// Is Pixel Shader 1.4 supported?
    PixelShader_1_4,

    /// Is Pixel Shader 2.0 supported?
    PixelShader_2_0,

    /// Is Pixel Shader 3.0 supported?
    PixelShader_3_0,

    /// Are ARB vertex programs v1.0 supported?
    ARB_VertexProgram_1,

    /// Are ARB fragment programs v1.0 supported?
    ARB_FragmentProgram_1,

    /// Is GLSL supported?
    ARB_GLSL,

    /// Is HLSL supported?
    HLSL,

    /// Are non-square textures supported?
    TextureNonSquare,

    /// Are non-power-of-two textures supported?
    TextureNonPOT,

    /// Are framebuffer objects supported?
    FrameBufferObject,

    /// Are vertex buffer objects supported?
    VertexBufferObject,

    /// Supports Alpha To Coverage
    AlphaToCoverage,

    /// Supports Color masks (disabling color planes in output)
    ColorMask,

    /// Supports multiple render targets at once
    MultipleRenderTargets,

    /// Supports separate blend settings for multiple render targets
    MRT_Blend,

    /// Supports separate color masks for multiple render targets
    MRT_ColorMask,

    /// Supports separate blend functions for multiple render targets
    MRT_BlendFunc,

    /// Supports geometry shaders
    GeomertyShader,

    /// Supports occlusion queries
    OcclusionQuery,

    /// Supports polygon offset/depth bias for avoiding z-fighting
    PolygonOffset,

    /// Support for different blend functions. Without, only ADD is available
    BlendOperations,

    /// Support for separate blending for RGB and Alpha.
    BlendSeperate,

    /// Support for texture coord transformation via texture matrix
    TextureMatrix,

    /// Support for DXTn compressed textures.
    TextureCompressedDXT,

    /// Only used for counting the elements of this enum
    Count
}
