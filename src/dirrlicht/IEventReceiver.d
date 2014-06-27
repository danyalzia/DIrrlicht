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

module dirrlicht.IEventReceiver;

import dirrlicht.IrrlichtDevice;

enum EEVENT_TYPE
{
	/// An event of the graphical user interface.
	/** GUI events are created by the GUI environment or the GUI elements in response
	to mouse or keyboard events. When a GUI element receives an event it will either
	process it and return true, or pass the event to its parent. If an event is not absorbed
	before it reaches the root element then it will then be passed to the user receiver. */
	EET_GUI_EVENT = 0,

	/// A mouse input event.
	/** Mouse events are created by the device and passed to IrrlichtDevice::postEventFromUser
	in response to mouse input received from the operating system.
	Mouse events are first passed to the user receiver, then to the GUI environment and its elements,
	then finally the input receiving scene manager where it is passed to the active camera.
	*/
	EET_MOUSE_INPUT_EVENT,

	/// A key input event.
	/** Like mouse events, keyboard events are created by the device and passed to
	IrrlichtDevice::postEventFromUser. They take the same path as mouse events. */
	EET_KEY_INPUT_EVENT,

	/// A joystick (joypad, gamepad) input event.
	/** Joystick events are created by polling all connected joysticks once per
	device run() and then passing the events to IrrlichtDevice::postEventFromUser.
	They take the same path as mouse events.
	Windows, SDL: Implemented.
	Linux: Implemented, with POV hat issues.
	MacOS / Other: Not yet implemented.
	*/
	EET_JOYSTICK_INPUT_EVENT,

	/// A log event
	/** Log events are only passed to the user receiver if there is one. If they are absorbed by the
	user receiver then no text will be sent to the console. */
	EET_LOG_TEXT_EVENT,

	/// A user event with user data.
	/** This is not used by Irrlicht and can be used to send user
	specific data though the system. The Irrlicht 'window handle'
	can be obtained from IrrlichtDevice::getExposedVideoData()
	The usage and behavior depends on the operating system:
	Windows: send a WM_USER message to the Irrlicht Window; the
		wParam and lParam will be used to populate the
		UserData1 and UserData2 members of the SUserEvent.
	Linux: send a ClientMessage via XSendEvent to the Irrlicht
		Window; the data.l[0] and data.l[1] members will be
		casted to s32 and used as UserData1 and UserData2.
	MacOS: Not yet implemented
	*/
	EET_USER_EVENT,

	/// This enum is never used, it only forces the compiler to
	/// compile these enumeration values to 32 bit.
	EGUIET_FORCE_32_BIT = 0x7fffffff

}

/// Enumeration for all mouse input events
enum EMOUSE_INPUT_EVENT
{
	/// Left mouse button was pressed down.
	EMIE_LMOUSE_PRESSED_DOWN = 0,

	/// Right mouse button was pressed down.
	EMIE_RMOUSE_PRESSED_DOWN,

	/// Middle mouse button was pressed down.
	EMIE_MMOUSE_PRESSED_DOWN,

	/// Left mouse button was left up.
	EMIE_LMOUSE_LEFT_UP,

	/// Right mouse button was left up.
	EMIE_RMOUSE_LEFT_UP,

	/// Middle mouse button was left up.
	EMIE_MMOUSE_LEFT_UP,

	/// The mouse cursor changed its position.
	EMIE_MOUSE_MOVED,

	/// The mouse wheel was moved. Use Wheel value in event data to find out
	/// in what direction and how fast.
	EMIE_MOUSE_WHEEL,

	/// Left mouse button double click.
	/// This event is generated after the second EMIE_LMOUSE_PRESSED_DOWN event.
	EMIE_LMOUSE_DOUBLE_CLICK,

	/// Right mouse button double click.
	/// This event is generated after the second EMIE_RMOUSE_PRESSED_DOWN event.
	EMIE_RMOUSE_DOUBLE_CLICK,

	/// Middle mouse button double click.
	/// This event is generated after the second EMIE_MMOUSE_PRESSED_DOWN event.
	EMIE_MMOUSE_DOUBLE_CLICK,

	/// Left mouse button triple click.
	/// This event is generated after the third EMIE_LMOUSE_PRESSED_DOWN event.
	EMIE_LMOUSE_TRIPLE_CLICK,

	/// Right mouse button triple click.
	/// This event is generated after the third EMIE_RMOUSE_PRESSED_DOWN event.
	EMIE_RMOUSE_TRIPLE_CLICK,

	/// Middle mouse button triple click.
	/// This event is generated after the third EMIE_MMOUSE_PRESSED_DOWN event.
	EMIE_MMOUSE_TRIPLE_CLICK,

	/// No real event. Just for convenience to get number of events
	EMIE_COUNT
}

/// Masks for mouse button states
enum E_MOUSE_BUTTON_STATE_MASK
{
	EMBSM_LEFT    = 0x01,
	EMBSM_RIGHT   = 0x02,
	EMBSM_MIDDLE  = 0x04,

