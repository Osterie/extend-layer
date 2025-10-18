#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class MenuBarSuspendingPopup extends DocumentationPopup {

    __New(){
        title := "Suspending"
        header := "Suspending Documentation"
        super.__New(title, header)

        this.createMenuBarSuspendingPopup()
        this.show()
    }

    createMenuBarSuspendingPopup() {
        sectionWidth := this.getSectionWidth()

        keyboardShortcutTitle := "Keyboard Navigation"
        keyboardShortcutParagraph := "You can select this menu item by pressing 'Alt' and then pressing 'c' (the underlined character)."

        suspendScriptTitle := "Suspending the Script"
        suspendScriptParagraph := "By clicking the 'Suspend Script' menu, you will suspend the script. This means all hotkeys will be disabled. When you click 'Suspend Script' it will change into 'Start Script', which when clicked will enable all the disabled hotkeys."


        Section(this, sectionWidth, keyboardShortcutTitle, keyboardShortcutParagraph)
        Section(this, sectionWidth, suspendScriptTitle, suspendScriptParagraph)
    }
}