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

module dirrlicht.eventreceiver;

import dirrlicht.compileconfig;
import dirrlicht.irrlichtdevice;
import dirrlicht.keycodes;
import dirrlicht.gui.guielement;
import dirrlicht.logger;

enum EventType {
    /***
     * An event of the graphical user interface.
     * GUI events are created by the GUI environment or the GUI elements in response
     * mouse or keyboard events. When a GUI element receives an event it will either
     * process it and return true, or pass the event to its parent. If an event is not absorbed
     * before it reaches the root element then it will then be passed to the user receiver.
     */
    GUI = 0,

    /// A mouse input event.
    /** Mouse events are created by the device and passed to IrrlichtDevice::postEventFromUser
    in response to mouse input received from the operating system.
    Mouse events are first passed to the user receiver, then to the GUI environment and its elements,
    then finally the input receiving scene manager where it is passed to the active camera.
    */
    Mouse,

    /// A key input event.
    /** Like mouse events, keyboard events are created by the device and passed to
    IrrlichtDevice::postEventFromUser. They take the same path as mouse events. */
    key,

    /// A joystick (joypad, gamepad) input event.
    /** Joystick events are created by polling all connected joysticks once per
    device run() and then passing the events to IrrlichtDevice::postEventFromUser.
    They take the same path as mouse events.
    Windows, SDL: Implemented.
    Linux: Implemented, with POV hat issues.
    MacOS / Other: Not yet implemented.
    */
    joystick,

    /// A log event
    /** Log events are only passed to the user receiver if there is one. If they are absorbed by the
    user receiver then no text will be sent to the console. */
    log,

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
    user
}

/// Enumeration for all mouse input events
enum MouseEventType
{
    /// Left mouse button was pressed down.
    leftDown = 0,

    /// Right mouse button was pressed down.
    rightDown,

    /// Middle mouse button was pressed down.
    middleDown,

    /// Left mouse button was left up.
    leftUp,

    /// Right mouse button was left up.
    rightUp,

    /// Middle mouse button was left up.
    middleUp,

    /// The mouse cursor changed its position.
    move,

    /// The mouse wheel was moved. Use Wheel value in event data to find out
    /// in what direction and how fast.
    wheel,

    /// Left mouse button double click.
    /// This event is generated after the second EMIE_LMOUSE_PRESSED_DOWN event.
    leftDoubleClick,

    /// Right mouse button double click.
    /// This event is generated after the second EMIE_RMOUSE_PRESSED_DOWN event.
    rightDoubleClick,

    /// Middle mouse button double click.
    /// This event is generated after the second EMIE_MMOUSE_PRESSED_DOWN event.
    middleDoubleClick,

    /// Left mouse button triple click.
    /// This event is generated after the third EMIE_LMOUSE_PRESSED_DOWN event.
    leftTripleClick,

    /// Right mouse button triple click.
    /// This event is generated after the third EMIE_RMOUSE_PRESSED_DOWN event.
    rightTripleClick,

    /// Middle mouse button triple click.
    /// This event is generated after the third EMIE_MMOUSE_PRESSED_DOWN event.
    middleTripleClick
}

/// Enumeration for all events which are sendable by the gui system
enum GUIEventType
{
    /// A gui element has lost its focus.
    /** GUIEvent.Caller is losing the focus to GUIEvent.Element.
    If the event is absorbed then the focus will not be changed. */
    elementFocusLost = 0,

    /// A gui element has got the focus.
    /** If the event is absorbed then the focus will not be changed. */
    elementFocused,

    /// The mouse cursor hovered over a gui element.
    /** If an element has sub-elements you also get this message for the subelements */
    elementMouseHovered,

    /// The mouse cursor left the hovered element.
    /** If an element has sub-elements you also get this message for the subelements */
    elementMouseLeft,

    /// An element would like to close.
    /** Windows and context menus use this event when they would like to close,
    this can be cancelled by absorbing the event. */
    elementClosed,

    /// A button was clicked.
    buttonClicked,

    /// A scrollbar has changed its position.
    scrollBarChanged,

    /// A checkbox has changed its check state.
    checkBoxChanged,

    /// A new item in a listbox was selected.
    /** NOTE: You also get this event currently when the same item was clicked again after more than 500 ms. */
    listBoxChanged,

    /// An item in the listbox was selected, which was already selected.
    /** NOTE: You get the event currently only if the item was clicked again within 500 ms or selected by "enter" or "space". */
    listBoxSelectedAgain,

