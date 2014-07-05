[![Build Status](https://travis-ci.org/danyalzia/DIrrlicht.png?branch=master)](https://travis-ci.org/danyalzia/DIrrlicht)

DIrrlicht - D Bindings for Irrlicht Engine
==========================================

Details
-------

DIrrlicht is the D Bindings for Irrlicht Engine which makes it possible to use Irrlicht Engine from D. It copies the API of Irrlicht Engine, but in a way that makes sense in D.

Status
------

It's in very early beta stage. Several functions still aren't wrapped. It is subject to API changes.

Installation
------------

Clone the repository:

```
$ git clone git://github.com/danyalzia/DIrrlicht.git DIrrlicht
```

DIrrlicht relies on CIrrlicht. Fortunately, it is already included as a submodule, just make sure to not forget to update submodules:

```
$ cd DIrrlicht
$ git submodule update --init
```

On Linux, currently the Code::Blocks is supported. It assumes that Irrlicht is installed in "$HOME" directory, so you have to place them in that directory and then open the Code::Blocks project and compile. At later time, building with dub and Visual D will also be supported.

License
-------

It is released under permissive zlib license same as Irrlicht Engine.
