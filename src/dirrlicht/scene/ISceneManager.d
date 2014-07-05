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

module dirrlicht.scene.ISceneManager;

import dirrlicht.CompileConfig;
import dirrlicht.IrrlichtDevice;
import dirrlicht.scene.ISceneNodeAnimator;
import dirrlicht.scene.ISceneNode;
import dirrlicht.scene.IMesh;
import dirrlicht.video.IVideoDriver;
import dirrlicht.gui.IGUIEnvironment;
import dirrlicht.io.IFileSystem;
import dirrlicht.scene.IVolumeLightSceneNode;
import dirrlicht.video.SColor;
import dirrlicht.video.ITexture;
import dirrlicht.scene.IMeshCache;
import dirrlicht.scene.IMeshSceneNode;
import dirrlicht.scene.IAnimatedMesh;
import dirrlicht.scene.IAnimatedMeshSceneNode;
import dirrlicht.scene.ICameraSceneNode;
import dirrlicht.core.vector3d;
import dirrlicht.core.dimension2d;
import dirrlicht.SKeyMap;
import dirrlicht.scene.ILightSceneNode;
import dirrlicht.scene.IBillboardSceneNode;
import dirrlicht.scene.IParticleSystemSceneNode;
import dirrlicht.scene.ITerrainSceneNode;
import dirrlicht.scene.ETerrainElements;
import dirrlicht.scene.IMeshBuffer;
import dirrlicht.scene.IShader;
import dirrlicht.scene.IDummyTransformationSceneNode;
import dirrlicht.scene.ITextSceneNode;
import dirrlicht.gui.IGUIFont;
import dirrlicht.scene.IBillboardTextSceneNode;
import dirrlicht.video.SMaterial;
import dirrlicht.video.IImage;
import dirrlicht.scene.ESceneNodeTypes;
import dirrlicht.core.array;
import dirrlicht.scene.ISceneNodeAnimatorCollisionResponse;
import dirrlicht.scene.ITriangleSelector;
import dirrlicht.scene.IMetaTriangleSelector;
import dirrlicht.scene.IMeshLoader;
import dirrlicht.scene.ISceneLoader;
import dirrlicht.scene.ISceneCollisionManager;
import dirrlicht.scene.IMeshManipulator;
import dirrlicht.IEventReceiver;
import dirrlicht.io.IAttributes;
import dirrlicht.scene.ISceneNodeFactory;
import dirrlicht.scene.ISceneNodeAnimatorFactory;
import dirrlicht.scene.ESceneNodeAnimatorTypes;
import dirrlicht.scene.ISceneUserDataSerializer;
import dirrlicht.scene.IMeshWriter;
import dirrlicht.scene.EMeshWriterEnums;
import dirrlicht.scene.ISkinnedMesh;
import dirrlicht.scene.IGeometryCreator;
import dirrlicht.scene.ILightManager;

/// Enumeration for render passes.
/** A parameter passed to the registerNodeForRendering() method of the ISceneManager,
specifying when the node wants to be drawn in relation to the other nodes. */
enum E_SCENE_NODE_RENDER_PASS
{
	/// No pass currently active
	ESNRP_NONE =0,

	/// Camera pass. The active view is set up here. The very first pass.
	ESNRP_CAMERA =1,

	/// In this pass, lights are transformed into camera space and added to the driver
	ESNRP_LIGHT =2,

	/// This is used for sky boxes.
	ESNRP_SKY_BOX =4,

	/// All normal objects can use this for registering themselves.
	/** This value will never be returned by
	ISceneManager::getSceneNodeRenderPass(). The scene manager
	will determine by itself if an object is transparent or solid
	and register the object as SNRT_TRANSPARENT or SNRT_SOLD
	automatically if you call registerNodeForRendering with this
	value (which is default). Note that it will register the node
	only as ONE type. If your scene node has both solid and
	transparent material types register it twice (one time as
	SNRT_SOLID, the other time as SNRT_TRANSPARENT) and in the
	render() method call getSceneNodeRenderPass() to find out the
	current render pass and render only the corresponding parts of
	the node. */
	ESNRP_AUTOMATIC =24,

	/// Solid scene nodes or special scene nodes without materials.
	ESNRP_SOLID =8,

	/// Transparent scene nodes, drawn after solid nodes. They are sorted from back to front and drawn in that order.
	ESNRP_TRANSPARENT =16,

	/// Transparent effect scene nodes, drawn after Transparent nodes. They are sorted from back to front and drawn in that order.
	ESNRP_TRANSPARENT_EFFECT =32,

	/// Drawn after the solid nodes, before the transparent nodes, the time for drawing shadow volumes
	ESNRP_SHADOW =64
}

