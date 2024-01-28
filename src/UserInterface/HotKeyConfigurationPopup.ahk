#Requires AutoHotkey v2.0

class HotKeyConfigurationPopup{



    CreatePopupForHotkeyRegistry(data, rowNumber, hotkeyCommand, hotkeyAction){


        guiToAddTo := Gui()
        guiToAddTo.opt("+Resize +MinSize300x560 +AlwaysOnTop")
        
        guiToAddTo.Add("Text", "w300 h20", "Hotkey:")
        inputKey := guiToAddTo.Add("Edit", "xm w300 h20", hotkeyCommand)
        
        currentHotkeyInfo := data.GetHotkey(hotkeyCommand)
        if (currentHotkeyInfo.hotkeyIsObject()){
            this.CreateHotKeyMaker(guiToAddTo)
        }
        else{

        }
        guiToAddTo.Add("Text", "xm w300 h20", "New Action For Hotkey:")
        inputValue := guiToAddTo.Add("Edit", "xm w300 h20", hotkeyAction)
        
        SaveButton := guiToAddTo.Add("Button", "w100 h20", "Save")
        CancelButton := guiToAddTo.Add("Button", "w100 h20", "Cancel")
        DeleteButton := guiToAddTo.Add("Button", "w100 h20", "Delete")
        guiToAddTo.Show()
    }

    CreateHotKeyMaker(guiToAddTo){
        manuallyCreateHotkeyCheckbox := guiToAddTo.Add("CheckBox", , "Manually create hotkey")
        manuallyCreateHotkeyCheckbox.onEvent("Click", (*) => this.manuallyCreateHotkeyCheckboxClickEvent(manuallyCreateHotkeyCheckbox))

        guiToAddTo.Add("Hotkey", "vChosenHotkey")
        guiToAddTo.Add("CheckBox", "vShipToBillingAddress", "Add win key as modifier")

    }

    manuallyCreateHotkeyCheckboxClickEvent(checkbox){
        if (checkbox.Value == 1){
            ; on, manually create hotkey
        }
        else{
            ; off create hotkey by pressing keys
        }
    }
    
    
}