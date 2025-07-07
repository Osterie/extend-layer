#Requires AutoHotkey v2.0

#Include <ui\util\GuiControlsRegistry>

class AdvancedHotkeyCraftingControl{

    guiToAddTo := ""

    controlsForAdvancedHotkeys := ""
    controlsForModifiers := ""
    hotkeySavedEventSubscribers := ""

    destinationKeyMode := false


    ; TODO this gui should know about availabkelKeyNames himself?
    __New(guiToAddTo, position, availableKeyNames, destinationKeyMode := false){
        this.guiToAddTo := guiToAddTo
        this.destinationKeyMode := destinationKeyMode
        this.controlsForAdvancedHotkeys := GuiControlsRegistry()
        this.controlsForModifiers := GuiControlsRegistry()
        this.hotkeySavedEventSubscribers := Array()

        groupBoxForAdvancedHotkeyCrafting := this.guiToAddTo.Add("GroupBox", "Section " . position, "Advanced hotkey crafting:")
        this.CreateModifierControls()
        this.CreateHotkeySelectionControls(availableKeyNames)
        ; this.CreateHotkeyStateControls() // Uncommented since adding support for key up/down state would require changes in the hotkey initialization logic
        
        this.controlsForAdvancedHotkeys.addControl("GroupBoxAdvancedCrafting", groupBoxForAdvancedHotkeyCrafting)
    }

    CreateModifierControls(){
        groupBoxForModifiers := this.guiToAddTo.Add("GroupBox", "Section w300 h50 xp+30 yp+20", "Modifiers:")
        
        if (this.destinationKeyMode = false){
            anyModifierCheckbox := this.guiToAddTo.Add("CheckBox","xs+25 ys+20", "Any")
            anyModifierCheckbox.OnEvent("Click", (*) => this.AnyModifierCheckboxClickEvent())
            this.controlsForModifiers.addControl("anyModifierCheckbox", anyModifierCheckbox)
            this.controlsForAdvancedHotkeys.addControl("AnyModifierCheckbox", anyModifierCheckbox)
        }
        
        
        controlCheckbox := this.guiToAddTo.Add("CheckBox","xp+40 ys+20", "Control")
        shiftCheckbox := this.guiToAddTo.Add("CheckBox","xp+60 ys+20", "Shift")
        altCheckbox := this.guiToAddTo.Add("CheckBox","xp+55 ys+20", "Alt")
        winCheckbox := this.guiToAddTo.Add("CheckBox","xp+40 ys+20", "Win")

        this.controlsForModifiers.addControl("ControlCheckbox", controlCheckbox)
        this.controlsForModifiers.addControl("ShiftCheckbox", shiftCheckbox)
        this.controlsForModifiers.addControl("AltCheckbox", altCheckbox)
        this.controlsForModifiers.addControl("WinCheckbox", winCheckbox)

        this.controlsForAdvancedHotkeys.addControl("GroupBoxForModifiers", groupBoxForModifiers)
        this.controlsForAdvancedHotkeys.addControl("ControlCheckbox", controlCheckbox)
        this.controlsForAdvancedHotkeys.addControl("ShiftCheckbox", shiftCheckbox)
        this.controlsForAdvancedHotkeys.addControl("AltCheckbox", altCheckbox)
        this.controlsForAdvancedHotkeys.addControl("WinCheckbox", winCheckbox)
    }

    CreateHotkeySelectionControls(availableKeyNames){
        groupBoxForHotkey := this.guiToAddTo.Add("GroupBox", "section w300 h50 xs ys+80", "Hotkey:")
        availableKeyNamesDropDown := this.guiToAddTo.Add("DropDownList", "xs+20 ys+20", availableKeyNames)
        availableKeyNamesDropDown.OnEvent("Change", (*) => this.NotifyListenersHotkeyChanged())
        this.controlsForAdvancedHotkeys.addControl("GroupBoxForHotkey", groupBoxForHotkey)
        this.controlsForAdvancedHotkeys.addControl("AvailableKeyNamesDropDown", availableKeyNamesDropDown)
    }

    CreateHotkeyStateControls(){
        if (this.destinationKeyMode = true){
            return
        }
        keyDownRadio := this.guiToAddTo.Add("Radio","Checked xs+95 ys+120", "When key down")
        keyUpRadio := this.guiToAddTo.Add("Radio",, "When key up")

        this.controlsForAdvancedHotkeys.addControl("KeyDownRadio", keyDownRadio)
        this.controlsForAdvancedHotkeys.addControl("KeyUpRadio", keyUpRadio)
    }

    AnyModifierCheckboxClickEvent(){
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

    Show(){
        this.controlsForAdvancedHotkeys.show()
    }

    Hide(){
        this.controlsForAdvancedHotkeys.hide()
    }

    GetKey(){
        return StrLower(this.controlsForAdvancedHotkeys.getControl("AvailableKeyNamesDropDown").Text)
    }

    GetModifiers() {
        hotkeyModifiers := ""

        modifiers := Map(
            "AnyModifierCheckbox", "*",
            "ControlCheckbox", "^",
            "ShiftCheckbox", "+",
            "AltCheckbox", "!",
            "WinCheckbox", "#",
        )

        for controlName, symbol in modifiers {
            control := this.controlsForAdvancedHotkeys.GetControl(controlName)
            if (control != ""){
                if (control.Value = 1){
                    hotkeyModifiers .= symbol
                }
            }
        }
        return hotkeyModifiers
    }

    GetUpModifier(){
        if (this.destinationKeyMode = true){
            MsgBox("This hotkey is for destination key, so it cannot be set to up or down state.")
            return ""
        }
        if (this.controlsForAdvancedHotkeys.getControl("KeyDownRadio").Value = 1){
            MsgBox("This hotkey is set to down state, so it cannot be set to up state.")
            return ""
        }
        else if (this.controlsForAdvancedHotkeys.getControl("KeyUpRadio").Value = 1){
            MsgBox("This hotkey is set to up state, so it will be returned as such.")
            return " Up"
        }
        MsgBox("This hotkey is not set to up or down state, so it will be returned as such.")
        return ""
    }

    
    GetValue(){
        return this.GetModifiers() . this.GetKey() . this.GetUpModifier()
    }

    SubscribeToHotkeySelectedEvent(event){
        this.hotkeySavedEventSubscribers.push(event)
    }

    NotifyListenersHotkeyChanged(){
        for event in this.hotkeySavedEventSubscribers{
            event(this.GetKey())
        }
    }
}