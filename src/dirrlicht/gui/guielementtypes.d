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
enum GUIElementType
{
    /// A button (IGUIButton)
    button = 0,

    /// A check box (IGUICheckBox)
    checkBox,

    /// A combo box (IGUIComboBox)
    comboBox,

    /// A context menu (IGUIContextMenu)
    contextMenu,

    /// A menu (IGUIMenu)
    menu,

    /// An edit box (IGUIEditBox)
    editBox,

    /// A file open dialog (IGUIFileOpenDialog)
    fileOpenDialog,

    /// A color select open dialog (IGUIColorSelectDialog)
    colorSelectDialog,

    /// A in/out fader (IGUIInOutFader)
    inOutFader,

    /// An image (IGUIImage)
    image,

    /// A list box (IGUIListBox)
    listBox,

    /// A mesh viewer (IGUIMeshViewer)
    meshViewer,

    /// A message box (IGUIWindow)
    messageBox,

    /// A modal screen
    modalScreen,

    /// A scroll bar (IGUIScrollBar)
    scrollBar,

    /// A spin box (IGUISpinBox)
    spinBox,

    /// A static text (IGUIStaticText)
    staticText,

    /// A tab (IGUITab)
    tab,

    /// A tab control
    tabControl,

    /// A Table
    table,

    /// A tool bar (IGUIToolBar)
    toolBar,

    /// A Tree View
    treeView,

    /// A window
    window,

    /// Unknown type.
    unknown,

    /// The root of the GUI
    root,

    /// IGUIProfiler
    profiler
}
