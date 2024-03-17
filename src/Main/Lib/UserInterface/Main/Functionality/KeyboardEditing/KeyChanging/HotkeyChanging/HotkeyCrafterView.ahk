#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiControlsRegistry>
#Include <UserInterface\Main\Util\DomainSpecificGui>
#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>

#Include ".\AdvancedHotkeyCraftingControl.ahk"

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

    advancedHotkeyCrafter := ""

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
        
        this.advancedHotkeyCrafter := AdvancedHotkeyCraftingControl(this, "w370 h200 xp yp", this.controller.getAvailableKeyNames())
        this.advancedHotkeyCrafter.hide()
        this.advancedHotkeyCrafter.SubscribeToHotkeySelectedEvent(ObjBindMethod(this, "updateSaveButtonStatus"))
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
            this.advancedHotkeyCrafter.show()
            this.hideSimpleHotkeyCrafter()
            this.updateSaveButtonStatus(this.advancedHotkeyCrafter.getKey())
        } 
        else {
            this.advancedHotkeyCrafter.hide()
            this.updateSaveButtonStatus(this.simpleHotkeyInput.Value)
            this.showSimpleHotkeyCrafter()
        }
    }

    ; TODO get rid of *
    getNewHotkey(*){

        hotkeyToReturn := HotKeyInfo()

        if (this.advancedModeCheckBox.Value = true){
            hotkeyKey := this.advancedHotkeyCrafter.getKey()
            hotkeyModifiers := this.advancedHotkeyCrafter.getModifiers()
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