class ISceneManager
{
    this(IrrlichtDevice dev)
    {
        device = dev;
        ptr = irr_IrrlichtDevice_getSceneManager(device.ptr);
    }

    IAnimatedMesh getMesh(string filename)
    {
        IAnimatedMesh mesh = new IAnimatedMesh(this, filename);
        return mesh;
    }

    IMeshCache getMeshCache()
    {
        auto cache = irr_ISceneManager_getMeshCache(ptr);
        return cast(IMeshCache)cache;
    }

    IVideoDriver getVideoDriver()
    {
        auto driver = irr_ISceneManager_getVideoDriver(ptr);
        return cast(IVideoDriver)driver;
    }

    IGUIEnvironment getGUIEnvironment()
    {
        auto env = irr_ISceneManager_getGUIEnvironment(ptr);
        return cast(IGUIEnvironment)env;
    }

    IFileSystem getFileSystem()
    {
        auto file = irr_ISceneManager_getFileSystem(ptr);
        return cast(IFileSystem)file;
    }

    IVolumeLightSceneNode addVolumeLightSceneNode(ISceneNode parent=null, int id=-1, uint subdivU = 32, uint subdivV = 32, SColor foot = SColor(51, 0, 230, 180), SColor tail = SColor(0, 0, 0, 0), vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f))
    {
        auto tempfoot = irr_SColor(foot.a, foot.b, foot.g, foot.r);
        auto temptail = irr_SColor(tail.a, tail.b, tail.g, tail.r);
        auto temppos = irr_vector3df(position.x, position.y, position.z);
        auto temprot = irr_vector3df(rotation.x, rotation.y, rotation.z);
        auto tempscale = irr_vector3df(scale.x, scale.y, scale.z);

        auto node = irr_ISceneManager_addVolumeLightSceneNode(ptr, parent.ptr, id, subdivU, subdivV, tempfoot, temptail, temppos, temprot, tempscale);
        return cast(IVolumeLightSceneNode)node;
    }

    IMeshSceneNode addCubeSceneNode(float size=10.0, ISceneNode parent=null, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f))
    {
        auto temppos = irr_vector3df(position.x, position.y, position.z);
        auto temprot = irr_vector3df(rotation.x, rotation.y, rotation.z);
        auto tempscale = irr_vector3df(scale.x, scale.y, scale.z);

        irr_IMeshSceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addCubeSceneNode(ptr, size, null, id, temppos, temprot, tempscale);
        else
            node = irr_ISceneManager_addCubeSceneNode(ptr, size, parent.ptr, id, temppos, temprot, tempscale);

        return cast(IMeshSceneNode)node;
    }

    IMeshSceneNode addSphereSceneNode(float radius=5.0, int polycount=16, ISceneNode parent=null, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f))
    {
        auto temppos = irr_vector3df(position.x, position.y, position.z);
        auto temprot = irr_vector3df(rotation.x, rotation.y, rotation.z);
        auto tempscale = irr_vector3df(scale.x, scale.y, scale.z);

        irr_IMeshSceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addSphereSceneNode(ptr, radius, polycount, null, id, temppos, temprot, tempscale);
        else
            node = irr_ISceneManager_addSphereSceneNode(ptr, radius, polycount, parent.ptr, id, temppos, temprot, tempscale);

        return cast(IMeshSceneNode)node;
    }

    IAnimatedMeshSceneNode addAnimatedMeshSceneNode(IAnimatedMesh mesh, ISceneNode parent=null, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f), bool alsoAddIfMeshPointerZero=false)
    {
        return new IAnimatedMeshSceneNode(this, mesh, parent, id, position, rotation, scale, alsoAddIfMeshPointerZero);
    }

    IMeshSceneNode addMeshSceneNode(IMesh mesh, ISceneNode parent=null, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f), bool alsoAddIfMeshPointerZero=false)
    {
        auto temppos = irr_vector3df(position.x, position.y, position.z);
        auto temprot = irr_vector3df(rotation.x, rotation.y, rotation.z);
        auto tempscale = irr_vector3df(scale.x, scale.y, scale.z);

        irr_IMeshSceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addMeshSceneNode(ptr, mesh.ptr, null, id, temppos, temprot, tempscale, alsoAddIfMeshPointerZero);
        else
            node = irr_ISceneManager_addMeshSceneNode(ptr, mesh.ptr, parent.ptr, id, temppos, temprot, tempscale, alsoAddIfMeshPointerZero);

        return cast(IMeshSceneNode)node;
    }

    ISceneNode addWaterSurfaceSceneNode(IMesh mesh,
            float waveHeight=2.0f, float waveSpeed=300.0f, float waveLength=10.0f,
            ISceneNode parent=null, int id=-1,
            vector3df position = vector3df(0,0,0),
            vector3df rotation = vector3df(0,0,0),
            vector3df scale = vector3df(1.0f, 1.0f, 1.0f))
    {
        auto temppos = irr_vector3df(position.x, position.y, position.z);
        auto temprot = irr_vector3df(rotation.x, rotation.y, rotation.z);
        auto tempscale = irr_vector3df(scale.x, scale.y, scale.z);

        irr_ISceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addWaterSurfaceSceneNode(ptr, mesh.ptr, waveHeight, waveSpeed, waveLength, null, id, temppos, temprot, tempscale);
        else
            node = irr_ISceneManager_addWaterSurfaceSceneNode(ptr, mesh.ptr, waveHeight, waveSpeed, waveLength, parent.ptr, id, temppos, temprot, tempscale);

        return cast(ISceneNode)node;
    }

    IMeshSceneNode addOctreeSceneNode(IAnimatedMesh mesh, ISceneNode parent=null, int id=-1, int minimalPolysPerNode=512, bool alsoAddIfMeshPointerZero=false)
    {
        irr_IMeshSceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addOctreeSceneNode(ptr, mesh.ptr, null, id, minimalPolysPerNode, alsoAddIfMeshPointerZero);
        else
            node = irr_ISceneManager_addOctreeSceneNode(ptr, mesh.ptr, parent.ptr, id, minimalPolysPerNode, alsoAddIfMeshPointerZero);

        return cast(IMeshSceneNode)node;
    }

    IMeshSceneNode addOctreeSceneNode(IMesh mesh, ISceneNode parent=null, int id=-1, int minimalPolysPerNode=512, bool alsoAddIfMeshPointerZero=false)
    {
        irr_IMeshSceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addOctreeSceneNode2(ptr, mesh.ptr, null, id, minimalPolysPerNode, alsoAddIfMeshPointerZero);
        else
            node = irr_ISceneManager_addOctreeSceneNode2(ptr, mesh.ptr, parent.ptr, id, minimalPolysPerNode, alsoAddIfMeshPointerZero);

        return cast(IMeshSceneNode)node;
    }

    ICameraSceneNode addCameraSceneNode(ISceneNode parent, vector3df pos, vector3df lookAt, int id=-1, bool makeActive=true)
    {
        auto temppos = irr_vector3df(pos.x, pos.y, pos.z);
        auto templookAt = irr_vector3df(lookAt.x, lookAt.y, lookAt.z);

        auto cameranode = irr_ISceneManager_addCameraSceneNode(ptr, parent.ptr, temppos, templookAt, id, makeActive);
        return cast(ICameraSceneNode)(cameranode);
    }

    ICameraSceneNode addCameraSceneNodeFPS(ISceneNode parent = null,
            float rotateSpeed = 100.0, float moveSpeed = 0.5, int id=-1,
            SKeyMap keyMapArray=null, int keyMapSize=0, bool noVerticalMovement=false,
            float jumpSpeed = 0, bool invertMouse=false,
            bool makeActive=true)
    {
        auto tempmap = irr_SKeyMap(keyMapArray.Action, keyMapArray.KeyCode);
        irr_ICameraSceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addCameraSceneNodeFPS(ptr, null, rotateSpeed, moveSpeed, id, &tempmap, keyMapSize, noVerticalMovement, jumpSpeed, invertMouse, makeActive);
        else
            node = irr_ISceneManager_addCameraSceneNodeFPS(ptr, parent.ptr, rotateSpeed, moveSpeed, id, &tempmap, keyMapSize, noVerticalMovement, jumpSpeed, invertMouse, makeActive);

        return cast(ICameraSceneNode)node;
    }

    ILightSceneNode addLightSceneNode(ISceneNode parent = null,
            vector3df position = vector3df(0,0,0),
            SColorf color = SColorf(1.0f, 1.0f, 1.0f),
            float radius=100., int id=-1)
    {
        auto temppos = irr_vector3df(position.x, position.y, position.z);
        auto tempcolor = irr_SColorf(color.a, color.b, color.g, color.r);

        irr_ILightSceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addLightSceneNode(ptr, null, temppos, tempcolor, radius, id);
        else
            node = irr_ISceneManager_addLightSceneNode(ptr, parent.ptr, temppos, tempcolor, radius, id);

        return cast(ILightSceneNode)node;
    }

    ISceneNodeAnimator createFlyCircleAnimator(vector3df center, float radius=100)
    {
        auto vec = irr_vector3df(center.x, center.y, center.z);
        auto anim = irr_ISceneManager_createFlyCircleAnimator(ptr, vec, radius);
        return cast(ISceneNodeAnimator)anim;
    }

    ISceneNodeAnimator createFlyStraightAnimator(vector3df startPoint, vector3df endPoint, uint timeForWay, bool loop=false, bool pingpong = false)
    {
        auto tempstart = irr_vector3df(startPoint.x, startPoint.y, startPoint.z);
        auto tempend = irr_vector3df(endPoint.x, endPoint.y, endPoint.z);
        auto anim = irr_ISceneManager_createFlyStraightAnimator(ptr, tempstart, tempend, timeForWay, loop, pingpong);
        return cast(ISceneNodeAnimator)anim;
    }

    void drawAll()
    {
        irr_ISceneManager_drawAll(ptr);
    }

    bool isCulled(ISceneNode node)
    {
        return irr_ISceneManager_isCulled(ptr, node.ptr);
    }

    irr_ISceneManager* ptr;
