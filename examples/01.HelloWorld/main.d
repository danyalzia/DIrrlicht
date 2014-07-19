import dirrlicht.all;

void main() {
    auto device = createDevice(DriverType.OpenGL, dimension2du(800, 600), 16, false, false, false);

    device.windowCaption = "Hello World!";
    device.resizable = true;

    auto driver = device.videoDriver;
    auto smgr = device.sceneManager;
    auto gui = device.guiEnvironment;

    gui.addStaticText("Hello World!", recti(10,10,260,22), true);

    auto mesh = smgr.getMesh("../../media/sydney.md2");
    auto node = smgr.addAnimatedMeshSceneNode(mesh);

    node.setMaterialFlag(MaterialFlag.Lighting, false);
    node.setMD2Animation(AnimationTypeMD2.Stand);
    node.setMaterialTexture(0, driver.getTexture("../../media/sydney.bmp"));

    smgr.addCameraSceneNode(null, vector3df(0,30,-40), vector3df(0,5,0));

    while (device.run()) {
        driver.beginScene(true, true, Color(140,101,100,255));
        smgr.drawAll();
        gui.drawAll();
        driver.endScene();
    }
}
