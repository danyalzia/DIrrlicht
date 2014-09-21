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

import dirrlicht.keycodes;
import dirrlicht.gui.guielement;
import dirrlicht.logger;

import std.bitmanip;

interface EventReceiver {
	bool OnEvent(const ref SEvent event);
}

extern (C):

struct irr_IEventReceiver;

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
    Key,

    /// A joystick (joypad, gamepad) input event.
    /** Joystick events are created by polling all connected joysticks once per
    device run() and then passing the events to IrrlichtDevice::postEventFromUser.
    They take the same path as mouse events.
    Windows, SDL: Implemented.
    Linux: Implemented, with POV hat issues.
    MacOS / Other: Not yet implemented.
    */
    Joystick,

    /// A log event
    /** Log events are only passed to the user receiver if there is one. If they are absorbed by the
    user receiver then no text will be sent to the console. */
    Log,

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
    User
}

/// Enumeration for all mouse input events
enum MouseEventType {
    /// Left mouse button was pressed down.
    LeftDown = 0,

    /// Right mouse button was pressed down.
    RightDown,

    /// Middle mouse button was pressed down.
    MiddleDown,

    /// Left mouse button was left up.
    LeftUp,

    /// Right mouse button was left up.
    RightUp,

    /// Middle mouse button was left up.
    MiddleUp,

    /// The mouse cursor changed its position.
    Move,

    /// The mouse wheel was moved. Use Wheel value in event data to find out
    /// in what direction and how fast.
	Wheel,

    /// Left mouse button double click.
    /// This event is generated after the second EMIE_LMOUSE_PRESSED_DOWN event.
    LeftDoubleClick,

    /// Right mouse button double click.
    /// This event is generated after the second EMIE_RMOUSE_PRESSED_DOWN event.
    RightDoubleClick,

    /// Middle mouse button double click.
    /// This event is generated after the second EMIE_MMOUSE_PRESSED_DOWN event.
    MiddleDoubleClick,

    /// Left mouse button triple click.
    /// This event is generated after the third EMIE_LMOUSE_PRESSED_DOWN event.
    LeftTripleClick,

    /// Right mouse button triple click.
    /// This event is generated after the third EMIE_RMOUSE_PRESSED_DOWN event.
    RightTripleClick,

    /// Middle mouse button triple click.
    /// This event is generated after the third EMIE_MMOUSE_PRESSED_DOWN event.
    MiddleTripleClick
}

enum E_MOUSE_BUTTON_STATE_MASK {
	EMBSM_LEFT    = 0x01,
	EMBSM_RIGHT   = 0x02,
	EMBSM_MIDDLE  = 0x04,
	EMBSM_EXTRA1  = 0x08,
	EMBSM_EXTRA2  = 0x10,
	EMBSM_FORCE_32_BIT = 0x7fffffff
}

/// Enumeration for all events which are sendable by the gui system
enum GUIEventType {
    /// A gui element has lost its focus.
    /** GUIEvent.Caller is losing the focus to GUIEvent.Element.
    If the event is absorbed then the focus will not be changed. */
    ElementFocusLost = 0,

    /// A gui element has got the focus.
    /** If the event is absorbed then the focus will not be changed. */
    ElementFocused,

    /// The mouse cursor hovered over a gui element.
    /** If an element has sub-elements you also get this message for the subelements */
    ElementMouseHovered,

    /// The mouse cursor left the hovered element.
    /** If an element has sub-elements you also get this message for the subelements */
    ElementMouseLeft,

    /// An element would like to close.
    /** Windows and context menus use this event when they would like to close,
    this can be cancelled by absorbing the event. */
    ElementClosed,

    /// A button was clicked.
    ButtonClicked,

    /// A scrollbar has changed its position.
    ScrollBarChanged,

    /// A checkbox has changed its check state.
    CheckBoxChanged,

    /// A new item in a listbox was selected.
    /** NOTE: You also get this event currently when the same item was clicked again after more than 500 ms. */
    ListBoxChanged,

    /// An item in the listbox was selected, which was already selected.
    /** NOTE: You get the event currently only if the item was clicked again within 500 ms or selected by "enter" or "space". */
    ListBoxSelectedAgain,

