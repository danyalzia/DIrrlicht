module dirrlicht.compileconfig;

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

template checkNull(string name)
{
	const char[] checkNull = "assert(" ~ name ~ " !is null);" ~ "assert(" ~ name ~ ".ptr" ~ "!= null);";
}

enum TestPrerequisite =
`
    import std.stdio;
    import dirrlicht;
    import dirrlicht.scene;
    import dirrlicht.video;
    import dirrlicht.core;
    import dirrlicht.gui;
    import dirrlicht.io;
    
    writeln();
    writeln("=====================");
    writeln("TESTING ", __MODULE__);
    writeln(__TIME__);
    writeln("=====================");
    writeln();

    auto device = createDevice(E_DRIVER_TYPE.EDT_OPENGL, dimension2du(800,600));
    mixin(checkNull!("device"));

    auto driver = device.getVideoDriver();
    mixin(checkNull!("driver"));

    auto smgr = device.getSceneManager();
    mixin(checkNull!("smgr"));

    auto gui = device.getGUIEnvironment();
    mixin(checkNull!("gui"));
`;
