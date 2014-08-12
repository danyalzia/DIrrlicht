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

module dirrlicht.io.filesystem;

import dirrlicht.io.filearchive;
import dirrlicht.io.readfile;
import dirrlicht.io.writefile;
import dirrlicht.io.filelist;
import dirrlicht.io.xmlreader;
import dirrlicht.io.xmlwriter;
import dirrlicht.io.attributes;
import dirrlicht.video.videodriver;

import std.string;

/+++
 + The FileSystem manages files and archives and provides access to them.
 + It manages where files are, so that modules which use the the IO do not
 + need to know where every file is located. A file could be in a .zip-Archive or
 + as file on disk, using the FileSystem makes no difference to this.
 +/
interface FileSystem {
	/***
	 * Opens a file for read access.
	 * Params:
	 *  filename = Name of file to open.
	 * Return: Pointer to the created file interface.
	 * 		The returned pointer should be dropped when no longer needed.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	ReadFile createAndOpenFile(string filename);

	/***
	 * Creates an IReadFile interface for accessing memory like a file.
	 * This allows you to use a pointer to memory where an IReadFile is requested.
	 * Params:
	 *  memory = A pointer to the start of the file in memory
	 *	len = The length of the memory in bytes
	 * 	fileName = The name given to this file
	 * 	deleteMemoryWhenDropped = True if the memory should be deleted
	 * 		along with the IReadFile when it is dropped.
	 * Return: Pointer to the created file interface.
	 * 		The returned pointer should be dropped when no longer needed.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	ReadFile createMemoryReadFile(const void* memory, int len, string fileName, bool deleteMemoryWhenDropped=false);

	/***
	 * Creates an IReadFile interface for accessing files inside files.
	 * This is useful e.g. for archives.
	 * Params:
	 *  fileName = The name given to this file
	 *  alreadyOpenedFile = Pointer to the enclosing file
	 *  pos = Start of the file inside alreadyOpenedFile
	 *  areaSize = The length of the file
	 * Return: A pointer to the created file interface.
	 * 		The returned pointer should be dropped when no longer needed.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	ReadFile createLimitReadFile(string fileName, ReadFile alreadyOpenedFile, long pos, long areaSize);

	/***
	 * Creates an IWriteFile interface for accessing memory like a file.
	 * This allows you to use a pointer to memory where an IWriteFile is requested.
	 * You are responsible for allocating enough memory.
	 * Params:
	 *  memory = A pointer to the start of the file in memory (allocated by you)
	 * 	len = The length of the memory in bytes
	 * 	fileName = The name given to this file
	 *	deleteMemoryWhenDropped = True if the memory should be deleted
	 * 		along with the IWriteFile when it is dropped.
	 * Return: Pointer to the created file interface.
	 * 		The returned pointer should be dropped when no longer needed.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	WriteFile createMemoryWriteFile(void* memory, int len, string fileName, bool deleteMemoryWhenDropped=false);

	/***
	 * Opens a file for write access.
	 * Params:
	 *  filename = Name of file to open.
	 * 	append = If the file already exist, all write operations are
	 * 		appended to the file.
	 * Return: Pointer to the created file interface. 0 is returned, if the
	 * 		file could not created or opened for writing.
	 * 		The returned pointer should be dropped when no longer needed.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	WriteFile createAndWriteFile(string filename, bool append=false);

	/***
	 * Adds an archive to the file system.
	 * After calling this, the Irrlicht Engine will also search and open
	 * files directly from this archive. This is useful for hiding data from
	 * the end user, speeding up file access and making it possible to access
	 * for example Quake3 .pk3 files, which are just renamed .zip files. By
	 * default Irrlicht supports ZIP, PAK, TAR, PNK, and directories as
	 * archives. You can provide your own archive types by implementing
	 * ArchiveLoader and passing an instance to addArchiveLoader.
	 * Irrlicht supports AES-encrypted zip files, and the advanced compression
	 * techniques lzma and bzip2.
	 * If you want to add a directory as an archive, prefix its name with a
	 * slash in order to let Irrlicht recognize it as a folder mount (mypath/).
	 * Using this technique one can build up a search order, because archives
	 * are read first, and can be used more easily with relative filenames.
	 * Params:
	 *  filename = filename: Filename of the archive to add to the file system.
	 *  ignoreCase = If set to true, files in the archive can be accessed without
	 * 		writing all letters in the right case.
	 * 	ignorePaths = If set to true, files in the added archive can be accessed
	 * 		without its complete path.
	 *  archiveType = If no specific E_FILE_ARCHIVE_TYPE is selected then
	 * 		the type of archive will depend on the extension of the file name. If
	 * 		you use a different extension then you can use this parameter to force
	 * 		a specific type of archive.
	 * 	password = An optional password, which is used in case of encrypted archives.
	 * 	retArchive = A pointer that will be set to the archive that is added.
	 * Return: True if the archive was added successfully, false if not.
	 */
	bool addFileArchive(string filename, bool ignoreCase=true,
			bool ignorePaths=true,
			FileArchiveType archiveType=FileArchiveType.Unknown,
			string password="",
			FileArchive** retArchive=null);