    /// A file has been selected in the file dialog
    FileDialogFileSelected,

    /// A directory has been selected in the file dialog
    FileDialogDirectorySelected,

    /// A file open dialog has been closed without choosing a file
    FileDialogCancelled,

    /// 'Yes' was clicked on a messagebox
    MessageBoxYes,

    /// 'No' was clicked on a messagebox
    MessageBoxNo,

    /// 'OK' was clicked on a messagebox
    MessageBoxOK,

    /// 'Cancel' was clicked on a messagebox
    MessageBoxCancel,

    /// In an editbox 'ENTER' was pressed
    EditBoxEnter,

    /// The text in an editbox was changed. This does not include automatic changes in text-breaking.
    EditBoxChanged,

    /// The marked area in an editbox was changed.
    EditBoxMarkingChanged,

    /// The tab was changed in an tab control
    TabChanged,

    /// A menu item was selected in a (context) menu
    MenuItemSelected,

    /// The selection in a combo box has been changed
    ComboBoxChanged,

    /// The value of a spin box has changed
    SpinBoxChanged,

    /// A table has changed
    TableChanged,
    TableHeaderChanged,
    TableSelectedAgain,

    /// A tree view node lost selection. See IGUITreeView::getLastEventNode().
    TreeViewNodeDeselect,

    /// A tree view node was selected. See IGUITreeView::getLastEventNode().
    TreeViewNodeSelect,

    /// A tree view node was expanded. See IGUITreeView::getLastEventNode().
    TreeViewNodeExpand,

    /// A tree view node was collapsed. See IGUITreeView::getLastEventNode().
    TreeViewNodeCollapse,
}

alias SEvent = irr_SEvent;

struct irr_SEvent {
	struct irr_SGUIEvent {
		irr_IGUIElement* Caller;
		irr_IGUIElement* Element;
		GUIEventType EventType;
	}

	struct irr_SMouseInput {
		int X;
		int Y;
		float Wheel;
		mixin(bitfields!(
		bool, "Shift", 1,
		bool, "Control", 1,
		uint, "", 6));
		uint ButtonStates;
		bool isLeftPressed() const { return 0 != ( ButtonStates & E_MOUSE_BUTTON_STATE_MASK.EMBSM_LEFT ); }
		bool isRightPressed() const { return 0 != ( ButtonStates & E_MOUSE_BUTTON_STATE_MASK.EMBSM_RIGHT ); }
		bool isMiddlePressed() const { return 0 != ( ButtonStates & E_MOUSE_BUTTON_STATE_MASK.EMBSM_MIDDLE ); }
		MouseEventType Event;
	}

	struct irr_SKeyInput {
		dchar Char;
		KeyCode Key;
		mixin(bitfields!(
		bool, "PressedDown", 1,
		bool, "Shift", 1,
		bool, "Control", 1,
		uint, "", 5));
	}

	struct irr_SJoystickEvent {
		enum {
			NUMBER_OF_BUTTONS = 32,

			AXIS_X = 0,	// e.g. analog stick 1 left to right
			AXIS_Y,		// e.g. analog stick 1 top to bottom
			AXIS_Z,		// e.g. throttle, or analog 2 stick 2 left to right
			AXIS_R,		// e.g. rudder, or analog 2 stick 2 top to bottom
			AXIS_U,
			AXIS_V,
			NUMBER_OF_AXES
		}

		uint ButtonStates;
		short Axis[NUMBER_OF_AXES];
		short POV;
		char Joystick;
		bool IsButtonPressed(uint button) const {
			if(button >= cast(uint)NUMBER_OF_BUTTONS)
				return false;

			return (ButtonStates & (1 << button)) ? true : false;
		}
	}

	struct irr_SLogEvent {
		const char* Text;
		int Level;
	}

	struct irr_SUserEvent {
		int UserData1;
		int UserData2;
	}

	EventType eventType;
	union {
		irr_SGUIEvent GUIEvent;
		irr_SMouseInput MouseInput;
		irr_SKeyInput KeyInput;
		irr_SJoystickEvent JoystickEvent;
		irr_SLogEvent LogEvent;
		irr_SUserEvent UserEvent;
	}
}
