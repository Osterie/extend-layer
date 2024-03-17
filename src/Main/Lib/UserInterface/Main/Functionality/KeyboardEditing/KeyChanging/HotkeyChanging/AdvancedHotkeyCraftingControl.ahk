#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiControlsRegistry>


class AdvancedHotkeyCraftingControl{

    guiToAddTo := ""

    controlsForAdvancedHotkeys := ""
    controlsForModifiers := ""

    hotkeySavedEventSubscribers := ""

    ; TODO this gui should know about availabkelKeyNames himself?
    __New(guiToAddTo, position, availableKeyNames){
        this.guiToAddTo := guiToAddTo
        this.controlsForAdvancedHotkeys := guiControlsRegistry()
        this.controlsForModifiers := guiControlsRegistry()
        this.hotkeySavedEventSubscribers := Array()



        groupBoxForAdvancedHotkeyCrafting := this.guiToAddTo.Add("GroupBox", "Section " . position, "Advanced hotkey crafting:")
        this.CreateModifierControls()
        this.CreateHotkeySelectionControls(availableKeyNames)
        this.CreateHotkeyStateControls()
        
        this.controlsForAdvancedHotkeys.addControl("GroupBoxAdvancedCrafting", groupBoxForAdvancedHotkeyCrafting)

        
    }

    CreateModifierControls(){
        groupBoxForModifiers := this.guiToAddTo.Add("GroupBox", "Section w300 h50 xp+30 yp+20", "Modifiers:")
        
        anyModifierCheckbox := this.guiToAddTo.Add("CheckBox","xs+25 ys+20", "Any")
        anyModifierCheckbox.OnEvent("Click", (*) => this.anyModifierCheckboxClickEvent())
        controlCheckbox := this.guiToAddTo.Add("CheckBox","xp+40 ys+20", "Control")
        shiftCheckbox := this.guiToAddTo.Add("CheckBox","xp+60 ys+20", "Shift")
        altCheckbox := this.guiToAddTo.Add("CheckBox","xp+55 ys+20", "Alt")
        winCheckbox := this.guiToAddTo.Add("CheckBox","xp+40 ys+20", "Win")

        this.controlsForModifiers.addControl("anyModifierCheckbox", anyModifierCheckbox)
        this.controlsForModifiers.addControl("ControlCheckbox", controlCheckbox)
        this.controlsForModifiers.addControl("ShiftCheckbox", shiftCheckbox)
        this.controlsForModifiers.addControl("AltCheckbox", altCheckbox)
        this.controlsForModifiers.addControl("WinCheckbox", winCheckbox)

        this.controlsForAdvancedHotkeys.addControl("GroupBoxForModifiers", groupBoxForModifiers)
        this.controlsForAdvancedHotkeys.addControl("AnyModifierCheckbox", anyModifierCheckbox)
        this.controlsForAdvancedHotkeys.addControl("ControlCheckbox", controlCheckbox)
        this.controlsForAdvancedHotkeys.addControl("ShiftCheckbox", shiftCheckbox)
        this.controlsForAdvancedHotkeys.addControl("AltCheckbox", altCheckbox)
        this.controlsForAdvancedHotkeys.addControl("WinCheckbox", winCheckbox)
    }

    CreateHotkeySelectionControls(availableKeyNames){
        groupBoxForHotkey := this.guiToAddTo.Add("GroupBox", "section w300 h50 xs ys+80", "Hotkey:")
        availableKeyNamesDropDown := this.guiToAddTo.Add("DropDownList", "xs+20 ys+20", availableKeyNames)
        availableKeyNamesDropDown.OnEvent("Change", (*) => this.NotifyListenersHotkeySaved())
        this.controlsForAdvancedHotkeys.addControl("GroupBoxForHotkey", groupBoxForHotkey)
        this.controlsForAdvancedHotkeys.addControl("AvailableKeyNamesDropDown", availableKeyNamesDropDown)


    }

    CreateHotkeyStateControls(){
        keyDownRadio := this.guiToAddTo.Add("Radio","Checked xs+95 ys+120", "When key down")
        keyUpRadio := this.guiToAddTo.Add("Radio",, "When key up")

        this.controlsForAdvancedHotkeys.addControl("KeyDownRadio", keyDownRadio)
        this.controlsForAdvancedHotkeys.addControl("KeyUpRadio", keyUpRadio)
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

    Show(){
        this.controlsForAdvancedHotkeys.showControls()
    }

    Hide(){
        this.controlsForAdvancedHotkeys.hideControls()
    }

    GetKey(){
        return this.controlsForAdvancedHotkeys.getControl("AvailableKeyNamesDropDown").Text
    }

    GetModifiers(){
        hotkeyModifiers := ""
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
        return hotkeyModifiers
    }
    
    GetValue(){
        return this.getModifiers() . this.GetKey()
    }

    SubscribeToHotkeySelectedEvent(event){
        this.hotkeySavedEventSubscribers.push(event)
    }

    NotifyListenersHotkeySaved(){
        for event in this.hotkeySavedEventSubscribers{
            event(this.GetKey())
        }
    }
}