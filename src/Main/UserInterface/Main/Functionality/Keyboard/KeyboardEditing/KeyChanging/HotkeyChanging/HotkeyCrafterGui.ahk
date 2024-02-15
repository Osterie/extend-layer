#Requires AutoHotkey v2.0

#Include "..\..\..\..\..\util\GuiControlsRegistry.ahk"

class HotkeyCrafterGui{


    GuiObject := ""
    hotkeyStaticInput := ""
    hotkeyDynamicInput := ""

    controlsForAdvancedHotkeys := ""
    controlsForSimpleHotkeys := ""
    controlsForModifiers := ""
    groupBox := ""
    
    advancedModeButton := ""
    saveButton := ""
    cancelButton := ""

    availableKeyNames := []

    __New(originalHotkey, arrayOfKeyNames, guiToAddTo := ""){

        if (guiToAddTo = ""){
            this.GuiObject := Gui()
            this.GuiObject.Add("Text", "h20", "Original hotkey: " . originalHotkey)
        }
        else {
            this.GuiObject := guiToAddTo
        }

        this.availableKeyNames := arrayOfKeyNames 
        this.controlsForAdvancedHotkeys := guiControlsRegistry()
        this.controlsForSimpleHotkeys := guiControlsRegistry()
        this.controlsForModifiers := guiControlsRegistry()

        originalHotkeyFormatted := HotkeyFormatConverter.convertFromFriendlyName(originalHotkey, " + ")

        
        this.advancedModeButton := this.GuiObject.AddCheckBox("h50 xp+15 yp+15", "Advanced mode")
        this.advancedModeButton.onEvent("Click", (*) => this.advancedModeButtonChangedEvent())

        groupBox := this.GuiObject.Add("GroupBox", "Section w300 h50", "Simple hotkey crafting:")
        this.hotkeyDynamicInput := this.GuiObject.Add("Hotkey", "w250 h20 xs+10 ys+20") ;yp sets the control's position to the left of the previous one...
        this.hotkeyDynamicInput.Value := originalHotkeyFormatted
        this.hotkeyDynamicInput.OnEvent("Change", (*) => this.dynamicHotkeyInputChangedEvent())

        this.controlsForSimpleHotkeys.addControl("GroupBox", groupBox)
        this.controlsForSimpleHotkeys.addControl("HotkeyDynamicInput", this.hotkeyDynamicInput)

        this.createAdvancedHotkeyCrafter()
        this.hideAdvancedHotkeyCrafter()

        this.saveButton := this.GuiObject.Add("Button", " w100 h20 xM yp+150", "Save")
        this.cancelButton := this.GuiObject.Add("Button", "w100 h20", "Cancel")
        this.deleteButton := this.GuiObject.Add("Button", "w100 h20", "Delete")
    }

    dynamicHotkeyInputChangedEvent(){
        if (this.hotkeyDynamicInput.Value = ""){
            this.saveButton.enabled := false
        }
        else{
            this.saveButton.enabled := true
        }
    }

