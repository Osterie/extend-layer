#Requires AutoHotkey v2.0

class HotKeyConfigurationPopup{

    hotkeyElement := ""
    hotkeyCommand := ""
    manuallyCreatHotkeyElement := ""
    addWinKeyAsModifierElement := ""

    CreatePopupForHotkeyRegistry(data, rowNumber, hotkeyCommand, hotkeyAction){

        this.hotkeyCommand := hotkeyCommand

        guiToAddTo := Gui()
        guiToAddTo.opt("+Resize +MinSize600x560")
        
        ; guiToAddTo.Add("Text", "w300 h20", "Original hotkey:") 
        guiToAddTo.Add("Text", "w300 h200", "Original hotkey: `n" . hotkeyCommand).SetFont("s20", "Arial")
        guiToAddTo.Add("Text", "w300 h200", "Original action: `n" . hotkeyAction).SetFont("s20", "Arial")
        
        ; currentHotkeyInfo := data.GetHotkey(hotkeyCommand)
        ; if (currentHotkeyInfo.hotkeyIsObject()){
        ;     this.CreateHotKeyMaker(guiToAddTo)
        ;     this.createHotkeyMethodCall(guiToAddTo, hotkeyAction)
        ; }
        ; else{

        ; }
        guiToAddTo.Show()
    }

    CreateHotKeyMaker(guiToAddTo){
        manuallyCreateHotkeyCheckbox := guiToAddTo.Add("CheckBox", , "Manually create hotkey")
        manuallyCreateHotkeyCheckbox.onEvent("Click", (*) => this.manuallyCreateHotkeyCheckboxClickEvent(manuallyCreateHotkeyCheckbox))

        this.hotkeyElement := guiToAddTo.Add("Hotkey", )
        this.manuallyCreatHotkeyElement := guiToAddTo.Add("Edit", "xm w300 h20", this.hotkeyCommand)
        this.manuallyCreatHotkeyElement.Opt("Hidden1")

        this.addWinKeyAsModifierElement := guiToAddTo.Add("CheckBox",, "Add win key as modifier")

    }

    manuallyCreateHotkeyCheckboxClickEvent(checkbox){
        if (checkbox.Value == 1){
            ; on, manually create hotkey
            this.hotkeyElement.Opt("Hidden1")
            this.manuallyCreatHotkeyElement.Opt("Hidden0")
            if (this.addWinKeyAsModifierElement.Value == 1){
                this.manuallyCreatHotkeyElement.Value := "#"    
            }
            this.addWinKeyAsModifierElement.Opt("Hidden1")
            this.manuallyCreatHotkeyElement.Value .= this.hotkeyElement.Value


        }
        else{
            ; off create hotkey by pressing keys
            this.hotkeyElement.Opt("Hidden0")
            this.addWinKeyAsModifierElement.Opt("Hidden0")
            this.manuallyCreatHotkeyElement.Opt("Hidden1")

        }
    }

    createHotkeyMethodCall(guiToAddTo, hotkeyAction){
        ; inputValue := guiToAddTo.Add("Edit", "xm w300 h20", hotkeyAction)
        guiToAddTo.Add("Text", "xm w300 h20", "New Action For Hotkey:")

        inputValue := guiToAddTo.Add("Edit", "xm w300 h20", hotkeyAction)
        
        SaveButton := guiToAddTo.Add("Button", "w100 h20", "Save")
        CancelButton := guiToAddTo.Add("Button", "w100 h20", "Cancel")
        DeleteButton := guiToAddTo.Add("Button", "w100 h20", "Delete")
    }


    
    
}