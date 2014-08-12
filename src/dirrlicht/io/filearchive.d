/*
    DIrrlicht - D Bindings for Irrlicht Engine

    Copyright (C) 2014- Danyal Zia (catofdanyal@yahoo.com)

    This software is provided 'as-is', without any express or
    implied warranty. In no event will the authors be held
    liable for any damages arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute
    it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented;
       you must not claim that you wrote the original software.
       If you use this software in a product, an acknowledgment
       in the product documentation would be appreciated but
       is not required.

    2. Altered source versions must be plainly marked as such,
       and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any
       source distribution.
*/

module dirrlicht.io.filearchive;

/// FileSystemType: which Filesystem should be used for e.g. browsing
enum EFileSystemType {
	FILESYSTEM_NATIVE = 0,	// Native OS FileSystem
	FILESYSTEM_VIRTUAL	// Virtual FileSystem
}

/// Contains the different types of archives
enum FileArchiveType {
	/// A PKZIP archive
	ZIP,

	/// A gzip archive
	GZIP,

	/// A virtual directory
	Folder,

	/// An ID Software PAK archive
	PAK,

	/// A Nebula Device archive
	NPK,

	/// A Tape ARchive
	TAR,

	/// A wad Archive, Quake2, Halflife
	WAD,

	/// The type of this archive is unknown
	Unknown
}

interface FileArchive {
	@property void* c_ptr();
	@property void c_ptr(void* ptr);
}

class CFileArchive : FileArchive {
	this(irr_IFileArchive* ptr)
    in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }

    @property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
    irr_IFileArchive* ptr;
}

interface ArchiveLoader {
	@property void* c_ptr();
	@property void c_ptr(void* ptr);
}

class CArchiveLoader : ArchiveLoader {
	this(irr_IArchiveLoader* ptr)
    in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }

    @property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
    irr_IArchiveLoader* ptr;
}

unittest {
	import dirrlicht.compileconfig;
	mixin(TestPrerequisite);
}

package extern(C):

struct irr_IFileArchive;
struct irr_IArchiveLoader;
