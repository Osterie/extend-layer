#Requires AutoHotkey v2.0

class HotkeyCrafterGui{


    GuiObject := ""

    __New(originalHotkey){
        this.GuiObject := Gui()
        this.GuiObject.Add("Text", "w300 h20", "Original hotkey: " . originalHotkey)
        this.GuiObject.Add("Text", "w300 h20", "New hotkey:")
        hotkeyDynamicInput := this.GuiObject.Add("Hotkey", )
        this.GuiObject.Add("Text", "w300 h20", "New Action For Hotkey:")
        this.GuiObject.Add("Edit", "xm w300 h20")
        this.GuiObject.Add("Button", "w100 h20", "Save")
        this.GuiObject.Add("Button", "w100 h20", "Cancel")
        this.GuiObject.Add("Button", "w100 h20", "Delete")
    }
    
    Show(){
        this.GuiObject.Show()
    }

    Destroy(){
        this.GuiObject.Destroy()
    }
}