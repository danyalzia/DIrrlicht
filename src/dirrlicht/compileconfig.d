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

template checkNull(string name)
{
	const char[] checkNull = "assert(" ~ name ~ " !is null);" ~ "assert(" ~ name ~ ".ptr" ~ "!= null);";
}

enum TestPrerequisite =
`
    import std.stdio;
    import dirrlicht.all;
    
    writeln();
    writeln("=====================");
    writeln("TESTING ", __MODULE__);
    writeln(__TIME__);
    writeln("=====================");
    writeln();

    auto device = createDevice(DriverType.OpenGL, dimension2du(800,600));
    mixin(checkNull!("device"));

    auto driver = device.videoDriver;
    mixin(checkNull!("driver"));

    auto smgr = device.sceneManager;
    mixin(checkNull!("smgr"));

    auto gui = device.guiEnvironment;
    mixin(checkNull!("gui"));
`;
