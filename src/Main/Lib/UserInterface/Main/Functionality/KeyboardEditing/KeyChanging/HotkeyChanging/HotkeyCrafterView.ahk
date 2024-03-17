#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiControlsRegistry>
#Include <UserInterface\Main\Util\DomainSpecificGui>
#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>


class HotkeyCrafterView extends DomainSpecificGui{ 

    simpleHotkeyInput := ""

    controlsForAdvancedHotkeys := ""
    controlsForSimpleHotkeys := ""
    controlsForModifiers := ""
    
    advancedModeCheckBox := ""
    saveButton := ""
    cancelButton := ""

    saveEventSubscribers := Array()

    originalHotkeyText := ""

    controller := ""

    __New(controller){
        super.__New(, "HotkeyCrafterGui")
        this.Opt("+Resize +MinSize480x480")
        
        this.controller := controller
        this.controlsForAdvancedHotkeys := guiControlsRegistry()
        this.controlsForSimpleHotkeys := guiControlsRegistry()
        this.controlsForModifiers := guiControlsRegistry()
    }

    Create(originalHotkey){
        this.originalHotkeyText := this.Add("Text", "h20", "Original hotkey: " . originalHotkey)
        this.advancedModeCheckBox := this.Add("Checkbox", "h50 xp+15 yp+15", "Advanced mode")
        this.advancedModeCheckBox.onEvent("Click", (*) => this.advancedModeButtonChangedEvent())
        this.createSimpleHotkeyCrafter(originalHotkey)
        this.createAdvancedHotkeyCrafter()
        this.hideAdvancedHotkeyCrafter()
        this.createButtons()
    }

    createSimpleHotkeyCrafter(originalHotkey){
        simpleHotkeyCraftingBox := this.Add("GroupBox", "Section w300 h50", "Simple hotkey crafting:")
        this.simpleHotkeyInput := this.Add("Hotkey", "w250 h20 xs+10 ys+20") ;yp sets the control's position to the left of the previous one...
        this.simpleHotkeyInput.Value := HotkeyFormatConverter.convertFromFriendlyName(originalHotkey, " + ")
        this.simpleHotkeyInput.OnEvent("Change", (*) => this.updateSaveButtonStatus(this.simpleHotkeyInput.Value))

        this.controlsForSimpleHotkeys.addControl("simpleHotkeyCraftingBox", simpleHotkeyCraftingBox)
        this.controlsForSimpleHotkeys.addControl("HotkeyDynamicInput", this.simpleHotkeyInput)
    }

    createButtons(){
        this.saveButton := this.Add("Button", " w100 h20 xM yp", "Save")
        this.saveButton.OnEvent("Click", (*) => this.NotifyListenersSave())
        
        this.cancelButton := this.Add("Button", "w100 h20", "Cancel")
        this.cancelButton.OnEvent("Click", (*) => this.Destroy())
    }

    hideButtons(){
        this.saveButton.Opt("Hidden1")
        this.cancelButton.Opt("Hidden1")
    }

    updateSaveButtonStatus(selectedHotkey){
        if (selectedHotkey = ""){
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
        availableKeyNamesDropDown := this.Add("DropDownList", "xs+20 ys+20", this.controller.getAvailableKeyNames())
        availableKeyNamesDropDown.OnEvent("Change", (*) => this.updateSaveButtonStatus(this.controlsForAdvancedHotkeys.getControl("AvailableKeyNamesDropDown").Text))
        
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

    advancedModeButtonChangedEvent(){
        if(this.advancedModeCheckBox.Value = true){
            this.showAdvancedHotkeyCrafter()
            this.hideSimpleHotkeyCrafter()
            this.updateSaveButtonStatus(this.controlsForAdvancedHotkeys.getControl("AvailableKeyNamesDropDown").Text)
        } 
        else {
            this.hideAdvancedHotkeyCrafter()
            this.showSimpleHotkeyCrafter()
        }
    }

    ; TODO get rid of *
    getNewHotkey(*){

        hotkeyKey := this.controlsForAdvancedHotkeys.getControl("AvailableKeyNamesDropDown").Text
        hotkeyModifiers := ""
        
        hotkeyToReturn := HotKeyInfo()


        if (this.advancedModeCheckBox.Value = true){
            if (this.controlsForAdvancedHotkeys.getControl("AnyModifierCheckbox").Value = 1){
                hotkeyModifiers .= "*"    
            }
            if (this.controlsForAdvancedHotkeys.getControl("ControlCheckbox").Value = 1){
                hotkeyModifiers .= "^"
            }
            if (this.controlsForAdvancedHotkeys.getControl("ShiftCheckbox").Value = 1){
                hotkeyModifiers .= "+"
            }
            if (this.controlsForAdvancedHotkeys.getControl("AltCheckbox").Value = 1){
                hotkeyModifiers .= "!"
            }
            if (this.controlsForAdvancedHotkeys.getControl("WinCheckbox").Value = 1){
                hotkeyModifiers .= "#"
            }
            if (this.controlsForAdvancedHotkeys.getControl("KeyUpRadio").Value = 1){
                hotkeyModifiers .= " Up"
            }
            hotkeyToReturn.setInfoForNormalHotKey(hotkeyKey, hotkeyModifiers)
        }
        else {
            hotkeyToReturn.setInfoForNormalHotKey(this.simpleHotkeyInput.Value)
        }
        return hotkeyToReturn
    }

    subscribeToSaveEvent(action){
        this.saveEventSubscribers.push(action)
    }

    NotifyListenersSave(){
        Loop this.saveEventSubscribers.Length{
            this.saveEventSubscribers[A_Index](this.getNewHotkey())
        }
        this.Destroy()
    }
    
    ; addDeleteButtonClickEventAction(action){
    ;     this.deleteButton.OnEvent("Click", action)
    ; }

    ShowSome(){
        ; Super.show()
        ; this.Show()
        this.advancedModeCheckBox.Opt("Hidden0")
        if (this.advancedModeCheckBox.Value = true){
            this.showAdvancedHotkeyCrafter()
            this.hideSimpleHotkeyCrafter()
        }
        else {
            this.showSimpleHotkeyCrafter()
            this.hideAdvancedHotkeyCrafter()
        }
    }

    hideOriginalHotkeyText(){
        this.originalHotkeyText.Opt("Hidden1")
    }

    hideControls(){
        this.hideAllButFinalisationButtons()
        this.hideButtons()
        this.hideOriginalHotkeyText()
    }

    hideAllButFinalisationButtons(){
        this.controlsForSimpleHotkeys.hideControls()
        this.controlsForAdvancedHotkeys.hideControls()
        this.advancedModeCheckBox.Opt("Hidden1")
    }
}