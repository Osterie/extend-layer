#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class KeyboardLayersPopup extends DocumentationPopup {

    __New(){
        title := "Keyboard Layers"
        header := "Keyboard Layers Documentation"
        super.__New(title, header)

        this.createKeyboardLayersPopup()
        this.show()
    }

    createKeyboardLayersPopup() {
        sectionWidth := this.getSectionWidth()

        whereToFindTitle := "Where to Find"
        whereToFindParagraph := "Going to the 'Keyboards' tab will show you the keyboard layers for the current Extend Layer profile."

        aboutTitle := "About Keyboard Layers"
        aboutParagraph := "There are four different layers:"
        aboutParagraph .= this.NEW_LINE
        aboutParagraph .= "- Global Layer"
        aboutParagraph .= this.NEW_LINE
            aboutParagraph .= "Hotkeys that are always active, no matter what layer is currently active."
            aboutParagraph .= this.SPACING

        aboutParagraph .= "- Normal Layer"
        aboutParagraph .= this.NEW_LINE
            aboutParagraph .= "Default hotkeys active when neither Secondary nor Teritary layer is active."
            aboutParagraph .= this.SPACING
        
        aboutParagraph .= "- Secondary Layer"
        aboutParagraph .= this.NEW_LINE
            aboutParagraph .= "Hotkeys which are active when this layer is activated, by default by pressing CapsLock. When this is active, Normal and Teritary layer hotkeys are not active."
            aboutParagraph .= this.SPACING
        
        aboutParagraph .= "- Tertiary Layer"
        aboutParagraph .= this.NEW_LINE
            aboutParagraph .= "Hotkeys which are active when this layer is activated, by default by holding shift and pressing CapsLock. When this is active, Normal and Secondary layer hotkeys are not active."
            aboutParagraph .= this.SPACING
        
        aboutParagraph .= "Some profiles do not have 4 layers. The Hold profile variants do not have the Tertiary layer."
        aboutParagraph .= this.SPACING

        this.section(whereToFindTitle, whereToFindParagraph)
        this.section(aboutTitle, aboutParagraph)
    }
}