	/***
	 * Adds an archive to the file system.
	 * After calling this, the Irrlicht Engine will also search and open
	 * files directly from this archive. This is useful for hiding data from
	 * the end user, speeding up file access and making it possible to access
	 * for example Quake3 .pk3 files, which are just renamed .zip files. By
	 * default Irrlicht supports ZIP, PAK, TAR, PNK, and directories as
	 * archives. You can provide your own archive types by implementing
	 * ArchiveLoader and passing an instance to addArchiveLoader.
	 * Irrlicht supports AES-encrypted zip files, and the advanced compression
	 * techniques lzma and bzip2.
	 * If you want to add a directory as an archive, prefix its name with a
	 * slash in order to let Irrlicht recognize it as a folder mount (mypath/).
	 * Using this technique one can build up a search order, because archives
	 * are read first, and can be used more easily with relative filenames.
	 * Params:
	 *  file = Archive to add to the file system.
	 *  ignoreCase = If set to true, files in the archive can be accessed without
	 * 		writing all letters in the right case.
	 * 	ignorePaths = If set to true, files in the added archive can be accessed
	 * 		without its complete path.
	 *  archiveType = If no specific E_FILE_ARCHIVE_TYPE is selected then
	 * 		the type of archive will depend on the extension of the file name. If
	 * 		you use a different extension then you can use this parameter to force
	 * 		a specific type of archive.
	 * 	password = An optional password, which is used in case of encrypted archives.
	 * 	retArchive = A pointer that will be set to the archive that is added.
	 * Return: True if the archive was added successfully, false if not.
	 */
	bool addFileArchive(ReadFile file, bool ignoreCase=true,
			bool ignorePaths=true,
			FileArchiveType archiveType=FileArchiveType.Unknown,
			string password="",
			irr_IFileArchive** retArchive=null);

	/***
	 * Adds an archive to the file system.
	 * Params:
	 *  archive = The archive to add to the file system.
	 * Return: True if the archive was added successfully, false if not.
	 */
	bool addFileArchive(FileArchive archive);

	/// Get the number of archives currently attached to the file system
	uint getFileArchiveCount();

	/***
	 * Removes an archive from the file system.
	 * This will close the archive and free any file handles, but will not
	 * close resources which have already been loaded and are now cached, for
	 * example textures and meshes.
	 * Params:
	 *  index = The index of the archive to remove
	 * Return: True on success, false on failure
	 */
	bool removeFileArchive(uint index);

	/***
	 * Removes an archive from the file system.
	 * This will close the archive and free any file handles, but will not
	 * close resources which have already been loaded and are now cached, for
	 * example textures and meshes. Note that a relative filename might be
	 * interpreted differently on each call, depending on the current working
	 * directory. In case you want to remove an archive that was added using
	 * a relative path name, you have to change to the same working directory
	 * again. This means, that the filename given on creation is not an
	 * identifier for the archive, but just a usual filename that is used for
	 * locating the archive to work with.
	 * Params:
	 *  filename = The archive pointed to by the name will be removed
	 * Return: True on success, false on failure
	 */
	bool removeFileArchive(string filename);

