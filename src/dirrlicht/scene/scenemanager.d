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

module dirrlicht.scene.scenemanager;

import dirrlicht.compileconfig;
import dirrlicht.irrlichtdevice;
import dirrlicht.scene.scenenodeanimator;
import dirrlicht.scene.scenenode;
import dirrlicht.scene.mesh;
import dirrlicht.video.videodriver;
import dirrlicht.gui.guienvironment;
import dirrlicht.io.filesystem;
import dirrlicht.scene.volumelightscenenode;
import dirrlicht.video.color;
import dirrlicht.video.texture;
import dirrlicht.scene.meshcache;
import dirrlicht.scene.meshscenenode;
import dirrlicht.scene.animatedmesh;
import dirrlicht.scene.animatedmeshscenenode;
import dirrlicht.scene.camerascenenode;
import dirrlicht.core.vector3d;
import dirrlicht.core.dimension2d;
import dirrlicht.keymap;
import dirrlicht.scene.lightscenenode;
import dirrlicht.scene.billboardscenenode;
import dirrlicht.scene.particlesystemscenenode;
import dirrlicht.scene.terrainscenenode;
import dirrlicht.scene.terrainelements;
import dirrlicht.scene.meshbuffer;
import dirrlicht.scene.q3shader;
import dirrlicht.scene.dummytransformationscenenode;
import dirrlicht.scene.textscenenode;
import dirrlicht.gui.guifont;
import dirrlicht.scene.billboardtextscenenode;
import dirrlicht.video.material;
import dirrlicht.video.image;
import dirrlicht.scene.scenenodetypes;
import dirrlicht.core.array;
import dirrlicht.scene.scenenodeanimatorcollisionresponse;
import dirrlicht.scene.triangleselector;
import dirrlicht.scene.metatriangleselector;
import dirrlicht.scene.meshloader;
import dirrlicht.scene.sceneloader;
import dirrlicht.scene.scenecollisionmanager;
import dirrlicht.scene.meshmanipulator;
import dirrlicht.eventreceiver;
import dirrlicht.io.attributes;
import dirrlicht.scene.scenenodefactory;
import dirrlicht.scene.scenenodeanimatorfactory;
import dirrlicht.scene.scenenodeanimatortypes;
import dirrlicht.scene.sceneuserdataserializer;
import dirrlicht.scene.meshwriter;
import dirrlicht.scene.meshwriterenums;
import dirrlicht.scene.skinnedmesh;
import dirrlicht.scene.geometrycreator;
import dirrlicht.scene.lightmanager;

import std.conv;
import std.string;

/+++
 + Enumeration for render passes.
 + A parameter passed to the registerNodeForRendering() method of the ISceneManager,
 + specifying when the node wants to be drawn in relation to the other nodes.
 +/
enum SceneNodeRenderPass {
	/// No pass currently active
	None =0,

	/// Camera pass. The active view is set up here. The very first pass.
	Camera =1,

	/// In this pass, lights are transformed into camera space and added to the driver
	Light =2,

	/// This is used for sky boxes.
	SkyBox =4,

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
	Automatic =24,

	/// Solid scene nodes or special scene nodes without materials.
	Solid =8,

	/// Transparent scene nodes, drawn after solid nodes. They are sorted from back to front and drawn in that order.
	Transparent =16,

	/// Transparent effect scene nodes, drawn after Transparent nodes. They are sorted from back to front and drawn in that order.
	TransparentEffect =32,

	/// Drawn after the solid nodes, before the transparent nodes, the time for drawing shadow volumes
	Shadow =64
}

