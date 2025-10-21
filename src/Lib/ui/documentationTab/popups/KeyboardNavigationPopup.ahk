#Requires AutoHotkey v2.0



#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class KeyboardNavigationPopup extends DocumentationPopup {

    __New(){
        title := "Keyboard Navigation"
        header := "Keyboard Navigation Documentation"
        super.__New(title, header)

        this.keyboardNavigationPopupPopup()
        this.show()
    }

    keyboardNavigationPopupPopup() {
        menuBarNavigationTitle := "Menu Bar"
        menuBarNavigationParagraph := "By pressing alt, the menus in the menu bar will each have one underlined character. For example the 'T' in 'Themes' gets underlined. By pressing that underlined character on the keyboard, you can select that item using only the keyboard."
        menuBarNavigationParagraph .= this.NEW_LINE
        menuBarNavigationParagraph .= "If that menu bar menu has sub menus, then you can navigate with the arrow keys and click enter on the sub menu you want."

        profileButtonsClickingTitle := "Profile Buttons"
        profileButtonsClickingParagraph := "By holding alt, you can use a shortcut for the Edit/Add/Import/Export buttons by then pressing the underlined character. For example hold alt and press 'e' to open the edit profiles dialog."

        this.section(menuBarNavigationTitle, menuBarNavigationParagraph)
        this.section(profileButtonsCLickingTitle, profileButtonsCLickingParagraph)
    }
}
