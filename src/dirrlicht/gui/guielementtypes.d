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

module dirrlicht.gui.guielementtypes;

/+++
 + List of all basic Irrlicht GUI elements.
 + An GUIElement returns this when calling getType()
 +/
enum GUIElementType {
    /// A button (IGUIButton)
    Button = 0,

    /// A check box (IGUICheckBox)
    CheckBox,

    /// A combo box (IGUIComboBox)
    ComboBox,

    /// A context menu (IGUIContextMenu)
    ContextMenu,

    /// A menu (IGUIMenu)
    Menu,

    /// An edit box (IGUIEditBox)
    EditBox,

    /// A file open dialog (IGUIFileOpenDialog)
    FileOpenDialog,

    /// A color select open dialog (IGUIColorSelectDialog)
    ColorSelectDialog,

    /// A in/out fader (IGUIInOutFader)
    InOutFader,

    /// An image (IGUIImage)
    Image,

    /// A list box (IGUIListBox)
    ListBox,

    /// A mesh viewer (IGUIMeshViewer)
    MeshViewer,

    /// A message box (IGUIWindow)
    MessageBox,

    /// A modal screen
    ModalScreen,

    /// A scroll bar (IGUIScrollBar)
    ScrollBar,

    /// A spin box (IGUISpinBox)
    SpinBox,

    /// A static text (IGUIStaticText)
    StaticText,

    /// A tab (IGUITab)
    Tab,

    /// A tab control
    TabControl,

    /// A Table
    Table,

    /// A tool bar (IGUIToolBar)
    ToolBar,

    /// A Tree View
    TreeView,

    /// A window
    Window,

    /// Unknown type.
    Unknown,

    /// The root of the GUI
    Root,

    /// IGUIProfiler
    Profiler
}
