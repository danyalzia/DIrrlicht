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

module dirrlicht.video.videodriver;

import dirrlicht.compileconfig;
import dirrlicht.core.dimension2d;
import dirrlicht.core.matrix4;
import dirrlicht.core.rect;
import dirrlicht.core.vector2d;
import dirrlicht.core.plane3d;
import dirrlicht.core.matrix4;
import dirrlicht.irrlichtdevice;
import dirrlicht.io.filesystem;
import dirrlicht.video.color;
import dirrlicht.video.texture;
import dirrlicht.video.driverfeatures;
import dirrlicht.io.attributes;
import dirrlicht.video.material;
import dirrlicht.video.texture;
import dirrlicht.video.imageloader;
import dirrlicht.video.imagewriter;
import dirrlicht.video.materialrenderer;
import dirrlicht.scene.meshbuffer;
import dirrlicht.scene.scenenode;
import dirrlicht.scene.mesh;
import dirrlicht.video.light;
import dirrlicht.video.image;
import dirrlicht.io.attributeexchangingobject;
import dirrlicht.video.exposedvideodata;
import dirrlicht.video.drivertypes;
import dirrlicht.video.gpuprogrammingservices;
import dirrlicht.scene.meshmanipulator;

import std.conv : to;
import std.utf : toUTFz;
import std.string : toStringz;

/// enumeration for geometry transformation states
enum TransformationState {
    /// View transformation
    View = 0,
    /// World transformation
    World,
    /// Projection transformation
    Projection,
    /// Texture transformation
    Texture0,
    /// Texture transformation
    Texture1,
    /// Texture transformation
    Texture2,
    /// Texture transformation
    Texture3,
    /// Texture transformation
    Texture4,
    /// Texture transformation
    Texture5,
    /// Texture transformation
    Texture6,
    /// Texture transformation
    Texture7
}

/// enumeration for signaling resources which were lost after the last render cycle
/// These values can be signaled by the driver, telling the app that some resources
/// were lost and need to be recreated. Irrlicht will sometimes recreate the actual objects,
/// but the content needs to be recreated by the application.
enum LostResource {
    /// The whole device/driver is lost
    Device = 1,
    //!/ All texture are lost, rare problem
    Textures = 2,
    /// The Render Target Textures are lost, typical problem for D3D
    RTTS = 4,
    /// The HW buffers are lost, will be recreated automatically, but might require some more time this frame
    HWBuffers = 8
}

/// Special render targets, which usually map to dedicated hardware
/// These render targets (besides 0 and 1) need not be supported by gfx cards
enum RenderTarget {
    /// Render target is the main color frame buffer
    FrameBuffer=0,
    /// Render target is a render texture
    RenderTexture,
    /// Multi-Render target textures
    MultiRenderTexture,
    /// Render target is the main color frame buffer
    StereoLeftBuffer,
    /// Render target is the right color buffer (left is the main buffer)
    StereoRightBuffer,
    /// Render to both stereo buffers at once
    StereoBothBuffers,
    /// Auxiliary buffer 0
    AuxBuffer0,
    /// Auxiliary buffer 1
    AuxBuffer1,
    /// Auxiliary buffer 2
    AuxBuffer2,
    /// Auxiliary buffer 3
    AuxBuffer3,
    /// Auxiliary buffer 4
    AuxBuffer4
}

/// Enum for the types of fog distributions to choose from
enum FogType {
    Exp=0,
    Linear,
    Exp2
}

class VideoDriver {
    this(irr_IVideoDriver* ptr) {
    	this.ptr = ptr;
    }
    
    bool beginScene(bool backBuffer=true, bool zBuffer=true, Color col=Color(0,0,0,255)) {
        return irr_IVideoDriver_beginScene(ptr, backBuffer, zBuffer, irr_SColor(col.a, col.b, col.g, col.r));
    }

    bool endScene() {
        return irr_IVideoDriver_endScene(ptr);
    }

    bool queryFeature(DriverFeature feature) {
        return irr_IVideoDriver_queryFeature(ptr, feature);
    }

    void disableFeature(DriverFeature feature, bool flag=true) {
        irr_IVideoDriver_disableFeature(ptr, feature, flag);
    }

    Attributes getDriverAttributes() {
        auto att = irr_IVideoDriver_getDriverAttributes(ptr);
        return new Attributes(att);
    }

    bool checkDriverReset() {
        return irr_IVideoDriver_checkDriverReset(ptr);
    }

    void setTransform(TransformationState state, matrix4 mat) {
        irr_matrix4 temp;
        foreach(i; 0..16)
        {
            temp.M[i] = mat[i];
        }

        irr_IVideoDriver_setTransform(ptr, state, temp);
    }
    
