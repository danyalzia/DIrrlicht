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

import dirrlicht.io.readfile;
import dirrlicht.io.filelist;

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

/+++
 + The FileArchive manages archives and provides access to files inside them.
 +/
interface FileArchive {
	/***
	 * Opens a file based on its name
	 * Creates and returns a new IReadFile for a file in the archive.
	 * Params:
	 *  filename = The file to open
	 * Return: A pointer to the created file on success,
	 * 		or 0 on failure.
	 */
	ReadFile createAndOpenFile(string filename);

	/***
	 * Opens a file based on its position in the file list.
	 * Creates and returns
	 * Params:
	 *  index =  The zero based index of the file.
	 * Return:
	 *  A pointer to the created file on success, or 0 on failure.
	 */
	ReadFile createAndOpenFile(uint index);

	/***
	 * Returns the complete file tree
	 * return Returns the complete directory tree for the archive,
	 * including all files and folders
	 */
	const(FileList) getFileList();

	/// get the archive type
	FileArchiveType getType();

	/// return the name (id) of the file Archive
	string getArchiveName();

	/***
	 * An optionally used password string
	 * This variable is publicly accessible from the interface in order to
	 * avoid single access patterns to this place, and hence allow some more
	 * obscurity.
	 * Note: In DIrrlicht, it is implemented as a property, because D interfaces
	 * 		can't have variables. 
	 */
	@property string password();

	/// ditto
	@property void password(string pass);
	
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

	ReadFile createAndOpenFile(string filename) {
		auto temp =  irr_IFileArchive_createAndOpenFile(ptr, filename.toStringz);
		return new CReadFile(temp);
	}
	
	ReadFile createAndOpenFile(uint index) {
		auto temp =  irr_IFileArchive_createAndOpenFile2(ptr, index);
		return new CReadFile(temp);
	}
	
	const(FileList) getFileList() {
		auto temp =  irr_IFileArchive_getFileList(ptr);
		return new CFileList(cast(irr_IFileList*)temp);
	}
	
	FileArchiveType getType() {
		return irr_IFileArchive_getType(ptr);
	}
	
	string getArchiveName() {
		return irr_IFileArchive_getArchiveName(ptr).to!string;
	}

	@property string password() {
		return irr_IFileArchive_getPassword(ptr).to!string;
	}
	
	@property void password(string pass) {
		irr_IFileArchive_setPassword(ptr, pass.toStringz);
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

/+++
 + Class which is able to create an archive from a file.
 + If you want the Irrlicht Engine be able to load archives of
 + currently unsupported file formats (e.g .wad), then implement
 + this and add your new Archive loader with
 + FileSystem.addArchiveLoader() to the engine.
 +/
interface ArchiveLoader {
	/***
	 * Check if the file might be loaded by this class
	 * Check based on the file extension (e.g. ".zip")
	 * Params:
	 *  filename = Name of file to check.
	 * Return: True if file seems to be loadable.
	 */
	bool isALoadableFileFormat(string filename);

	/***
	 * Check if the file might be loaded by this class
	 * This check may look into the file.
	 * Params:
	 *  file = File handle to check.
	 * Return: True if file seems to be loadable.
	 */
	bool isALoadableFileFormat(ReadFile file);

	/***
	 * Check to see if the loader can create archives of this type.
	 * Check based on the archive type.
	 * Params:
	 *  fileType = The archive type to check.
	 * Return: True if the archile loader supports this type, false if not
	 */
	bool isALoadableFileFormat(FileArchiveType fileType);

	/***
	 * Creates an archive from the filename
	 * Params:
	 *  filename = File to use.
	 *  ignoreCase = Searching is performed without regarding the case
	 *  ignorePaths = Files are searched for without checking for the directories
	 * Return: Pointer to newly created archive, or 0 upon error.
	 */
	FileArchive createArchive(string filename, bool ignoreCase, bool ignorePaths);

	/***
	 * Creates an archive from the file
	 * Params:
	 *  file = File handle to use.
	 *  ignoreCase = Searching is performed without regarding the case
	 *  ignorePaths = Files are searched for without checking for the directories
	 * Return: Pointer to newly created archive, or 0 upon error.
	 */
	FileArchive createArchive(ReadFile file, bool ignoreCase, bool ignorePaths);
	
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

	bool isALoadableFileFormat(string filename) {
		return irr_IArchiveLoader_isALoadableFileFormat(ptr, filename.toStringz);
	}
	
	bool isALoadableFileFormat(ReadFile file) {
		return irr_IArchiveLoader_isALoadableFileFormat2(ptr, cast(irr_IReadFile*)file.c_ptr);
	}
	
	bool isALoadableFileFormat(FileArchiveType fileType) {
		return irr_IArchiveLoader_isALoadableFileFormat3(ptr, fileType);
	}
	
	FileArchive createArchive(string filename, bool ignoreCase, bool ignorePaths) {
		auto temp = irr_IArchiveLoader_createArchive(ptr, filename.toStringz, ignoreCase, ignorePaths);
		return new CFileArchive(temp);
	}
	
	FileArchive createArchive(ReadFile file, bool ignoreCase, bool ignorePaths) {
		auto temp = irr_IArchiveLoader_createArchive2(ptr, cast(irr_IReadFile*)file.c_ptr, ignoreCase, ignorePaths);
		return new CFileArchive(temp);
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

irr_IReadFile* irr_IFileArchive_createAndOpenFile(irr_IFileArchive* filearchive, const(char*) filename);
irr_IReadFile* irr_IFileArchive_createAndOpenFile2(irr_IFileArchive* filearchive, uint index);
const(irr_IFileList*) irr_IFileArchive_getFileList(irr_IFileArchive* filearchive);
FileArchiveType irr_IFileArchive_getType(irr_IFileArchive* filearchive);
const(char*) irr_IFileArchive_getArchiveName(irr_IFileArchive* filearchive);
void irr_IFileArchive_setPassword(irr_IFileArchive* filearchive, const(char*) pass);
const(char*) irr_IFileArchive_getPassword(irr_IFileArchive* filearchive);

struct irr_IArchiveLoader;

bool irr_IArchiveLoader_isALoadableFileFormat(irr_IArchiveLoader* loader, const(char*) filename);
bool irr_IArchiveLoader_isALoadableFileFormat2(irr_IArchiveLoader* loader, irr_IReadFile* file);
bool irr_IArchiveLoader_isALoadableFileFormat3(irr_IArchiveLoader* loader, FileArchiveType fileType);
irr_IFileArchive* irr_IArchiveLoader_createArchive(irr_IArchiveLoader* loader, const(char*) filename, bool ignoreCase, bool ignorePaths);
irr_IFileArchive* irr_IArchiveLoader_createArchive2(irr_IArchiveLoader* loader, irr_IReadFile* file, bool ignoreCase, bool ignorePaths);
