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

module dirrlicht.io.xmlwriter;

import dirrlicht.core.array;
import std.conv : to;
import std.utf : toUTFz;

/+++
 + Interface providing methods for making it easier to write XML files.
 + This XML Writer writes xml files using in the platform dependent
 + wchar_t format and sets the xml-encoding correspondingly.
 +/
interface XMLWriter {
	/***
	 * Writes an xml 1.0 header.
	 * Looks like &lt;?xml version="1.0"?&gt;. This should always
	 * be called before writing anything other, because also the text
	 * file header for unicode texts is written out with this method.
	 */
	void writeXMLHeader();

	/***
	 * Writes an xml element with maximal 5 attributes like "<foo />" or
	 *  &lt;foo optAttr="value" /&gt;.
	 *  The element can be empty or not.
	 * Params:
	 *  name = Name of the element
	 * 	empty = Specifies if the element should be empty. Like
	 * 		"<foo />". If You set this to false, something like this is
	 * 		written instead: "<foo>".
	 *  attr1Name = 1st attributes name
	 *  attr1Value = 1st attributes value
	 *  attr2Name = 2nd attributes name
	 *  attr2Value = 2nd attributes value
	 *  attr3Name = 3rd attributes name
	 *  attr3Value = 3rd attributes value
	 *  attr4Name = 4th attributes name
	 *  attr4Value = 4th attributes value
	 *  attr5Name = 5th attributes name
	 *  attr5Value = 5th attributes value
	 */
	void writeElement(string name, bool empty=false,
			string attr1Name = null, string attr1Value = null,
			string attr2Name = null, string attr2Value = null,
			string attr3Name = null, string attr3Value = null,
			string attr4Name = null, string attr4Value = null,
			string attr5Name = null, string attr5Value = null);

	/// ditto
	void writeElement(dstring name, bool empty=false,
			dstring attr1Name = null, dstring attr1Value = null,
			dstring attr2Name = null, dstring attr2Value = null,
			dstring attr3Name = null, dstring attr3Value = null,
			dstring attr4Name = null, dstring attr4Value = null,
			dstring attr5Name = null, dstring attr5Value = null);
			
	/// Writes an xml element with any number of attributes
	void writeElement(string name, bool empty,
				string[] names, string[] values);

	/// ditto
	void writeElement(dstring name, bool empty,
				dstring[] names, dstring[] values);
				
	/// Writes a comment into the xml file
	void writeComment(string comment);

	/// ditto
	void writeComment(dstring comment);
	
	/// Writes the closing tag for an element. Like "</foo>"
	void writeClosingTag(string name);

	/// ditto
	void writeClosingTag(dstring name);
	
	/***
	 * Writes a text into the file.
	 * All occurrences of special characters such as
	 * & (&amp;), < (&lt;), > (&gt;), and " (&quot;) are automaticly
	 * replaced.
	 */
	void writeText(string text);

	/// ditto
	void writeText(dstring text);
	
	/// Writes a line break
	void writeLineBreak();
	@property void* c_ptr();
	@property void c_ptr(void* ptr);
}

class CXMLWriter : XMLWriter {
	this(irr_IXMLWriter* ptr)
    in {
		assert(ptr != null);
	}
	body {
    	this.ptr = ptr;
    }

	void writeXMLHeader() {
		irr_IXMLWriter_writeXMLHeader(ptr);
	}
	
	void writeElement(string name, bool empty=false,
			string attr1Name = null, string attr1Value = null,
			string attr2Name = null, string attr2Value = null,
			string attr3Name = null, string attr3Value = null,
			string attr4Name = null, string attr4Value = null,
			string attr5Name = null, string attr5Value = null) {
		irr_IXMLWriter_writeElement(ptr, name.toUTFz!(const(dchar)*), empty, attr1Name.toUTFz!(const(dchar)*), attr1Value.toUTFz!(const(dchar)*), attr2Name.toUTFz!(const(dchar)*), attr2Value.toUTFz!(const(dchar)*), attr3Name.toUTFz!(const(dchar)*), attr3Value.toUTFz!(const(dchar)*), attr4Name.toUTFz!(const(dchar)*), attr4Value.toUTFz!(const(dchar)*), attr5Name.toUTFz!(const(dchar)*), attr5Value.toUTFz!(const(dchar)*));
	}