    matrix4 getTransform(TransformationState state) {
    	auto temp = irr_IVideoDriver_getTransform(ptr, state);
    	matrix4 trans;
    	foreach(i; 0..16)
        {
            trans[i] = temp.M[i];
        }
        
        return trans;
    }
    
    uint getImageLoaderCount() {
    	return irr_IVideoDriver_getImageLoaderCount(ptr);
    }
    
    ImageLoader getImageLoader(uint n) {
    	auto temp = irr_IVideoDriver_getImageLoader(ptr, n);
    	return new ImageLoader(temp);
    }
    
    uint getImageWriterCount() {
    	return irr_IVideoDriver_getImageWriterCount(ptr);
    }
    
    ImageWriter getImageWriter(uint n) {
    	auto temp = irr_IVideoDriver_getImageWriter(ptr, n);
    	return new ImageWriter(temp);
    }
    
    void setMaterial(Material material) {
    	irr_IVideoDriver_setMaterial(ptr, material);
    }
    
    Texture getTexture(string file) {
        auto temp = irr_IVideoDriver_getTexture(ptr, file.toStringz);
        return new Texture(temp);
    }
    
    Texture getTextureByIndex(uint index) {
    	auto temp = irr_IVideoDriver_getTextureByIndex(ptr, index);
    	return new Texture(temp);
    }
    
    uint getTextureCount() {
    	return irr_IVideoDriver_getTextureCount(ptr);
    }
    
    void renameTexture(Texture texture, string newName) {
    	irr_IVideoDriver_renameTexture(ptr, texture, newName.toStringz);
    }
    
    Texture addTexture(dimension2du size, string name, ColorFormat format) {
    	auto temp = irr_IVideoDriver_addTexture(ptr, size, name.toStringz, format);
    	return new Texture(temp);
    }
    
    void makeColorKeyTexture(Texture texture, Color color, bool zeroTexels) {
    	irr_IVideoDriver_makeColorKeyTexture(ptr, texture, color, zeroTexels);
    }
    
    void makeColorKeyTexture(Texture texture, vector2di colorKeyPixelPos, bool zeroTexels) {
    	irr_IVideoDriver_makeColorKeyTexture2(ptr, texture, colorKeyPixelPos, zeroTexels);
    }
    
    void makeNormalMapTexture(Texture texture, float amplitude=1.0f) {
    	irr_IVideoDriver_makeNormalMapTexture(ptr, texture, amplitude);
    }
    
    void setRenderTarget(Texture texture, bool clearBackBuffer, bool clearZBuffer, Color color) {
    	irr_IVideoDriver_setRenderTarget(ptr, texture, clearBackBuffer, clearZBuffer, color);
    }
    
    @property int fps() { return irr_IVideoDriver_getFPS(ptr); }
   
    string name() @property {
        auto temp = irr_IVideoDriver_getName(ptr);
        dstring text = temp[0..strlen(temp)].idup;
        return to!string(text);
    }
    
    void fillMaterialStructureFromAttributes(out Material outMaterial, out Attributes attributes) {
    	irr_IVideoDriver_fillMaterialStructureFromAttributes(ptr, outMaterial, attributes);
    }
    
    // irr_IVideoDriver_getExposedVideoData
    
    DriverType getDriverType() {
    	return irr_IVideoDriver_getDriverType(ptr);
    }
    
    GPUProgrammingServices getGPUProgrammingServices() {
    	auto temp = irr_IVideoDriver_getGPUProgrammingServices(ptr);
    	return new GPUProgrammingServices(temp);
    }
    
    MeshManipulator getMeshManipulator() {
    	auto temp = irr_IVideoDriver_getMeshManipulator(ptr);
    	return new MeshManipulator(temp);
    }
    
    void clearZBuffer() {
    	irr_IVideoDriver_clearZBuffer(ptr);
    }
    
    Image createScreenShot(ColorFormat format, RenderTarget target) {
    	auto temp = irr_IVideoDriver_createScreenShot(ptr, format, target);
    	return new Image(temp);
    }
    
    Texture findTexture(string filename) {
		auto temp = irr_IVideoDriver_findTexture(ptr, filename.toStringz);
		return new Texture(temp);
	}
	
    void setClipPlane(uint index, plane3df plane, bool enable=false) {
		irr_IVideoDriver_setClipPlane(ptr, index, plane, enable);
	}
    
    void enableClipPlane(uint index, bool enable) {
		irr_IVideoDriver_enableClipPlane(ptr, index, enable);
	}
    
