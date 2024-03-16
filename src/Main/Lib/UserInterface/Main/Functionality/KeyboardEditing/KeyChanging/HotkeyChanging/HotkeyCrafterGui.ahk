#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiControlsRegistry>

#Include <UserInterface\Main\Util\DomainSpecificGui>


class HotkeyCrafterGui extends DomainSpecificGui{ 


    hotkeyStaticInput := ""
    hotkeyDynamicInput := ""

    controlsForAdvancedHotkeys := ""
    controlsForSimpleHotkeys := ""
    controlsForModifiers := ""
    groupBox := ""
    
    advancedModeButton := ""
    saveButton := ""
    cancelButton := ""

    saveEventSubscribers := Array()

    availableKeyNames := []

    __New(){
        super.__New(, "HotkeyCrafterGui")
        this.Opt("+Resize +MinSize640x480")
    }

    Create(originalHotkey, arrayOfKeyNames){
        this.show("w640 h480")
        this.Add("Text", "h20", "Original hotkey: " . originalHotkey)

        this.availableKeyNames := arrayOfKeyNames 
        this.controlsForAdvancedHotkeys := guiControlsRegistry()
        this.controlsForSimpleHotkeys := guiControlsRegistry()
        this.controlsForModifiers := guiControlsRegistry()


        
        this.advancedModeButton := this.Add("Checkbox", "h50 xp+15 yp+15", "Advanced mode")
        this.advancedModeButton.onEvent("Click", (*) => this.advancedModeButtonChangedEvent())

        groupBox := this.Add("GroupBox", "Section w300 h50", "Simple hotkey crafting:")
        this.hotkeyDynamicInput := this.Add("Hotkey", "w250 h20 xs+10 ys+20") ;yp sets the control's position to the left of the previous one...
        originalHotkeyFormatted := HotkeyFormatConverter.convertFromFriendlyName(originalHotkey, " + ")
        this.hotkeyDynamicInput.Value := originalHotkeyFormatted
        this.hotkeyDynamicInput.OnEvent("Change", (*) => this.dynamicHotkeyInputChangedEvent())

        this.controlsForSimpleHotkeys.addControl("GroupBox", groupBox)
        this.controlsForSimpleHotkeys.addControl("HotkeyDynamicInput", this.hotkeyDynamicInput)

        this.createAdvancedHotkeyCrafter()
        this.hideAdvancedHotkeyCrafter()

        this.saveButton := this.Add("Button", " w100 h20 xM yp+150", "Save")
        this.saveButton.OnEvent("Click", (*) => this.NotifyListenersSave())
        
        this.cancelButton := this.Add("Button", "w100 h20", "Cancel")
        this.cancelButton.OnEvent("Click", (*) => this.Destroy())
    }

    hideButtons(){
        this.saveButton.Opt("Hidden1")
        this.cancelButton.Opt("Hidden1")
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
        groupBoxForAdvancedHotkeyCrafting := this.Add("GroupBox", "Section w370 h200 xp yp", "Advanced hotkey crafting:")
        
        groupBoxForModifiers := this.Add("GroupBox", "Section w300 h50 xp+30 yp+20", "Modifiers:")
        
        anyModifierCheckbox := this.Add("CheckBox","xs+25 ys+20", "Any")
        anyModifierCheckbox.OnEvent("Click", (*) => this.anyModifierCheckboxClickEvent())
        controlCheckbox := this.Add("CheckBox","xp+40 ys+20", "Control")
        shiftCheckbox := this.Add("CheckBox","xp+60 ys+20", "Shift")
        altCheckbox := this.Add("CheckBox","xp+55 ys+20", "Alt")
        winCheckbox := this.Add("CheckBox","xp+40 ys+20", "Win")
        

        this.controlsForModifiers.addControl("anyModifierCheckbox", anyModifierCheckbox)
        this.controlsForModifiers.addControl("ControlCheckbox", controlCheckbox)
        this.controlsForModifiers.addControl("ShiftCheckbox", shiftCheckbox)
        this.controlsForModifiers.addControl("AltCheckbox", altCheckbox)
        this.controlsForModifiers.addControl("WinCheckbox", winCheckbox)

        groupBoxForHotkey := this.Add("GroupBox", "section w300 h50 xs ys+80", "Hotkey:")
        availableKeyNamesDropDown := this.Add("DropDownList", "xs+20 ys+20", this.availableKeyNames)
        availableKeyNamesDropDown.OnEvent("Change", (*) => this.updateSaveButtonStateBasedOnAdvancedHotkey())
        
        keyDownRadio := this.Add("Radio","Checked xs+95 ys+120", "When key down")
        keyUpRadio := this.Add("Radio",, "When key up")

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
        this.Destroy()
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

    subscribeToSaveEvent(action){
        this.saveEventSubscribers.push(action)
    }

    NotifyListenersSave(){
        Loop this.saveEventSubscribers.Length{
            this.saveEventSubscribers[A_Index](this.getNewHotkey())
        }
    }

    addCancelButtonClickEventAction(action){
        this.cancelButton.OnEvent("Click", action)
    }
    
    ; addDeleteButtonClickEventAction(action){
    ;     this.deleteButton.OnEvent("Click", action)
    ; }

    addCloseEventAction(action){
        this.OnEvent("Close", action)
    }

    ShowSome(){
        Super.show()
        ; this.Show()
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

    hideAllButFinalisationButtons(){
        this.controlsForSimpleHotkeys.hideControls()
        this.controlsForAdvancedHotkeys.hideControls()
        this.advancedModeButton.Opt("Hidden1")
    }
}