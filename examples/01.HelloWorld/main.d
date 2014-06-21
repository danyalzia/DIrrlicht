
import dirrlicht.IrrlichtDevice;
import dirrlicht.core.dimension2d;
import dirrlicht.core.rect;
import dirrlicht.video.IVideoDriver;
import dirrlicht.video.SColor;
import dirrlicht.c.irrlicht;

void main()
{
   auto device = createDevice(E_DRIVER_TYPE.EDT_OPENGL, dimension2du(800, 600));

    device.setWindowCaption("Hello World!");
    device.setResizable();

    auto driver = device.getVideoDriver();
    auto smgr = device.getSceneManager();
    auto gui = device.getGUIEnvironment();

    SColor col = {255, 0, 0, 0};

    while (device.run())
    {
        driver.beginScene(true, true, col);
        smgr.drawAll();
        gui.drawAll();
        driver.endScene();
    }

}
