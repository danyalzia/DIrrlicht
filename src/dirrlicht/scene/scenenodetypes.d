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

module dirrlicht.scene.scenenodetypes;

/******* An enumeration for all types of built-in scene nodes
 *A scene node type is represented by a four character code
 *such as 'cube' or 'mesh' instead of simple numbers, to avoid
 *name clashes with external scene nodes.
 */

enum SceneNodeType {
    /// of type CSceneManager (note that ISceneManager is not(!) an ISceneNode)
    SceneManager,

    /// simple cube scene node
    Cube,

    /// Sphere scene node
    Sphere,

    /// Text Scene Node
    Text,

    /// Water Surface Scene Node
    WaterSurface,

    /// Terrain Scene Node
    Terrain,

    /// Sky Box Scene Node
    SkyBox,

    /// Sky Dome Scene Node
    SkyDome,

    /// Shadow Volume Scene Node
    ShadowVolume,

    /// Octree Scene Node
    Octree,

    /// Mesh Scene Node
    Mesh,

    /// Light Scene Node
    Light,

    /// Empty Scene Node
    Empty,

    /// Dummy Transformation Scene Node
    DummyTransformation,

    /// Camera Scene Node
    Camera,

    /// Billboard Scene Node
    Billboard,

    /// Animated Mesh Scene Node
    AnimatedMesh,

    /// Particle System Scene Node
    ParticleSystem,

    /// Quake3 Shader Scene Node
    Q3Shader,

    /// Quake3 Model Scene Node ( has tag to link to )
    Q3Node,

    /// Volume Light Scene Node
    VolumeLight,

    /// Maya Camera Scene Node
    /// Legacy, for loading version <= 1.4.x .irr files
    CameraMaya,

    /// First Person Shooter Camera
    /// Legacy, for loading version <= 1.4.x .irr files
    CameraFPS,

    /// Unknown scene node
    Unknown,

    /// Will match with any scene node when checking types
    Any
}