	void setMinHardwareBufferVertexCount(uint count) {
		irr_IVideoDriver_setMinHardwareBufferVertexCount(ptr, count);
	}
	
	// irr_IVideoDriver_getOverrideMaterial
	
    Material getMaterial2D() {
    	auto temp = irr_IVideoDriver_getMaterial2D(ptr);
    	return new Material(temp);
    }
    
    void enableMaterial2D(bool enable=true) {
    	irr_IVideoDriver_enableMaterial2D(ptr, enable);
    }
    
    string getVendorInfo() {
    	return irr_IVideoDriver_getVendorInfo(ptr).to!string;
    }
    
    void setAmbientLight(Colorf color) {
    	irr_IVideoDriver_setAmbientLight(ptr, color);
    }
    
    void setAllowZWriteOnTransparent(bool flag) {
    	irr_IVideoDriver_setAllowZWriteOnTransparent(ptr, flag);
    }
    
    dimension2du getMaxTextureSize() {
    	auto size = irr_IVideoDriver_getMaxTextureSize(ptr);
    	return dimension2du(size.Width, size.Height);
    }
    
    void convertColor(const void* sP, ColorFormat sF, int sN, void* dP, ColorFormat dF) {
    	irr_IVideoDriver_convertColor(ptr, sP, sF, sN, dP, dF);
    }
    
	alias ptr this;
    irr_IVideoDriver* ptr;
}

/// strlen for dchar*
private pure nothrow @system size_t strlen(const(dchar)* str) {
    size_t n = 0;
    for (; str[n] != 0; ++n) {}
    return n;
}

/// strlen example
unittest
{
    import std.stdio;
    const(dchar)* text = "Hello const(dchar)*";
    dstring str = text[0..strlen(text)].idup;
    writeln("strlen_test: ", str);
}

/// IVideoDriver example
unittest
{
    mixin(TestPrerequisite);

    driver.beginScene(false, false, Color(0, 0, 0, 255));
    driver.endScene();
    auto shader2 = driver.queryFeature(DriverFeature.PixelShader_2_0);
    
    assert(shader2 == true);
    driver.disableFeature(DriverFeature.PixelShader_2_0, false);

    auto att = driver.getDriverAttributes();
    checkNull(att);

    driver.checkDriverReset();
    driver.setTransform(TransformationState.World, matrix4());

    auto texture = driver.getTexture("../../media/wall.bmp");
    auto texture2 = driver.getTexture("../../media/t351sml.jpg");
    driver.fps;
    auto driverName = driver.name;
    debug writeln("Driver Name: ", driverName);
}

package extern(C):

struct irr_IVideoDriver;
struct irr_SOverrideMaterial;

