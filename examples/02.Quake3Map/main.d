import dirrlicht.all;

import std.conv : to;

void main() {
    auto device = createDevice(DriverType.OpenGL, dimension2du(640, 480), 16, false, false, false);

    device.resizable = true;

    auto driver = device.videoDriver;
    auto smgr = device.sceneManager;
    auto gui = device.guiEnvironment;

    device.fileSystem.addFileArchive("../../media/map-20kdm2.pk3");

    auto mesh = smgr.getMesh("20kdm2.bsp");
    auto node = smgr.addAnimatedMeshSceneNode(mesh);
    node.position = vector3df(-1300,-144,-1249);
    node.setMaterialFlag(MaterialFlag.Lighting, false);

    smgr.addCameraSceneNodeFPS();

	device.cursorControl.visible = false;

    int lastFPS = -1;

    while (device.run) {
        if (device.isWindowActive) {
            driver.beginScene(true, true, Color(200,200,200,255));
            smgr.drawAll;
            gui.drawAll;
            driver.endScene;

            int fps = driver.fps;

            if (lastFPS != fps) {
                auto str = "DIrrlicht - Quake 3 Map example [";
                str ~= driver.name;
				str ~= "] FPS:";
				str ~= to!string(fps);
				device.windowCaption = str;
                lastFPS = fps;
            }
        }
        else {
            device.yield;
		}
    }
}
