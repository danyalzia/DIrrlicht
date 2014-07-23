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

module dirrlicht.video.texture;

import dirrlicht.core.dimension2d;
import dirrlicht.irrlichtdevice;
import dirrlicht.io.filesystem;
import dirrlicht.video.color;
import dirrlicht.video.videodriver;

/// Enumeration flags telling the video driver in which format textures should be created.
enum TextureCreationFlag {
    /// Forces the driver to create 16 bit textures always, independent of
    /// which format the file on disk has. When choosing this you may lose
    /// some color detail, but gain much speed and memory. 16 bit textures can
    /// be transferred twice as fast as 32 bit textures and only use half of
    /// the space in memory.
    /// When using this flag, it does not make sense to use the flags
    /// ETCF_ALWAYS_32_BIT, ETCF_OPTIMIZED_FOR_QUALITY, or
    /// ETCF_OPTIMIZED_FOR_SPEED at the same time.
    Always16Bit = 0x00000001,

    /// Forces the driver to create 32 bit textures always, independent of
    /// which format the file on disk has. Please note that some drivers (like
    /// the software device) will ignore this, because they are only able to
    /// create and use 16 bit textures.
    /// When using this flag, it does not make sense to use the flags
    /// ETCF_ALWAYS_16_BIT, ETCF_OPTIMIZED_FOR_QUALITY, or
    /// ETCF_OPTIMIZED_FOR_SPEED at the same time.
    Always32Bit = 0x00000002,

    /// Lets the driver decide in which format the textures are created and
    /// tries to make the textures look as good as possible. Usually it simply
    /// chooses the format in which the texture was stored on disk.
    /// When using this flag, it does not make sense to use the flags
    /// ETCF_ALWAYS_16_BIT, ETCF_ALWAYS_32_BIT, or ETCF_OPTIMIZED_FOR_SPEED at
    /// the same time.
    OptimizedForQuality = 0x00000004,

    /// Lets the driver decide in which format the textures are created and
    /// tries to create them maximizing render speed.
    /// When using this flag, it does not make sense to use the flags
    /// ETCF_ALWAYS_16_BIT, ETCF_ALWAYS_32_BIT, or ETCF_OPTIMIZED_FOR_QUALITY,
    /// at the same time.
    OptimizedForSpeed = 0x00000008,

    /// Automatically creates mip map levels for the textures.
    CreateMipMaps = 0x00000010,

    /// Discard any alpha layer and use non-alpha color format.
    NoAlphaChannel = 0x00000020,

    /// Allow the Driver to use Non-Power-2-Textures
    /// BurningVideo can handle Non-Power-2 Textures in 2D (GUI), but not in 3D.
    AllowNonPower2 = 0x00000040,
}

/// Enum for the mode for texture locking. Read-Only, write-only or read/write.
enum TextureLockMode {
    /// The default mode. Texture can be read and written to.
    ReadWrite = 0,

    /// Read only. The texture is downloaded, but not uploaded again.
    /// Often used to read back shader generated textures.
    ReadOnly,

    /// Write only. The texture is not downloaded and might be uninitialised.
    /// The updated texture is uploaded to the GPU.
    /// Used for initialising the shader from the CPU.
    WriteOnly
}

/// Where did the last IVideoDriver::getTexture call find this texture
enum TextureSource {
    /// IVideoDriver::getTexture was never called (texture created otherwise)
    Unknown,

    /// Texture has been found in cache
    FromCache,

    /// Texture had to be loaded
    FromFile
}

class Texture { 
    this(irr_ITexture* ptr) {
    	this.ptr = ptr;
    }
    
    irr_ITexture* ptr;
}

package extern(C):

struct irr_ITexture;
