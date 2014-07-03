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

module dirrlicht.scene;

public
{
    import dirrlicht.scene.CDynamicMeshBuffer;
    import dirrlicht.scene.CIndexBuffer;
    import dirrlicht.scene.CVertexBuffer;
    import dirrlicht.scene.ECullingTypes;
    import dirrlicht.scene.EDebugSceneTypes;
    import dirrlicht.scene.EHardwareBufferFlags;
    import dirrlicht.scene.EMeshWriterEnums;
    import dirrlicht.scene.ESceneNodeTypes;
    import dirrlicht.scene.ESceneNodeAnimatorTypes;
    import dirrlicht.scene.EPrimitiveTypes;
    import dirrlicht.scene.ETerrainElements;
    import dirrlicht.scene.IAnimatedMesh;
    import dirrlicht.scene.IAnimatedMeshMD2;
    import dirrlicht.scene.IAnimatedMeshMD3;
    import dirrlicht.scene.IAnimatedMeshMD3;
    import dirrlicht.scene.IAnimatedMeshSceneNode;
    import dirrlicht.scene.IBillboardSceneNode;
    import dirrlicht.scene.IBillboardTextSceneNode;
    import dirrlicht.scene.IBoneSceneNode;
    import dirrlicht.scene.ICameraSceneNode;
    import dirrlicht.scene.IDummyTransformationSceneNode;
    import dirrlicht.scene.IGeometryCreator;
    import dirrlicht.scene.IIndexBuffer;
    import dirrlicht.scene.ILightManager;
    import dirrlicht.scene.ILightSceneNode;
    import dirrlicht.scene.IMesh;
    import dirrlicht.scene.IMeshBuffer;
    import dirrlicht.scene.IMeshCache;
    import dirrlicht.scene.IMeshLoader;
    import dirrlicht.scene.IMeshManipulator;
    import dirrlicht.scene.IMeshSceneNode;
    import dirrlicht.scene.IMeshWriter;
    import dirrlicht.scene.IMetaTriangleSelector;
    import dirrlicht.scene.IParticleSystemSceneNode;
    import dirrlicht.scene.ISceneCollisionManager;
    import dirrlicht.scene.ISceneLoader;
    import dirrlicht.scene.ISceneManager;
    import dirrlicht.scene.ISceneNode;
    import dirrlicht.scene.ISceneNodeAnimator;
    import dirrlicht.scene.ISceneNodeAnimatorCollisionResponse;
    import dirrlicht.scene.ISceneNodeAnimatorFactory;
    import dirrlicht.scene.ISceneNodeFactory;
    import dirrlicht.scene.ISceneUserDataSerializer;
    import dirrlicht.scene.IShader;
    import dirrlicht.scene.IShadowVolumeSceneNode;
    import dirrlicht.scene.ISkinnedMesh;
    import dirrlicht.scene.ITerrainSceneNode;
    import dirrlicht.scene.ITextSceneNode;
    import dirrlicht.scene.ITriangleSelector;
    import dirrlicht.scene.IVertexBuffer;
    import dirrlicht.scene.IVolumeLightSceneNode;
    import dirrlicht.scene.SAnimatedMesh;
    import dirrlicht.scene.SceneParameters;
    import dirrlicht.scene.SMesh;
    import dirrlicht.scene.SParticle;
    import dirrlicht.scene.SSkinMeshBuffer;
    import dirrlicht.scene.SVertexManipulator;
    import dirrlicht.scene.SViewFrustum;
}