	/***
	 * Removes an archive from the file system.
	 * This will close the archive and free any file handles, but will not
	 * close resources which have already been loaded and are now cached, for
	 * example textures and meshes.
	 * param archive The archive to remove.
	 * Return: True on success, false on failure
	 */
	bool removeFileArchive(FileArchive archive);

	/***
	 * Changes the search order of attached archives.
	 * 
	 * Params:
	 *  sourceIndex = The index of the archive to change
	 *  relative = The relative change in position, archives with a lower index are searched first
	 */
	bool moveFileArchive(uint sourceIndex, int relative);

	/// Get the archive at a given index.
	FileArchive getFileArchive(uint index);

	/***
	 * Adds an external archive loader to the engine.
	 * Use this function to add support for new archive types to the
	 * engine, for example proprietary or encrypted file storage.
	 */
	void addArchiveLoader(ArchiveLoader loader);

	/// Gets the number of archive loaders currently added
	uint getArchiveLoaderCount();

	/***
	 * Retrieve the given archive loader
	 * Params:
	 *  index = The index of the loader to retrieve. This parameter is an 0-based
	 * 		array index.
	 * Return: A pointer to the specified loader, 0 if the index is incorrect.
	 */
	ArchiveLoader getArchiveLoader(uint index);

	/***
	 * Get the current working directory.
	 * Return: Current working directory as a string.
	 */
	string getWorkingDirectory();

	/***
	 * Changes the current working directory.
	 * param newDirectory: A string specifying the new working directory.
	 * The string is operating system dependent. Under Windows it has
	 * the form "<drive>:\<directory>\<sudirectory>\<..>". An example would be: "C:\Windows\"
	 * Return: True if successful, otherwise false.
	 */
	bool changeWorkingDirectoryTo(string newDirectory);

	/***
	 * Converts a relative path to an absolute (unique) path, resolving symbolic links if required
	 * Params:
	 *  filename = Possibly relative file or directory name to query.
	 * Return: Absolute filename which points to the same file.
	 */
	char* getAbsolutePath(string filename);

	/***
	 * Get the directory a file is located in.
	 * Params:
	 *  filename = The file to get the directory from.
	 * Return: String containing the directory of the file.
	 */
	char* getFileDir(string filename);

	/***
	 * Get the base part of a filename, i.e. the name without the directory part.
	 * If no directory is prefixed, the full name is returned.
	 * Params:
	 *  filename = The file to get the basename from
	 *  keepExtension = True if filename with extension is returned otherwise everything
	 * 		after the final '.' is removed as well.
	 */
	char* getFileBasename(string filename, bool keepExtension=true);

	/// flatten a path and file name for example: "/you/me/../." becomes "/you"
	char* flattenFilename(char* directory, string root="/");

	/// Get the relative filename, relative to the given directory
	char* getRelativeFilename(string filename, string directory);

	/***
	 * Creates a list of files and directories in the current working directory and returns it.
	 * Return: a Pointer to the created IFileList is returned. After the list has been used
	 * it has to be deleted using its IFileList::drop() method.
	 * See IReferenceCounted::drop() for more information.
	 */
	FileList createFileList();

	/***
	 * Creates an empty filelist
	 * Return: a Pointer to the created IFileList is returned. After the list has been used
	 * it has to be deleted using its IFileList::drop() method.
	 * See IReferenceCounted::drop() for more information.
	 */
	FileList createEmptyFileList(string path, bool ignoreCase, bool ignorePaths);

	/// Set the active type of file system.
	EFileSystemType setFileListSystem(EFileSystemType listType);

	/***
	 * Determines if a file exists and could be opened.
	 * Params:
	 *  filename = is the string identifying the file which should be tested for existence.
	 * Return: True if file exists, and false if it does not exist or an error occured.
	 */
	bool existFile(string filename);

