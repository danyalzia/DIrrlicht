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

/+ Enums representing keys on standard keyboard
+ Authors:
Irrlicht Developers
+/

module dirrlicht.keycodes;

enum KeyCode
{
    MouseLButton          = 0x01,  /// Left mouse button
    MouseRButton          = 0x02,  /// Right mouse button
    Cancel           = 0x03,  /// Control-break processing
    MouseMButton          = 0x04,  /// Middle mouse button (three-button mouse)
    MouseXButton1         = 0x05,  /// Windows 2000/XP: X1 mouse button
    MouseXButton2         = 0x06,  /// Windows 2000/XP: X2 mouse button
    Backspace             = 0x08,  /// BACKSPACE key
    Tab              = 0x09,  /// TAB key
    Clear            = 0x0C,  /// CLEAR key
    Return           = 0x0D,  /// ENTER key
    Shift            = 0x10,  /// SHIFT key
    Ctrl          = 0x11,  /// CTRL key
    Alt             = 0x12,  /// ALT key
    Pause            = 0x13,  /// PAUSE key
    CapsLock          = 0x14,  /// CAPS LOCK key
    IME_Kana             = 0x15,  /// IME Kana mode
    IME_Hangul          = 0x15,
    IME_Junja            = 0x17,  /// IME Junja mode
    IME_Final            = 0x18,  /// IME final mode
    IME_Hanja            = 0x19,  /// IME Hanja mode
    IME_Kanji            = 0x19,  /// IME Kanji mode
    Esc           = 0x1B,  /// ESC key
    IME_Convert          = 0x1C,  /// IME convert
    IME_NonConvert       = 0x1D,  /// IME nonconvert
    IME_Accept           = 0x1E,  /// IME accept
    IME_ModeChange       = 0x1F,  /// IME mode change request
    Space            = 0x20,  /// SPACEBAR
    PageUp            = 0x21,  /// PAGE UP key
    PageDown             = 0x22,  /// PAGE DOWN key
    End              = 0x23,  /// END key
    Home             = 0x24,  /// HOME key
    Left             = 0x25,  /// LEFT ARROW key
    Up               = 0x26,  /// UP ARROW key
    Right            = 0x27,  /// RIGHT ARROW key
    Down             = 0x28,  /// DOWN ARROW key
    Select           = 0x29,  /// SELECT key
    Print            = 0x2A,  /// PRINT key
    Execute           = 0x2B,  /// EXECUTE key
    PrintScreen         = 0x2C,  /// PRINT SCREEN key
    Insert           = 0x2D,  /// INS key
    Delete           = 0x2E,  /// DEL key
    Help             = 0x2F,  /// HELP key
    Key0            = 0x30,  /// 0 key
    Key1            = 0x31,  /// 1 key
    Key2            = 0x32,  /// 2 key
    Key3            = 0x33,  /// 3 key
    Key4            = 0x34,  /// 4 key
    Key5            = 0x35,  /// 5 key
    Key6            = 0x36,  /// 6 key
    Key7            = 0x37,  /// 7 key
    Key8            = 0x38,  /// 8 key
    Key9            = 0x39,  /// 9 key
    KeyA            = 0x41,  /// A key
    KeyB            = 0x42,  /// B key
    KeyC            = 0x43,  /// C key
    KeyD            = 0x44,  /// D key
    KeyE            = 0x45,  /// E key
    KeyF            = 0x46,  /// F key
    KeyG            = 0x47,  /// G key
    KeyH            = 0x48,  /// H key
    KeyI            = 0x49,  /// I key
    KeyJ            = 0x4A,  /// J key
    KeyK            = 0x4B,  /// K key
    KeyL            = 0x4C,  /// L key
    KeyM            = 0x4D,  /// M key
    KeyN            = 0x4E,  /// N key
    KeyO            = 0x4F,  /// O key
    KeyP            = 0x50,  /// P key
    KeyQ            = 0x51,  /// Q key
    KeyR            = 0x52,  /// R key
    KeyS            = 0x53,  /// S key
    KeyT            = 0x54,  /// T key
    KeyU            = 0x55,  /// U key
    KeyV            = 0x56,  /// V key
    KeyW            = 0x57,  /// W key
    KeyX            = 0x58,  /// X key
    KeyY            = 0x59,  /// Y key
    KeyZ            = 0x5A,  /// Z key
    LWin             = 0x5B,  /// Left Windows key (Microsoft® Natural® keyboard)
    RWin             = 0x5C,  /// Right Windows key (Natural keyboard)
    Apps             = 0x5D,  /// Applications key (Natural keyboard)
    Sleep            = 0x5F,  /// Computer Sleep key
    Num0          = 0x60,  /// Numeric keypad 0 key
    Num1          = 0x61,  /// Numeric keypad 1 key
    Num2          = 0x62,  /// Numeric keypad 2 key
    Num3          = 0x63,  /// Numeric keypad 3 key
    Num4          = 0x64,  /// Numeric keypad 4 key
    Num5          = 0x65,  /// Numeric keypad 5 key
    Num6          = 0x66,  /// Numeric keypad 6 key
    Num7	          = 0x67,  /// Numeric keypad 7 key
    Num8    	      = 0x68,  /// Numeric keypad 8 key
    Num9    	      = 0x69,  /// Numeric keypad 9 key
    Multiply         = 0x6A,  /// Multiply key
    Add              = 0x6B,  /// Add key
    Separator        = 0x6C,  /// Separator key
    Subtract         = 0x6D,  /// Subtract key
    Decimal          = 0x6E,  /// Decimal key
    Devide           = 0x6F,  /// Divide key
    F1               = 0x70,  /// F1 key
    F2               = 0x71,  /// F2 key
    F3               = 0x72,  /// F3 key
    F4               = 0x73,  /// F4 key
    F5               = 0x74,  /// F5 key
    F6               = 0x75,  /// F6 key
    F7               = 0x76,  /// F7 key
    F8               = 0x77,  /// F8 key
    F9               = 0x78,  /// F9 key
    F10              = 0x79,  /// F10 key
    F11              = 0x7A,  /// F11 key
    F12              = 0x7B,  /// F12 key
    F13              = 0x7C,  /// F13 key
    F14              = 0x7D,  /// F14 key
    F15              = 0x7E,  /// F15 key
    F16              = 0x7F,  /// F16 key
    F17              = 0x80,  /// F17 key
    F18              = 0x81,  /// F18 key
    F19              = 0x82,  /// F19 key
    F20              = 0x83,  /// F20 key
    F21              = 0x84,  /// F21 key
    F22              = 0x85,  /// F22 key
    F23              = 0x86,  /// F23 key
    F24              = 0x87,  /// F24 key
    NumLock          = 0x90,  /// NUM LOCK key
    ScrollLock           = 0x91,  /// SCROLL LOCK key
    LShift           = 0xA0,  /// Left SHIFT key
    RShift           = 0xA1,  /// Right SHIFT key
    LControl         = 0xA2,  /// Left CONTROL key
    RControl         = 0xA3,  /// Right CONTROL key
    LMenu            = 0xA4,  /// Left MENU key
    RMenu            = 0xA5,  /// Right MENU key
    OEM_1            = 0xBA,  /// for US    ";:"
    Plus             = 0xBB,  /// Plus Key   "+"
    Comma            = 0xBC,  /// Comma Key  ","
    Minus            = 0xBD,  /// Minus Key  "-"
    Period           = 0xBE,  /// Period Key "."
    OEM_2	           = 0xBF,  /// for US    "/?"
    OEM_3            = 0xC0,  /// for US    "`~"
    OEM_4            = 0xDB,  /// for US    "[{"
    OEM_5            = 0xDC,  /// for US    "\|"
    OEM_6            = 0xDD,  /// for US    "]}"
    OEM_7            = 0xDE,  /// for US    "'""
    OEM_8            = 0xDF,  /// None
    OEM_AX           = 0xE1,  /// for Japan "AX"
    OEM_102          = 0xE2,  /// "<>" or "\|"
    Attn             = 0xF6,  /// Attn key
    CrSel            = 0xF7,  /// CrSel key
    ExSel            = 0xF8,  /// ExSel key
    ErEOF            = 0xF9,  /// Erase EOF key
    Play             = 0xFA,  /// Play key
    Zoom             = 0xFB,  /// Zoom key
    PA1              = 0xFD,  /// PA1 key
    OEM_Clear        = 0xFE,
    Count
}
