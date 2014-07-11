import dirrlicht.all;

import std.conv : to;

void main()
{
    auto device = createDevice(DriverType.OpenGL, dimension2du(640, 480), 16, false, false, false);

    device.resizable = true;
	
    auto driver = device.videoDriver;
    auto smgr = device.sceneManager;
    auto gui = device.guiEnvironment;

    auto node = smgr.addSphereSceneNode();
    
    node.position = vector3df(0,0,30);
	node.setMaterialTexture(0, driver.getTexture("../../media/wall.bmp"));
    node.setMaterialFlag(MaterialFlag.lighting, false);

    auto n = smgr.addCubeSceneNode();
    
    n.setMaterialTexture(0, driver.getTexture("../../media/t351sml.jpg"));
    n.setMaterialFlag(MaterialFlag.lighting, false);

    auto anim = smgr.createFlyCircleAnimator(vector3df(0,0,30), 20.0);

    n.addAnimator(anim);

    auto anms = smgr.addAnimatedMeshSceneNode(smgr.getMesh("../../media/ninja.b3d"));

    anim = smgr.createFlyStraightAnimator(vector3df(100,0,60), vector3df(-100,0,60), 3500, true);
	anms.addAnimator(anim);
	anms.setMaterialFlag(MaterialFlag.lighting, false);
	anms.setFrameLoop(0, 13);
	anms.setAnimationSpeed(15);
	anms.scale = vector3df(2, 2, 2);
	anms.rotation = vector3df(0,-90,0);

	smgr.addCameraSceneNodeFPS();
    device.cursorControl.visible = true;

	gui.addImage(driver.getTexture("../../media/irrlichtlogoalpha2.tga"), vector2di(10,20));
	//auto diagnostics = gui.addStaticText("", recti(10, 10, 400, 20));
	//diagnostics.setOverrideColor(Color(255, 255, 255, 0));
	
    int lastFPS = -1;
	
    while (device.run)
    {
        if (device.isWindowActive)
        {
			
			auto nodepos = node.position;
			import dsfml.window;
			if(Keyboard.isKeyPressed(Keyboard.Key.W)) {
				nodepos.y = nodepos.y + 5;
			}
			else if (Keyboard.isKeyPressed(Keyboard.Key.S)) {
				nodepos.y = nodepos.y - 5;
			}

			if(Keyboard.isKeyPressed(Keyboard.Key.A)) {
				nodepos.x = nodepos.x + 5;
			}
			else if (Keyboard.isKeyPressed(Keyboard.Key.D)) {
				nodepos.x = nodepos.x - 5;
			}
			
			node.position = nodepos;
            driver.beginScene(true, true, dirrlicht.video.Color(133,113,113,255));
            smgr.drawAll();
            gui.drawAll();
            driver.endScene();

            int fps = driver.fps;

            if (lastFPS != fps)
            {
                dstring str = "DIrrlicht - Movement Example[";
                //str ~= driver.name;
				//str ~= "] FPS:";
				//str ~= to!dstring(fps);
				device.windowCaption = str;
                lastFPS = fps;
            }
        }
        else
            device.yield();
    }
}