	/***
	 * Creates a XML Reader from a file which returns all parsed strings as wide characters (wchar_t*).
	 * Use createXMLReaderUTF8() if you prefer char* instead of wchar_t*. See IIrrXMLReader for
	 * more information on how to use the parser.
	 * Return: 0, if file could not be opened, otherwise a pointer to the created
	 * 		XMLReader is returned. After use, the reader
	 *		 has to be deleted using its IXMLReader::drop() method.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	XMLReader createXMLReader(string filename);

	/***
	 * Creates a XML Reader from a file which returns all parsed strings as wide characters (wchar_t*).
	 * Use createXMLReaderUTF8() if you prefer char* instead of wchar_t*. See IIrrXMLReader for
	 * more information on how to use the parser.
	 * Return: 0, if file could not be opened, otherwise a pointer to the created
	 * 		XMLReader is returned. After use, the reader
	 *		 has to be deleted using its IXMLReader::drop() method.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	XMLReader createXMLReader(ReadFile file);

	/***
	 * Creates a XML Reader from a file which returns all parsed strings as ASCII/UTF-8 characters (char*).
	 * Use createXMLReader() if you prefer wchar_t* instead of char*. See IIrrXMLReader for
	 * more information on how to use the parser.
	 * Return: 0, if file could not be opened, otherwise a pointer to the created
	 * 		XMLReader is returned. After use, the reader
	 * 		has to be deleted using its IXMLReaderUTF8::drop() method.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	XMLReaderUTF8 createXMLReaderUTF8(string filename);

	/***
	 * Creates a XML Reader from a file which returns all parsed strings as ASCII/UTF-8 characters (char*).
	 * Use createXMLReader() if you prefer wchar_t* instead of char*. See IIrrXMLReader for
	 * more information on how to use the parser.
	 * Return: 0, if file could not be opened, otherwise a pointer to the created
	 * 		XMLReader is returned. After use, the reader
	 * 		has to be deleted using its IXMLReaderUTF8::drop() method.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	XMLReaderUTF8 createXMLReaderUTF8(ReadFile file);

	/***
	 * Creates a XML Writer from a file.
	 * Return: 0, if file could not be opened, otherwise a pointer to the created
	 * 		XMLWriter is returned. After use, the reader
	 * 		has to be deleted using its IXMLWriter::drop() method.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	XMLWriter createXMLWriter(string filename);

	/***
	 * Creates a XML Writer from a file.
	 * Return: 0, if file could not be opened, otherwise a pointer to the created
	 * 		XMLWriter is returned. After use, the reader
	 * 		has to be deleted using its IXMLWriter::drop() method.
	 * 		See IReferenceCounted::drop() for more information.
	 */
	XMLWriter createXMLWriter(WriteFile file);

	/***
	 * Creates a new empty collection of attributes, usable for serialization and more.
	 * Params:
	 *  driver = Video driver to be used to load textures when specified as attribute values.
	 * 		Can be null to prevent automatic texture loading by attributes.
	 * Return: Pointer to the created object.
	 * 		If you no longer need the object, you should call IAttributes::drop().
	 * 		See IReferenceCounted::drop() for more information.
	 */
	Attributes createEmptyAttributes(VideoDriver driver=null);
	
	@property void* c_ptr();
	@property void c_ptr(void* ptr);
}