bool irr_IVideoDriver_beginScene(irr_IVideoDriver* driver, bool backBuffer, bool zBuffer, irr_SColor color);
bool irr_IVideoDriver_endScene(irr_IVideoDriver* driver);
bool irr_IVideoDriver_queryFeature(irr_IVideoDriver* driver, DriverFeature feature);
void irr_IVideoDriver_disableFeature(irr_IVideoDriver* driver, DriverFeature feature, bool flag=true);
irr_IAttributes* irr_IVideoDriver_getDriverAttributes(irr_IVideoDriver* driver);
bool irr_IVideoDriver_checkDriverReset(irr_IVideoDriver* driver);
void irr_IVideoDriver_setTransform(irr_IVideoDriver* driver, TransformationState state, irr_matrix4 mat);
irr_matrix4 irr_IVideoDriver_getTransform(irr_IVideoDriver* driver, TransformationState state);
uint irr_IVideoDriver_getImageLoaderCount(irr_IVideoDriver* driver);
irr_IImageLoader* irr_IVideoDriver_getImageLoader(irr_IVideoDriver* driver, uint n);
uint irr_IVideoDriver_getImageWriterCount(irr_IVideoDriver* driver);
irr_IImageWriter* irr_IVideoDriver_getImageWriter(irr_IVideoDriver* driver, uint n);
void irr_IVideoDriver_setMaterial(irr_IVideoDriver* driver, irr_SMaterial* material);
irr_ITexture* irr_IVideoDriver_getTexture(irr_IVideoDriver* driver, const char* file);
irr_ITexture* irr_IVideoDriver_getTextureByIndex(irr_IVideoDriver* driver, uint index);
uint irr_IVideoDriver_getTextureCount(irr_IVideoDriver* driver);
void irr_IVideoDriver_renameTexture(irr_IVideoDriver* driver, irr_ITexture* texture, const char* newName);
irr_ITexture* irr_IVideoDriver_addTexture(irr_IVideoDriver* driver, irr_dimension2du size, const char* name, ColorFormat format);
//irr_ITexture* irr_IVideoDriver_addTexture(const char* name, irr_IImage* image, void* mipmapData);
irr_ITexture* irr_IVideoDriver_addRenderTargetTexture(irr_IVideoDriver* driver, irr_dimension2du size, const char* name, const ColorFormat);
void irr_IVideoDriver_removeTexture(irr_IVideoDriver* driver, irr_ITexture* texture);
void irr_IVideoDriver_removeAllTextures(irr_IVideoDriver* driver);
void irr_IVideoDriver_removeHardwareBuffer(irr_IVideoDriver* driver, irr_IMeshBuffer* mb);
void irr_IVideoDriver_removeAllHardwareBuffers(irr_IVideoDriver* driver);
void irr_IVideoDriver_addOcclusionQuery(irr_IVideoDriver* driver, irr_ISceneNode* node, irr_IMesh* mesh);
void irr_IVideoDriver_removeOcclusionQuery(irr_IVideoDriver* driver, irr_ISceneNode* node);
void irr_IVideoDriver_removeAllOcclusionQueries(irr_IVideoDriver* driver);
void irr_IVideoDriver_runOcclusionQuery(irr_IVideoDriver* driver, irr_ISceneNode* node, bool visible);
void irr_IVideoDriver_runAllOcclusionQueries(irr_IVideoDriver* driver, bool visible);
void irr_IVideoDriver_updateOcclusionQuery(irr_IVideoDriver* driver, irr_ISceneNode* node, bool block);
void irr_IVideoDriver_updateAllOcclusionQueries(irr_IVideoDriver* driver, bool block);
uint irr_IVideoDriver_getOcclusionQueryResult(irr_IVideoDriver* driver, irr_ISceneNode* node);
void irr_IVideoDriver_makeColorKeyTexture(irr_IVideoDriver* driver, irr_ITexture* texture, irr_SColor color, bool zeroTexels);
void irr_IVideoDriver_makeColorKeyTexture2(irr_IVideoDriver* driver, irr_ITexture* texture, irr_vector2di colorKeyPixelPos, bool zeroTexels = false);
void irr_IVideoDriver_makeNormalMapTexture(irr_IVideoDriver* driver, irr_ITexture* texture, float amplitude=1.0f);
bool irr_IVideoDriver_setRenderTarget(irr_IVideoDriver* driver, irr_ITexture* texture, bool clearBackBuffer, bool clearZBuffer, irr_SColor color);
bool irr_IVideoDriver_setRenderTargetByEnum(irr_IVideoDriver* driver, RenderTarget target, bool clearTarget, bool clearZBuffer, irr_SColor color);

void irr_IVideoDriver_setViewPort(irr_IVideoDriver* driver, irr_recti area);
irr_recti irr_IVideoDriver_getViewPort(irr_IVideoDriver* driver);

