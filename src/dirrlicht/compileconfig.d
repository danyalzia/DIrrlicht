/+++
 + Compile-time functions/macros/mixins
 +/
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

enum Core_TestBegin =
`
	import std.stdio;
	writeln();
    writeln("=====================");
    writeln("TESTING BEGIN: ", __MODULE__);
    writeln(__TIME__);
    writeln("=====================");
    writeln();
`;

enum Core_TestEnd =
`
	writeln();
    writeln("=====================");
    writeln("TESTING END: ", __MODULE__);
    writeln(__TIME__);
    writeln("=====================");
    writeln();
`;

enum TestPrerequisite =
`
    import std.stdio;
    import dirrlicht.all;
    
    writeln();
    writeln("=====================");
    writeln("TESTING BEGIN: ", __MODULE__);
    writeln(__TIME__);
    writeln("=====================");
    writeln();

    auto device = createDevice(DriverType.OpenGL, dimension2du(800,600));
	assert(device !is null);
	assert(device.ptr != null);

    auto driver = device.videoDriver;
    assert(driver !is null);
	assert(driver.ptr != null);

    auto smgr = device.sceneManager;
    assert(smgr !is null);
	assert(smgr.ptr != null);

    auto gui = device.guiEnvironment;
    assert(gui !is null);
	assert(gui.ptr != null);
`;