class CFileSystem : FileSystem {
    this(irr_IFileSystem* ptr)
    in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }

	ReadFile createAndOpenFile(string filename) {
		auto temp = irr_IFileSystem_createAndOpenFile(ptr, filename.toStringz);
		return new CReadFile(temp);
	}
	
	ReadFile createMemoryReadFile(const void* memory, int len, string fileName, bool deleteMemoryWhenDropped=false) {
		auto temp = irr_IFileSystem_createMemoryReadFile(ptr, memory, len, fileName.toStringz, deleteMemoryWhenDropped);
		return new CReadFile(temp);
	}
	
	ReadFile createLimitReadFile(string fileName, ReadFile alreadyOpenedFile, long pos, long areaSize) {
		auto temp = irr_IFileSystem_createLimitReadFile(ptr, fileName.toStringz, cast(irr_IReadFile*)alreadyOpenedFile.c_ptr, pos, areaSize);
		return new CReadFile(temp);
	}
	
	WriteFile createMemoryWriteFile(void* memory, int len, string fileName, bool deleteMemoryWhenDropped=false) {
		auto temp = irr_IFileSystem_createMemoryWriteFile(ptr, memory, len, fileName.toStringz, deleteMemoryWhenDropped);
		return new CWriteFile(temp);
	}
	
	WriteFile createAndWriteFile(string filename, bool append=false) {
		auto temp = irr_IFileSystem_createAndWriteFile(ptr, filename.toStringz, append);
		return new CWriteFile(temp);
	}
	
	bool addFileArchive(string filename, bool ignoreCase=true,
			bool ignorePaths=true,
			FileArchiveType archiveType=FileArchiveType.Unknown,
			string password="",
			FileArchive** retArchive=null) {
		return irr_IFileSystem_addFileArchive(ptr, filename.toStringz, ignoreCase, ignorePaths, archiveType, password.toStringz/*, retArchive.c_ptr*/);
	}
	
	bool addFileArchive(ReadFile file, bool ignoreCase=true,
			bool ignorePaths=true,
			FileArchiveType archiveType=FileArchiveType.Unknown,
			string password="",
			irr_IFileArchive** retArchive=null) {
		return irr_IFileSystem_addFileArchive2(ptr, cast(irr_IReadFile*)file.c_ptr, ignoreCase, ignorePaths, archiveType, password.toStringz/*, retArchive.c_ptr*/);
	}
	
	bool addFileArchive(FileArchive archive) {
		return irr_IFileSystem_addFileArchive3(ptr, cast(irr_IFileArchive*)archive.c_ptr);
	}
	
	uint getFileArchiveCount() {
		return irr_IFileSystem_getFileArchiveCount(ptr);
	}
	
	bool removeFileArchive(uint index) {
		return irr_IFileSystem_removeFileArchive(ptr, index);
	}
	
	bool removeFileArchive(string filename) {
		return irr_IFileSystem_removeFileArchive2(ptr, filename.toStringz);
	}
	
	bool removeFileArchive(FileArchive archive) {
		return irr_IFileSystem_removeFileArchive3(ptr, cast(irr_IFileArchive*)archive.c_ptr);
	}
	
	bool moveFileArchive(uint sourceIndex, int relative) {
		return irr_IFileSystem_moveFileArchive(ptr, sourceIndex, relative);
	}
	
	FileArchive getFileArchive(uint index) {
		auto temp = irr_IFileSystem_getFileArchive(ptr, index);
		return new CFileArchive(temp);
	}
	
	void addArchiveLoader(ArchiveLoader loader) {
		irr_IFileSystem_addArchiveLoader(ptr, cast(irr_IArchiveLoader*)loader.c_ptr);
	}
	
	uint getArchiveLoaderCount() {
		return irr_IFileSystem_getArchiveLoaderCount(ptr);
	}
	
	ArchiveLoader getArchiveLoader(uint index) {
		auto temp = irr_IFileSystem_getArchiveLoader(ptr, index);
		return new CArchiveLoader(temp);
	}
	
	string getWorkingDirectory() {
		return irr_IFileSystem_getWorkingDirectory(ptr).to!string;
	}
	
	bool changeWorkingDirectoryTo(string newDirectory) {
		return irr_IFileSystem_changeWorkingDirectoryTo(ptr, newDirectory.toStringz);
	}
	
	char* getAbsolutePath(string filename) {
		return irr_IFileSystem_getAbsolutePath(ptr, filename.toStringz);
	}
	
	char* getFileDir(string filename) {
		return irr_IFileSystem_getFileDir(ptr, filename.toStringz);
	}
	
	char* getFileBasename(string filename, bool keepExtension=true) {
		return irr_IFileSystem_getFileBasename(ptr, filename.toStringz, keepExtension);
	}
	
	char* flattenFilename(char* directory, string root="/") {
		return irr_IFileSystem_flattenFilename(ptr, directory, root.toStringz);
	}
	
	char* getRelativeFilename(string filename, string directory) {
		return irr_IFileSystem_getRelativeFilename(ptr, filename.toStringz, directory.toStringz);
	}
	
	FileList createFileList() {
		auto temp = irr_IFileSystem_createFileList(ptr);
		return new CFileList(temp);
	}
	
	FileList createEmptyFileList(string path, bool ignoreCase, bool ignorePaths) {
		auto temp = irr_IFileSystem_createEmptyFileList(ptr, path.toStringz, ignoreCase, ignorePaths);
		return new CFileList(temp);
	}
	
	EFileSystemType setFileListSystem(EFileSystemType listType) {
		return irr_IFileSystem_setFileListSystem(ptr, listType);
	}
	
	bool existFile(string filename) {
		return irr_IFileSystem_existFile(ptr, filename.toStringz);
	}
	
	XMLReader createXMLReader(string filename) {
		auto temp = irr_IFileSystem_createXMLReader(ptr, filename.toStringz);
		return new CXMLReader(temp);
	}
	
	XMLReader createXMLReader(ReadFile file) {
		auto temp = irr_IFileSystem_createXMLReader2(ptr, cast(irr_IReadFile*)file.c_ptr);
		return new CXMLReader(temp);
	}
	
	XMLReaderUTF8 createXMLReaderUTF8(string filename) {
		auto temp = irr_IFileSystem_createXMLReaderUTF8(ptr, filename.toStringz);
		return new CXMLReaderUTF8(temp);
	}
	
	XMLReaderUTF8 createXMLReaderUTF8(ReadFile file) {
		auto temp = irr_IFileSystem_createXMLReaderUTF82(ptr, cast(irr_IReadFile*)file.c_ptr);
		return new CXMLReaderUTF8(temp);
	}
	
	XMLWriter createXMLWriter(string filename) {
		auto temp = irr_IFileSystem_createXMLWriter(ptr, filename.toStringz);
		return new CXMLWriter(temp);
	}
	
	XMLWriter createXMLWriter(WriteFile file) {
		auto temp = irr_IFileSystem_createXMLWriter2(ptr, cast(irr_IWriteFile*)file.c_ptr);
		return new CXMLWriter(temp);
	}
	
	Attributes createEmptyAttributes(VideoDriver driver=null) {
		auto temp = irr_IFileSystem_createEmptyAttributes(ptr, driver.ptr);
		return new CAttributes(temp);
	}
	
	@property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
	
