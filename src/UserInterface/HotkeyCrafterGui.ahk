#Requires AutoHotkey v2.0
#Include ".\guiControlsRegistry.ahk"

#Include "..\library\MetaInfo\MetaInfoReading\KeyNamesReader.ahk"

class HotkeyCrafterGui{


    GuiObject := ""
    hotkeyStaticInput := ""
    hotkeyDynamicInput := ""

    controlsForAdvancedHotkeys := ""
    controlsForSimpleHotkeys := ""
    groupBox := ""
    
    advancedModeButton := ""
    saveButton := ""
    cancelButton := ""

    availableKeyNames := []

    __New(originalHotkey, pathToKeyNamesFile){

        ; TODO add path to keynames file as parameter

        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(pathToKeyNamesFile, "rw" , "UTF-8")

        this.availableKeyNames := keyNamesFileObjReader.ReadKeyNamesFromTextFileObject(fileObjectOfKeyNames).GetKeyNames()
        this.controlsForAdvancedHotkeys := guiControlsRegistry()
        this.controlsForSimpleHotkeys := guiControlsRegistry()

        originalHotkeyFormatted := HotkeyFormatConverter.convertFromFriendlyName(originalHotkey, " + ")

        this.GuiObject := Gui()
        this.GuiObject.Add("Text", "h20", "Original hotkey: " . originalHotkey)
        
        this.advancedModeButton := this.GuiObject.AddCheckBox("h50", "Advanced mode")
        this.advancedModeButton.onEvent("Click", (*) => this.advancedModeButtonChangedEvent())

        groupBox := this.GuiObject.Add("GroupBox", "Section w300 h50", "Simple hotkey crafting:")
        this.hotkeyDynamicInput := this.GuiObject.Add("Hotkey", "w250 h20 xs+10 ys+20") ;yp sets the control's position to the left of the previous one...
        this.hotkeyDynamicInput.Value := originalHotkeyFormatted

        this.controlsForSimpleHotkeys.addControl("GroupBox", groupBox)
        this.controlsForSimpleHotkeys.addControl("HotkeyDynamicInput", this.hotkeyDynamicInput)


        this.createAdvancedHotkeyCrafter()
        ; this.hideAdvancedHotkeyCrafter()

        this.hideSimpleHotkeyCrafter()

        ; this.hotkeyStaticInput := this.GuiObject.Add("Edit", "w300 h20 xp yp")
        ; this.hotkeyStaticInput.Opt("Hidden1")

        this.saveButton := this.GuiObject.Add("Button", " w100 h20 xM yp+150", "Save")
        this.cancelButton := this.GuiObject.Add("Button", "w100 h20", "Cancel")
        this.deleteButton := this.GuiObject.Add("Button", "w100 h20", "Delete")
    }

    createAdvancedHotkeyCrafter(){
        groupBoxForAdvancedHotkeyCrafting := this.GuiObject.Add("GroupBox", "Section w370 h200 xp yp", "Advanced hotkey crafting:")
        ; hotkeyText := this.GuiObject.Add("Text", "h100 xs+10 ys+10", "Advanced hotkey crafting:")
        
        groupBoxForModifiers := this.GuiObject.Add("GroupBox", "Section w300 h50 xp+30 yp+20", "Modifiers:")
        
        anyModifierCheckbox := this.GuiObject.Add("CheckBox","xs+15 ys+20", "Any")
        controlCheckbox := this.GuiObject.Add("CheckBox","xp+55 ys+20", "Control")
        shiftCheckbox := this.GuiObject.Add("CheckBox","xp+55 ys+20", "Shift")
        altCheckbox := this.GuiObject.Add("CheckBox","xp+55 ys+20", "Alt")
        winCheckbox := this.GuiObject.Add("CheckBox","xp+55 ys+20", "Win")
        
        groupBoxForHotkey := this.GuiObject.Add("GroupBox", "section w300 h50 xs ys+80", "Hotkey:")
        availableKeyNamesDropDown := this.GuiObject.Add("DropDownList", "xs+20 ys+20", this.availableKeyNames)

        
        keyDownRadio := this.GuiObject.Add("Radio","Checked xs+95 ys+120", "When key down")
        keyUpRadio := this.GuiObject.Add("Radio",, "When key up")

        this.controlsForAdvancedHotkeys.addControl("GroupBoxAdvancedCrafting", groupBoxForAdvancedHotkeyCrafting)
        ; this.controlsForAdvancedHotkeys.addControl("HotkeyText", hotkeyText)
        this.controlsForAdvancedHotkeys.addControl("GroupBoxForModifiers", groupBoxForModifiers)
        this.controlsForAdvancedHotkeys.addControl("GroupBoxForHotkey", groupBoxForHotkey)
        this.controlsForAdvancedHotkeys.addControl("KeyDownRadio", keyDownRadio)
        this.controlsForAdvancedHotkeys.addControl("KeyUpRadio", keyUpRadio)
        this.controlsForAdvancedHotkeys.addControl("AnyModifierCheckbox", anyModifierCheckbox)
        this.controlsForAdvancedHotkeys.addControl("ControlCheckbox", controlCheckbox)
        this.controlsForAdvancedHotkeys.addControl("ShiftCheckbox", shiftCheckbox)
        this.controlsForAdvancedHotkeys.addControl("AltCheckbox", altCheckbox)
        this.controlsForAdvancedHotkeys.addControl("WinCheckbox", winCheckbox)
        this.controlsForAdvancedHotkeys.addControl("AvailableKeyNamesDropDown", availableKeyNamesDropDown)


    }

    showAdvancedHotkeyCrafter(){
        this.controlsForAdvancedHotkeys.showControls()
    }
    hideAdvancedHotkeyCrafter(){
        this.controlsForAdvancedHotkeys.hideControls()
    }

    showSimpleHotkeyCrafter(){
        this.controlsForSimpleHotkeys.showControls()
    }
    hideSimpleHotkeyCrafter(){
        this.controlsForSimpleHotkeys.hideControls()
    }




    cancelButtonClickEvent(){

        this.GuiObject.Destroy()
        this.Destroy()

    }

    advancedModeButtonChangedEvent(){
        if(this.advancedModeButton.Value = true){
            ; this.hotkeyStaticInput.Opt("Hidden0")
            this.showAdvancedHotkeyCrafter()
            this.hideSimpleHotkeyCrafter()
            ; if (this.hotkeyDynamicInput.Value != ""){
            ;     this.hotkeyStaticInput.Value := this.hotkeyDynamicInput.Value
            ; }
        } 
        else {
            ; this.hotkeyStaticInput.Opt("Hidden1")
            this.hideAdvancedHotkeyCrafter()
            this.showSimpleHotkeyCrafter()
            ; this.hotkeyDynamicInput.Value := this.hotkeyStaticInput.Value
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


test := HotkeyCrafterGui("+Capslock", "..\resources\keyNames\keyNames.txt")
test.Show()