    /// A file has been selected in the file dialog
    fileDialogFileSelected,

    /// A directory has been selected in the file dialog
    fileDialogDirectorySelected,

    /// A file open dialog has been closed without choosing a file
    fileDialogCancelled,

    /// 'Yes' was clicked on a messagebox
    messageBoxYes,

    /// 'No' was clicked on a messagebox
    messageBoxNo,

    /// 'OK' was clicked on a messagebox
    messageBoxOK,

    /// 'Cancel' was clicked on a messagebox
    messageBoxCancel,

    /// In an editbox 'ENTER' was pressed
    editBoxEnter,

    /// The text in an editbox was changed. This does not include automatic changes in text-breaking.
    editBoxChanged,

    /// The marked area in an editbox was changed.
    editBoxMarkingChanged,

    /// The tab was changed in an tab control
    tabChanged,

    /// A menu item was selected in a (context) menu
    menuItemSelected,

    /// The selection in a combo box has been changed
    comboBoxChanged,

    /// The value of a spin box has changed
    spinBoxChanged,

    /// A table has changed
    tableChanged,
    tableHeaderChanged,
    tableSelectedAgain,

    /// A tree view node lost selection. See IGUITreeView::getLastEventNode().
    treeViewNodeDeselect,

    /// A tree view node was selected. See IGUITreeView::getLastEventNode().
    treeViewNodeSelect,

    /// A tree view node was expanded. See IGUITreeView::getLastEventNode().
    treeViewNodeExpand,

    /// A tree view node was collapsed. See IGUITreeView::getLastEventNode().
    treeViewNodeCollapse,
}

/// Information on a joystick, returned from @ref irr::IrrlichtDevice::activateJoysticks()
struct JoystickInfo
{
	/***
	 * The ID of the joystick
	 * This is an internal Irrlicht index; it does not map directly
	 * to any particular hardware joystick. It corresponds to the
	 * SJoystickEvent Joystick ID.
	 */
	ubyte joystick;

	/// The name that the joystick uses to identify itself.
	string name;

	/// The number of buttons that the joystick has.
	uint buttons;

	/// The number of axes that the joystick has, i.e. X, Y, Z, R, U, V.
	/// Note: with a Linux device, the POV hat (if any) will use two axes. These
	/// will be included in this count.
	uint axes;

	/// An indication of whether the joystick has a POV hat.
	/// A Windows device will identify the presence or absence or the POV hat.  A
	/// Linux device cannot, and will always return POV_HAT_UNKNOWN.
	enum PovHat
	{
		/// A hat is definitely present.
		present,

		/// A hat is definitely not present.
		absent,

		/// The presence or absence of a hat cannot be determined.
		unknown
	}
}

alias Event = irr_SEvent;
extern (C):

enum EEVENT_TYPE
{
	EET_GUI_EVENT = 0,
	EET_MOUSE_INPUT_EVENT,
	EET_KEY_INPUT_EVENT,
	EET_JOYSTICK_INPUT_EVENT,
	EET_LOG_TEXT_EVENT,
	EET_USER_EVENT

};

enum EMOUSE_INPUT_EVENT
{
	EMIE_LMOUSE_PRESSED_DOWN = 0,
	EMIE_RMOUSE_PRESSED_DOWN,
	EMIE_MMOUSE_PRESSED_DOWN,
	EMIE_LMOUSE_LEFT_UP,
	EMIE_RMOUSE_LEFT_UP,
	EMIE_MMOUSE_LEFT_UP,
	EMIE_MOUSE_MOVED,
	EMIE_MOUSE_WHEEL,
	EMIE_LMOUSE_DOUBLE_CLICK,
	EMIE_RMOUSE_DOUBLE_CLICK,
	EMIE_MMOUSE_DOUBLE_CLICK,
	EMIE_LMOUSE_TRIPLE_CLICK,
	EMIE_RMOUSE_TRIPLE_CLICK,
	EMIE_MMOUSE_TRIPLE_CLICK,
	EMIE_COUNT
};

enum E_MOUSE_BUTTON_STATE_MASK
{
	EMBSM_LEFT    = 0x01,
	EMBSM_RIGHT   = 0x02,
	EMBSM_MIDDLE  = 0x04,
	EMBSM_EXTRA1  = 0x08,
	EMBSM_EXTRA2  = 0x10,
	EMBSM_FORCE_32_BIT = 0x7fffffff
};


struct irr_IGUIElement;

