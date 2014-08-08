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

module dirrlicht.io.filelist;

import std.conv : to;
import std.string : toStringz;

/+++
 + Provides a list of files and folders.
 + File lists usually contain a list of all files in a given folder,
 + but can also contain a complete directory structure.
 +/
interface FileList {
	/***
	 * Get the number of files in the filelist.
	 * Return: Amount of files and directories in the file list.
	 */
	uint getFileCount();

	/***
	 * Gets the name of a file in the list, based on an index.
	 * The path is not included in this name. Use getFullFileName for this.
	 * Params:
	 *  index = is the zero based index of the file which name should
	 * 		be returned. The index must be less than the amount getFileCount() returns.
	 * Return: File name of the file. Returns 0, if an error occured.
	 */
	string getFileName(uint index);

	/***
	 * Gets the full name of a file in the list including the path, based on an index.
	 * Params:
	 *  index = is the zero based index of the file which name should
	 * 		be returned. The index must be less than the amount getFileCount() returns.
	 * Return: File name of the file. Returns 0 if an error occured.
	 */
	string getFullFileName(uint index);

	/***
	 * Returns the size of a file in the file list, based on an index.
	 * Params:
	 *  index = is the zero based index of the file which should be returned.
	 * 		The index must be less than the amount getFileCount() returns.
	 * Return: The size of the file in bytes.
	 */
	uint getFileSize(uint index);

	/***
	 * Returns the file offset of a file in the file list, based on an index.
	 * Params:
	 *  index = is the zero based index of the file which should be returned.
	 * 		The index must be less than the amount getFileCount() returns.
	 * Return: The offset of the file in bytes.
	 */
	uint getFileOffset(uint index);

	/***
	 * Returns the ID of a file in the file list, based on an index.
	 * This optional ID can be used to link the file list entry to information held
	 * elsewhere. For example this could be an index in an IFileArchive, linking the entry
	 * to its data offset, uncompressed size and CRC.
	 * Params:
	 *  index = is the zero based index of the file which should be returned.
	 * 		The index must be less than the amount getFileCount() returns.
	 * Return: The ID of the file.
	 */
	uint getID(uint index);

	/***
	 * Check if the file is a directory
	 * Params:
	 *  index = The zero based index which will be checked. The index
	 * 		must be less than the amount getFileCount() returns.
	 * Return: True if the file is a directory, else false.
	 */
	bool isDirectory(uint index);

	/***
	 * Searches for a file or folder in the list
	 * Searches for a file by name
	 * Params:
	 *  filename = The name of the file to search for.
	 *  isFolder = True if you are searching for a directory path, false if you are searching for a file
	 * Return:
	 *  Returns the index of the file in the file list, or -1 if
	 * 		no matching name name was found.
	 */
	int findFile(string filename, bool isFolder=false);

	/// Returns the base path of the file list
	string getPath();

	/***
	 * Add as a file or folder to the list
	 * Params:
	 *  fullPath = The file name including path, from the root of the file list.
	 *  isDirectory = True if this is a directory rather than a file.
	 *  offset = The file offset inside an archive
	 *  size = The size of the file in bytes.
	 *  id = The ID of the file in the archive which owns it
	 */
	uint addItem(string fullPath, uint offset, uint size, bool isDirectory, uint id=0);

	/// Sorts the file list. You should call this after adding any items to the file list
	void sort();
	
	@property void* c_ptr();
	@property void c_ptr(void* ptr);
}

class CFileList : FileList {
	this(irr_IFileList* ptr)
    in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }

	uint getFileCount() {
		return irr_IFileList_getFileCount(ptr);
	}
	
	string getFileName(uint index) {
		return irr_IFileList_getFileName(ptr, index).to!string;
	}
	
	string getFullFileName(uint index) {
		return irr_IFileList_getFullFileName(ptr, index).to!string;
	}
	
	uint getFileSize(uint index) {
		return irr_IFileList_getFileSize(ptr, index);
	}
	
	uint getFileOffset(uint index) {
		return irr_IFileList_getFileOffset(ptr, index);
	}
	
	uint getID(uint index) {
		return irr_IFileList_getID(ptr, index);
	}
	
	bool isDirectory(uint index) {
		return irr_IFileList_isDirectory(ptr, index);
	}
	
	int findFile(string filename, bool isFolder=false) {
		return irr_IFileList_findFile(ptr, filename.toStringz, isFolder);
	}
	
	string getPath() {
		return irr_IFileList_getPath(ptr).to!string;
	}
	
	uint addItem(string fullPath, uint offset, uint size, bool isDirectory, uint id=0) {
		return irr_IFileList_addItem(ptr, fullPath.toStringz, offset, size, isDirectory, id);
	}
	
	void sort() {
		irr_IFileList_sort(ptr);
	}
	
    @property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
    irr_IFileList* ptr;
}

unittest {
	import dirrlicht.compileconfig;
	mixin(TestPrerequisite);
}

package extern(C):

struct irr_IFileList;

uint irr_IFileList_getFileCount(irr_IFileList* filelist);
const(char*) irr_IFileList_getFileName(irr_IFileList* filelist, uint index);
const(char*) irr_IFileList_getFullFileName(irr_IFileList* filelist, uint index);
uint irr_IFileList_getFileSize(irr_IFileList* filelist, uint index);
uint irr_IFileList_getFileOffset(irr_IFileList* filelist, uint index);
uint irr_IFileList_getID(irr_IFileList* filelist, uint index);
bool irr_IFileList_isDirectory(irr_IFileList* filelist, uint index);
int irr_IFileList_findFile(irr_IFileList* filelist, const(char*) filename, bool isFolder=false);
const(char*) irr_IFileList_getPath(irr_IFileList* filelist);
uint irr_IFileList_addItem(irr_IFileList* filelist, const(char*) fullPath, uint offset, uint size, bool isDirectory, uint id=0);
void irr_IFileList_sort(irr_IFileList* filelist);
