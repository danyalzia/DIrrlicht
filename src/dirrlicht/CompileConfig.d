module dirrlicht.CompileConfig;

version(DigitalMars)
    enum DigitalMars = true;
else
    enum DigitalMars = false;

version(GNU)
    enum GDC = true;
else
    enum GDC = false;

version(LDC)
    enum LDC = true;
else
    enum LDC = false;

enum TestPrerequisite =
    `
    import std.stdio;
    import dirrlicht;
    import dirrlicht.scene;
    import dirrlicht.video;
    import dirrlicht.core;
    import dirrlicht.gui;
    import dirrlicht.io;

    auto device = createDevice(E_DRIVER_TYPE.EDT_NULL, dimension2du(800,600));
    assert(device !is null);
    device.setWindowCaption("NULL");

    auto driver = device.getVideoDriver();
    assert(driver !is null);

    auto smgr = device.getSceneManager();
    assert(smgr !is null);

    auto gui = device.getGUIEnvironment();
    assert(gui !is null);

    writeln();
    writeln("TESTING: ", __MODULE__);
`;
