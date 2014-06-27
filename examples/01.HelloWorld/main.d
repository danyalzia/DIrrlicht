
import dirrlicht;
import dirrlicht.core;
import dirrlicht.video;
import dirrlicht.scene;
import dirrlicht.gui;

void main()
{
    auto device = createDevice(E_DRIVER_TYPE.EDT_OPENGL, dimension2du(800, 600), 16, false, false, false);

    device.setWindowCaption("Hello World!");
    device.setResizable(true);

    auto driver = device.getVideoDriver();
    auto smgr = device.getSceneManager();
    auto gui = device.getGUIEnvironment();

    gui.addStaticText("Hello World!", recti(10,10,260,22), true);

    auto mesh = smgr.getMesh("../../media/sydney.md2");
    auto node = smgr.addAnimatedMeshSceneNode(mesh);

    node.setMaterialFlag(E_MATERIAL_FLAG.EMF_LIGHTING, false);
    //node.setMD2Animation(EMD2_ANIMATION_TYPE.EMAT_STAND);
    node.setMaterialTexture(0, driver.getTexture("../../media/sydney.bmp"));

    smgr.addCameraSceneNode(null, vector3df(0,30,-40), vector3df(0,5,0));

    auto col = SColor(255,100,101,140);
    while (device.run())
    {
        driver.beginScene(true, true, col);
        smgr.drawAll();
        gui.drawAll();
        driver.endScene();
    }
}
