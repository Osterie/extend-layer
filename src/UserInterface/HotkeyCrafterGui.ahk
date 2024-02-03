#Requires AutoHotkey v2.0

class HotkeyCrafterGui{


    GuiObject := ""
    hotkeyStaticInput := ""

    __New(originalHotkey){
        this.GuiObject := Gui()
        this.GuiObject.Add("Text", "h20", "Original hotkey: " . originalHotkey)
        
        advancedModeButton := this.GuiObject.AddCheckBox("h50", "Advanced mode")

        newHotKeyText := this.GuiObject.Add("Text", "h20", "New hotkey:")
        hotkeyDynamicInput := this.GuiObject.Add("Hotkey", "w200 h20 yp") ;yp sets the control's position to the left of the previous one...

        hotkeyDynamicInput.onEvent("Change", (*) => this.hotkeyDynamicInputFieldChangedEvent(hotkeyDynamicInput))

        

        this.GuiObject.Add("Text", "w300 h20", "New Action For Hotkey:")
        this.hotkeyStaticInput := this.GuiObject.Add("Edit", "w300 h20")

        this.GuiObject.Add("Button", "w100 h20", "Save")
        this.GuiObject.Add("Button", "w100 h20", "Cancel")
        this.GuiObject.Add("Button", "w100 h20", "Delete")
    }

    hotkeyDynamicInputFieldChangedEvent(hotkeyDynamicInput){
        this.hotkeyStaticInput.Value := hotkeyDynamicInput.Value
    }
    
    Show(){
        this.GuiObject.Show()
    }

    Destroy(){
        this.GuiObject.Destroy()
    }
}


test := HotkeyCrafterGui("+Capslock")
test.Show()