void irr_IVideoDriver_setFog(irr_IVideoDriver* driver, irr_SColor color, FogType fogType, float start, float end, float density, bool pixelFog, bool rangeFog);
void irr_IVideoDriver_getFog(irr_IVideoDriver* driver, irr_SColor* color, ref FogType fogType, ref float start, ref float end, ref float density, ref bool pixelFog, ref bool rangeFog);
ColorFormat irr_IVideoDriver_getColorFormat(irr_IVideoDriver* driver);
irr_dimension2du irr_IVideoDriver_getScreenSize(irr_IVideoDriver* driver);
irr_dimension2du irr_IVideoDriver_getCurrentRenderTargetSize(irr_IVideoDriver* driver);
int irr_IVideoDriver_getFPS(irr_IVideoDriver* driver);
uint irr_IVideoDriver_getPrimitiveCountDrawn(irr_IVideoDriver* driver, uint mode =0);
void irr_IVideoDriver_deleteAllDynamicLights(irr_IVideoDriver* driver);
int irr_IVideoDriver_addDynamicLight(irr_IVideoDriver* driver, irr_SLight* light);
uint irr_IVideoDriver_getMaximalDynamicLightAmount(irr_IVideoDriver* driver);
uint irr_IVideoDriver_getDynamicLightCount(irr_IVideoDriver* driver);
irr_SLight* irr_IVideoDriver_getDynamicLight(irr_IVideoDriver* driver, uint idx);
void irr_IVideoDriver_turnLightOn(irr_IVideoDriver* driver, int lightIndex, bool turnOn);
const(dchar)* irr_IVideoDriver_getName(irr_IVideoDriver* driver);
void irr_IVideoDriver_addExternalImageLoader(irr_IVideoDriver* driver, irr_IImageLoader* loader);
void irr_IVideoDriver_addExternalImageWriter(irr_IVideoDriver* driver, irr_IImageWriter* writer);
uint irr_IVideoDriver_getMaximalPrimitiveCount(irr_IVideoDriver* driver);
void irr_IVideoDriver_setTextureCreationFlag(irr_IVideoDriver* driver, TextureCreationFlag flag, bool enabled=true);
bool irr_IVideoDriver_getTextureCreationFlag(irr_IVideoDriver* driver, TextureCreationFlag flag);
irr_IImage* irr_IVideoDriver_createImageFromFile(irr_IVideoDriver* driver, const char* file);
bool irr_IVideoDriver_writeImageToFile(irr_IVideoDriver* driver, irr_IImage* image, const char* filename, uint param = 0);
//  bool irr_IVideoDriver_writeImageToFile(irr_IVideoDriver* driver, irr_IImage* image, irr_IWriteFile* file, uint param =0);
irr_IImage* irr_IVideoDriver_createImageFromData(irr_IVideoDriver* driver, ColorFormat format, irr_dimension2du size, void *data, bool ownForeignMemory=false, bool deleteMemory = true);
irr_IImage* irr_IVideoDriver_createEmptyImage(irr_IVideoDriver* driver, ColorFormat format, irr_dimension2du size);
irr_IImage* irr_IVideoDriver_createImage(irr_IVideoDriver* driver, irr_ITexture* texture, irr_vector2di pos, irr_dimension2du size);
void irr_IVideoDriver_OnResize(irr_IVideoDriver* driver, irr_dimension2du size);
int irr_IVideoDriver_addMaterialRenderer(irr_IVideoDriver* driver, irr_IMaterialRenderer* renderer, const char* name);
irr_IMaterialRenderer* irr_IVideoDriver_getMaterialRenderer(irr_IVideoDriver* driver, uint idx);
uint irr_IVideoDriver_getMaterialRendererCount(irr_IVideoDriver* driver);
const char* irr_IVideoDriver_getMaterialRendererName(irr_IVideoDriver* driver, uint idx);
void irr_IVideoDriver_setMaterialRendererName(irr_IVideoDriver* driver, int idx, const char* name);
irr_IAttributes* irr_IVideoDriver_createAttributesFromMaterial(irr_IVideoDriver* driver, irr_SMaterial* material, irr_SAttributeReadWriteOptions* options);
void irr_IVideoDriver_fillMaterialStructureFromAttributes(irr_IVideoDriver* driver, irr_SMaterial* outMaterial, irr_IAttributes* attributes);
irr_SExposedVideoData* irr_IVideoDriver_getExposedVideoData(irr_IVideoDriver* driver);
DriverType irr_IVideoDriver_getDriverType(irr_IVideoDriver* driver);
irr_IGPUProgrammingServices* irr_IVideoDriver_getGPUProgrammingServices(irr_IVideoDriver* driver);
irr_IMeshManipulator* irr_IVideoDriver_getMeshManipulator(irr_IVideoDriver* driver);
void irr_IVideoDriver_clearZBuffer(irr_IVideoDriver* driver);
irr_IImage* irr_IVideoDriver_createScreenShot(irr_IVideoDriver* driver, ColorFormat format, RenderTarget target);
irr_ITexture* irr_IVideoDriver_findTexture(irr_IVideoDriver* driver, const char* filename);
bool irr_IVideoDriver_setClipPlane(irr_IVideoDriver* driver, uint index, irr_plane3df plane, bool enable=false);
void irr_IVideoDriver_enableClipPlane(irr_IVideoDriver* driver, uint index, bool enable);
void irr_IVideoDriver_setMinHardwareBufferVertexCount(irr_IVideoDriver* driver, uint count);
irr_SOverrideMaterial* irr_IVideoDriver_getOverrideMaterial(irr_IVideoDriver* driver);
irr_SMaterial* irr_IVideoDriver_getMaterial2D(irr_IVideoDriver* driver);
void irr_IVideoDriver_enableMaterial2D(irr_IVideoDriver* driver, bool enable=true);
const(char*) irr_IVideoDriver_getVendorInfo(irr_IVideoDriver* driver);
void irr_IVideoDriver_setAmbientLight(irr_IVideoDriver* driver, irr_SColorf color);
void irr_IVideoDriver_setAllowZWriteOnTransparent(irr_IVideoDriver* driver, bool flag);
irr_dimension2du irr_IVideoDriver_getMaxTextureSize(irr_IVideoDriver* driver);
void irr_IVideoDriver_convertColor(irr_IVideoDriver* driver, const void* sP, ColorFormat sF, int sN, void* dP, ColorFormat dF);