private:
    IrrlichtDevice device;
}

unittest
{
    mixin(TestPrerequisite);

    scope(success)
    {
        auto mesh = smgr.getMesh("../../media/sydney.md2");
        assert(mesh !is null);

        auto meshcache = smgr.getMeshCache();
        assert(meshcache !is null);

        auto videodriver = smgr.getVideoDriver();
        assert(videodriver !is null);

        auto guienv = smgr.getGUIEnvironment();
        assert(guienv !is null);

        auto filesystem = smgr.getFileSystem();
        assert(filesystem !is null);

        auto cube = smgr.addCubeSceneNode();
        assert(cube !is null);

        auto sphere = smgr.addSphereSceneNode();
        assert(sphere !is null);

        auto flycircleanim = smgr.createFlyCircleAnimator(vector3df(0,0,30), 20.0);
        assert(flycircleanim !is null);

        auto flystraightanim = smgr.createFlyStraightAnimator(vector3df(100,0,60), vector3df(-100,0,60), 3500, true);
        assert(flystraightanim !is null);
    }
}

package extern (C):

struct irr_ISceneManager;

irr_IAnimatedMesh* irr_ISceneManager_getMesh(irr_ISceneManager* smgr, const char* file);
irr_IMeshCache* irr_ISceneManager_getMeshCache(irr_ISceneManager* smgr);
irr_IVideoDriver* irr_ISceneManager_getVideoDriver(irr_ISceneManager* smgr);
irr_IGUIEnvironment* irr_ISceneManager_getGUIEnvironment(irr_ISceneManager* smgr);
irr_IFileSystem* irr_ISceneManager_getFileSystem(irr_ISceneManager* smgr);
irr_IVolumeLightSceneNode* irr_ISceneManager_addVolumeLightSceneNode(irr_ISceneManager* smgr, irr_ISceneNode* parent=null, int id=-1, uint subdivU = 32, uint subdivV = 32, irr_SColor foot = irr_SColor(51, 0, 230, 180), irr_SColor tail = irr_SColor(0, 0, 0, 0), irr_vector3df position = irr_vector3df(0,0,0), irr_vector3df rotation = irr_vector3df(0,0,0), irr_vector3df scale = irr_vector3df(1.0f, 1.0f, 1.0f));
irr_IMeshSceneNode* irr_ISceneManager_addCubeSceneNode(irr_ISceneManager* smgr, float size=10.0, irr_ISceneNode* parent=null, int id=-1, irr_vector3df position = irr_vector3df(0,0,0), irr_vector3df rotation = irr_vector3df(0,0,0), irr_vector3df scale = irr_vector3df(1.0f, 1.0f, 1.0f));
irr_IMeshSceneNode* irr_ISceneManager_addSphereSceneNode(irr_ISceneManager* smgr, float radius=5.0f, int polyCount=16, irr_ISceneNode* parent=null, int id=-1, irr_vector3df position = irr_vector3df(0,0,0), irr_vector3df rotation = irr_vector3df(0,0,0), irr_vector3df scale = irr_vector3df(1.0f, 1.0f, 1.0f));
irr_IAnimatedMeshSceneNode* irr_ISceneManager_addAnimatedMeshSceneNode(irr_ISceneManager* smgr, irr_IAnimatedMesh* mesh, irr_ISceneNode* parent=null, int id=-1, irr_vector3df position = irr_vector3df(0,0,0), irr_vector3df rotation = irr_vector3df(0,0,0), irr_vector3df scale = irr_vector3df(1.0f, 1.0f, 1.0f), bool alsoAddIfMeshPointerZero=false);
irr_IMeshSceneNode* irr_ISceneManager_addMeshSceneNode(irr_ISceneManager* smgr, irr_IMesh* mesh, irr_ISceneNode* parent=null, int id=-1, irr_vector3df position = irr_vector3df(0,0,0), irr_vector3df rotation = irr_vector3df(0,0,0), irr_vector3df scale = irr_vector3df(1.0f, 1.0f, 1.0f), bool alsoAddIfMeshPointerZero=false);
irr_ISceneNode* irr_ISceneManager_addWaterSurfaceSceneNode(irr_ISceneManager* smgr, irr_IMesh* mesh,
	float waveHeight=2.0f, float waveSpeed=300.0f, float waveLength=10.0f,
	irr_ISceneNode* parent=null, int id=-1,
	irr_vector3df position = irr_vector3df(0,0,0),
	irr_vector3df rotation = irr_vector3df(0,0,0),
	irr_vector3df scale = irr_vector3df(1.0f, 1.0f, 1.0f));
