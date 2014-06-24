
import dirrlicht;
import dirrlicht.core;
import dirrlicht.video;
import dirrlicht.scene;
import dirrlicht.gui;

import std.conv;

void main()
{
    auto device = createDevice(E_DRIVER_TYPE.EDT_OPENGL, dimension2du(640, 480), 16, false, false, false);

    device.setWindowCaption("Hello World!");
    device.setResizable(true);

    auto driver = device.getVideoDriver();
    auto smgr = device.getSceneManager();
    auto gui = device.getGUIEnvironment();

    device.getFileSystem().addFileArchive("../../media/map-20kdm2.pk3");

    auto mesh = smgr.getMesh("20kdm2.bsp");
    auto node = smgr.addAnimatedMeshSceneNode(mesh);
    node.setPosition(vector3df(-1300,-144,-1249));
    node.setMaterialFlag(E_MATERIAL_FLAG.EMF_LIGHTING, false);

    smgr.addCameraSceneNodeFPS();

    auto cursor = device.getCursorControl();
    cursor.setVisible(false);

    auto col = SColor(255,200,200,200);
    int lastFPS = -1;

    while (device.run())
    {
        if (device.isWindowActive())
        {
            driver.beginScene(true, true, col);
            smgr.drawAll();
            gui.drawAll();
            driver.endScene();

            int fps = driver.getFPS();

            if (lastFPS != fps)
            {
                dstring str = "Irrlicht Engine - Quake 3 Map example [";
                str ~= driver.getName();
				str ~= "] FPS:";
				str ~= to!dstring(fps);
				device.setWindowCaption(str);
                lastFPS = fps;
            }
        }
        else
            device.yield();
    }
}