class SceneManager {
    this(irr_ISceneManager* ptr)
    in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }
	
    AnimatedMesh getMesh(string filename) {
    	auto temp = irr_ISceneManager_getMesh(ptr, filename.toStringz);
    	return new CAnimatedMesh(temp);
    }

    MeshCache getMeshCache() {
        auto temp = irr_ISceneManager_getMeshCache(ptr);
        return new MeshCache(temp);
    }

    VideoDriver getVideoDriver() {
        auto driver = irr_ISceneManager_getVideoDriver(ptr);
        return new VideoDriver(driver);
    }

    GUIEnvironment getGUIEnvironment() {
        auto env = irr_ISceneManager_getGUIEnvironment(ptr);
        return new GUIEnvironment(env);
    }

    FileSystem getFileSystem() {
        auto file = irr_ISceneManager_getFileSystem(ptr);
        return new CFileSystem(file);
    }

    VolumeLightSceneNode addVolumeLightSceneNode(SceneNode parent=null, int id=-1, uint subdivU = 32, uint subdivV = 32, Color foot = Color(51, 0, 230, 180).reverse, Color tail = Color(0, 0, 0, 0).reverse, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f)) {
        auto node = irr_ISceneManager_addVolumeLightSceneNode(ptr, cast(irr_ISceneNode*)(parent.c_ptr), id, subdivU, subdivV, foot.ptr, tail.ptr, position.ptr, rotation.ptr, scale.ptr);
        return new VolumeLightSceneNode(node);
    }

    MeshSceneNode addCubeSceneNode(float size=10.0, SceneNode parent=null, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f)) {
        irr_IMeshSceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addCubeSceneNode(ptr, size);
        else
            node = irr_ISceneManager_addCubeSceneNode(ptr, size, cast(irr_ISceneNode*)(parent.c_ptr), id, position.ptr, rotation.ptr, scale.ptr);

        return new MeshSceneNode(node);
    }

    MeshSceneNode addSphereSceneNode(float radius=5.0, int polycount=16, SceneNode parent=null, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f)) {
        irr_IMeshSceneNode* node = null;
        if (parent is null)
            node = irr_ISceneManager_addSphereSceneNode(ptr);
        else
            node = irr_ISceneManager_addSphereSceneNode(ptr, radius, polycount, cast(irr_ISceneNode*)(parent.c_ptr), id, position.ptr, rotation.ptr, scale.ptr);

        return new MeshSceneNode(node);
    }

    AnimatedMeshSceneNode addAnimatedMeshSceneNode(AnimatedMesh mesh, SceneNode parent=null, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f), bool alsoAddIfMeshPointerZero=false) {
    	irr_IAnimatedMeshSceneNode* temp;
    	if (parent is null)
    		temp = irr_ISceneManager_addAnimatedMeshSceneNode(ptr, cast(irr_IAnimatedMesh*)(mesh.c_ptr));
    	else
    		temp = irr_ISceneManager_addAnimatedMeshSceneNode(ptr, cast(irr_IAnimatedMesh*)(mesh.c_ptr), cast(irr_ISceneNode*)(parent.c_ptr), id, position.ptr, rotation.ptr, scale.ptr, alsoAddIfMeshPointerZero);
        
        return new CAnimatedMeshSceneNode(temp);
    }

    MeshSceneNode addMeshSceneNode(Mesh mesh, SceneNode parent=null, int id=-1, vector3df position = vector3df(0,0,0), vector3df rotation = vector3df(0,0,0), vector3df scale = vector3df(1.0f, 1.0f, 1.0f), bool alsoAddIfMeshPointerZero=false) {
        auto temppos = irr_vector3df(position.x, position.y, position.z);
        auto temprot = irr_vector3df(rotation.x, rotation.y, rotation.z);
        auto tempscale = irr_vector3df(scale.x, scale.y, scale.z);

        irr_IMeshSceneNode* temp = null;
        if (parent is null)
            temp = irr_ISceneManager_addMeshSceneNode(ptr, cast(irr_IMesh*)(mesh.c_ptr), null, id, temppos, temprot, tempscale, alsoAddIfMeshPointerZero);
        else
            temp = irr_ISceneManager_addMeshSceneNode(ptr, cast(irr_IMesh*)(mesh.c_ptr), cast(irr_ISceneNode*)(parent.c_ptr), id, temppos, temprot, tempscale, alsoAddIfMeshPointerZero);

        return new MeshSceneNode(temp);
    }

    SceneNode* addWaterSurfaceSceneNode(Mesh mesh,
            float waveHeight=2.0f, float waveSpeed=300.0f, float waveLength=10.0f,
            SceneNode parent=null, int id=-1,
            vector3df position = vector3df(0,0,0),
            vector3df rotation = vector3df(0,0,0),
            vector3df scale = vector3df(1.0f, 1.0f, 1.0f)) {
        auto temppos = irr_vector3df(position.x, position.y, position.z);
        auto temprot = irr_vector3df(rotation.x, rotation.y, rotation.z);
        auto tempscale = irr_vector3df(scale.x, scale.y, scale.z);

        irr_ISceneNode* temp = null;
        if (parent is null)
            temp = irr_ISceneManager_addWaterSurfaceSceneNode(ptr, cast(irr_IMesh*)(mesh.c_ptr), waveHeight, waveSpeed, waveLength, null, id, temppos, temprot, tempscale);
        else
            temp = irr_ISceneManager_addWaterSurfaceSceneNode(ptr, cast(irr_IMesh*)(mesh.c_ptr), waveHeight, waveSpeed, waveLength, cast(irr_ISceneNode*)(parent.c_ptr), id, temppos, temprot, tempscale);
            
            
        SceneNode* node; 
        return node;
    }

    MeshSceneNode addOctreeSceneNode(AnimatedMesh mesh, SceneNode parent=null, int id=-1, int minimalPolysPerNode=512, bool alsoAddIfMeshPointerZero=false) {
        irr_IMeshSceneNode* temp = null;
        if (parent is null)
            temp = irr_ISceneManager_addOctreeSceneNode(ptr, cast(irr_IAnimatedMesh*)(mesh.c_ptr), null, id, minimalPolysPerNode, alsoAddIfMeshPointerZero);
        else
            temp = irr_ISceneManager_addOctreeSceneNode(ptr, cast(irr_IAnimatedMesh*)(mesh.c_ptr), cast(irr_ISceneNode*)(parent.c_ptr), id, minimalPolysPerNode, alsoAddIfMeshPointerZero);

        return new MeshSceneNode(temp);
    }

    MeshSceneNode addOctreeSceneNode(Mesh mesh, SceneNode parent=null, int id=-1, int minimalPolysPerNode=512, bool alsoAddIfMeshPointerZero=false) {
        irr_IMeshSceneNode* temp = null;
        if (parent is null)
            temp = irr_ISceneManager_addOctreeSceneNode2(ptr, cast(irr_IMesh*)(mesh.c_ptr), null, id, minimalPolysPerNode, alsoAddIfMeshPointerZero);
        else
            temp = irr_ISceneManager_addOctreeSceneNode2(ptr, cast(irr_IMesh*)(mesh.c_ptr), cast(irr_ISceneNode*)(parent.c_ptr), id, minimalPolysPerNode, alsoAddIfMeshPointerZero);

        return new MeshSceneNode(temp);
    }

    CameraSceneNode addCameraSceneNode(SceneNode parent, vector3df pos, vector3df lookAt, int id=-1, bool makeActive=true) {
        auto temp = irr_ISceneManager_addCameraSceneNode(ptr, null, pos.ptr, lookAt.ptr, id, makeActive);
        return new CCameraSceneNode(temp);
    }

    CameraSceneNode addCameraSceneNodeFPS() {
        auto temp = irr_ISceneManager_addCameraSceneNodeFPS(ptr);
        
        return new CCameraSceneNode(temp);
    }

    LightSceneNode addLightSceneNode(SceneNode parent = null,
            vector3df position = vector3df(0,0,0),
            Colorf color = Colorf(1.0f, 1.0f, 1.0f),
            float radius=100., int id=-1) {
        irr_ILightSceneNode* temp = null;
        if (parent is null)
            temp = irr_ISceneManager_addLightSceneNode(ptr);
        else
            temp = irr_ISceneManager_addLightSceneNode(ptr, cast(irr_ISceneNode*)(parent.c_ptr), position.ptr, color.ptr, radius, id);

        return new CLightSceneNode(temp);
    }
    
    BillboardSceneNode addBillboardSceneNode(SceneNode parent =null, dimension2df size = dimension2df(10.0, 10.0),
    		vector3df position = vector3df(0,0,0), int id=-1,
    		Color colorTop = Color(0, 0, 0, 0), Color colorBottom = Color(0, 0, 0, 0)) {
    	auto temp = irr_ISceneManager_addBillboardSceneNode(ptr, cast(irr_ISceneNode*)(parent.c_ptr), size.ptr, position.ptr, id, colorTop.ptr, colorBottom.ptr);
    	return new CBillboardSceneNode(temp);
    }
    
    ParticleSystemSceneNode addParticleSystemSceneNode(bool withDefaultEmitter=true, SceneNode parent=null, int id=-1,
    		vector3df position = vector3df(0, 0, 0),
    		vector3df rotation = vector3df(0, 0, 0),
    		vector3df scale = vector3df(1.0, 1.0, 1.0)) {
    	auto temp = irr_ISceneManager_addParticleSystemSceneNode(ptr, withDefaultEmitter, cast(irr_ISceneNode*)(parent.c_ptr), id, position.ptr, rotation.ptr, scale.ptr);
    	return new CParticleSystemSceneNode(temp);
    }
    
    TerrainSceneNode addTerrainSceneNode(string heightMapFileName,
    		SceneNode parent=null, int id=-1,
    		vector3df position = vector3df(0.0f,0.0f,0.0f),
    		vector3df rotation = vector3df(0.0f,0.0f,0.0f),
    		vector3df scale = vector3df(1.0f,1.0f,1.0f),
    		Color vertexColor = Color(255,255,255,255),
    		int maxLOD=5, TerrainPatchSize patchSize=TerrainPatchSize._17, int smoothFactor=0,
    		bool addAlsoIfHeightmapEmpty = false) {
    	auto temp = irr_ISceneManager_addTerrainSceneNode(ptr, heightMapFileName.toStringz, cast(irr_ISceneNode*)(parent.c_ptr), id, position.ptr, rotation.ptr, scale.ptr, vertexColor.ptr, maxLOD, patchSize, smoothFactor, addAlsoIfHeightmapEmpty);
    	return new CTerrainSceneNode(temp);
    }
    
    SceneNode* addSkyBoxSceneNode(Texture top, Texture bottom,
    		Texture left, Texture right, Texture front,
    		Texture back, SceneNode parent = null, int id=-1) {
    	auto temp = irr_ISceneManager_addSkyBoxSceneNode(ptr, top.ptr, bottom.ptr, back.ptr, left.ptr, right.ptr, front.ptr, cast(irr_ISceneNode*)(parent.c_ptr), id);
    	SceneNode* node;
    	return node;
    }
    
    SceneNode* addSkyDomeSceneNode(Texture texture,
    		uint horiRes=16, uint vertRes=8,
    		float texturePercentage=0.9, float spherePercentage=2.0,float radius = 1000,
    		SceneNode parent=null, int id=-1) {
    	auto temp = irr_ISceneManager_addSkyDomeSceneNode(ptr, texture.ptr, horiRes, vertRes, texturePercentage, spherePercentage, radius, cast(irr_ISceneNode*)(parent.c_ptr), id);
    	SceneNode* node;
    	return node;
    }
    
    SceneNodeAnimator createFlyCircleAnimator(vector3df center, float radius=100) {
        auto temp = irr_ISceneManager_createFlyCircleAnimator(ptr, center.ptr, radius);
        return new SceneNodeAnimator(temp);
    }

    SceneNodeAnimator createFlyStraightAnimator(vector3df startPoint, vector3df endPoint, uint timeForWay, bool loop=false, bool pingpong = false) {
        auto temp = irr_ISceneManager_createFlyStraightAnimator(ptr, startPoint.ptr, endPoint.ptr, timeForWay, loop, pingpong);
        return new SceneNodeAnimator(temp);
    }

    void drawAll() {
        irr_ISceneManager_drawAll(ptr);
    }
    
    void addExternalMeshLoader(MeshLoader loader) {
    	irr_ISceneManager_addExternalMeshLoader(ptr, loader.ptr);
    }
    
    uint getMeshLoaderCount() {
    	return irr_ISceneManager_getMeshLoaderCount(ptr);
    }
    
    MeshLoader getMeshLoader(uint index) {
    	auto temp = irr_ISceneManager_getMeshLoader(ptr, index);
    	return new MeshLoader(temp);
    }
    
    void addExternalSceneLoader(SceneLoader loader) {
    	irr_ISceneManager_addExternalSceneLoader(ptr, loader.ptr);
    }
    
    uint getSceneLoaderCount() {
    	return irr_ISceneManager_getSceneLoaderCount(ptr);
    }
    
    SceneLoader getSceneLoader(uint index) {
    	auto temp = irr_ISceneManager_getSceneLoader(ptr, index);
    	return new SceneLoader(temp);
    }
    
    SceneCollisionManager getSceneCollisionManager() {
    	auto temp = irr_ISceneManager_getSceneCollisionManager(ptr);
    	return new SceneCollisionManager(temp);
    }
    
    MeshManipulator getMeshManipulator() {
    	auto temp = irr_ISceneManager_getMeshManipulator(ptr);
    	return new MeshManipulator(temp);
    }
    
    void addToDeletionQueue(SceneNode node) {
    	irr_ISceneManager_addToDeletionQueue(ptr, cast(irr_ISceneNode*)(node.c_ptr));
    }
    
    bool postEventFromUser(SEvent event) {
    	return irr_ISceneManager_postEventFromUser(ptr, event);
    }
    
    void clear() {
    	irr_ISceneManager_clear(ptr);
    }
    
    Attributes getParameters() {
    	auto temp = irr_ISceneManager_getParameters(ptr);
    	return new CAttributes(temp);
    }
    
    SceneNodeRenderPass getSceneNodeRenderPass() {
    	return irr_ISceneManager_getSceneNodeRenderPass(ptr);
    }
    
    SceneNodeFactory getDefaultSceneNodeFactory() {
    	auto temp = irr_ISceneManager_getDefaultSceneNodeFactory(ptr);
    	return new SceneNodeFactory(temp);
    }
    
    void registerSceneNodeFactory(SceneNodeFactory factoryToAdd) {
    	irr_ISceneManager_registerSceneNodeFactory(ptr, factoryToAdd.ptr);
    }
    
    uint getRegisteredSceneNodeFactoryCount() {
    	return irr_ISceneManager_getRegisteredSceneNodeFactoryCount(ptr);
    }
    
    SceneNodeFactory getSceneNodeFactory(uint index) {
    	auto temp = irr_ISceneManager_getSceneNodeFactory(ptr, index);
    	return new SceneNodeFactory(temp);
    }
    
    SceneNodeAnimatorFactory getDefaultSceneNodeAnimatorFactory() {
    	auto temp = irr_ISceneManager_getDefaultSceneNodeAnimatorFactory(ptr);
    	return new SceneNodeAnimatorFactory(temp);
    }
    
    void registerSceneNodeAnimatorFactory(SceneNodeAnimatorFactory factoryToAdd) {
        irr_ISceneManager_registerSceneNodeAnimatorFactory(ptr, factoryToAdd.ptr);
    }

    uint getRegisteredSceneNodeAnimatorFactoryCount() {
        return irr_ISceneManager_getRegisteredSceneNodeAnimatorFactoryCount(ptr);
    }

    SceneNodeAnimatorFactory getSceneNodeAnimatorFactory(uint index) {
        auto temp = irr_ISceneManager_getSceneNodeAnimatorFactory(ptr, index);
        return new SceneNodeAnimatorFactory(temp);
    }

    string getSceneNodeTypeName(SceneNodeType type) {
        auto temp = irr_ISceneManager_getSceneNodeTypeName(ptr, type);
        return to!string(temp);
    }

    string getAnimatorTypeName(SceneNodeAnimatorType type) {
        auto temp = irr_ISceneManager_getAnimatorTypeName(ptr, type);
        return to!string(temp);
    }

    SceneNode* addSceneNode(string sceneNodeTypeName, SceneNode parent=null) {
        auto temp  = irr_ISceneManager_addSceneNode(ptr, toStringz(sceneNodeTypeName), cast(irr_ISceneNode*)(parent.c_ptr));
        SceneNode* node;
    	return node;
    }

    SceneNodeAnimator createSceneNodeAnimator(string typeName, SceneNode target=null) {
        auto temp  = irr_ISceneManager_createSceneNodeAnimator(ptr, toStringz(typeName), cast(irr_ISceneNode*)(target.c_ptr));
        return new SceneNodeAnimator(temp);
    }

    SceneManager createNewSceneManager(bool cloneContent=false) {
        auto temp = irr_ISceneManager_createNewSceneManager(ptr, cloneContent);
        return new SceneManager(temp);
    }

    bool saveScene(string filename, ISceneUserDataSerializer userDataSerializer=null, SceneNode node=null) {
        return irr_ISceneManager_saveScene(ptr, toStringz(filename), userDataSerializer.ptr, cast(irr_ISceneNode*)(node.c_ptr));
    }

    bool loadScene(string filename, ISceneUserDataSerializer userDataSerializer=null, SceneNode rootNode=null) {
        return irr_ISceneManager_loadScene(ptr, toStringz(filename), userDataSerializer.ptr, cast(irr_ISceneNode*)(rootNode.c_ptr));
    }

    MeshWriter createMeshWriter(MeshWriterFlags type) {
        auto temp = irr_ISceneManager_createMeshWriter(ptr, type);
        return new MeshWriter(temp);
    }

    SkinnedMesh createSkinnedMesh() {
        auto temp = irr_ISceneManager_createSkinnedMesh(ptr);
        return new SkinnedMesh(temp);
    }

    void setAmbientLight(Colorf ambientColor) {
        irr_ISceneManager_setAmbientLight(ptr, ambientColor.ptr);
    }

    Colorf getAmbientLight() {
        auto temp = irr_ISceneManager_getAmbientLight(ptr);
        return Colorf(temp.r, temp.g, temp.b, temp.a);
    }

    void setLightManager(LightManager lightManager) {
        irr_ISceneManager_setLightManager(ptr, lightManager.ptr);
    }

    SceneNodeRenderPass getCurrentRenderPass() {
        return irr_ISceneManager_getCurrentRenderPass(ptr);
    }

    GeometryCreator getGeometryCreator() {
        auto temp = irr_ISceneManager_getGeometryCreator(ptr);
        return new GeometryCreator(cast(irr_IGeometryCreator*)(temp));
    }

    bool isCulled(SceneNode node) {
        return irr_ISceneManager_isCulled(ptr, cast(irr_ISceneNode*)(node.c_ptr));
    }
    
    irr_ISceneManager* ptr;
}

