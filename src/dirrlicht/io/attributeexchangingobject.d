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

module dirrlicht.io.attributeexchangingobject;

import dirrlicht.io.attributes;
import std.string : toStringz;

/// Enumeration flags passed through SAttributeReadWriteOptions to the IAttributeExchangingObject object
enum AttributeReadWriteFlag {
    /// Serialization/Deserializion is done for an xml file
    ForFile = 0x00000001,

    /// Serialization/Deserializion is done for an editor property box
    ForEditor = 0x00000002,

    /// When writing filenames, relative paths should be used
    UseRelativePaths = 0x00000004
}

/// struct holding data describing options
struct AttributeReadWriteOptions {
    /// Combination of E_ATTRIBUTE_READ_WRITE_FLAGS or other, custom ones
    int Flags;

    ///  Optional filename
    string Filename;

    //@property irr_SAttributeReadWriteOptions ptr() {
		//irr_SAttributeReadWriteOptions temp;
		//temp.Flags = Flags;
		//temp.Filename = Filename.toStringz;
		//return temp;
	//}
}

/// An object which is able to serialize and deserialize its attributes into an attributes object
class AttributeExchangingObject {
public:

    /// Writes attributes of the object.
    /** Implement this to expose the attributes of your scene node animator for
    scripting languages, editors, debuggers or xml serialization purposes.
    */
    void serializeAttributes(out Attributes att, AttributeReadWriteOptions options=AttributeReadWriteOptions(0, null)) {}

    /// Reads attributes of the object.
    /** Implement this to set the attributes of your scene node animator for
    scripting languages, editors, debuggers or xml deserialization purposes.
    */
    void deserializeAttributes(in Attributes att, AttributeReadWriteOptions options=AttributeReadWriteOptions(0, null)) {}
}

package extern (C):

struct irr_SAttributeReadWriteOptions {
	int Flags;
	const char* Filename;
}


