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

module dirrlicht.video.light;

import dirrlicht.video.color;
import dirrlicht.core.vector3d;

/// Enumeration for different types of lights
enum LightType {
	/// point light, it has a position in space and radiates light in all directions
	Point,
	/// spot light, it has a position in space, a direction, and a limited cone of influence
	Spot,
	/// directional light, coming from a direction from an infinite distance
	Directional,

	/// Only used for counting the elements of this enum
	Count
}

/+++
 + structure for holding data describing a dynamic point light.
 + Irrlicht supports point lights, spot lights, and directional lights.
 +/
struct Light {
	//! Ambient color emitted by the light
	Colorf AmbientColor;

	//! Diffuse color emitted by the light.
	/** This is the primary color you want to set. */
	Colorf DiffuseColor;

	//! Specular color emitted by the light.
	/** For details how to use specular highlights, see SMaterial::Shininess */
	Colorf SpecularColor;

	//! Attenuation factors (constant, linear, quadratic)
	/** Changes the light strength fading over distance.
	Can also be altered by setting the radius, Attenuation will change to
	(0,1.f/radius,0). Can be overridden after radius was set. */
	vector3df Attenuation;

	//! The angle of the spot's outer cone. Ignored for other lights.
	float OuterCone;

	//! The angle of the spot's inner cone. Ignored for other lights.
	float InnerCone;

	//! The light strength's decrease between Outer and Inner cone.
	float Falloff;

	//! Read-ONLY! Position of the light.
	/** If Type is ELT_DIRECTIONAL, it is ignored. Changed via light scene node's position. */
	vector3df Position;

	//! Read-ONLY! Direction of the light.
	/** If Type is ELT_POINT, it is ignored. Changed via light scene node's rotation. */
	vector3df Direction;

	//! Read-ONLY! Radius of light. Everything within this radius will be lighted.
	float Radius;

	//! Read-ONLY! Type of the light. Default: ELT_POINT
	LightType Type;

	//! Read-ONLY! Does the light cast shadows?
	bool CastShadows;
	
	@property irr_SLight ptr() {
		irr_SLight light;
		light.AmbientColor = AmbientColor; 
		light.DiffuseColor = DiffuseColor;
		light.SpecularColor = SpecularColor;
		light.Attenuation = Attenuation.ptr;
		light.OuterCone = OuterCone;
		light.InnerCone = InnerCone;
		light.Falloff = Falloff;
		light.Position = Position.ptr;
		light.Direction = Direction.ptr;
		light.Radius = Radius;
		light.Type = Type;
		light.CastShadows = CastShadows;
		return light;
	}
}

extern (C):

struct irr_SLight {
	irr_SColorf AmbientColor;
	irr_SColorf DiffuseColor;
	irr_SColorf SpecularColor;
	irr_vector3df Attenuation;
	float OuterCone;
	float InnerCone;
	float Falloff;
	irr_vector3df Position;
	irr_vector3df Direction;
	float Radius;
	LightType Type;
	bool CastShadows;
}