irr_IMeshSceneNode* irr_ISceneManager_addOctreeSceneNode(irr_ISceneManager* smgr, irr_IAnimatedMesh* mesh, irr_ISceneNode* parent=null,
	int id=-1, int minimalPolysPerNode=512, bool alsoAddIfMeshPointerZero=false);
irr_IMeshSceneNode* irr_ISceneManager_addOctreeSceneNode2(irr_ISceneManager* smgr, irr_IMesh* mesh, irr_ISceneNode* parent=null,
	int id=-1, int minimalPolysPerNode=256, bool alsoAddIfMeshPointerZero=false);

irr_ICameraSceneNode* irr_ISceneManager_addCameraSceneNode(irr_ISceneManager* smgr, irr_ISceneNode* parent, irr_vector3df pos, irr_vector3df lookAt, int id=-1, bool makeActive=true);
irr_ICameraSceneNode* irr_ISceneManager_addCameraSceneNodeMaya(irr_ISceneManager* smgr, irr_ISceneNode* parent=null,
	float rotateSpeed=-1500, float zoomSpeed=200,
	float translationSpeed=1500, int id=-1, float distance=70,
	bool makeActive=true);

irr_ICameraSceneNode* irr_ISceneManager_addCameraSceneNodeFPS(irr_ISceneManager* smgr, irr_ISceneNode* parent = null,
	float rotateSpeed = 100.0, float moveSpeed = 0.5, int id=-1,
	irr_SKeyMap* keyMapArray=null, int keyMapSize=0, bool noVerticalMovement=false,
	float jumpSpeed = 0, bool invertMouse=false,
	bool makeActive=true);