enum EGUI_EVENT_TYPE
{
	EGET_ELEMENT_FOCUS_LOST = 0,
	EGET_ELEMENT_FOCUSED,
	EGET_ELEMENT_HOVERED,
	EGET_ELEMENT_LEFT,
	EGET_ELEMENT_CLOSED,
	EGET_BUTTON_CLICKED,
	EGET_SCROLL_BAR_CHANGED,
	EGET_CHECKBOX_CHANGED,
	EGET_LISTBOX_CHANGED,
	EGET_LISTBOX_SELECTED_AGAIN,
	EGET_FILE_SELECTED,
	EGET_DIRECTORY_SELECTED,
	EGET_FILE_CHOOSE_DIALOG_CANCELLED,
	EGET_MESSAGEBOX_YES,
	EGET_MESSAGEBOX_NO,
	EGET_MESSAGEBOX_OK,
	EGET_MESSAGEBOX_CANCEL,
	EGET_EDITBOX_ENTER,
	EGET_EDITBOX_CHANGED,
	EGET_EDITBOX_MARKING_CHANGED,
	EGET_TAB_CHANGED,
	EGET_MENU_ITEM_SELECTED,
	EGET_COMBO_BOX_CHANGED,
	EGET_SPINBOX_CHANGED,
	EGET_TABLE_CHANGED,
	EGET_TABLE_HEADER_CHANGED,
	EGET_TABLE_SELECTED_AGAIN,
	EGET_TREEVIEW_NODE_DESELECT,
	EGET_TREEVIEW_NODE_SELECT,
	EGET_TREEVIEW_NODE_EXPAND,
	EGET_TREEVIEW_NODE_COLLAPSE,
	EGET_TREEVIEW_NODE_COLLAPS = EGET_TREEVIEW_NODE_COLLAPSE,
	EGET_COUNT
};


struct irr_SEvent
{
	struct irr_SGUIEvent
	{
		irr_IGUIElement* Caller;
		irr_IGUIElement* Element;
		EGUI_EVENT_TYPE EventType;

	};

	struct irr_SMouseInput
	{
		int X;
		int Y;
		float Wheel;
		bool Shift;
		bool Control;
		uint ButtonStates;
		bool isLeftPressed() const { return 0 != ( ButtonStates & E_MOUSE_BUTTON_STATE_MASK.EMBSM_LEFT ); }
		bool isRightPressed() const { return 0 != ( ButtonStates & E_MOUSE_BUTTON_STATE_MASK.EMBSM_RIGHT ); }
		bool isMiddlePressed() const { return 0 != ( ButtonStates & E_MOUSE_BUTTON_STATE_MASK.EMBSM_MIDDLE ); }
		EMOUSE_INPUT_EVENT Event;
	};

	struct irr_SKeyInput
	{
		wchar Char;
		KeyCode Key;
		bool PressedDown;
		bool Shift;
		bool Control;
	};

	struct irr_SJoystickEvent
	{
		enum
		{
			NUMBER_OF_BUTTONS = 32,

			AXIS_X = 0,	// e.g. analog stick 1 left to right
			AXIS_Y,		// e.g. analog stick 1 top to bottom
			AXIS_Z,		// e.g. throttle, or analog 2 stick 2 left to right
			AXIS_R,		// e.g. rudder, or analog 2 stick 2 top to bottom
			AXIS_U,
			AXIS_V,
			NUMBER_OF_AXES
		};

		uint ButtonStates;
		short Axis[NUMBER_OF_AXES];
		short POV;
		char Joystick;
		bool IsButtonPressed(uint button) const
		{
			if(button >= cast(uint)NUMBER_OF_BUTTONS)
				return false;

			return (ButtonStates & (1 << button)) ? true : false;
		}
	};

	struct irr_SLogEvent
	{
		const char* Text;
		int Level;
	};

	struct irr_SUserEvent
	{
		int UserData1;
		int UserData2;
	};

	EEVENT_TYPE EventType;
	union
	{
		irr_SGUIEvent GUIEvent;
		irr_SMouseInput MouseInput;
		irr_SKeyInput KeyInput;
		irr_SJoystickEvent JoystickEvent;
		irr_SLogEvent LogEvent;
		irr_SUserEvent UserEvent;
	};
}

interface EventReceiver : IEventReceiver {
	extern(C++)bool OnEvent(const ref Event event);
}

extern (C++) {
  interface IEventReceiver {
    bool OnEvent(const ref Event event);
  }
}