	void writeElement(dstring name, bool empty=false,
			dstring attr1Name = null, dstring attr1Value = null,
			dstring attr2Name = null, dstring attr2Value = null,
			dstring attr3Name = null, dstring attr3Value = null,
			dstring attr4Name = null, dstring attr4Value = null,
			dstring attr5Name = null, dstring attr5Value = null) {
		irr_IXMLWriter_writeElement(ptr, name.toUTFz!(const(dchar)*), empty, attr1Name.toUTFz!(const(dchar)*), attr1Value.toUTFz!(const(dchar)*), attr2Name.toUTFz!(const(dchar)*), attr2Value.toUTFz!(const(dchar)*), attr3Name.toUTFz!(const(dchar)*), attr3Value.toUTFz!(const(dchar)*), attr4Name.toUTFz!(const(dchar)*), attr4Value.toUTFz!(const(dchar)*), attr5Name.toUTFz!(const(dchar)*), attr5Value.toUTFz!(const(dchar)*));
	}
	
	void writeElement(string name, bool empty, string[] names, string[] values) {
		irr_array tempnames, tempvalues;
		tempnames.data = names.ptr;
		tempvalues.data = values.ptr;
		irr_IXMLWriter_writeElement2(ptr, name.toUTFz!(const(dchar)*), empty, &tempnames, &tempvalues);
	}

	void writeElement(dstring name, bool empty, dstring[] names, dstring[] values) {
		irr_array tempnames, tempvalues;
		tempnames.data = names.ptr;
		tempvalues.data = values.ptr;
		irr_IXMLWriter_writeElement2(ptr, name.toUTFz!(const(dchar)*), empty, &tempnames, &tempvalues);
	}
	
	void writeComment(string comment) {
		irr_IXMLWriter_writeComment(ptr, comment.toUTFz!(const(dchar)*));
	}

	void writeComment(dstring comment) {
		irr_IXMLWriter_writeComment(ptr, comment.toUTFz!(const(dchar)*));
	}
	
	void writeClosingTag(string name) {
		irr_IXMLWriter_writeClosingTag(ptr, name.toUTFz!(const(dchar)*));
	}

	void writeClosingTag(dstring name) {
		irr_IXMLWriter_writeClosingTag(ptr, name.toUTFz!(const(dchar)*));
	}
	
	void writeText(string text) {
		irr_IXMLWriter_writeText(ptr, text.toUTFz!(const(dchar)*));
	}

	void writeText(dstring text) {
		irr_IXMLWriter_writeText(ptr, text.toUTFz!(const(dchar)*));
	}
	
	void writeLineBreak() {
		irr_IXMLWriter_writeLineBreak(ptr);
	}
	
    @property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
    irr_IXMLWriter* ptr;
}

unittest {
	import dirrlicht.compileconfig;
	mixin(TestPrerequisite);
}

package extern(C):

struct irr_IXMLWriter;

void irr_IXMLWriter_writeXMLHeader(irr_IXMLWriter* writer);
void irr_IXMLWriter_writeElement(irr_IXMLWriter* writer, const(dchar*) name, bool empty=false,
		const(dchar*) attr1Name = null, const(dchar*) attr1Value = null,
		const(dchar*) attr2Name = null, const(dchar*) attr2Value = null,
		const(dchar*) attr3Name = null, const(dchar*) attr3Value = null,
		const(dchar*) attr4Name = null, const(dchar*) attr4Value = null,
		const(dchar*) attr5Name = null, const(dchar*) attr5Value = null);
void irr_IXMLWriter_writeElement2(irr_IXMLWriter* writer, const(dchar*) name, bool empty,
			irr_array* names, irr_array* values);
void irr_IXMLWriter_writeComment(irr_IXMLWriter* writer, const(dchar*) comment);
void irr_IXMLWriter_writeClosingTag(irr_IXMLWriter* writer, const(dchar*) name);
void irr_IXMLWriter_writeText(irr_IXMLWriter* writer, const(dchar*) text);
void irr_IXMLWriter_writeLineBreak(irr_IXMLWriter* writer);
