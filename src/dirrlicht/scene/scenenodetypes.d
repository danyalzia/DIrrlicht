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

import dirrlicht.irrtypes;

/******* An enumeration for all types of built-in scene nodes
 *A scene node type is represented by a four character code
 *such as 'cube' or 'mesh' instead of simple numbers, to avoid
 *name clashes with external scene nodes.
 */
enum SceneNodeType {
    /// of type CSceneManager (note that ISceneManager is not(!) an ISceneNode)
    SceneManager = MAKE_DIRR_ID('s','m','n','g'),

    /// simple cube scene node
    Cube = MAKE_DIRR_ID('c','u','b','e'),

    /// Sphere scene node
    Sphere = MAKE_DIRR_ID('s','p','h','r'),

    /// Text Scene Node
    Text = MAKE_DIRR_ID('t','e','x','t'),

    /// Water Surface Scene Node
    WaterSurface = MAKE_DIRR_ID('w','a','t','r'),

    /// Terrain Scene Node
    Terrain = MAKE_DIRR_ID('t','e','r','r'),

    /// Sky Box Scene Node
    SkyBox = MAKE_DIRR_ID('s','k','y','_'),

    /// Sky Dome Scene Node
    SkyDome = MAKE_DIRR_ID('s','k','y','d'),

    /// Shadow Volume Scene Node
    ShadowVolume = MAKE_DIRR_ID('s','h','d','w'),

    /// Octree Scene Node
    Octree = MAKE_DIRR_ID('o','c','t','r'),

    /// Mesh Scene Node
    Mesh = MAKE_DIRR_ID('m','e','s','h'),

    /// Light Scene Node
    Light = MAKE_DIRR_ID('l','g','h','t'),

    /// Empty Scene Node
    Empty = MAKE_DIRR_ID('e','m','t','y'),

    /// Dummy Transformation Scene Node
    DummyTransformation = MAKE_DIRR_ID('d','m','m','y'),

    /// Camera Scene Node
    Camera = MAKE_DIRR_ID('c','a','m','_'),

    /// Billboard Scene Node
    Billboard = MAKE_DIRR_ID('b','i','l','l'),

    /// Animated Mesh Scene Node
    AnimatedMesh = MAKE_DIRR_ID('a','m','s','h'),

    /// Particle System Scene Node
    ParticleSystem = MAKE_DIRR_ID('p','t','c','l'),

    /// Quake3 Shader Scene Node
    Q3Shader = MAKE_DIRR_ID('q','3','s','h'),

    /// Quake3 Model Scene Node ( has tag to link to )
    Q3Node = MAKE_DIRR_ID('m','d','3','_'),

    /// Volume Light Scene Node
    VolumeLight = MAKE_DIRR_ID('v','o','l','l'),

    /// Maya Camera Scene Node
    /// Legacy, for loading version <= 1.4.x .irr files
    CameraMaya = MAKE_DIRR_ID('c','a','m','M'),

    /// First Person Shooter Camera
    /// Legacy, for loading version <= 1.4.x .irr files
    CameraFPS = MAKE_DIRR_ID('c','a','m','F'),

    /// Unknown scene node
    Unknown = MAKE_DIRR_ID('u','n','k','n'),

    /// Will match with any scene node when checking types
    Any  = MAKE_DIRR_ID('a','n','y','_')
}
