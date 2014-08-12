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

/***
 * Interface to driver which is able to perform 2d and 3d graphics functions.
 * This interface is one of the most important interfaces of
 * the Irrlicht Engine: All rendering and texture manipulation is done with
 * this interface. You are able to use the Irrlicht Engine by only
 * invoking methods of this interface if you like to, although the
 * SceneManager interface provides a lot of powerful classes
 * and methods to make the programmer's life easier.
 */
class VideoDriver {
    this(irr_IVideoDriver* ptr)
	in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }

    /***
     * Applications must call this method before performing any rendering.
     * This method can clear the back- and the z-buffer.
     * Params:
     *  backBuffer = Specifies if the back buffer should be
     * 		cleared, which means that the screen is filled with the color
     * 		specified. If this parameter is false, the back buffer will
     * 		not be cleared and the color parameter is ignored.
     * zBuffer = Specifies if the depth buffer (z buffer) should
     * 		be cleared. It is not nesesarry to do so if only 2d drawing is
     * 		used.
     * col =  The color used for back buffer clearing
     * videoData = Handle of another window, if you want the
     * 		bitmap to be displayed on another window. If this is an empty
     * 		element, everything will be displayed in the default window.
     * Note: This feature is not fully implemented for all devices.
     * sourceRect = Pointer to a rectangle defining the source
     * 		rectangle of the area to be presented. Set to null to present
     * 		everything. Note: not implemented in all devices.
     * Return: False if failed.
     */
    bool beginScene(bool backBuffer=true, bool zBuffer=true, Color col=Color(0,0,0,255)) {
        return irr_IVideoDriver_beginScene(ptr, backBuffer, zBuffer, irr_SColor(col.a, col.b, col.g, col.r));
    }

	/***
	 * Presents the rendered image to the screen.
	 * Applications must call this method after performing any
	 * rendering.
	 * Return: False if failed and true if succeeded.
	 */
    bool endScene() {
        return irr_IVideoDriver_endScene(ptr);
    }

	/***
	 * Queries the features of the driver.
	 * Returns true if a feature is available
	 * Params:
	 *  feature = Feature to query.
	 * Return: True if the feature is available, false if not.
	 */
    bool queryFeature(DriverFeature feature) {
        return irr_IVideoDriver_queryFeature(ptr, feature);
    }

	/***
	 * Disable a feature of the driver.
	 * Can also be used to enable the features again. It is not
	 * possible to enable unsupported features this way, though.
	 * Params:
	 *  feature = Feature to disable.
	 *  flag = When true the feature is disabled, otherwise it is enabled.
	 */
    void disableFeature(DriverFeature feature, bool flag=true) {
        irr_IVideoDriver_disableFeature(ptr, feature, flag);
    }

	/***
	 * Get attributes of the actual video driver
	 * The following names can be queried for the given types:
	 * MaxTextures (int) The maximum number of simultaneous textures supported by the driver. This can be less than the supported number of textures of the driver. Use _IRR_MATERIAL_MAX_TEXTURES_ to adapt the number.
	 * MaxSupportedTextures (int) The maximum number of simultaneous textures supported by the fixed function pipeline of the (hw) driver. The actual supported number of textures supported by the engine can be lower.
	 * MaxLights (int) Number of hardware lights supported in the fixed function pipieline of the driver, typically 6-8. Use light manager or deferred shading for more.
	 * MaxAnisotropy (int) Number of anisotropy levels supported for filtering. At least 1, max is typically at 16 or 32.
	 * MaxUserClipPlanes (int) Number of additional clip planes, which can be set by the user via dedicated driver methods.
	 * MaxAuxBuffers (int) Special render buffers, which are currently not really usable inside Irrlicht. Only supported by OpenGL
	 * MaxMultipleRenderTargets (int) Number of render targets which can be bound simultaneously. Rendering to MRTs is done via shaders.
	 * MaxIndices (int) Number of indices which can be used in one render call (i.e. one mesh buffer).
	 * MaxTextureSize (int) Dimension that a texture may have, both in width and height.
	 * MaxGeometryVerticesOut (int) Number of vertices the geometry shader can output in one pass. Only OpenGL so far.
	 * MaxTextureLODBias (float) Maximum value for LOD bias. Is usually at around 16, but can be lower on some systems.
	 * Version (int) Version of the driver. Should be Major*100+Minor
	 * ShaderLanguageVersion (int) Version of the high level shader language. Should be Major*100+Minor.
	 * AntiAlias (int) Number of Samples the driver uses for each pixel. 0 and 1 means anti aliasing is off, typical values are 2,4,8,16,32
	 */
	Attributes getDriverAttributes() {
        auto att = irr_IVideoDriver_getDriverAttributes(ptr);
        return new CAttributes(att);
    }

	/***
	 * Check if the driver was recently reset.
	 * For d3d devices you will need to recreate the RTTs if the
	 * driver was reset. Should be queried right after beginScene().
	 */
    bool checkDriverReset() {
        return irr_IVideoDriver_checkDriverReset(ptr);
    }

	/***
	 * Sets transformation matrices.
	 * param state Transformation type to be set, e.g. view,
	 * world, or projection.
	 * Params:
	 *  mat = Matrix describing the transformation.
	 */
    void setTransform(TransformationState state, matrix4 mat) {
        irr_matrix4 temp;
        foreach(i; 0..16)
        {
            temp.M[i] = mat[i];
        }

        irr_IVideoDriver_setTransform(ptr, state, temp);
    }

    /***
     * Returns the transformation set by setTransform
     * Params:
     *  state Transformation type to query
     * Return: Matrix describing the transformation.
     */
	matrix4 getTransform(TransformationState state) {
    	auto temp = irr_IVideoDriver_getTransform(ptr, state);
    	matrix4 trans;
    	foreach(i; 0..16)
        {
            trans[i] = temp.M[i];
        }
        
        return trans;
    }

    /***
     * Retrieve the number of image loaders
     * Return: Number of image loaders
     */
    uint getImageLoaderCount() {
    	return irr_IVideoDriver_getImageLoaderCount(ptr);
    }

    /***
     * Retrieve the given image loader
     * Params:
     *  n = The index of the loader to retrieve. This parameter is an 0-based
     * 		array index.
     * Return: A pointer to the specified loader, 0 if the index is incorrect.
     */
    ImageLoader getImageLoader(uint n) {
    	auto temp = irr_IVideoDriver_getImageLoader(ptr, n);
    	return new CImageLoader(temp);
    }

    /***
     * Retrieve the number of image writers
     * Return: Number of image writers
     */
    uint getImageWriterCount() {
    	return irr_IVideoDriver_getImageWriterCount(ptr);
    }

    /***
     * Retrieve the given image writer
     * Params:
     *  n = The index of the writer to retrieve. This parameter is an 0-based
     * 		array index.
     * Return: A pointer to the specified writer, 0 if the index is incorrect.
     */
    ImageWriter getImageWriter(uint n) {
    	auto temp = irr_IVideoDriver_getImageWriter(ptr, n);
    	return new CImageWriter(temp);
    }

    /***
     * Sets a material.
     * All 3d drawing functions will draw geometry using this material thereafter.
     * Params:
     *  material = Material to be used from now on.
     */
    void setMaterial(Material material) {
    	irr_IVideoDriver_setMaterial(ptr, material.ptr);
    }

    /***
     * Get access to a named texture.
     * Loads the texture from disk if it is not
     * already loaded and generates mipmap levels if desired.
     * Texture loading can be influenced using the
     * setTextureCreationFlag() method. The texture can be in several
     * imageformats, such as BMP, JPG, TGA, PCX, PNG, and PSD.
     * Params:
     *  filename = Filename of the texture to be loaded.
     * Return: Pointer to the texture, or 0 if the texture
     * could not be loaded. This pointer should not be dropped. See
     * drop() for more information.
     */
    Texture getTexture(string file) {
        auto temp = irr_IVideoDriver_getTexture(ptr, file.toStringz);
        return new Texture(temp);
    }

    /***
     * Returns a texture by index
     * Params:
     *  index = Index of the texture, must be smaller than
     * 		getTextureCount() Please note that this index might change when
     * 		adding or removing textures
     * 		return Pointer to the texture, or 0 if the texture was not
     * 		set or index is out of bounds. This pointer should not be
     * 		dropped. See IReferenceCounted::drop() for more information.
     */
    Texture getTextureByIndex(uint index) {
    	auto temp = irr_IVideoDriver_getTextureByIndex(ptr, index);
    	return new Texture(temp);
    }

    /***
     * Returns amount of textures currently loaded
     * Return: Amount of textures currently loaded
     */
    uint getTextureCount() {
    	return irr_IVideoDriver_getTextureCount(ptr);
    }

    /***
     * Renames a texture
     * Params:
     *  texture = Pointer to the texture to rename.
     * 	newName = New name for the texture. This should be a unique name.
     */
    void renameTexture(Texture texture, string newName) {
    	irr_IVideoDriver_renameTexture(ptr, texture.ptr, newName.toStringz);
    }

    /***
     * Creates an empty texture of specified size.
     * param size: Size of the texture.
     * param name A name for the texture. Later calls to
     * getTexture() with this name will return this texture
     * param format Desired color format of the texture. Please note
     * that the driver may choose to create the texture in another
     * color format.
     * return Pointer to the newly created texture. This pointer
     * should not be dropped. See drop() for more
     * information.
     */
    Texture addTexture(dimension2du size, string name, ColorFormat format) {
    	auto temp = irr_IVideoDriver_addTexture(ptr, size.ptr, name.toStringz, format);
    	return new Texture(temp);
    }

	/***
	 * Adds a new render target texture to the texture cache.
	 * Params:
	 *  size = Size of the texture, in pixels. Width and
	 * 		height should be a power of two (e.g. 64, 128, 256, 512, ...)
	 * 		and it should not be bigger than the backbuffer, because it
	 * 		shares the zbuffer with the screen buffer.
	 * name = An optional name for the RTT.
	 * format = The color format of the render target. Floating point formats are supported.
	 * Return: Pointer to the created texture or 0 if the texture
	 * could not be created. This pointer should not be dropped. See
	 * drop() for more information.
	 */
    Texture addRenderTargetTexture(dimension2du size, string name, const ColorFormat format) {
		auto temp = irr_IVideoDriver_addRenderTargetTexture(ptr, size, name.toStringz, format);
		return new Texture(temp);
	}

	/***
	 * Removes a texture from the texture cache and deletes it.
	 * This method can free a lot of memory!
	 * Please note that after calling this, the pointer to the
	 * Texture may no longer be valid, if it was not grabbed before
	 * by other parts of the engine for storing it longer. So it is a
	 * good idea to set all materials which are using this texture to
	 * 0 or another texture first.
	 * Params:
	 *  texture = Texture to delete from the engine cache.
	 */
	void removeTexture(Texture texture) {
		irr_IVideoDriver_removeTexture(ptr, texture.ptr);
	}

	/***
	 * Removes all textures from the texture cache and deletes them.
	 * This method can free a lot of memory!
	 * Please note that after calling this, the pointer to the
	 * Texture may no longer be valid, if it was not grabbed before
	 * by other parts of the engine for storing it longer. So it is a
	 * good idea to set all materials which are using this texture to
	 * 0 or another texture first.
	 */
	void removeAllTextures() {
		irr_IVideoDriver_removeAllTextures(ptr);
	}

	/// Remove hardware buffer
	void removeHardwareBuffer(MeshBuffer mb) {
		irr_IVideoDriver_removeHardwareBuffer(ptr, mb.ptr);
	}

	/// Remove all hardware buffers
	void removeAllHardwareBuffers() {
		irr_IVideoDriver_removeAllHardwareBuffers(ptr);
	}

	/***
	 * Create occlusion query.
	 * Use node for identification and mesh for occlusion test.
	 */
	void addOcclusionQuery(SceneNode node, Mesh mesh) {
		irr_IVideoDriver_addOcclusionQuery(ptr, cast(irr_ISceneNode*)(node.c_ptr), cast(irr_IMesh*)(mesh.c_ptr));
	}

	/// Remove occlusion query.
	void removeOcclusionQuery(SceneNode node) {
		irr_IVideoDriver_removeOcclusionQuery(ptr, cast(irr_ISceneNode*)(node.c_ptr));
	}

	/// Remove all occlusion queries.
	void removeAllOcclusionQueries() {
		irr_IVideoDriver_removeAllOcclusionQueries(ptr);
	}

	/***
	 * Run occlusion query. Draws mesh stored in query.
	 * If the mesh shall not be rendered visible, use
	 * overrideMaterial to disable the color and depth buffer.
	 */
	void runOcclusionQuery(SceneNode node, bool visible) {
		irr_IVideoDriver_runOcclusionQuery(ptr, cast(irr_ISceneNode*)(node.c_ptr), visible);
	}

	/***
	 * Run all occlusion queries. Draws all meshes stored in queries.
	 * If the meshes shall not be rendered visible, use
	 * overrideMaterial to disable the color and depth buffer.
	 */
	void runAllOcclusionQueries(bool visible) {
		irr_IVideoDriver_runAllOcclusionQueries(ptr, visible);
	}

	/***
	 * Update occlusion query. Retrieves results from GPU.
	 * If the query shall not block, set the flag to false.
	 * Update might not occur in this case, though
	 */
	void updateOcclusionQuery(SceneNode node, bool block) {
		irr_IVideoDriver_updateOcclusionQuery(ptr, cast(irr_ISceneNode*)(node.c_ptr), block);
	}

	/***
	 * Update all occlusion queries. Retrieves results from GPU.
	 * If the query shall not block, set the flag to false.
	 * Update might not occur in this case, though
	 */
	void updateAllOcclusionQueries(bool block) {
		irr_IVideoDriver_updateAllOcclusionQueries(ptr, block);
	}

	/***
	 * Return: query result.
	 * Return value is the number of visible pixels/fragments.
	 * The value is a safe approximation, i.e. can be larger than the
	 * actual value of pixels.
	 */
	uint getOcclusionQueryResult(SceneNode node) {
		return irr_IVideoDriver_getOcclusionQueryResult(ptr, cast(irr_ISceneNode*)(node.c_ptr));
	}

	/***
	 * Sets a boolean alpha channel on the texture based on a color key.
	 * This makes the texture fully transparent at the texels where
	 * this color key can be found when using for example draw2DImage
	 * with useAlphachannel==true.  The alpha of other texels is not modified.
	 * Params:
	 *  texture = Texture whose alpha channel is modified.
	 *  color = Color key color. Every texel with this color will
	 * 		become fully transparent as described above. Please note that the
	 * 		colors of a texture may be converted when loading it, so the
	 * 		color values may not be exactly the same in the engine and for
	 * 		example in picture edit programs. To avoid this problem, you
	 * 		could use the makeColorKeyTexture method, which takes the
	 * 		position of a pixel instead a color value.
	 * zeroTexels = If set to true, then any texels that match
	 * 		the color key will have their color, as well as their alpha, set to zero
	 * 		(i.e. black). This behavior matches the legacy (buggy) behavior prior
	 * 		to release 1.5 and is provided for backwards compatibility only.
	 * 		This parameter may be removed by Irrlicht 1.9.
	 */
    void makeColorKeyTexture(Texture texture, Color color, bool zeroTexels) {
    	irr_IVideoDriver_makeColorKeyTexture(ptr, texture.ptr, color, zeroTexels);
    }

    /***
     * Sets a boolean alpha channel on the texture based on the color at a position.
     * This makes the texture fully transparent at the texels where
     * the color key can be found when using for example draw2DImage
     * with useAlphachannel==true.  The alpha of other texels is not modified.
     * param texture Texture whose alpha channel is modified.
     * param colorKeyPixelPos Position of a pixel with the color key
     * color. Every texel with this color will become fully transparent as
     * described above.
     * Params:
     *  zeroTexels = If set to true, then any texels that match
     * 		the color key will have their color, as well as their alpha, set to zero
     * 		(i.e. black). This behavior matches the legacy (buggy) behavior prior
     * 		to release 1.5 and is provided for backwards compatibility only.
     * 		This parameter may be removed by Irrlicht 1.9.
     */
    void makeColorKeyTexture(Texture texture, vector2di colorKeyPixelPos, bool zeroTexels) {
    	irr_IVideoDriver_makeColorKeyTexture2(ptr, texture.ptr, colorKeyPixelPos, zeroTexels);
    }

    /***
     * Creates a normal map from a height map texture.
     * If the target texture has 32 bit, the height value is
     * stored in the alpha component of the texture as addition. This
     * value is used by the video::EMT_PARALLAX_MAP_SOLID material and
     * similar materials.
     * Params:
     *  texture = Texture whose alpha channel is modified.
     *  amplitude = Constant value by which the height
     * 		information is multiplied.
     */
    void makeNormalMapTexture(Texture texture, float amplitude=1.0f) {
    	irr_IVideoDriver_makeNormalMapTexture(ptr, texture.ptr, amplitude);
    }

    /***
     * Sets a new render target.
     * This will only work if the driver supports the
     * EVDF_RENDER_TO_TARGET feature, which can be queried with
     * queryFeature(). Usually, rendering to textures is done in this
     * way:
     * 
     * // create render target
     * auto target = driver.addRenderTargetTexture(dimension2du(128,128), "rtt1");
     * 
     * // ...
     * 
     * driver.setRenderTarget(target); // set render target
     * // .. draw stuff here
     * driver.setRenderTarget(0); // set previous render target
     * 
     * Please note that you cannot render 3D or 2D geometry with a
     * render target as texture on it when you are rendering the scene
     * into this render target at the same time. It is usually only
     * possible to render into a texture between the
     * VideoDriver.beginScene() and endScene() method calls.
     * param texture New render target. Must be a texture created with
     * VideoDriver.addRenderTargetTexture(). If set to 0, it sets
     * the previous render target which was set before the last
     * setRenderTarget() call.
     * param clearBackBuffer Clears the backbuffer of the render
     * target with the color parameter
     * param clearZBuffer Clears the zBuffer of the rendertarget.
     * Note that because the frame buffer may share the zbuffer with
     * the rendertarget, its zbuffer might be partially cleared too
     * by this.
     * Params:
     *  color = The background color for the render target.
     * Return: True if sucessful and false if not.
     */
    void setRenderTarget(Texture texture, bool clearBackBuffer, bool clearZBuffer, Color color) {
    	irr_IVideoDriver_setRenderTarget(ptr, texture.ptr, clearBackBuffer, clearZBuffer, color);
    }

    bool setRenderTargetByEnum(RenderTarget target, bool clearTarget, bool clearZBuffer, Color color) {
		return irr_IVideoDriver_setRenderTargetByEnum(ptr, target, clearTarget, clearZBuffer, color.ptr);
	}

	void setViewPort(recti area) {
		irr_IVideoDriver_setViewPort(ptr, area.ptr);
	}

	recti getViewPort() {
		auto temp = irr_IVideoDriver_getViewPort(ptr);
		return recti(temp);
	}

	void setFog(Color color, FogType fogType, float start, float end, float density, bool pixelFog, bool rangeFog) {
		irr_IVideoDriver_setFog(ptr, color.ptr, fogType, start, end, density,pixelFog, rangeFog);
	}

	//void getFog(ref Color color, ref FogType fogType, ref float start, ref float end, ref float density, ref bool pixelFog, ref bool rangeFog) {
		//irr_IVideoDriver_getFog(ptr, color.ptr, fogType, start, end, density, pixelFog, rangeFog);
	//}

	/***
	 * Get the current color format of the color buffer
	 * Return: Color format of the color buffer.
	 */
	ColorFormat getColorFormat() {
		return irr_IVideoDriver_getColorFormat(ptr);
	}

	/***
	 * Get the size of the screen or render window.
	 * Return: Size of screen or render window.
	 */
	dimension2du getScreenSize() {
		auto temp = irr_IVideoDriver_getScreenSize(ptr);
		return dimension2du(temp);
	}

	/***
	 * Get the size of the current render target
	 * This method will return the screen size if the driver
	 * doesn't support render to texture, or if the current render
	 * target is the screen.
	 * Return: Size of render target or screen/window
	 */
	dimension2du getCurrentRenderTargetSize() {
		auto temp = irr_IVideoDriver_getCurrentRenderTargetSize(ptr);
		return dimension2du(temp);
	}

	/***
	 * Returns current frames per second value.
	 * This value is updated approximately every 1.5 seconds and
	 * is only intended to provide a rough guide to the average frame
	 * rate. It is not suitable for use in performing timing
	 * calculations or framerate independent movement.
	 * Return: Approximate amount of frames per second drawn.
	 */
    @property int fps() { return irr_IVideoDriver_getFPS(ptr); }

	/***
	 * Returns amount of primitives (mostly triangles) which were drawn in the last frame.
	 * Together with getFPS() very useful method for statistics.
	 * Params:
	 *  mode = Defines if the primitives drawn are accumulated or
	 * 		counted per frame.
	 * Return: Amount of primitives drawn in the last frame.
	 */
	uint getPrimitiveCountDrawn(uint mode) {
		return irr_IVideoDriver_getPrimitiveCountDrawn(ptr, mode);
	}

	/// Deletes all dynamic lights which were previously added with addDynamicLight().
	void deleteAllDynamicLights() {
		irr_IVideoDriver_deleteAllDynamicLights(ptr);
	}

	/// adds a dynamic light, returning an index to the light
	/// Params: light = the light data to use to create the light
	/// Return: An index to the light, or -1 if an error occurs
	//int addDynamicLight(Light light) {
		//return irr_IVideoDriver_addDynamicLight(ptr, light.ptr);
	//}

	/***
	 * Returns the maximal amount of dynamic lights the device can handle
	 * Return: Maximal amount of dynamic lights.
	 */
	uint getMaximalDynamicLightAmount() {
		return irr_IVideoDriver_getMaximalDynamicLightAmount(ptr);
	}

	/***
	 * Returns amount of dynamic lights currently set
	 * Return:
	 *  Amount of dynamic lights currently set
	 */
	uint getDynamicLightCount() {
		return irr_IVideoDriver_getDynamicLightCount(ptr);
	}

	/***
	 * Returns light data which was previously set by VideoDriver.addDynamicLight().
	 * Params:
	 *  idx = Zero based index of the light. Must be 0 or
	 * 		greater and smaller than VideoDriver.getDynamicLightCount.
	 * Return: Light data.
	 */
	//Light getDynamicLight(uint idx) {
		//auto temp = irr_IVideoDriver_getDynamicLight(ptr, idx);
		//return new Light(temp);
	//}

	/// Turns a dynamic light on or off
	/// Params:
	///  lightIndex = the index returned by addDynamicLight
	///  turnOn = true to turn the light on, false to turn it off
	void turnLightOn(int lightIndex, bool turnOn) {
		irr_IVideoDriver_turnLightOn(ptr, lightIndex, turnOn);
	}

	/***
	 * Gets name of this video driver.
	 * return Returns the name of the video driver, e.g. in case
	 * of the Direct3D8 driver, it would return "Direct3D 8.1".
	 */
    string name() @property {
        auto temp = irr_IVideoDriver_getName(ptr);
        dstring text = temp[0..strlen(temp)].idup;
        return to!string(text);
    }

	/***
	 * Adds an external image loader to the engine.
	 * This is useful if the Irrlicht Engine should be able to load
	 * textures of currently unsupported file formats (e.g. gif). The
	 * ImageLoader only needs to be implemented for loading this file
	 * format. A pointer to the implementation can be passed to the
	 * engine using this method.
	 * Params:
	 *  loader = Pointer to the external loader created.
	 */
	void addExternalImageLoader(ImageLoader loader) {
		irr_IVideoDriver_addExternalImageLoader(ptr, cast(irr_IImageLoader*)loader.c_ptr);
	}

	/***
	 * Adds an external image writer to the engine.
	 * This is useful if the Irrlicht Engine should be able to
	 * write textures of currently unsupported file formats (e.g
	 * .gif). The ImageWriter only needs to be implemented for
	 * writing this file format. A pointer to the implementation can
	 * be passed to the engine using this method.
	 * Params:
	 *  writer = Pointer to the external writer created.
	 */
	void addExternalImageWriter(ImageWriter writer) {
		irr_IVideoDriver_addExternalImageWriter(ptr, cast(irr_IImageWriter*)writer.c_ptr);
	}

	/***
	 * Returns the maximum amount of primitives
	 * (mostly vertices) which the device is able to render with
	 * one drawVertexPrimitiveList call.
	 * Return: Maximum amount of primitives.
	 */
	uint getMaximalPrimitiveCount() {
		return irr_IVideoDriver_getMaximalPrimitiveCount(ptr);
	}

	/***
	 * Enables or disables a texture creation flag.
	 * These flags define how textures should be created. By
	 * changing this value, you can influence for example the speed of
	 * rendering a lot. But please note that the video drivers take
	 * this value only as recommendation. It could happen that you
	 * enable the ETCF_ALWAYS_16_BIT mode, but the driver still creates
	 * 32 bit textures.
	 * Params:
	 *  flag = Texture creation flag.
	 *  enabled = Specifies if the given flag should be enabled or
	 * 		disabled.
	 */
	void setTextureCreationFlag(TextureCreationFlag flag, bool enabled=true) {
		irr_IVideoDriver_setTextureCreationFlag(ptr, flag, enabled);
	}

	/***
	 * Returns if a texture creation flag is enabled or disabled.
	 * You can change this value using setTextureCreationFlag().
	 * Params:
	 *  flag = Texture creation flag.
	 * Return: The current texture creation flag enabled mode.
	 */
	bool getTextureCreationFlag(TextureCreationFlag flag) {
		return irr_IVideoDriver_getTextureCreationFlag(ptr, flag);
	}

	/***
	 * Creates a software image from a file.
	 * No hardware texture will be created for this image. This
	 * method is useful for example if you want to read a heightmap
	 * for a terrain renderer.
	 * param filename Name of the file from which the image is
	 * created.
	 * return The created image.
	 * If you no longer need the image, you should call Image.drop().
	 * See IReferenceCounted::drop() for more information.
	 */
	Image createImageFromFile(string file) {
		auto temp = irr_IVideoDriver_createImageFromFile(ptr, file.toStringz);
		return new CImage(temp);
	}

	/***
	 * Writes the provided image to a file.
	 * Requires that there is a suitable image writer registered
	 * for writing the image.
	 * Params:
	 *  image = Image to write.
	 *  filename = Name of the file to write.
	 *  param = Control parameter for the backend (e.g. compression
	 * 		level).
	 * Return: True on successful write.
	 */
	bool writeImageToFile(Image image, string filename, uint param = 0) {
		return irr_IVideoDriver_writeImageToFile(ptr, cast(irr_IImage*)image.c_ptr, filename.toStringz, param);
	}
	
	//  bool irr_IVideoDriver_writeImageToFile(irr_IVideoDriver* driver, irr_IImage* image, irr_IWriteFile* file, uint param =0);


	/***
	 * Creates a software image from a byte array.
	 * No hardware texture will be created for this image. This
	 * method is useful for example if you want to read a heightmap
	 * for a terrain renderer.
	 * Params:
	 *  format = Desired color format of the texture
	 *  size = Desired size of the image
	 *  data = A byte array with pixel color information
	 *  	ownForeignMemory = If true, the image will use the data
	 * 		pointer directly and own it afterwards. If false, the memory
	 * 		will by copied internally.
	 *  deleteMemory: Whether the memory is deallocated upon
	 * 		destruction.
	 * Return: The created image.
	 * 		If you no longer need the image, you should call Image.drop().
	 * 		See IReferenceCounted::drop() for more information.
	 */
	Image createImageFromData(ColorFormat format, dimension2du size, void *data, bool ownForeignMemory=false, bool deleteMemory=true) {
		auto temp = irr_IVideoDriver_createImageFromData(ptr, format, size, data, ownForeignMemory, deleteMemory);
		return new CImage(temp);
	}

	/***
	 * Creates an empty software image.
	 * 
	 * Params:
	 *  format = Desired color format of the image.
	 *  size = Size of the image to create.
	 * Return: The created image.
	 * 		If you no longer need the image, you should call Image.drop().
	 * 		See IReferenceCounted::drop() for more information.
	 */
	Image createEmptyImage(ColorFormat format, dimension2du size) {
		auto temp = irr_IVideoDriver_createEmptyImage(ptr, format, size);
		return new CImage(temp);
	}

	/***
	 * Creates a software image from a part of a texture.
	 * 
	 * Params:
	 *  texture = Texture to copy to the new image in part.
	 *  pos = Position of rectangle to copy.
	 *  size = Extents of rectangle to copy.
	 * Return: The created image.
	 * 		If you no longer need the image, you should call Image.drop().
	 * 		See drop() for more information.
	 */
	Image createImage(Texture texture, vector2di pos, dimension2du size) {
		auto temp = irr_IVideoDriver_createImage(ptr, texture.ptr, pos, size);
		return new CImage(temp);
	}

	/***
	 * Event handler for resize events. Only used by the engine internally.
	 * Used to notify the driver that the window was resized.
	 * Usually, there is no need to call this method.
	 */
	void OnResize(dimension2du size) {
		irr_IVideoDriver_OnResize(ptr, size);
	}

	/***
	 * Adds a new material renderer to the video device.
	 * Use this method to extend the VideoDriver with new material
	 * types. To extend the engine using this method do the following:
	 * Derive a class from IMaterialRenderer and override the methods
	 * you need. For setting the right renderstates, you can try to
	 * get a pointer to the real rendering device using
	 * VideoDriver.getExposedVideoData(). Add your class with
	 * VideoDriver.addMaterialRenderer(). To use an object being
	 * displayed with your new material, set the MaterialType member of
	 * the SMaterial struct to the value returned by this method.
	 * If you simply want to create a new material using vertex and/or
	 * pixel shaders it would be easier to use the
	 * GPUProgrammingServices interface which you can get
	 * using the getGPUProgrammingServices() method.
	 * param renderer A pointer to the new renderer.
	 * param name Optional name for the material renderer entry.
	 * return The number of the material type which can be set in
	 * SMaterial::MaterialType to use the renderer. -1 is returned if
	 * an error occured. For example if you tried to add an material
	 * renderer to the software renderer or the null device, which do
	 * not accept material renderers.
	 */
	int addMaterialRenderer(MaterialRenderer renderer, string name) {
		return irr_IVideoDriver_addMaterialRenderer(ptr, renderer.ptr, name.toStringz);
	}

	/***
	 * Get access to a material renderer by index.
	 * Params:
	 *  idx = Id of the material renderer. Can be a value of
	 * 		the E_MATERIAL_TYPE enum or a value which was returned by
	 * 		addMaterialRenderer().
	 * Return:
	 *  Pointer to material renderer or null if not existing.
	 */
	MaterialRenderer getMaterialRenderer(uint idx) {
		auto temp = irr_IVideoDriver_getMaterialRenderer(ptr, idx);
		return new MaterialRenderer(temp);
	}

	/***
	 * Get amount of currently available material renderers.
	 * Return:
	 *  Amount of currently available material renderers.
	 */
	uint getMaterialRendererCount() {
		return irr_IVideoDriver_getMaterialRendererCount(ptr);
	}

	/***
	 * Get name of a material renderer
	 * This string can, e.g., be used to test if a specific
	 * renderer already has been registered/created, or use this
	 * string to store data about materials: This returned name will
	 * be also used when serializing materials.
	 * Params:
	 *  idx = Id of the material renderer. Can be a value of the
	 * 		MaterialType enum or a value which was returned by
	 * 		addMaterialRenderer().
	 * return String with the name of the renderer, or 0 if not
	 * exisiting
	 */
	string getMaterialRendererName(uint idx) {
		return irr_IVideoDriver_getMaterialRendererName(ptr, idx).to!string;
	}

	/***
	 * Sets the name of a material renderer.
	 * Will have no effect on built-in material renderers.
	 * Params:
	 *  idx = Id of the material renderer. Can be a value of the
	 * 		MaterialType enum or a value which was returned by
	 * 		addMaterialRenderer().
	 *  name = New name of the material renderer.
	 */
	void setMaterialRendererName(int idx, string name) {
		irr_IVideoDriver_setMaterialRendererName(ptr, idx, name.toStringz);
	}
	
	/***
	 * Creates material attributes list from a material
	 * This method is useful for serialization and more.
	 * Please note that the video driver will use the material
	 * renderer names from getMaterialRendererName() to write out the
	 * material type name, so they should be set before.
	 * param material The material to serialize.
	 * param options Additional options which might influence the
	 * serialization.
	 * return The Attributes container holding the material
	 * properties.
	 */
	//void createAttributesFromMaterial(Material material, AttributeReadWriteOptions option) {
		//irr_IVideoDriver_createAttributesFromMaterial(ptr, material.ptr, option.ptr);
	//}
	
    /***
     * Fills an SMaterial structure from attributes.
     * Please note that for setting material types of the
     * material, the video driver will need to query the material
     * renderers for their names, so all non built-in materials must
     * have been created before calling this method.
     * Params:
     *  outMaterial = The material to set the properties for.
     *  attributes = The attributes to read from.
     */
    void fillMaterialStructureFromAttributes(out Material outMaterial, out Attributes attributes) {
    	irr_IVideoDriver_fillMaterialStructureFromAttributes(ptr, outMaterial.ptr, cast(irr_IAttributes*)attributes.c_ptr);
    }
    
    // irr_IVideoDriver_getExposedVideoData

    /***
     * Get type of video driver
     * Return: Type of driver.
     */
    DriverType getDriverType() {
    	return irr_IVideoDriver_getDriverType(ptr);
    }

    /***
     * Gets the IGPUProgrammingServices interface.
     * Return: Pointer to the IGPUProgrammingServices. Returns 0
     * if the video driver does not support this. For example the
     * Software driver and the Null driver will always return 0.
     */
    GPUProgrammingServices getGPUProgrammingServices() {
    	auto temp = irr_IVideoDriver_getGPUProgrammingServices(ptr);
    	return new CGPUProgrammingServices(temp);
    }

    /// Returns a pointer to the mesh manipulator.
    MeshManipulator getMeshManipulator() {
    	auto temp = irr_IVideoDriver_getMeshManipulator(ptr);
    	return new MeshManipulator(temp);
    }

    /***
     * Clears the ZBuffer.
     * Note that you usually need not to call this method, as it
     * is automatically done in beginScene() or
     * setRenderTarget() if you enable zBuffer. But if
     * you have to render some special things, you can clear the
     * zbuffer during the rendering process with this method any time.
	 */
    void clearZBuffer() {
    	irr_IVideoDriver_clearZBuffer(ptr);
    }

    /***
     * Make a screenshot of the last rendered frame.
	 * return An image created from the last rendered frame.
	 */
    Image createScreenShot(ColorFormat format, RenderTarget target) {
    	auto temp = irr_IVideoDriver_createScreenShot(ptr, format, target);
    	return new CImage(temp);
    }

    /***
     * Check if the image is already loaded.
     * Works similar to getTexture(), but does not load the texture
     * if it is not currently loaded.
     * Params:
     *  filename = Name of the texture.
     * Return: Pointer to loaded texture, or 0 if not found.
     */
    Texture findTexture(string filename) {
		auto temp = irr_IVideoDriver_findTexture(ptr, filename.toStringz);
		return new Texture(temp);
	}

	/***
	 * Set or unset a clipping plane.
	 * There are at least 6 clipping planes available for the user
	 * to set at will.
	 * Param:
	 *  index = The plane index. Must be between 0 and
	 * 		MaxUserClipPlanes.
	 * plane = The plane itself.
	 * enable = If true, enable the clipping plane else disable
	 * 		it.
	 * Return: True if the clipping plane is usable.
	 */
    void setClipPlane(uint index, plane3df plane, bool enable=false) {
		irr_IVideoDriver_setClipPlane(ptr, index, plane, enable);
	}

    /***
     * Enable or disable a clipping plane.
     * There are at least 6 clipping planes available for the user
     * to set at will.
     * Params:
     *  index = The plane index. Must be between 0 and
     * 		MaxUserClipPlanes.
     *  enable = If true, enable the clipping plane else disable
     * 		it.
     */
    void enableClipPlane(uint index, bool enable) {
		irr_IVideoDriver_enableClipPlane(ptr, index, enable);
	}

    /***
     * Set the minimum number of vertices for which a hw buffer will be created
     * Params:
     *  count = Number of vertices to set as minimum.
     */
	void setMinHardwareBufferVertexCount(uint count) {
		irr_IVideoDriver_setMinHardwareBufferVertexCount(ptr, count);
	}
	
	// irr_IVideoDriver_getOverrideMaterial

	/***
	 * Get the 2d override material for altering its values
	 * The 2d override materual allows to alter certain render
	 * states of the 2d methods. Not all members of Material are
	 * honored, especially not MaterialType and Textures. Moreover,
	 * the zbuffer is always ignored, and lighting is always off. All
	 * other flags can be changed, though some might have to effect
	 * in most cases.
	 * Please note that you have to enable/disable this effect with
	 * enableInitMaterial2D(). This effect is costly, as it increases
	 * the number of state changes considerably. Always reset the
	 * values when done.
	 * return Material reference which should be altered to reflect
	 * the new settings.
	 */
    Material getMaterial2D() {
    	auto temp = irr_IVideoDriver_getMaterial2D(ptr);
    	return new Material(temp);
    }

    /***
     * Enable the 2d override material
     * Params:
     *  enable = Flag which tells whether the material shall be
     * 		enabled or disabled.
     */
    void enableMaterial2D(bool enable=true) {
    	irr_IVideoDriver_enableMaterial2D(ptr, enable);
    }

    /// Get the graphics card vendor name.
    string getVendorInfo() {
    	return irr_IVideoDriver_getVendorInfo(ptr).to!string;
    }

    /***
     * Only used by the engine internally.
     * The ambient color is set in the scene manager, see
     * scene::ISceneManager::setAmbientLight().
     * Params:
     *  color = New color of the ambient light.
     */
    void setAmbientLight(Colorf color) {
    	irr_IVideoDriver_setAmbientLight(ptr, color);
    }

    /***
     * Only used by the engine internally.
     * Passes the global material flag AllowZWriteOnTransparent.
     * Use the SceneManager attribute to set this value from your app.
     * Params:
     *  flag = Default behavior is to disable ZWrite, i.e. false.
     */
    void setAllowZWriteOnTransparent(bool flag) {
    	irr_IVideoDriver_setAllowZWriteOnTransparent(ptr, flag);
    }

    /// Get the maximum texture size supported.
    dimension2du getMaxTextureSize() {
    	auto size = irr_IVideoDriver_getMaxTextureSize(ptr);
    	return dimension2du(size.Width, size.Height);
    }

    /***
     * Color conversion convenience function
     * Convert an image (as array of pixels) from source to destination
     * array, thereby converting the color format. The pixel size is
     * determined by the color formats.
     * Params:
     *  sP = Pointer to source
     *  sF = Color format of source
     *  sN = Number of pixels to convert, both array must be large enough
     *  dP = Pointer to destination
     *  dF = Color format of destination
	 */
    void convertColor(const void* sP, ColorFormat sF, int sN, void* dP, ColorFormat dF) {
    	irr_IVideoDriver_convertColor(ptr, sP, sF, sN, dP, dF);
    }
	
    irr_IVideoDriver* ptr;
}

