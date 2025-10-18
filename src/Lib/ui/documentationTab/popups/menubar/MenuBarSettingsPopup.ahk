#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class MenuBarSettingsPopup extends DocumentationPopup {

    __New(){
        title := "Settings"
        header := "Settings Documentation"
        super.__New(title, header)

        this.createMenuBarSettingsPopup()
        this.show()
    }

    createMenuBarSettingsPopup() {
        sectionWidth := this.getSectionWidth()

        keyboardShortcutTitle := "Keyboard Navigation"
        keyboardShortcutParagraph := "You can select this menu item by pressing 'Alt' and then pressing 's' (the underlined character). Then navigate with the arrow keys to the setting you want to change and hit enter."

        aboutTitle := "About Settings"
        aboutParagraph := "You can check if an option is on or off by seeing if the option name has a checkmark to its left. Checkmark means on, no checkmark means off."
        
        stopScriptOnGuiCloseTitle := "Stop Script on GUI Close"
        stopScriptOnGuiCloseParagraph := "This option will decide if closing the gui will also stop the script from running in the background. By default this is on, meaning the script stops running when the GUI is closed."


        Section(this, sectionWidth, keyboardShortcutTitle, keyboardShortcutParagraph)
        Section(this, sectionWidth, aboutTitle, aboutParagraph)
        Section(this, sectionWidth, stopScriptOnGuiCloseTitle, stopScriptOnGuiCloseParagraph)
    }
}