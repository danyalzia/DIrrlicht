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

module dirrlicht.video.color;

enum ColorFormat {
    /***
     * 16 bit color format used by the software driver.
     * It is thus preferred by all other irrlicht engine video drivers.
     * There are 5 bits for every color component, and a single bit is left
     * for alpha information.
     */
    A1R5G5B5 = 0,

    /// Standard 16 bit color format.
    R5G6B5,

    /// 24 bit color, no alpha channel, but 8 bit for red, green and blue.
    R8G8B8,

    /// Default 32 bit color format. 8 bits are used for every component: red, green, blue and alpha.
    A8R8G8B8,

    /// Compressed image formats.

    /// DXT1 color format.
    DXT1,

    /// DXT2 color format.
    DXT2,

    /// DXT3 color format.
    DXT3,

    /// DXT4 color format.
    DXT4,

    /// DXT5 color format.
    DXT5,

    /// Floating Point formats. The following formats may only be used for render target textures. */

    /// 16 bit floating point format using 16 bits for the red channel.
    R16F,

    /// 32 bit floating point format using 16 bits for the red channel and 16 bits for the green channel.
    G16R16F,

    /// 64 bit floating point format 16 bits are used for the red, green, blue and alpha channels.
    A16B16G16R16F,

    /// 32 bit floating point format using 32 bits for the red channel.
    R32F,

    /// 64 bit floating point format using 32 bits for the red channel and 32 bits for the green channel.
    G32R32F,

    /// 128 bit floating point format. 32 bits are used for the red, green, blue and alpha channels.
    A32B32G32R32F
}

struct Color {
	this(uint r, uint g, uint b, uint a) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}
	
	@property Color reverse() {
		return Color(a,r,g,b);
	}
	
    uint r = 0;
    uint g = 0;
    uint b = 0;
    uint a = 255;
    
    alias ptr this;
	@property irr_SColor ptr() {
		return irr_SColor(a,r,g,b);
	}
}

struct Colorf {
    float r;
    float g;
    float b;
    float a;
    
    alias ptr this;
    @property irr_SColorf ptr() {
		return irr_SColorf(r,g,b,a);
	}
}

package extern (C):

struct irr_SColor {
    uint a;
    uint r;
    uint g;
    uint b;
}

struct irr_SColorf {
    float r;
    float g;
    float b;
    float a;
}
