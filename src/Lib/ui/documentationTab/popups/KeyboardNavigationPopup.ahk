#Requires AutoHotkey v2.0

#Include <ui\documentationTab\popups\DocumentationPopup>

class KeyboardNavigationPopup extends DocumentationPopup {

    __New(){
        title := "Keyboard Navigation"
        header := "Keyboard Navigation Documentation"
        super.__New(title, header)

        this.createKeyboardNavigationPopupPopup()
        this.show()
    }

    createKeyboardNavigationPopupPopup() {

        noteAboutAltTitle := "Note About Pressing Alt"
        noteAboutAltParagraph := "When you press alt in the gui, it activates the gui's menu, which pauses all hotkeys. Pressing alt again or clicking the mouse will make it possible to use hotkeys again."

        ; menuBarNavigationTitle := "Menu Bar"
        ; menuBarNavigationParagraph := "By holding alt, the menus in the menu bar will each have one underlined character. For example the 'T' in 'Themes' gets underlined. By pressing that underlined character on the keyboard, you can select that item using only the keyboard."
        ; menuBarNavigationParagraph .= this.NEW_LINE
        ; menuBarNavigationParagraph .= "If that menu bar menu has sub menus, then you can navigate with the arrow keys and click enter on the sub menu you want."

        ; profileButtonsClickingTitle := "Profile Buttons"
        ; profileButtonsClickingParagraph := "By holding alt, you can use a shortcut for the Edit/Add/Import/Export buttons by then pressing the underlined character. For example hold alt and press 'e' to open the edit profiles dialog."

        closingGuisTitle := "Closing Guis"
        closingGuisParagraph := "- The 'Esc' key closes almost all guis and dialogs."

        navigationInTabsTitle := "Navigation in Tab Controls"
        navigationInTabsParagraph := "- Ctrl+PgDn/PgUp navigates between tabs in a tab control."
        navigationInTabsParagraph .= this.NEW_LINE
        navigationInTabsParagraph .= "- Ctrl+Tab and Ctrl+Shift+Tab may also be used."
        navigationInTabsParagraph .= this.NEW_LINE
        navigationInTabsParagraph .= "The image below shows what a tab control is. Navigating from 'Keyboards' to 'Documentation' can be done by executing Ctrl+Tab twice."
        
        clickingButtonsTitle := "Clicking Buttons"
        clickingButtonsParagraph := "This applies to buttons, radio buttons, checkboxes and menus:"
        clickingButtonsParagraph .= this.NEW_LINE
        clickingButtonsParagraph .= "- Holding Alt and then pressing the underlined character of one of these controls will click that control."
        clickingButtonsParagraph .= this.SPACING
        clickingButtonsParagraph .= "Buttons underlined:"

        clickingRadioButtonsParagraph := this.SPACING
        clickingRadioButtonsParagraph .= "Radio buttons underlined:"
        
        clickingCheckBoxParagraph := this.SPACING
        clickingCheckBoxParagraph .= "Checkbox underlined:"
        
        clickingMenusParagraph := this.SPACING
        clickingMenusParagraph .= "Menubar menus underlined:"


        groupBoxesAndTextControlsTitle := "Groupboxes and Text Controls"
        groupBoxesAndTextControlsParagraph := "- Holding Alt and then pressing the underlined character of one of these controls will focuse the input inside of the control."
        groupBoxesAndTextControlsParagraph .= this.NEW_LINE
        groupBoxesAndTextControlsParagraph .= "The image below shows a groupbox with the letter 'P' underlined. Pressing Alt+p would then focus the input for 'Site URL'."


        treeViewsAndListViewsTitle := "TreeViews and ListViews"
        treeViewsAndListViewsParagraph := "Home and End will bring you to the start and end of listviews and treeviews. PageUp and PageDown will bring you up and down a page in a listview and treeview"
        treeViewsAndListViewsParagraph .= this.SPACING


        this.section(noteAboutAltTitle, noteAboutAltParagraph)

        ; this.section(menuBarNavigationTitle, menuBarNavigationParagraph)
        ; this.section(profileButtonsCLickingTitle, profileButtonsCLickingParagraph)

        this.section(closingGuisTitle, closingGuisParagraph)

        this.section(navigationInTabsTitle, navigationInTabsParagraph)
        this.image(DocumentationImages.TAB_CONTROL)

        this.section(clickingButtonsTitle, clickingButtonsParagraph)
        this.image(DocumentationImages.ALT_NAVIGATION_BUTTONS_1)
        this.image(DocumentationImages.ALT_NAVIGATION_BUTTONS_2)
        this.paragraph(clickingRadioButtonsParagraph)
        this.image(DocumentationImages.ALT_NAVIGATION_RADIO_BUTTONS)
        this.paragraph(clickingCheckBoxParagraph)
        this.image(DocumentationImages.ALT_NAVIGATION_CHECKBOX)
        this.paragraph(clickingMenusParagraph)
        this.image(DocumentationImages.ALT_NAVIGATION_MENU_BAR)

        this.section(groupBoxesAndTextControlsTitle, groupBoxesAndTextControlsParagraph)
        this.image(DocumentationImages.ALT_NAVIGATION_GROUP_BOX)

        this.section(treeViewsAndListViewsTitle, treeViewsAndListViewsParagraph)
    }
}