irr_ILightSceneNode* irr_ISceneManager_addLightSceneNode(irr_ISceneManager* smgr, irr_ISceneNode* parent = null,
	irr_vector3df position = irr_vector3df(0,0,0),
	irr_SColorf color = irr_SColorf(1.0f, 1.0f, 1.0f),
	float radius=100., int id=-1);

irr_IBillboardSceneNode* irr_ISceneManager_addBillboardSceneNode(irr_ISceneManager* smgr, irr_ISceneNode* parent = null,
	irr_dimension2df size = irr_dimension2df(10.0, 10.0),
	irr_vector3df position = irr_vector3df(0,0,0), int id=-1,
	irr_SColor colorTop = irr_SColor(0, 0, 0, 0), irr_SColor colorBottom = irr_SColor(0, 0, 0, 0));

irr_ISceneNode* irr_ISceneManager_addSkyBoxSceneNode(irr_ISceneManager* smgr, irr_ITexture* top, irr_ITexture* bottom,
	irr_ITexture* left, irr_ITexture* right, irr_ITexture* front,
	irr_ITexture* back, irr_ISceneNode* parent = null, int id=-1);

irr_ISceneNode* irr_ISceneManager_addSkyDomeSceneNode(irr_ISceneManager* smgr, irr_ITexture* texture,
	uint horiRes=16, uint vertRes=8,
	float texturePercentage=0.9, float spherePercentage=2.0,float radius = 1000,
	irr_ISceneNode* parent=null, int id=-1);

irr_IParticleSystemSceneNode* irr_ISceneManager_addParticleSystemSceneNode(irr_ISceneManager* smgr,
	bool withDefaultEmitter=true, irr_ISceneNode* parent=null, int id=-1,
	irr_vector3df position = irr_vector3df(0, 0, 0),
	irr_vector3df rotation = irr_vector3df(0, 0, 0),
	irr_vector3df scale = irr_vector3df(1.0, 1.0, 1.0));

