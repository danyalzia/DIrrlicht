import dirrlicht.all;

import std.conv : to;
import std.stdio : writeln;

bool[KeyCode.Count] KeyIsDown;

bool IsKeyDown(KeyCode keyCode) {
	return KeyIsDown[keyCode];
}

extern(C) bool OnEvent(const ref SEvent event) {
	if (event.eventType == EventType.Key) {
		KeyIsDown[event.KeyInput.Key] = event.KeyInput.PressedDown;
            
        return false;
	}
	
	return false;
}

void main() {
    auto device = createDevice(DriverType.OpenGL, dimension2du(640, 480), 16, false, false, false);
	
    device.resizable = true;
    
    for (uint i = 0; i < KeyCode.Count; ++i)
		KeyIsDown[i] = false;
		
	
	device.eventReceiver = &OnEvent;
	
    auto driver = device.videoDriver;
    auto smgr = device.sceneManager;
    auto gui = device.guiEnvironment;

    auto node = smgr.addSphereSceneNode();
    
    node.position = vector3df(0,0,30);
	node.setMaterialTexture(0, driver.getTexture("../../media/wall.bmp"));
    node.setMaterialFlag(MaterialFlag.Lighting, false);

    auto n = smgr.addCubeSceneNode();
    
    n.setMaterialTexture(0, driver.getTexture("../../media/t351sml.jpg"));
    n.setMaterialFlag(MaterialFlag.Lighting, false);

    auto anim = smgr.createFlyCircleAnimator(vector3df(0,0,30), 20.0);

    n.addAnimator(anim);

    auto anms = smgr.addAnimatedMeshSceneNode(smgr.getMesh("../../media/ninja.b3d"));

    anim = smgr.createFlyStraightAnimator(vector3df(100,0,60), vector3df(-100,0,60), 3500, true);
	anms.addAnimator(anim);
	anms.setMaterialFlag(MaterialFlag.Lighting, false);
	anms.setFrameLoop(0, 13);
	anms.setAnimationSpeed(15);
	anms.scale = vector3df(2, 2, 2);
	anms.rotation = vector3df(0,-90,0);

	smgr.addCameraSceneNodeFPS();
    device.cursorControl.visible = true;

	gui.addImage(driver.getTexture("../../media/irrlichtlogoalpha2.tga"), vector2di(10,20));
	auto diagnostics = gui.addStaticText("", recti(10, 10, 400, 20));
	diagnostics.setOverrideColor(Color(0, 255, 255, 255));
	
    int lastFPS = -1;
	
	uint then = device.timer.getTime;
	const float MOVEMENT_SPEED = 5.0f;
	
    while (device.run) {
		const now = device.timer.getTime;
		const frameDeltaTime = cast(float)(now - then) / 1000.0f;
		then = now;
		auto nodepos = node.position;
		
		if (IsKeyDown(KeyCode.KeyW)) {
			"W".writeln;
			nodepos.y = nodepos.y + (MOVEMENT_SPEED * frameDeltaTime);
		}
		
		else if (IsKeyDown(KeyCode.KeyS)) {
			"S".writeln;
			nodepos.y = nodepos.y - (MOVEMENT_SPEED * frameDeltaTime);
		}
		
		if (IsKeyDown(KeyCode.KeyA)) {
			"A".writeln;
			nodepos.x = nodepos.x - (MOVEMENT_SPEED * frameDeltaTime);
		}
		
		else if (IsKeyDown(KeyCode.KeyD)) {
			"D".writeln;
			nodepos.x = nodepos.x + (MOVEMENT_SPEED * frameDeltaTime);
		}
	
		node.position = nodepos;
		driver.beginScene(true, true, dirrlicht.video.Color(113,113,133,255));
		smgr.drawAll();
		gui.drawAll();
		driver.endScene();

		int fps = driver.fps;

		if (lastFPS != fps) {
			string str = "DIrrlicht - Movement Example[";
			str ~= driver.name;
			str ~= "] FPS:";
			str ~= to!string(fps);
			device.windowCaption = str;
			lastFPS = fps;
		}
    }
}