    createAdvancedHotkeyCrafter(){
        groupBoxForAdvancedHotkeyCrafting := this.GuiObject.Add("GroupBox", "Section w370 h200 xp yp", "Advanced hotkey crafting:")
        
        groupBoxForModifiers := this.GuiObject.Add("GroupBox", "Section w300 h50 xp+30 yp+20", "Modifiers:")
        
        anyModifierCheckbox := this.GuiObject.Add("CheckBox","xs+25 ys+20", "Any")
        anyModifierCheckbox.OnEvent("Click", (*) => this.anyModifierCheckboxClickEvent())
        controlCheckbox := this.GuiObject.Add("CheckBox","xp+40 ys+20", "Control")
        shiftCheckbox := this.GuiObject.Add("CheckBox","xp+60 ys+20", "Shift")
        altCheckbox := this.GuiObject.Add("CheckBox","xp+55 ys+20", "Alt")
        winCheckbox := this.GuiObject.Add("CheckBox","xp+40 ys+20", "Win")
        

        this.controlsForModifiers.addControl("anyModifierCheckbox", anyModifierCheckbox)
        this.controlsForModifiers.addControl("ControlCheckbox", controlCheckbox)
        this.controlsForModifiers.addControl("ShiftCheckbox", shiftCheckbox)
        this.controlsForModifiers.addControl("AltCheckbox", altCheckbox)
        this.controlsForModifiers.addControl("WinCheckbox", winCheckbox)

        groupBoxForHotkey := this.GuiObject.Add("GroupBox", "section w300 h50 xs ys+80", "Hotkey:")
        availableKeyNamesDropDown := this.GuiObject.Add("DropDownList", "xs+20 ys+20", this.availableKeyNames)
        availableKeyNamesDropDown.OnEvent("Change", (*) => this.updateSaveButtonStateBasedOnAdvancedHotkey())
        
        keyDownRadio := this.GuiObject.Add("Radio","Checked xs+95 ys+120", "When key down")
        keyUpRadio := this.GuiObject.Add("Radio",, "When key up")

        this.controlsForAdvancedHotkeys.addControl("GroupBoxAdvancedCrafting", groupBoxForAdvancedHotkeyCrafting)
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

    updateSaveButtonStateBasedOnAdvancedHotkey(){
        selectedKey := this.controlsForAdvancedHotkeys.getControl("AvailableKeyNamesDropDown").Text
        if (selectedKey = ""){
            this.saveButton.enabled := false
        }
        else{
            this.saveButton.enabled := true
        }
    }

    anyModifierCheckboxClickEvent(){
        if (this.controlsForModifiers.getControl("anyModifierCheckbox").Value = true){
            this.controlsForModifiers.setValuesFalse()
            this.controlsForModifiers.disableControls()
            this.controlsForModifiers.getControl("anyModifierCheckbox").Value := true
            this.controlsForModifiers.getControl("anyModifierCheckbox").Enabled := true
        }
        else if (this.controlsForModifiers.getControl("anyModifierCheckbox").Value = false){
            this.controlsForModifiers.enableControls()
        }   
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
            this.showAdvancedHotkeyCrafter()
            this.hideSimpleHotkeyCrafter()
            this.updateSaveButtonStateBasedOnAdvancedHotkey()
        } 
        else {
            this.hideAdvancedHotkeyCrafter()
            this.showSimpleHotkeyCrafter()
        }
    }

    getNewHotkey(*){
        hotkeyValueToReturn := ""
        if (this.advancedModeButton.Value = true){
            if (this.controlsForAdvancedHotkeys.getControl("AnyModifierCheckbox").Value = 1){
                hotkeyValueToReturn .= "*"    
            }
            if (this.controlsForAdvancedHotkeys.getControl("ControlCheckbox").Value = 1){
                hotkeyValueToReturn .= "^"
            }
            if (this.controlsForAdvancedHotkeys.getControl("ShiftCheckbox").Value = 1){
                hotkeyValueToReturn .= "+"
            }
            if (this.controlsForAdvancedHotkeys.getControl("AltCheckbox").Value = 1){
                hotkeyValueToReturn .= "!"
            }
            if (this.controlsForAdvancedHotkeys.getControl("WinCheckbox").Value = 1){
                hotkeyValueToReturn .= "#"
            }
            hotkeyValueToReturn .= this.controlsForAdvancedHotkeys.getControl("AvailableKeyNamesDropDown").Text

            if (this.controlsForAdvancedHotkeys.getControl("KeyUpRadio").Value = 1){
                hotkeyValueToReturn .= " Up"
            }
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
        this.advancedModeButton.Opt("Hidden0")
        if (this.advancedModeButton.Value = true){
            this.showAdvancedHotkeyCrafter()
            this.hideSimpleHotkeyCrafter()
        }
        else {
            this.showSimpleHotkeyCrafter()
            this.hideAdvancedHotkeyCrafter()
        }
    }

    Destroy(){
        this.GuiObject.Destroy()
    }

    hide(){
        this.GuiObject.Hide()
    }

    hideAllButFinalisationButtons(){
        this.controlsForSimpleHotkeys.hideControls()
        this.controlsForAdvancedHotkeys.hideControls()
        this.advancedModeButton.Opt("Hidden1")
    }
}