irr_ITerrainSceneNode* irr_ISceneManager_addTerrainSceneNode(irr_ISceneManager* smgr,
	const char* heightMapFileName,
	irr_ISceneNode* parent=null, int id=-1,
	irr_vector3df position = irr_vector3df(0.0f,0.0f,0.0f),
	irr_vector3df rotation = irr_vector3df(0.0f,0.0f,0.0f),
	irr_vector3df scale = irr_vector3df(1.0f,1.0f,1.0f),
	irr_SColor vertexColor = irr_SColor(255,255,255,255),
	int maxLOD=5, E_TERRAIN_PATCH_SIZE patchSize=E_TERRAIN_PATCH_SIZE.ETPS_17, int smoothFactor=0,
	bool addAlsoIfHeightmapEmpty = false);

irr_IMeshSceneNode* irr_ISceneManager_addQuake3SceneNode(irr_ISceneManager* smgr, const irr_IMeshBuffer* meshBuffer, const irr_IShader * shader,
	irr_ISceneNode* parent=null, int id=-1);

irr_ISceneNode* irr_ISceneManager_addEmptySceneNode(irr_ISceneManager* smgr, irr_ISceneNode* parent=null, int id=-1);

irr_IDummyTransformationSceneNode* irr_ISceneManager_addDummyTransformationSceneNode(irr_ISceneManager* smgr,
	irr_ISceneNode* parent=null, int id=-1);

irr_ITextSceneNode* irr_ISceneManager_addTextSceneNode(irr_ISceneManager* smgr, irr_IGUIFont* font, const(dchar)* text,
	irr_SColor color= irr_SColor(100,255,255,255),
	irr_ISceneNode* parent = null, irr_vector3df position = irr_vector3df(0, 0, 0),
	int id=-1);

irr_IBillboardTextSceneNode* irr_ISceneManager_addBillboardTextSceneNode(irr_ISceneManager* smgr, irr_IGUIFont* font, const(dchar)* text,
	irr_ISceneNode* parent = null,
	irr_dimension2df size = irr_dimension2df(10.0f, 10.0f),
	irr_vector3df position = irr_vector3df(0,0,0), int id=-1,
	irr_SColor colorTop = irr_SColor(0xFFFFFFFF>>24, (0xFFFFFFFF>>16) & 0xff, (0xFFFFFFFF>>8) & 0xff, 0xFFFFFFFF & 0xff), irr_SColor colorBottom = irr_SColor(0xFFFFFFFF>>24, (0xFFFFFFFF>>16) & 0xff, (0xFFFFFFFF>>8) & 0xff, 0xFFFFFFFF & 0xff));

irr_IAnimatedMesh* irr_ISceneManager_addHillPlaneMesh(irr_ISceneManager* smgr, const char* name,
	irr_dimension2df tileSize, irr_dimension2du tileCount,
	irr_SMaterial* material = null, float hillHeight = 0.0f,
	irr_dimension2df countHills = irr_dimension2df(0.0f, 0.0f),
	irr_dimension2df textureRepeatCount = irr_dimension2df(1.0f, 1.0f));

irr_IAnimatedMesh* irr_ISceneManager_addTerrainMesh(irr_ISceneManager* smgr, const char* meshname,
	irr_IImage* texture, irr_IImage* heightmap,
	irr_dimension2df stretchSize = irr_dimension2df(10.0f,10.0f),
	float maxHeight=200.0f,
	irr_dimension2du defaultVertexBlockSize = irr_dimension2du(64,64));

irr_IAnimatedMesh* irr_ISceneManager_addArrowMesh(irr_ISceneManager* smgr, const char* name,
	irr_SColor vtxColorCylinder= irr_SColor(0xFFFFFFFF>>24, (0xFFFFFFFF>>16) & 0xff, (0xFFFFFFFF>>8) & 0xff, 0xFFFFFFFF & 0xff),
	irr_SColor vtxColorCone= irr_SColor(0xFFFFFFFF>>24, (0xFFFFFFFF>>16) & 0xff, (0xFFFFFFFF>>8) & 0xff, 0xFFFFFFFF & 0xff),
	uint tesselationCylinder=4, uint tesselationCone=8,
	float height=1, float cylinderHeight=0.6,
	float widthCylinder=0.05, float widthCone=0.3);

irr_IAnimatedMesh* irr_ISceneManager_addSphereMesh(irr_ISceneManager* smgr, const char* name,
	float radius=5, uint polyCountX = 16,
	uint polyCountY = 16);

irr_IAnimatedMesh* irr_ISceneManager_addVolumeLightMesh(irr_ISceneManager* smgr, const char* name,
	const uint SubdivideU = 32, const uint SubdivideV = 32,
	irr_SColor FootColor = irr_SColor(51, 0, 230, 180),
	irr_SColor TailColor = irr_SColor(0, 0, 0, 0));

irr_ISceneNode* irr_ISceneManager_getRootSceneNode(irr_ISceneManager* smgr);

