#Requires AutoHotkey v2.0

#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class AddEditHotkeyPopup extends DocumentationPopup {

    __New(){
        title := "Add/Edit Hotkey"
        header := "Add/Edit Hotkey Documentation"
        super.__New(title, header)

        this.createAddEditHotkeyPopup()
        this.show()
    }

    createAddEditHotkeyPopup() {
        sectionWidth := this.getSectionWidth()

        addingTitle := "Adding Hotkeys"
        addingParagraph := "To add a hotkey, go to the 'Keyboards' tab and select the layer you want to add a hotkey to from the treeview on the left. Then click the 'Add' button below the hotkeys list view on the right. This will open a hotkey editor where you can set the key combo and action."
        addingParagraph .= this.NEW_LINE
        addingParagraph .= "To set the key combo, click the 'Set Hotkey' button and make a key combo. Further down you can read more about this in the 'Setting Hotkey Key Combo' section."
        addingParagraph .= this.NEW_LINE
        addingParagraph .= "To set the action, click the 'Set Action' button and choose an action. Further down you can read more about this in the 'Setting Action' section."
        addingParagraph .= this.NEW_LINE
        addingParagraph .= "After having set the key combo and the action, click the 'Save+Done' button and this hotkey will be added to the layer you chose."

        editingTitle := "Editing Hotkeys"
        editingParagraph := "To edit a hotkey, go to the 'Keyboards' tab and select the layer you want to edit a hotkey from. Select the hotkey from the hotkeys in list view on the right and click the 'Edit' button (or press enter). This will open the hotkey editor where you can change the key combo and action."
        editingParagraph .= this.NEW_LINE
        editingParagraph .= "To change the key combo, click the 'Set Hotkey' button and make a key combo. Further down you can read more about this in the 'Setting Hotkey Key Combo' section."
        editingParagraph .= this.NEW_LINE
        editingParagraph .= "To change the action, click the 'Set Action' button and choose an action. Further down you can read more about this in the 'Setting Action' section."
        editingParagraph .= this.NEW_LINE
        editingParagraph .= "After having changed the key combo or the action or both, you will see that the text fields showing the key combo and action are green. After editing the hotkey to your liking you can click the 'Save+Done' button and your changes will be saved."

        deletingTitle := "Deleting Hotkeys"
        deletingParagraph := "Only when editing a hotkey will you have the 'Delete+Done' button visible. Clicking this button will delete the chosen hotkey."

        settingHotkeyKeyComboTitle := "Setting Hotkey Key Combo"
        settingHotkeyKeyComboParagraph := "There are two modes when setting the hotkey key combo, 'simple' and 'advanced'. When you click the 'Set Hotkey' button, you will see the simple version and a checkbox saying 'Advanced mode', which when clicked will change to the advanced version."
        settingHotkeyKeyComboParagraph .= this.NEW_LINE
        settingHotkeyKeyComboParagraph .= "The image below shows the simple version. The simple version just has a hotkey input box. You can focus this input box and create the key combo by pressing the keys on your keyboard. By holding shift, ctrl and alt and then pressing c, you can click save which makes the key combo 'Shift + Ctrl + Alt + C'."
        settingHotkeyKeyComboParagraph .= this.NEW_LINE
        settingHotkeyKeyComboParagraph .= "This is very simple and therefore has some limitations, hence why advanced mode exists. You cannot use the 'Win' or 'Any' modifiers, and there are many keys you cannot choose, for example 'Tab', 'Browser_Back' and many more."

        settingHotkeyKeyComboAdvancedParagraph := "The advanced mode allows for creating key combos using more keys and modifiers options."
        settingHotkeyKeyComboAdvancedParagraph .= this.NEW_LINE
        settingHotkeyKeyComboAdvancedParagraph .= "Choose the modifiers you want by clicking the checkboxes for those modifiers. If you choose the 'Any' modfier you cannot choose the other modifiers, and vice versa."
        settingHotkeyKeyComboAdvancedParagraph .= this.NEW_LINE
        settingHotkeyKeyComboAdvancedParagraph .= "Select the key you want for the key combo from the drop down list. You can press keys on your keyboard to find them faster, for example pressing 'B' multiple times will cycle through the keys starting with the letter 'B'"
        settingHotkeyKeyComboAdvancedParagraph .= this.NEW_LINE
        settingHotkeyKeyComboAdvancedParagraph .= "Click save when done."

        settingHotkeyActionTitle := "Setting Action"
        settingHotkeyActionParagraph := "When setting the action you can choose between the action being a special action or a new key. To change between which of these you are setting, use the radio buttons in the top left."
        settingHotkeyActionParagraph .= this.NEW_LINE
        settingHotkeyActionParagraph .= "When selecting a special action you must choose the action you want from the list view. A description of the action will show below the list view after chosing an action."
        settingHotkeyActionParagraph .= this.NEW_LINE
        settingHotkeyActionParagraph .= "Some actions have parameters you must choose. If the chosen action has any these will appear to the right of the list view."
        settingHotkeyActionNewKeyParagraph .= "If you choose to set a new key instead, it will be like when setting the hotkey key combo. When the action is a new key you cannot use the 'any' keyword, since that does not make sense."

        this.image(DocumentationImages.HOTKEY_ADD_EDIT, "h-1 w" . sectionWidth)
        
        this.section(addingTitle, addingParagraph)
        this.image(DocumentationImages.HOTKEY_ADD_DIALOG, "h-1 w" . sectionWidth/1.5)
        
        this.section(editingTitle, editingParagraph)
        this.image(DocumentationImages.HOTKEY_EDIT_DIALOG, "h-1 w" . sectionWidth/1.5)
        this.image(DocumentationImages.HOTKEY_EDITED_DIALOG, "h-1 w" . sectionWidth/1.5)
        
        this.section(deletingTitle, deletingParagraph)

        this.section(settingHotkeyKeyComboTitle, settingHotkeyKeyComboParagraph)
        this.image(DocumentationImages.HOTKEY_SIMPLE_CRAFTING_DIALOG, "h-1 w" . sectionWidth/1.5)
        this.paragraph(settingHotkeyKeyComboAdvancedParagraph)
        this.image(DocumentationImages.HOTKEY_ADVANCED_CRAFTING_DIALOG, "h-1 w" . sectionWidth/1.5)

        this.section(settingHotkeyActionTitle, settingHotkeyActionParagraph)
        this.image(DocumentationImages.HOTKEY_SET_ACTION, "h-1 w" . sectionWidth)
        this.paragraph(settingHotkeyActionNewKeyParagraph)
        this.image(DocumentationImages.HOTKEY_SET_ACTION_KEY, "h-1 w" . sectionWidth)
    }
}