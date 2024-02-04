#Requires AutoHotkey v2.0

class HotkeyCrafterGui{


    GuiObject := ""
    hotkeyStaticInput := ""
    hotkeyDynamicInput := ""

    advancedModeButton := ""
    saveButton := ""
    cancelButton := ""

    __New(originalHotkey){

        originalHotkeyFormatted := HotkeyFormatConverter.convertFromFriendlyName(originalHotkey, " + ")

        this.GuiObject := Gui()
        this.GuiObject.Add("Text", "h20", "Original hotkey: " . originalHotkey)
        
        this.advancedModeButton := this.GuiObject.AddCheckBox("h50", "Advanced mode")
        this.advancedModeButton.onEvent("Click", (*) => this.advancedModeButtonChangedEvent())

        this.GuiObject.Add("Text", "h20", "New hotkey:")
        this.hotkeyDynamicInput := this.GuiObject.Add("Hotkey", "w200 h20 yp") ;yp sets the control's position to the left of the previous one...
        this.hotkeyDynamicInput.Value := originalHotkeyFormatted

        this.hotkeyStaticInput := this.GuiObject.Add("Edit", "w300 h20 xp yp")
        this.hotkeyStaticInput.Opt("Hidden1")

        this.saveButton := this.GuiObject.Add("Button", "w100 h20", "Save")
        this.cancelButton := this.GuiObject.Add("Button", "w100 h20", "Cancel")
        this.deleteButton := this.GuiObject.Add("Button", "w100 h20", "Delete")
    }

    cancelButtonClickEvent(){

        this.GuiObject.Destroy()
        this.Destroy()

    }

    advancedModeButtonChangedEvent(){
        if(this.advancedModeButton.Value = true){
            this.hotkeyStaticInput.Opt("Hidden0")
            this.hotkeyDynamicInput.Opt("Hidden1")
            if (this.hotkeyDynamicInput.Value != ""){
                this.hotkeyStaticInput.Value := this.hotkeyDynamicInput.Value
            }
        } 
        else {
            this.hotkeyStaticInput.Opt("Hidden1")
            this.hotkeyDynamicInput.Opt("Hidden0")
            this.hotkeyDynamicInput.Value := this.hotkeyStaticInput.Value
        }
    }

    getNewHotkey(*){
        hotkeyValueToReturn := ""
        if (this.advancedModeButton.Value = true){
            hotkeyValueToReturn := this.hotkeyStaticInput.Value
        }
        else {
            hotkeyValueToReturn := this.hotkeyDynamicInput.Value
        }
        return hotkeyValueToReturn
    }

    addSaveButtonClickEventAction(action){
        this.saveButton.OnEvent("Click", action)
    }

    addCancelButtonClickEventAction(action){
        this.cancelButton.OnEvent("Click", action)
    }
    
    addDeleteButtonClickEventAction(action){
        this.deleteButton.OnEvent("Click", action)
    }

    addCloseEventAction(action){
        this.GuiObject.OnEvent("Close", action)
    }


    Show(){
        this.GuiObject.Show()
    }

    Destroy(){
        this.GuiObject.Destroy()
    }
}


; test := HotkeyCrafterGui("+Capslock")
; test.Show()