irr_ISceneNode* irr_ISceneManager_getSceneNodeFromId(irr_ISceneManager* smgr, uint id, irr_ISceneNode* start=null);
irr_ISceneNode* irr_ISceneManager_getSceneNodeFromName(irr_ISceneManager* smgr, const char* name, irr_ISceneNode* start=null);
irr_ISceneNode* irr_ISceneManager_getSceneNodeFromType(irr_ISceneManager* smgr, ESCENE_NODE_TYPE type, irr_ISceneNode* start=null);
void irr_ISceneManager_getSceneNodesFromType(irr_ISceneManager* smgr, ESCENE_NODE_TYPE type,
	irr_array* outNodes,
	irr_ISceneNode* start=null);
irr_ICameraSceneNode* irr_ISceneManager_getActiveCamera(irr_ISceneManager* smgr);
void irr_ISceneManager_setActiveCamera(irr_ISceneManager* smgr, irr_ICameraSceneNode* camera);
void irr_ISceneManager_setShadowColor(irr_ISceneManager* smgr, irr_SColor color = irr_SColor(150,0,0,0));
irr_SColor irr_ISceneManager_getShadowColor(irr_ISceneManager* smgr);
uint irr_ISceneManager_registerNodeForRendering(irr_ISceneManager* smgr, irr_ISceneNode* node,
	E_SCENE_NODE_RENDER_PASS pass = E_SCENE_NODE_RENDER_PASS.ESNRP_AUTOMATIC);

void irr_ISceneManager_drawAll(irr_ISceneManager* smgr);
irr_ISceneNodeAnimator* irr_ISceneManager_createRotationAnimator(irr_ISceneManager* smgr, irr_vector3df rotationSpeed);
irr_ISceneNodeAnimator* irr_ISceneManager_createFlyCircleAnimator(irr_ISceneManager* smgr,
	irr_vector3df center= irr_vector3df(0, 0, 0),
	float radius=100, float speed=0.001f,
	irr_vector3df direction= irr_vector3df(0, 1, 0),
	float startPosition = 0,
	float radiusEllipsoid = 0);

irr_ISceneNodeAnimator* irr_ISceneManager_createFlyStraightAnimator(irr_ISceneManager* smgr, irr_vector3df startPoint, irr_vector3df endPoint, uint timeForWay, bool loop=false, bool pingpong = false);

irr_ISceneNodeAnimator* irr_ISceneManager_createTextureAnimator(irr_ISceneManager* smgr, irr_array* textures, int timePerFrame, bool loop=true);
irr_ISceneNodeAnimator* irr_ISceneManager_createDeleteAnimator(irr_ISceneManager* smgr, uint timeMs);
irr_ISceneNodeAnimatorCollisionResponse* irr_ISceneManager_createCollisionResponseAnimator(irr_ISceneManager* smgr,
	irr_ITriangleSelector* world, irr_ISceneNode* sceneNode,
	irr_vector3df ellipsoidRadius = irr_vector3df(30, 60, 30),
	irr_vector3df gravityPerSecond = irr_vector3df(0, -10.0, 0),
	irr_vector3df ellipsoidTranslation = irr_vector3df(0, 0, 0),
	float slidingValue = 0.0005f);

irr_ISceneNodeAnimator* irr_ISceneManager_createFollowSplineAnimator(irr_ISceneManager* smgr, int startTime,
	irr_array* points,
	float speed = 1.0f, float tightness = 0.5f, bool loop=true, bool pingpong=false);

irr_ITriangleSelector* irr_ISceneManager_createTriangleSelector(irr_ISceneManager* smgr, irr_IMesh* mesh, irr_ISceneNode* node);
irr_ITriangleSelector* irr_ISceneManager_createTriangleSelector2(irr_ISceneManager* smgr, irr_IAnimatedMeshSceneNode* node);
irr_ITriangleSelector* irr_ISceneManager_createTriangleSelectorFromBoundingBox(irr_ISceneManager* smgr, irr_ISceneNode* node);
irr_ITriangleSelector* irr_ISceneManager_createOctreeTriangleSelector(irr_ISceneManager* smgr, irr_IMesh* mesh,
	irr_ISceneNode* node, int minimalPolysPerNode=32);
irr_IMetaTriangleSelector* irr_ISceneManager_createMetaTriangleSelector(irr_ISceneManager* smgr);
irr_ITriangleSelector* irr_ISceneManager_createTerrainTriangleSelector(irr_ISceneManager* smgr,
	irr_ITerrainSceneNode* node, int LOD=0);
