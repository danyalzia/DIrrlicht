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

static if (DigitalMars || LDC) {
	enum x86_Assembly = true;
} else {
	enum x86_Assembly = false;
}

enum Core_TestBegin =
`
	import std.stdio;
	writeln();
    writeln("|=============================================|");
    writeln("|TESTING BEGIN: ", __MODULE__);
    writeln("|", __TIME__);
    writeln("|=============================================|");
    writeln();
`;

enum Core_TestEnd =
`
	writeln();
    writeln("|=============================================|");
    writeln("|TESTING END: ", __MODULE__);
    writeln("|", __TIME__);
    writeln("|=============================================|");
    writeln();
`;

enum Irr_TestBegin =
`
    import std.stdio;
    import dirrlicht.all;
    
    writeln();
    writeln("|=============================================|");
    writeln("|TESTING BEGIN: ", __MODULE__);
    writeln("|", __TIME__);
    writeln("|=============================================|");
    writeln();

    auto device = createDevice(DriverType.BurningsVideo, dimension2du(800,600));
	assert(device !is null);

    auto driver = device.videoDriver;
    assert(driver !is null);

    auto smgr = device.sceneManager;
    assert(smgr !is null);

    auto gui = device.guiEnvironment;
    assert(gui !is null);
`;

alias TestPrerequisite = Irr_TestBegin;

enum Irr_TestEnd =
`
	device.closeDevice();
	writeln();
    writeln("|=============================================|");
    writeln("|TESTING END: ", __MODULE__);
    writeln("|", __TIME__);
    writeln("|=============================================|");
    writeln();
`;
