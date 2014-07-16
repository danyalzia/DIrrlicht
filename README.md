[![Build Status](https://travis-ci.org/Artistic-Games/DIrrlicht.png?branch=master)](https://travis-ci.org/Artistic-Games/DIrrlicht)
[![Stories in Ready](https://badge.waffle.io/artistic-games/dirrlicht.png?label=ready&title=Ready)](https://waffle.io/artistic-games/dirrlicht)
[![Gitter chat](https://badges.gitter.im/Artistic-Games/DIrrlicht.png)](https://gitter.im/Artistic-Games/DIrrlicht)

DIrrlicht - D Bindings for Irrlicht Engine
=========================================================

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
$ git clone git://github.com/Artistic-Games/DIrrlicht.git DIrrlicht
```

DIrrlicht relies on CIrrlicht. Fortunately, it is already included as a submodule, just make sure to not forget to update submodules:

```
$ cd DIrrlicht
$ git submodule update --init
```

On Linux, it assumes that Irrlicht is installed in "$HOME" directory, so you have to place the irrlicht's folder in that directory. To create dynamic libray, in `CIrrlicht` do:

```
$ sudo make sharedlib
```

It will create a library in `lib`.

Contributing
------------

DIrrlicht aims to be a community driven project. It needs your help to grow up. Any kind of help will be fully appreciated. Feel free to open issues, send pull requests or just send me an email. If you provide some good pull requests and moral support, you may be given the rights to commit directly.

Before making a commit, please try to adhere to the coding [style](https://github.com/Artistic-Games/DIrrlicht/blob/master/CONTRIBUTING.md) of DIrrlicht.

Unit Tests
----------

Unit Tests are being aggressively tested through Travis Cl on every push. It uses only those resources that are in repository. To run them offline, do `dub test`. You can pass an extra flag for other compilers (i.e. GDC and LDC) such as `--compiler gdc` and `--compiler ldc2`.

License
-------

It is released under permissive zlib license same as Irrlicht Engine.