void irr_ISceneManager_addExternalMeshLoader(irr_ISceneManager* smgr, irr_IMeshLoader* externalLoader);
int irr_ISceneManager_getMeshLoaderCount(irr_ISceneManager* smgr);
irr_IMeshLoader* irr_ISceneManager_getMeshLoader(irr_ISceneManager* smgr, int index);
void irr_ISceneManager_addExternalSceneLoader(irr_ISceneManager* smgr, irr_ISceneLoader* externalLoader);
uint irr_ISceneManager_getSceneLoaderCount(irr_ISceneManager* smgr);
irr_ISceneLoader* irr_ISceneManager_getSceneLoader(irr_ISceneManager* smgr, uint index);
irr_ISceneCollisionManager* irr_ISceneManager_getSceneCollisionManager(irr_ISceneManager* smgr);
irr_IMeshManipulator* irr_ISceneManager_getMeshManipulator(irr_ISceneManager* smgr);
void irr_ISceneManager_addToDeletionQueue(irr_ISceneManager* smgr, irr_ISceneNode* node);
bool irr_ISceneManager_postEventFromUser(irr_ISceneManager* smgr, irr_SEvent* event);
void irr_ISceneManager_clear(irr_ISceneManager* smgr);
irr_IAttributes* irr_ISceneManager_getParameters(irr_ISceneManager* smgr);
E_SCENE_NODE_RENDER_PASS irr_ISceneManager_getSceneNodeRenderPass(irr_ISceneManager* smgr);
irr_ISceneNodeFactory* irr_ISceneManager_getDefaultSceneNodeFactory(irr_ISceneManager* smgr);
void irr_ISceneManager_registerSceneNodeFactory(irr_ISceneManager* smgr, irr_ISceneNodeFactory* factoryToAdd);
uint irr_ISceneManager_getRegisteredSceneNodeFactoryCount(irr_ISceneManager* smgr);
irr_ISceneNodeFactory* irr_ISceneManager_getSceneNodeFactory(irr_ISceneManager* smgr, uint index);
irr_ISceneNodeAnimatorFactory* irr_ISceneManager_getDefaultSceneNodeAnimatorFactory(irr_ISceneManager* smgr);
void irr_ISceneManager_registerSceneNodeAnimatorFactory(irr_ISceneManager* smgr, irr_ISceneNodeAnimatorFactory* factoryToAdd);
uint irr_ISceneManager_getRegisteredSceneNodeAnimatorFactoryCount(irr_ISceneManager* smgr);
irr_ISceneNodeAnimatorFactory* irr_ISceneManager_getSceneNodeAnimatorFactory(irr_ISceneManager* smgr, uint index);
const char* irr_ISceneManager_getSceneNodeTypeName(irr_ISceneManager* smgr, ESCENE_NODE_TYPE type);
const char* irr_ISceneManager_getAnimatorTypeName(irr_ISceneManager* smgr, ESCENE_NODE_ANIMATOR_TYPE type);
irr_ISceneNode* irr_ISceneManager_addSceneNode(irr_ISceneManager* smgr, const char* sceneNodeTypeName, irr_ISceneNode* parent=null);
irr_ISceneNodeAnimator* irr_ISceneManager_createSceneNodeAnimator(irr_ISceneManager* smgr, const char* typeName, irr_ISceneNode* target=null);
irr_ISceneManager* irr_ISceneManager_createNewSceneManager(irr_ISceneManager* smgr, bool cloneContent=false);
bool irr_ISceneManager_saveScene(irr_ISceneManager* smgr, const char* filename, irr_ISceneUserDataSerializer* userDataSerializer=null, irr_ISceneNode* node=null);
bool irr_ISceneManager_loadScene(irr_ISceneManager* smgr, const char* filename, irr_ISceneUserDataSerializer* userDataSerializer=null, irr_ISceneNode* rootNode=null);
irr_IMeshWriter* irr_ISceneManager_createMeshWriter(irr_ISceneManager* smgr, EMESH_WRITER_TYPE type);
irr_ISkinnedMesh* irr_ISceneManager_createSkinnedMesh(irr_ISceneManager* smgr);
void irr_ISceneManager_setAmbientLight(irr_ISceneManager* smgr, irr_SColorf ambientColor);
irr_SColorf irr_ISceneManager_getAmbientLight(irr_ISceneManager* smgr);
void irr_ISceneManager_setLightManager(irr_ISceneManager* smgr, irr_ILightManager* lightManager);
E_SCENE_NODE_RENDER_PASS irr_ISceneManager_getCurrentRenderPass(irr_ISceneManager* smgr);
const irr_IGeometryCreator* irr_ISceneManager_getGeometryCreator(irr_ISceneManager* smgr);
bool irr_ISceneManager_isCulled(irr_ISceneManager* smgr, const irr_ISceneNode* node);
