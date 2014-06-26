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

module dirrlicht.c.core;

extern (C)
{
    struct irr_vector2di
    {
        int x;
        int y;
    }

    struct irr_vector2df
    {
        float x;
        float y;
    }

    struct irr_vector3di
    {
        int x;
        int y;
        int z;
    }

    struct irr_vector3df
    {
        float x;
        float y;
        float z;
    }

    struct irr_recti
    {
        int x;
        int y;
        int x1;
        int y1;
    }

    struct irr_dimension2du
    {
        uint Width;
        uint Height;
    }

    struct irr_dimension2df
    {
        uint Width;
        uint Height;
    }

    struct irr_triangle3di
    {
        irr_vector3di pointA;
        irr_vector3di pointB;
        irr_vector3di pointC;
    }

    struct irr_triangle3df
    {
        irr_vector3df pointA;
        irr_vector3df pointB;
        irr_vector3df pointC;
    }

    struct irr_aabbox3di
    {
        irr_vector3di MinEdge;
        irr_vector3di MaxEdge;
    }

    struct irr_aabbox3df
    {
        irr_vector3df MinEdge;
        irr_vector3df MaxEdge;
    }

    struct irr_list
    {
        void* data;
    }
}
