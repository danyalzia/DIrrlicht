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

enum EventType
{
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
    mouse,

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

/// Events hold information about an event. See irr::IEventReceiver for details on event handling.
class Event
{
	this(irr_SEvent* ptr)
	{
		this.ptr = ptr;
	}
	
	/// Any kind of GUI event.
	struct GUIEvent
	{
		/// IGUIElement who called the event
		GUIElement Caller;

		/// If the event has something to do with another element, it will be held here.
		GUIElement Element;

		/// Type of GUI Event
		EventType eventType;
	}

	/// Any kind of mouse event.
	struct MouseInput
	{
		/// X position of mouse cursor
		int X;

		/// Y position of mouse cursor
		int Y;

		/// mouse wheel delta, often 1.0 or -1.0, but can have other values < 0.f or > 0.f;
		/// Only valid if event was EMIE_MOUSE_WHEEL
		float Wheel;

		/// True if shift was also pressed
		bool Shift;

		/// True if ctrl was also pressed
		bool Control;
		
		//! A bitmap of button states. You can use isButtonPressed() to determine
		//! if a button is pressed or not.
		//! Currently only valid if the event was EMIE_MOUSE_MOVED
		uint ButtonStates;

		//! Is the left button pressed down?
		bool isLeftPressed() const { return 0 != ( ButtonStates & MouseEventType.leftDown ); }

		//! Is the right button pressed down?
		bool isRightPressed() const { return 0 != ( ButtonStates & MouseEventType.rightDown ); }

		//! Is the middle button pressed down?
		bool isMiddlePressed() const { return 0 != ( ButtonStates & MouseEventType.middleDown ); }

		//! Type of mouse event
		MouseEventType Event;
	}

	//! Any kind of keyboard event.
	struct KeyInput
	{
		//! Character corresponding to the key (0, if not a character, value undefined in key releases)
		wchar Char;

		//! Key which has been pressed or released
		KeyCode Key;

		//! If not true, then the key was left up
		bool PressedDown;

		//! True if shift was also pressed
		bool Shift;

		//! True if ctrl was also pressed
		bool Control;
	}

	//! A joystick event.
	/** Unlike other events, joystick events represent the result of polling
	 * each connected joystick once per run() of the device. Joystick events will
	 * not be generated by default.  If joystick support is available for the
	 * active device, _IRR_COMPILE_WITH_JOYSTICK_EVENTS_ is defined, and
	 * @ref irr::IrrlichtDevice::activateJoysticks() has been called, an event of
	 * this type will be generated once per joystick per @ref IrrlichtDevice::run()
	 * regardless of whether the state of the joystick has actually changed. */
	struct JoystickEvent
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

		/** A bitmap of button states.  You can use IsButtonPressed() to
		 ( check the state of each button from 0 to (NUMBER_OF_BUTTONS - 1) */
		uint ButtonStates;

		/** For AXIS_X, AXIS_Y, AXIS_Z, AXIS_R, AXIS_U and AXIS_V
		 * Values are in the range -32768 to 32767, with 0 representing
		 * the center position.  You will receive the raw value from the
		 * joystick, and so will usually want to implement a dead zone around
		 * the center of the range. Axes not supported by this joystick will
		 * always have a value of 0. On Linux, POV hats are represented as axes,
		 * usually the last two active axis.
		 */
		int Axis[NUMBER_OF_AXES];

		/** The POV represents the angle of the POV hat in degrees * 100,
		 * from 0 to 35,900.  A value of 65535 indicates that the POV hat
		 * is centered (or not present).
		 * This value is only supported on Windows.  On Linux, the POV hat
		 * will be sent as 2 axes instead. */
		int POV;

		//! The ID of the joystick which generated this event.
		/** This is an internal Irrlicht index; it does not map directly
		 * to any particular hardware joystick. */
		ubyte Joystick;

		//! A helper function to check if a button is pressed.
		bool IsButtonPressed(uint button) const
		{
			if(button >= cast(uint)NUMBER_OF_BUTTONS)
				return false;

			return (ButtonStates & (1 << button)) ? true : false;
		}
	};


	/// Any kind of log event.
	struct LogEvent
	{
		/// Pointer to text which has been logged
		const char* text;

		/// Log level in which the text has been logged
		LogLevel Level;
	}

	/// Any kind of user event.
	struct UserEvent
	{
		/// Some user specified data as int
		int UserData1;

		/// Another user specified data as int
		int UserData2;
	}
	
	EventType eventType;
	union
	{
		GUIEvent guiEvent;
		MouseInput mouseInput;
		KeyInput keyInput;
		JoystickEvent joystickEvent;
		LogEvent logEvent;
		UserEvent userEvent;
	};
	
	irr_SEvent* ptr;
private:
	IrrlichtDevice device;
}

interface IEventReceiver
{
	abstract bool OnEvent(Event event);
}

class EventReceiver : IEventReceiver
{
	this() { }
	this(irr_IEventReceiver* ptr)
	{
		this.ptr = ptr;
	}
	
	override bool OnEvent(Event event)
	{
		return true;
	}
	
	EventReceiver opBinary(string op)(EventReceiver rhs)
    {
    	mixin("return new EventReceiver(OnEvent" ~ op ~ "rhs.OnEvent");
    }
	IEventReceiver* base;
	alias base this;
	
	irr_IEventReceiver* ptr;
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

unittest
{
	mixin(TestPrerequisite);
}

extern (C):

struct irr_SEvent;
struct irr_IEventReceiver;

bool irr_IEventReceiver_OnEvent(irr_IEventReceiver* receiver, const irr_SEvent* event);
