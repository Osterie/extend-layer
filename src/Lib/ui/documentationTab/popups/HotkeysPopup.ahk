#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class HotkeysPopup extends DocumentationPopup {

    __New(){
        title := "Hotkeys"
        header := "Hotkeys Documentation"
        super.__New(title, header)

        this.createHotkeysPopup()
        this.show()
    }

    createHotkeysPopup() {
        sectionWidth := this.getSectionWidth()

        aboutTitle := "About Hotkeys"
        aboutParagraph := "Hotkeys are a key combo mapped to an action. Pressing a hotkey key combo will execute the action associated with that key combo."
        aboutParagraph .= this.NEW_LINE
        aboutParagraph .= "That action can be a new key, for example the key combo 'i' corresponds to the action 'arrow up', which would remap the 'i' key to the 'arrow up' key."
        aboutParagraph .= this.NEW_LINE
        aboutParagraph .= "The action can also be a special action, for example an action which toggles an auto clicker."

        aboutParagraph .= this.SPACING
        aboutParagraph .= "A key combo can have modifiers, which mostly can be combined together with one exception. The modifiers which can be used are 'Ctrl', 'Shift', 'Alt', 'Win' (Windows key) and 'Any'. The 'Any' modifiers cannot be combined with any other modifiers, and vice versa. Otherwise you can combine 'Ctrl', 'Shift', 'Alt', and 'Win' in any combination. This means all the chosen modifiers must be held down for that key combo. The 'Any' modifiers means that hotkey will execute no matter what modifiers are active."

        whereToFindTitle := "Where to Find Hotkeys"
        whereToFindParagraph := "Under the 'Keyboards' tab you will see all your different layers in a treeview on the left. Selecting one of the layers will show the hotkeys for that layer to the right in a listview."
        whereToFindParagraph .= this.NEW_LINE
        whereToFindParagraph .= "In the hotkeys listview there are two columns. 'KeyCombo' and 'Action'."

        whereToFindParagraphContinued .= "KeyCombo:"
        whereToFindParagraphContinued .= this.NEW_LINE
        whereToFindParagraphContinued .= "The key combination to hit to execute the hotkey action. This can include multiple modifiers, for example 'Shift+Ctrl+C', or none, like 'F'."
        whereToFindParagraphContinued .= this.SPACING
        
        whereToFindParagraphContinued .= "Action:"
        whereToFindParagraphContinued .= this.NEW_LINE
        whereToFindParagraphContinued .= "The action to perform when the key combo is hit. The action can be a new key, for example 'C' or 'Ctrl + C', or it can be a new special action. For example 'layers.toggleLayer(1)' which toggles between normal layer and secondary layer."

        specialActionsTitle := "Special Actions"
        specialActionsParagraph := "Special Actions are actions which have a non-default key behaviour. An example of a default key would be 'K' or 'Browser_Forward'. A special action would be something like 'Open URL' or 'Move mouse to position'."
        specialActionsParagraph .= this.NEW_LINE
        
        specialActionsParagraph .= "When adding a hotkey there are many special actions one can choose from. Each action will have a description to help understand what it does. Some actions can have parameters, which also have a description."
        specialActionsParagraph .= this.SPACING

        specialActionsParagraph .= "An example of a special action with parameters is the 'Move mouse to position' action. It has two parameters: x coordinate and y coordinate. These parameters have input fields where you must type tha values to give the parameters, in this case numbers correlating to where you want the mouse cursor to move to."
        specialActionsParagraph .= this.SPACING

        specialActionsParagraph .=  "Some special actions have action settings. which can be changed under the 'Change Action Settings' tab. For example 'Layer' where you can modify the layer indicator for the Secondary and Tertiary layer."
        specialActionsParagraph .= this.SPACING

        ; addingHotkeyTitle := "Adding Hotkeys"
        ; editingHotkeyTitle := "Editing Hotkeys"
        
        ; Enter to edit
        this.section(aboutTitle, aboutParagraph)
        
        this.section(whereToFindTitle, whereToFindParagraph)
        this.image(DocumentationImages.HOTKEY_ADD_EDIT, "h-1 w" . sectionWidth)
        this.paragraph(whereToFindParagraphContinued)

        this.section(specialActionsTitle, specialActionsParagraph)
    }
}