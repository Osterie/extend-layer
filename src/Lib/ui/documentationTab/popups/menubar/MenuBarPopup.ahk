#Requires AutoHotkey v2.0

#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class MenuBarPopup extends DocumentationPopup {

    __New(){
        title := "Menu Bar"
        header := "Menu Bar Documentation"
        super.__New(title, header)

        this.createMenuBarPopup()
        this.show()
    }

    createMenuBarPopup() {
        sectionWidth := this.getSectionWidth()

        locationTitle := "Location"
        locationParagraph := "The menu bar is located at the top of the window, and it has three menus. 'Themes', 'Settings' and 'Suspend Script'."

        keyboardNavigationTitle := "Keyboard Navigation"
        keyboardNavigationParagraph := "By pressing alt, the menus in the menu bar will each have one underlined character. For example the 'T' in 'Themes' gets underlined. By pressing that underlined character on the keyboard, you can select that item using only the keyboard."

        this.section(locationTitle, locationParagraph)
        this.image(DocumentationImages.MENU_BAR_LOCATION)

        this.section(keyboardNavigationTitle, keyboardNavigationParagraph)
    }
}