	/// currently only on windows
	EMBSM_EXTRA1  = 0x08,

	/// currently only on windows
	EMBSM_EXTRA2  = 0x10,

	EMBSM_FORCE_32_BIT = 0x7fffffff
}

/// Enumeration for all events which are sendable by the gui system
enum EGUI_EVENT_TYPE
{
	/// A gui element has lost its focus.
	/** GUIEvent.Caller is losing the focus to GUIEvent.Element.
	If the event is absorbed then the focus will not be changed. */
	EGET_ELEMENT_FOCUS_LOST = 0,

	/// A gui element has got the focus.
	/** If the event is absorbed then the focus will not be changed. */
	EGET_ELEMENT_FOCUSED,

	/// The mouse cursor hovered over a gui element.
	/** If an element has sub-elements you also get this message for the subelements */
	EGET_ELEMENT_HOVERED,

	/// The mouse cursor left the hovered element.
	/** If an element has sub-elements you also get this message for the subelements */
	EGET_ELEMENT_LEFT,

	/// An element would like to close.
	/** Windows and context menus use this event when they would like to close,
	this can be cancelled by absorbing the event. */
	EGET_ELEMENT_CLOSED,

	/// A button was clicked.
	EGET_BUTTON_CLICKED,

	/// A scrollbar has changed its position.
	EGET_SCROLL_BAR_CHANGED,

	/// A checkbox has changed its check state.
	EGET_CHECKBOX_CHANGED,

	/// A new item in a listbox was selected.
	/** NOTE: You also get this event currently when the same item was clicked again after more than 500 ms. */
	EGET_LISTBOX_CHANGED,

	/// An item in the listbox was selected, which was already selected.
	/** NOTE: You get the event currently only if the item was clicked again within 500 ms or selected by "enter" or "space". */
	EGET_LISTBOX_SELECTED_AGAIN,

	/// A file has been selected in the file dialog
	EGET_FILE_SELECTED,

	/// A directory has been selected in the file dialog
	EGET_DIRECTORY_SELECTED,

	/// A file open dialog has been closed without choosing a file
	EGET_FILE_CHOOSE_DIALOG_CANCELLED,

	/// 'Yes' was clicked on a messagebox
	EGET_MESSAGEBOX_YES,

	/// 'No' was clicked on a messagebox
	EGET_MESSAGEBOX_NO,

	/// 'OK' was clicked on a messagebox
	EGET_MESSAGEBOX_OK,

	/// 'Cancel' was clicked on a messagebox
	EGET_MESSAGEBOX_CANCEL,

	/// In an editbox 'ENTER' was pressed
	EGET_EDITBOX_ENTER,

	/// The text in an editbox was changed. This does not include automatic changes in text-breaking.
	EGET_EDITBOX_CHANGED,

	/// The marked area in an editbox was changed.
	EGET_EDITBOX_MARKING_CHANGED,

	/// The tab was changed in an tab control
	EGET_TAB_CHANGED,

	/// A menu item was selected in a (context) menu
	EGET_MENU_ITEM_SELECTED,

	/// The selection in a combo box has been changed
	EGET_COMBO_BOX_CHANGED,

	/// The value of a spin box has changed
	EGET_SPINBOX_CHANGED,

	/// A table has changed
	EGET_TABLE_CHANGED,
	EGET_TABLE_HEADER_CHANGED,
	EGET_TABLE_SELECTED_AGAIN,

	/// A tree view node lost selection. See IGUITreeView::getLastEventNode().
	EGET_TREEVIEW_NODE_DESELECT,

	/// A tree view node was selected. See IGUITreeView::getLastEventNode().
	EGET_TREEVIEW_NODE_SELECT,

	/// A tree view node was expanded. See IGUITreeView::getLastEventNode().
	EGET_TREEVIEW_NODE_EXPAND,

	/// A tree view node was collapsed. See IGUITreeView::getLastEventNode().
	EGET_TREEVIEW_NODE_COLLAPSE,

	/// deprecated - use EGET_TREEVIEW_NODE_COLLAPSE instead. This
	/// may be removed by Irrlicht 1.9
	EGET_TREEVIEW_NODE_COLLAPS = EGET_TREEVIEW_NODE_COLLAPSE,

	/// No real event. Just for convenience to get number of events
	EGET_COUNT
};

class SEvent
{
    this(IrrlichtDevice* dev)
    {
        device = dev;
    }

private:
    IrrlichtDevice* device;
}

class IEventReceiver
{
    this(IrrlichtDevice* dev)
    {
        device = dev;
        ptr = irr_IrrlichtDevice_getEventReceiver(device.ptr);
    }

    irr_IEventReceiver* ptr;
private:
    IrrlichtDevice* device;
}

package extern (C):

struct irr_SEvent;
struct irr_IEventReceiver;
