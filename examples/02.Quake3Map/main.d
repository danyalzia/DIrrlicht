import dirrlicht.all;

import std.conv : to;

void main()
{
    auto device = createDevice(DriverType.openGL, dimension2du(640, 480), 16, false, false, false);

    device.resizable = true;

    auto driver = device.videoDriver;
    auto smgr = device.sceneManager;
    auto gui = device.guiEnvironment;

    device.fileSystem.addFileArchive("../../media/map-20kdm2.pk3");

    auto mesh = smgr.getMesh("20kdm2.bsp");
    auto node = smgr.addAnimatedMeshSceneNode(mesh);
    node.setPosition(vector3df(-1300,-144,-1249));
    node.setMaterialFlag(E_MATERIAL_FLAG.EMF_LIGHTING, false);

    smgr.addCameraSceneNodeFPS();

	device.cursorControl.setVisible(false);

    auto col = SColor(255,200,200,200);
    int lastFPS = -1;

    while (device.run)
    {
        if (device.isWindowActive)
        {
            driver.beginScene(true, true, col);
            smgr.drawAll;
            gui.drawAll;
            driver.endScene;

            int fps = driver.fps;

            if (lastFPS != fps)
            {
                dstring str = "DIrrlicht - Quake 3 Map example [";
                //str ~= driver.name;
				//str ~= "] FPS:";
				//str ~= to!dstring(fps);
				//device.windowCaption = str;
                //lastFPS = fps;
            }
        }
        else
            device.yield;
    }
}
