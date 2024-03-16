#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiControlsRegistry>
#Include <UserInterface\Main\Util\DomainSpecificGui>
#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>


class HotkeyCrafterModel{ 

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

    originalHotkeyText := ""

    __New(arrayOfKeyNames){
        this.availableKeyNames := arrayOfKeyNames
    }

    getNewHotkey(*){

        hotkeyKey := this.controlsForAdvancedHotkeys.getControl("AvailableKeyNamesDropDown").Text
        hotkeyModifiers := ""
        
        hotkeyToReturn := HotKeyInfo()


        if (this.advancedModeButton.Value = true){
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
            hotkeyToReturn.setInfoForNormalHotKey(this.hotkeyDynamicInput.Value)
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
        ; Super.show()
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

    hideOriginalHotkeyText(){
        this.originalHotkeyText.Opt("Hidden1")
    }

    hideAllButFinalisationButtons(){
        this.controlsForSimpleHotkeys.hideControls()
        this.controlsForAdvancedHotkeys.hideControls()
        this.advancedModeButton.Opt("Hidden1")
    }

    getAvailableKeyNames(){
        return this.availableKeyNames
    }
}