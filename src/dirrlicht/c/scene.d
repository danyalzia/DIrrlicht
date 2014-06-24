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

module dirrlicht.c.scene;

import dirrlicht.c.irrlicht;
import dirrlicht.c.core;
import dirrlicht.c.io;
import dirrlicht.c.video;
import dirrlicht.video.EMaterialFlags;
import dirrlicht.scene.ESceneNodeTypes;
import dirrlicht.scene.IAnimatedMeshMD2;

extern (C)
{
    //! Abstracted and easy to use fixed function/programmable pipeline material modes.
	enum E_MATERIAL_TYPE
	{
		//! Standard solid material.
		/** Only first texture is used, which is supposed to be the
		diffuse material. */
		EMT_SOLID = 0,

		//! Solid material with 2 texture layers.
		/** The second is blended onto the first using the alpha value
		of the vertex colors. This material is currently not implemented in OpenGL.
		*/
		EMT_SOLID_2_LAYER,

		//! Material type with standard lightmap technique
		/** There should be 2 textures: The first texture layer is a
		diffuse map, the second is a light map. Dynamic light is
		ignored. */
		EMT_LIGHTMAP,

		//! Material type with lightmap technique like EMT_LIGHTMAP.
		/** But lightmap and diffuse texture are added instead of modulated. */
		EMT_LIGHTMAP_ADD,

		//! Material type with standard lightmap technique
		/** There should be 2 textures: The first texture layer is a
		diffuse map, the second is a light map. Dynamic light is
		ignored. The texture colors are effectively multiplied by 2
		for brightening. Like known in DirectX as D3DTOP_MODULATE2X. */
		EMT_LIGHTMAP_M2,

		//! Material type with standard lightmap technique
		/** There should be 2 textures: The first texture layer is a
		diffuse map, the second is a light map. Dynamic light is
		ignored. The texture colors are effectively multiplyied by 4
		for brightening. Like known in DirectX as D3DTOP_MODULATE4X. */
		EMT_LIGHTMAP_M4,

		//! Like EMT_LIGHTMAP, but also supports dynamic lighting.
		EMT_LIGHTMAP_LIGHTING,

		//! Like EMT_LIGHTMAP_M2, but also supports dynamic lighting.
		EMT_LIGHTMAP_LIGHTING_M2,

		//! Like EMT_LIGHTMAP_4, but also supports dynamic lighting.
		EMT_LIGHTMAP_LIGHTING_M4,

		//! Detail mapped material.
		/** The first texture is diffuse color map, the second is added
		to this and usually displayed with a bigger scale value so that
		it adds more detail. The detail map is added to the diffuse map
		using ADD_SIGNED, so that it is possible to add and substract
		color from the diffuse map. For example a value of
		(127,127,127) will not change the appearance of the diffuse map
		at all. Often used for terrain rendering. */
		EMT_DETAIL_MAP,

		//! Look like a reflection of the environment around it.
		/** To make this possible, a texture called 'sphere map' is
		used, which must be set as the first texture. */
		EMT_SPHERE_MAP,

		//! A reflecting material with an optional non reflecting texture layer.
		/** The reflection map should be set as first texture. */
		EMT_REFLECTION_2_LAYER,

		//! A transparent material.
		/** Only the first texture is used. The new color is calculated
		by simply adding the source color and the dest color. This
		means if for example a billboard using a texture with black
		background and a red circle on it is drawn with this material,
		the result is that only the red circle will be drawn a little
		bit transparent, and everything which was black is 100%
		transparent and not visible. This material type is useful for
		particle effects. */
		EMT_TRANSPARENT_ADD_COLOR,

		//! Makes the material transparent based on the texture alpha channel.
		/** The final color is blended together from the destination
		color and the texture color, using the alpha channel value as
		blend factor. Only first texture is used. If you are using
		this material with small textures, it is a good idea to load
		the texture in 32 bit mode
		(video::IVideoDriver::setTextureCreationFlag()). Also, an alpha
		ref is used, which can be manipulated using
		SMaterial::MaterialTypeParam. This value controls how sharp the
		edges become when going from a transparent to a solid spot on
		the texture. */
		EMT_TRANSPARENT_ALPHA_CHANNEL,

		//! Makes the material transparent based on the texture alpha channel.
		/** If the alpha channel value is greater than 127, a
		pixel is written to the target, otherwise not. This
		material does not use alpha blending and is a lot faster
		than EMT_TRANSPARENT_ALPHA_CHANNEL. It is ideal for drawing
		stuff like leafes of plants, because the borders are not
		blurry but sharp. Only first texture is used. If you are
		using this material with small textures and 3d object, it
		is a good idea to load the texture in 32 bit mode
		(video::IVideoDriver::setTextureCreationFlag()). */
		EMT_TRANSPARENT_ALPHA_CHANNEL_REF,

		//! Makes the material transparent based on the vertex alpha value.
		EMT_TRANSPARENT_VERTEX_ALPHA,

		//! A transparent reflecting material with an optional additional non reflecting texture layer.
		/** The reflection map should be set as first texture. The
		transparency depends on the alpha value in the vertex colors. A
		texture which will not reflect can be set as second texture.
		Please note that this material type is currently not 100%
		implemented in OpenGL. */
		EMT_TRANSPARENT_REFLECTION_2_LAYER,

		//! A solid normal map renderer.
		/** First texture is the color map, the second should be the
		normal map. Note that you should use this material only when
		drawing geometry consisting of vertices of type
		S3DVertexTangents (EVT_TANGENTS). You can convert any mesh into
		this format using IMeshManipulator::createMeshWithTangents()
		(See SpecialFX2 Tutorial). This shader runs on vertex shader
		1.1 and pixel shader 1.1 capable hardware and falls back to a
		fixed function lighted material if this hardware is not
		available. Only two lights are supported by this shader, if
		there are more, the nearest two are chosen. */
		EMT_NORMAL_MAP_SOLID,

		//! A transparent normal map renderer.
		/** First texture is the color map, the second should be the
		normal map. Note that you should use this material only when
		drawing geometry consisting of vertices of type
		S3DVertexTangents (EVT_TANGENTS). You can convert any mesh into
		this format using IMeshManipulator::createMeshWithTangents()
		(See SpecialFX2 Tutorial). This shader runs on vertex shader
		1.1 and pixel shader 1.1 capable hardware and falls back to a
		fixed function lighted material if this hardware is not
		available. Only two lights are supported by this shader, if
		there are more, the nearest two are chosen. */
		EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR,

		//! A transparent (based on the vertex alpha value) normal map renderer.
		/** First texture is the color map, the second should be the
		normal map. Note that you should use this material only when
		drawing geometry consisting of vertices of type
		S3DVertexTangents (EVT_TANGENTS). You can convert any mesh into
		this format using IMeshManipulator::createMeshWithTangents()
		(See SpecialFX2 Tutorial). This shader runs on vertex shader
		1.1 and pixel shader 1.1 capable hardware and falls back to a
		fixed function lighted material if this hardware is not
		available.  Only two lights are supported by this shader, if
		there are more, the nearest two are chosen. */
		EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA,

		//! Just like EMT_NORMAL_MAP_SOLID, but uses parallax mapping.
		/** Looks a lot more realistic. This only works when the
		hardware supports at least vertex shader 1.1 and pixel shader
		1.4. First texture is the color map, the second should be the
		normal map. The normal map texture should contain the height
		value in the alpha component. The
		IVideoDriver::makeNormalMapTexture() method writes this value
		automatically when creating normal maps from a heightmap when
		using a 32 bit texture. The height scale of the material
		(affecting the bumpiness) is being controlled by the
		SMaterial::MaterialTypeParam member. If set to zero, the
		default value (0.02f) will be applied. Otherwise the value set
		in SMaterial::MaterialTypeParam is taken. This value depends on
		with which scale the texture is mapped on the material. Too
		high or low values of MaterialTypeParam can result in strange
		artifacts. */
		EMT_PARALLAX_MAP_SOLID,

		//! A material like EMT_PARALLAX_MAP_SOLID, but transparent.
		/** Using EMT_TRANSPARENT_ADD_COLOR as base material. */
		EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR,

		//! A material like EMT_PARALLAX_MAP_SOLID, but transparent.
		/** Using EMT_TRANSPARENT_VERTEX_ALPHA as base material. */
		EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA,

		//! BlendFunc = source * sourceFactor + dest * destFactor ( E_BLEND_FUNC )
		/** Using only first texture. Generic blending method. */
		EMT_ONETEXTURE_BLEND,

		//! This value is not used. It only forces this enumeration to compile to 32 bit.
		EMT_FORCE_32BIT = 0x7fffffff
	};

    enum E_JOINT_UPDATE_ON_RENDER
    {
        EJUOR_NONE = 0,
        EJUOR_READ,
        EJUOR_CONTROL
    };

    struct irr_IMesh;
    struct irr_IAnimatedMesh;
    struct irr_ISceneNode;
    struct irr_IAnimatedMeshSceneNode;
    struct irr_ICameraSceneNode;
    struct irr_ISceneManager;
    struct irr_ITriangleSelector;
    struct irr_SMaterial;

    irr_ICameraSceneNode* irr_ISceneManager_addCameraSceneNode(irr_ISceneManager* smgr, irr_IAnimatedMeshSceneNode* parent, irr_vector3df pos, irr_vector3df lookAt);
    irr_ICameraSceneNode* irr_ISceneManager_addCameraSceneNodeFPS(irr_ISceneManager* smgr);
    irr_ISceneNode* irr_ISceneManager_addSphereSceneNode(irr_ISceneManager* smgr);
    irr_ISceneNode* irr_ISceneManager_addCubeSceneNode(irr_ISceneManager* smgr);
    void irr_ISceneManager_drawAll(irr_ISceneManager* smgr);

    struct irr_ISceneNodeAnimator;

    irr_ISceneNodeAnimator* irr_ISceneManager_createFlyCircleAnimator(irr_ISceneManager* smgr, const ref irr_vector3df center, float radius=100);
    irr_ISceneNodeAnimator* irr_ISceneManager_createFlyStraightAnimator(irr_ISceneManager* smgr, const ref irr_vector3df startPoint, const ref irr_vector3df endPoint, uint timeForWay, bool loop=false, bool pingpong = false);

    struct irr_IAttributes;
    struct irr_IShadowVolumeSceneNode;
    struct irr_IBoneSceneNode;
    struct irr_IAnimationEndCallBack;
    struct irr_SMD3QuaternionTag;

    void irr_ISceneNode_addAnimator(irr_ISceneNode* node, irr_ISceneNodeAnimator* animator);
    const ref irr_list irr_ISceneNode_getAnimators(irr_ISceneNode* node);
    void irr_ISceneNode_removeAnimator(irr_ISceneNode* node, irr_ISceneNodeAnimator* animator);
    void irr_ISceneNode_removeAnimators(irr_ISceneNode* node);
    irr_SMaterial* irr_ISceneNode_getMaterial(irr_ISceneNode* node, uint num);
    uint irr_ISceneNode_getMaterialCount(irr_ISceneNode* node);
    void irr_ISceneNode_setMaterialFlag(irr_ISceneNode* node, E_MATERIAL_FLAG flag, bool newvalue);
    void irr_ISceneNode_setMaterialTexture(irr_ISceneNode* node, int c, irr_ITexture* texture);
    void irr_ISceneNode_setMaterialType(irr_ISceneNode* node, E_MATERIAL_TYPE newType);
    const ref irr_vector3df irr_ISceneNode_getScale(irr_ISceneNode* node);
    void irr_ISceneNode_setScale(irr_ISceneNode* node, const ref irr_vector3df scale);
    const ref irr_vector3df irr_ISceneNode_getRotation(irr_ISceneNode* node);
    void irr_ISceneNode_setRotation(irr_ISceneNode* node, const ref irr_vector3df rotation);
    const ref irr_vector3df irr_ISceneNode_getPosition(irr_ISceneNode* node);
    void irr_ISceneNode_setPosition(irr_ISceneNode* node, const ref irr_vector3df newpos);
    irr_vector3df irr_ISceneNode_getAbsolutePosition(irr_ISceneNode* node);
    void irr_ISceneNode_setAutomaticCulling(irr_ISceneNode* node, uint state);
    uint irr_ISceneNode_getAutomaticCulling(irr_ISceneNode* node);
    void irr_ISceneNode_setDebugDataVisible(irr_ISceneNode* node, uint state);
    uint irr_ISceneNode_isDebugDataVisible(irr_ISceneNode* node);
    void irr_ISceneNode_setIsDebugObject(irr_ISceneNode* node, bool debugObject);
    bool irr_ISceneNode_isDebugObject(irr_ISceneNode* node);
    const ref irr_list irr_ISceneNode_getChildren(irr_ISceneNode* node);
    void irr_ISceneNode_setParent(irr_ISceneNode* node, irr_ISceneNode* newParent);
    irr_ITriangleSelector* irr_ISceneNode_getTriangleSelector(irr_ISceneNode* node);
    void irr_ISceneNode_setTriangleSelector(irr_ISceneNode* node, irr_ITriangleSelector* selector);
    void irr_ISceneNode_updateAbsolutePosition(irr_ISceneNode* node);
    irr_ISceneNode* irr_ISceneNode_getParent(irr_ISceneNode* node);
    ESCENE_NODE_TYPE irr_ISceneNode_getType(irr_ISceneNode* node);
    void irr_ISceneNode_serializeAttributes(irr_ISceneNode* node, irr_IAttributes* ou, irr_SAttributeReadWriteOptions* options=null);
    void irr_ISceneNode_deserializeAttributes(irr_ISceneNode* node, irr_IAttributes* i, irr_SAttributeReadWriteOptions* options=null);
    irr_ISceneNode* irr_ISceneNode_clone(irr_ISceneNode* node, irr_ISceneNode* newParent=null, irr_ISceneManager* newManager=null);
    irr_ISceneManager* irr_ISceneNode_getSceneManager(irr_ISceneNode* node);

    void irr_IAnimatedMeshSceneNode_addAnimator(irr_IAnimatedMeshSceneNode* node, irr_ISceneNodeAnimator* animator);
    const ref irr_list irr_IAnimatedMeshSceneNode_getAnimators(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_removeAnimator(irr_IAnimatedMeshSceneNode* node, irr_ISceneNodeAnimator* animator);
    irr_IAnimatedMesh* irr_ISceneManager_getMesh(irr_ISceneManager* smgr, const(char)* file);
    irr_IAnimatedMeshSceneNode* irr_ISceneManager_addAnimatedMeshSceneNode(irr_ISceneManager* smgr, irr_IAnimatedMesh* mesh);
    void irr_IAnimatedMeshSceneNode_setPosition(irr_IAnimatedMeshSceneNode* node, const ref irr_vector3df newpos);
    void irr_IAnimatedMeshSceneNode_setMaterialFlag(irr_IAnimatedMeshSceneNode* node, E_MATERIAL_FLAG flag, bool newvalue);
    void irr_IAnimatedMeshSceneNode_setMaterialTexture(irr_IAnimatedMeshSceneNode* node, int c, irr_ITexture* texture);
    void irr_IAnimatedMeshSceneNode_setScale(irr_IAnimatedMeshSceneNode* node, const ref irr_vector3df scale);
    void irr_IAnimatedMeshSceneNode_setRotation(irr_IAnimatedMeshSceneNode* node, const ref irr_vector3df rotation);

    void irr_IAnimatedMeshSceneNode_setCurrentFrame(irr_IAnimatedMeshSceneNode* node, float frame);
    void irr_IAnimatedMeshSceneNode_setFrameLoop(irr_IAnimatedMeshSceneNode* node, int begin, int end);
    void irr_IAnimatedMeshSceneNode_setAnimationSpeed(irr_IAnimatedMeshSceneNode* node, float framesPerSecond);
    float irr_IAnimatedMeshSceneNode_getAnimationSpeed(irr_IAnimatedMeshSceneNode* node);
    irr_IShadowVolumeSceneNode* irr_IAnimatedMeshSceneNode_addShadowVolumeSceneNode(irr_IAnimatedMeshSceneNode* node, const irr_IMesh* shadowMesh=null, int id=-1, bool zfailmethod=true, float infinity=1000.0f);
    irr_IBoneSceneNode* irr_IAnimatedMeshSceneNode_getJointNode(irr_IAnimatedMeshSceneNode* node, const char* jointName);
    irr_IBoneSceneNode* irr_IAnimatedMeshSceneNode_getJointNodeByID(irr_IAnimatedMeshSceneNode* node, uint jointID);
    uint irr_IAnimatedMeshSceneNode_getJointCount(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_setMD2Animation(irr_IAnimatedMeshSceneNode* node, EMD2_ANIMATION_TYPE value);
    bool irr_IAnimatedMeshSceneNode_setMD2AnimationByName(irr_IAnimatedMeshSceneNode* node, const char* animationName);
    float irr_IAnimatedMeshSceneNode_getFrameNr(irr_IAnimatedMeshSceneNode* node);
    int irr_IAnimatedMeshSceneNode_getStartFrame(irr_IAnimatedMeshSceneNode* node);
    int irr_IAnimatedMeshSceneNode_getEndFrame(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_setLoopMode(irr_IAnimatedMeshSceneNode* node, bool playAnimationLooped);
    bool irr_IAnimatedMeshSceneNode_getLoopMode(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_setAnimationEndCallback(irr_IAnimatedMeshSceneNode* node, irr_IAnimationEndCallBack* callback=null);
    void irr_IAnimatedMeshSceneNode_setReadOnlyMaterials(irr_IAnimatedMeshSceneNode* node, bool readonly);
    bool irr_IAnimatedMeshSceneNode_isReadOnlyMaterials(irr_IAnimatedMeshSceneNode* node);
    void irr_IAnimatedMeshSceneNode_setMesh(irr_IAnimatedMeshSceneNode* node, irr_IAnimatedMesh* mesh);
    irr_IAnimatedMesh* irr_IAnimatedMeshSceneNode_getMesh(irr_IAnimatedMeshSceneNode* node);
    const irr_SMD3QuaternionTag* irr_IAnimatedMeshSceneNode_getMD3TagTransformation(irr_IAnimatedMeshSceneNode* node, const char* tagname);
    void irr_IAnimatedMeshSceneNode_setJointMode(irr_IAnimatedMeshSceneNode* node, E_JOINT_UPDATE_ON_RENDER mode);
    void irr_IAnimatedMeshSceneNode_setTransitionTime(irr_IAnimatedMeshSceneNode* node, float Time);
    void irr_IAnimatedMeshSceneNode_animateJoints(irr_IAnimatedMeshSceneNode* node, bool CalculateAbsolutePositions=true);
    void irr_IAnimatedMeshSceneNode_setRenderFromIdentity(irr_IAnimatedMeshSceneNode* node, bool On);
}