private:
    irr_IFileSystem* ptr;
}

unittest {
	import dirrlicht.compileconfig;
	mixin(TestPrerequisite);
}

package extern (C):

struct irr_IFileSystem;

irr_IReadFile* irr_IFileSystem_createAndOpenFile(irr_IFileSystem* filesys, const(char*) filename);
irr_IReadFile* irr_IFileSystem_createMemoryReadFile(irr_IFileSystem* filesys, const void* memory, int len, const(char*) fileName, bool deleteMemoryWhenDropped=false);
irr_IReadFile* irr_IFileSystem_createLimitReadFile(irr_IFileSystem* filesys, const(char*) fileName, irr_IReadFile* alreadyOpenedFile, long pos, long areaSize);
irr_IWriteFile* irr_IFileSystem_createMemoryWriteFile(irr_IFileSystem* filesys, void* memory, int len, const(char*) fileName, bool deleteMemoryWhenDropped=false);
irr_IWriteFile* irr_IFileSystem_createAndWriteFile(irr_IFileSystem* filesys, const(char*) filename, bool append=false);
bool irr_IFileSystem_addFileArchive(irr_IFileSystem* filesys, const(char*) filename, bool ignoreCase=true,
		bool ignorePaths=true,
		FileArchiveType archiveType=FileArchiveType.Unknown,
		const(char*) password="",
		irr_IFileArchive** retArchive=null);