unittest
{
    mixin(TestPrerequisite);

    //scope(success)
    //{
        //auto mesh = smgr.getMesh("../media/sydney.md2");
        //assert(mesh !is null);

        //auto meshcache = smgr.getMeshCache();
        //assert(meshcache !is null);

        //auto videodriver = smgr.getVideoDriver();
        //assert(videodriver !is null);

        //auto guienv = smgr.getGUIEnvironment();
        //assert(guienv !is null);

        //auto filesystem = smgr.getFileSystem();
        //assert(filesystem !is null);

        //auto cube = smgr.addCubeSceneNode();
        //assert(cube !is null);

        //auto sphere = smgr.addSphereSceneNode();
        //assert(sphere !is null);

        //auto flycircleanim = smgr.createFlyCircleAnimator(vector3df(0,0,30), 20.0);
        //assert(flycircleanim !is null);

        //auto flystraightanim = smgr.createFlyStraightAnimator(vector3df(100,0,60), vector3df(-100,0,60), 3500, true);
        //assert(flystraightanim !is null);
    //}
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
	int maxLOD=5, TerrainPatchSize patchSize=TerrainPatchSize._17, int smoothFactor=0,
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
irr_ISceneNode* irr_ISceneManager_getSceneNodeFromType(irr_ISceneManager* smgr, SceneNode type, irr_ISceneNode* start=null);
void irr_ISceneManager_getSceneNodesFromType(irr_ISceneManager* smgr, SceneNode type,
	irr_array* outNodes,
	irr_ISceneNode* start=null);
irr_ICameraSceneNode* irr_ISceneManager_getActiveCamera(irr_ISceneManager* smgr);
void irr_ISceneManager_setActiveCamera(irr_ISceneManager* smgr, irr_ICameraSceneNode* camera);
void irr_ISceneManager_setShadowColor(irr_ISceneManager* smgr, irr_SColor color = irr_SColor(150,0,0,0));
irr_SColor irr_ISceneManager_getShadowColor(irr_ISceneManager* smgr);
uint irr_ISceneManager_registerNodeForRendering(irr_ISceneManager* smgr, irr_ISceneNode* node,
	SceneNodeRenderPass pass = SceneNodeRenderPass.Automatic);

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
uint irr_ISceneManager_getMeshLoaderCount(irr_ISceneManager* smgr);
irr_IMeshLoader* irr_ISceneManager_getMeshLoader(irr_ISceneManager* smgr, uint index);
void irr_ISceneManager_addExternalSceneLoader(irr_ISceneManager* smgr, irr_ISceneLoader* externalLoader);
uint irr_ISceneManager_getSceneLoaderCount(irr_ISceneManager* smgr);
irr_ISceneLoader* irr_ISceneManager_getSceneLoader(irr_ISceneManager* smgr, uint index);
irr_ISceneCollisionManager* irr_ISceneManager_getSceneCollisionManager(irr_ISceneManager* smgr);
irr_IMeshManipulator* irr_ISceneManager_getMeshManipulator(irr_ISceneManager* smgr);
void irr_ISceneManager_addToDeletionQueue(irr_ISceneManager* smgr, irr_ISceneNode* node);
bool irr_ISceneManager_postEventFromUser(irr_ISceneManager* smgr, SEvent event);
void irr_ISceneManager_clear(irr_ISceneManager* smgr);
irr_IAttributes* irr_ISceneManager_getParameters(irr_ISceneManager* smgr);
SceneNodeRenderPass irr_ISceneManager_getSceneNodeRenderPass(irr_ISceneManager* smgr);
irr_ISceneNodeFactory* irr_ISceneManager_getDefaultSceneNodeFactory(irr_ISceneManager* smgr);
void irr_ISceneManager_registerSceneNodeFactory(irr_ISceneManager* smgr, irr_ISceneNodeFactory* factoryToAdd);
uint irr_ISceneManager_getRegisteredSceneNodeFactoryCount(irr_ISceneManager* smgr);
irr_ISceneNodeFactory* irr_ISceneManager_getSceneNodeFactory(irr_ISceneManager* smgr, uint index);
irr_ISceneNodeAnimatorFactory* irr_ISceneManager_getDefaultSceneNodeAnimatorFactory(irr_ISceneManager* smgr);
void irr_ISceneManager_registerSceneNodeAnimatorFactory(irr_ISceneManager* smgr, irr_ISceneNodeAnimatorFactory* factoryToAdd);
uint irr_ISceneManager_getRegisteredSceneNodeAnimatorFactoryCount(irr_ISceneManager* smgr);
irr_ISceneNodeAnimatorFactory* irr_ISceneManager_getSceneNodeAnimatorFactory(irr_ISceneManager* smgr, uint index);
const(char*) irr_ISceneManager_getSceneNodeTypeName(irr_ISceneManager* smgr, SceneNodeType type);
const(char*) irr_ISceneManager_getAnimatorTypeName(irr_ISceneManager* smgr, SceneNodeAnimatorType type);
irr_ISceneNode* irr_ISceneManager_addSceneNode(irr_ISceneManager* smgr, const char* sceneNodeTypeName, irr_ISceneNode* parent=null);
irr_ISceneNodeAnimator* irr_ISceneManager_createSceneNodeAnimator(irr_ISceneManager* smgr, const char* typeName, irr_ISceneNode* target=null);
irr_ISceneManager* irr_ISceneManager_createNewSceneManager(irr_ISceneManager* smgr, bool cloneContent=false);
bool irr_ISceneManager_saveScene(irr_ISceneManager* smgr, const char* filename, irr_ISceneUserDataSerializer* userDataSerializer=null, irr_ISceneNode* node=null);
bool irr_ISceneManager_loadScene(irr_ISceneManager* smgr, const char* filename, irr_ISceneUserDataSerializer* userDataSerializer=null, irr_ISceneNode* rootNode=null);
irr_IMeshWriter* irr_ISceneManager_createMeshWriter(irr_ISceneManager* smgr, MeshWriterFlags type);
irr_ISkinnedMesh* irr_ISceneManager_createSkinnedMesh(irr_ISceneManager* smgr);
void irr_ISceneManager_setAmbientLight(irr_ISceneManager* smgr, irr_SColorf ambientColor);
irr_SColorf irr_ISceneManager_getAmbientLight(irr_ISceneManager* smgr);
void irr_ISceneManager_setLightManager(irr_ISceneManager* smgr, irr_ILightManager* lightManager);
SceneNodeRenderPass irr_ISceneManager_getCurrentRenderPass(irr_ISceneManager* smgr);
const(irr_IGeometryCreator*) irr_ISceneManager_getGeometryCreator(irr_ISceneManager* smgr);
bool irr_ISceneManager_isCulled(irr_ISceneManager* smgr, const irr_ISceneNode* node);