/// strlen for dchar*
private pure nothrow @system size_t strlen(const(dchar)* str) {
    size_t n = 0;
    for (; str[n] != 0; ++n) {}
    return n;
}

/// strlen example
unittest {
    import std.stdio;
    const(dchar)* text = "Hello const(dchar)*";
    dstring str = text[0..strlen(text)].idup;
    writeln("strlen_test: ", str);
}

/// IVideoDriver example
unittest {
    mixin(TestPrerequisite);
    
    with (driver) { 
        beginScene(false, false, Color(0, 0, 0, 255));
        endScene();
        queryFeature(DriverFeature.PixelShader_2_0);
        disableFeature(DriverFeature.PixelShader_2_0, false);

        auto att = getDriverAttributes();
        assert(att !is null);
        assert(att.c_ptr != null);

        checkDriverReset();
        setTransform(TransformationState.World, matrix4());

        getTexture("../media/wall.bmp");
        getTexture("../media/t351sml.jpg");
        debug writeln("Fps: ", fps);
        auto driverName = name;
        debug writeln("Driver Name: ", driverName);
    }
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
void irr_IVideoDriver_getFog(irr_IVideoDriver* driver, ref irr_SColor color, ref FogType fogType, ref float start, ref float end, ref float density, ref bool pixelFog, ref bool rangeFog);
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
const(char*) irr_IVideoDriver_getMaterialRendererName(irr_IVideoDriver* driver, uint idx);
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