bool irr_IFileSystem_addFileArchive2(irr_IFileSystem* filesys, irr_IReadFile* file, bool ignoreCase=true,
		bool ignorePaths=true,
		FileArchiveType archiveType=FileArchiveType.Unknown,
		const(char*) password="",
		irr_IFileArchive** retArchive=null);
bool irr_IFileSystem_addFileArchive3(irr_IFileSystem* filesys, irr_IFileArchive* archive);
uint irr_IFileSystem_getFileArchiveCount(irr_IFileSystem* filesys);
bool irr_IFileSystem_removeFileArchive(irr_IFileSystem* filesys, uint index);
bool irr_IFileSystem_removeFileArchive2(irr_IFileSystem* filesys, const(char*) filename);
bool irr_IFileSystem_removeFileArchive3(irr_IFileSystem* filesys, const irr_IFileArchive* archive);
bool irr_IFileSystem_moveFileArchive(irr_IFileSystem* filesys, uint sourceIndex, int relative);
irr_IFileArchive* irr_IFileSystem_getFileArchive(irr_IFileSystem* filesys, uint index);
void irr_IFileSystem_addArchiveLoader(irr_IFileSystem* filesys, irr_IArchiveLoader* loader);
uint irr_IFileSystem_getArchiveLoaderCount(irr_IFileSystem* filesys);
irr_IArchiveLoader* irr_IFileSystem_getArchiveLoader(irr_IFileSystem* filesys, uint index);
const(char*) irr_IFileSystem_getWorkingDirectory(irr_IFileSystem* filesys);
bool irr_IFileSystem_changeWorkingDirectoryTo(irr_IFileSystem* filesys, const(char*) newDirectory);
char* irr_IFileSystem_getAbsolutePath(irr_IFileSystem* filesys, const(char*) filename);
char* irr_IFileSystem_getFileDir(irr_IFileSystem* filesys, const(char*) filename);
char* irr_IFileSystem_getFileBasename(irr_IFileSystem* filesys, const(char*) filename, bool keepExtension=true);
char* irr_IFileSystem_flattenFilename(irr_IFileSystem* filesys, char* directory, const(char*) root="/");
char* irr_IFileSystem_getRelativeFilename(irr_IFileSystem* filesys, const(char*) filename, const(char*) directory);
irr_IFileList* irr_IFileSystem_createFileList(irr_IFileSystem* filesys);
irr_IFileList* irr_IFileSystem_createEmptyFileList(irr_IFileSystem* filesys, const(char*) path, bool ignoreCase, bool ignorePaths);
EFileSystemType irr_IFileSystem_setFileListSystem(irr_IFileSystem* filesys, EFileSystemType listType);
bool irr_IFileSystem_existFile(irr_IFileSystem* filesys, const(char*) filename);
irr_IXMLReader* irr_IFileSystem_createXMLReader(irr_IFileSystem* filesys, const(char*) filename);
irr_IXMLReader* irr_IFileSystem_createXMLReader2(irr_IFileSystem* filesys, irr_IReadFile* file);
irr_IXMLReaderUTF8* irr_IFileSystem_createXMLReaderUTF8(irr_IFileSystem* filesys, const(char*) filename);
irr_IXMLReaderUTF8* irr_IFileSystem_createXMLReaderUTF82(irr_IFileSystem* filesys, irr_IReadFile* file);
irr_IXMLWriter* irr_IFileSystem_createXMLWriter(irr_IFileSystem* filesys, const(char*) filename);
irr_IXMLWriter* irr_IFileSystem_createXMLWriter2(irr_IFileSystem* filesys, irr_IWriteFile* file);
irr_IAttributes* irr_IFileSystem_createEmptyAttributes(irr_IFileSystem* filesys, irr_IVideoDriver* driver=null);
