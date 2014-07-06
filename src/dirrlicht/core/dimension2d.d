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

module dirrlicht.core.dimension2d;

struct dimension2d(T)
{
    T Width, Height;
    
    /// internal use only
    static if (is (T == float))
    {
    	@property irr_dimension2df ptr()
    	{
    		return irr_dimension2df(Width, Height);
    	}
    }
    	
    else
    {
    	@property irr_dimension2du ptr()
    	{
    		return irr_dimension2du(Width, Height);
    	}
    }
}

alias dimension2du = dimension2d!(uint);
alias dimension2df = dimension2d!(float);

package extern(C):

struct irr_dimension2du
{
    uint Width;
    uint Height;
}

struct irr_dimension2df
{
    float Width;
    float Height;
}
