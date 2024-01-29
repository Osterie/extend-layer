#Requires AutoHotkey v2.0

class HotKeyConfigurationPopup{

    hotkeyElement := ""
    hotkeyCommand := ""
    manuallyCreatHotkeyElement := ""

    CreatePopupForHotkeyRegistry(data, rowNumber, hotkeyCommand, hotkeyAction){

        this.hotkeyCommand := hotkeyCommand

        guiToAddTo := Gui()
        guiToAddTo.opt("+Resize +MinSize300x560 +AlwaysOnTop")
        
        guiToAddTo.Add("Text", "w300 h20", "Hotkey:")
        
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

        this.hotkeyElement := guiToAddTo.Add("Hotkey", )
        this.manuallyCreatHotkeyElement := guiToAddTo.Add("Edit", "xm w300 h20", this.hotkeyCommand)
        this.manuallyCreatHotkeyElement.Opt("Hidden1")

        guiToAddTo.Add("CheckBox",, "Add win key as modifier")

    }

    manuallyCreateHotkeyCheckboxClickEvent(checkbox){
        if (checkbox.Value == 1){
            ; on, manually create hotkey
            this.hotkeyElement.Opt("Hidden1")
            this.manuallyCreatHotkeyElement.Opt("Hidden0")
            this.manuallyCreatHotkeyElement.Value := this.hotkeyElement.Value

        }
        else{
            ; off create hotkey by pressing keys
            this.hotkeyElement.Opt("Hidden0")
            this.manuallyCreatHotkeyElement.Opt("Hidden1")
        }
    }
    
    
}