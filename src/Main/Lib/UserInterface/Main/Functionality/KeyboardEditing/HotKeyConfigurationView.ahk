#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>
#Include <UserInterface\Main\Util\DomainSpecificGui>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationView extends DomainSpecificGui{


    manuallyCreatHotkeyElement := ""
    addWinKeyAsModifierElement := ""
    currentHotkeyTextControl := ""

    hotkeyElement := ""

    currentHotkeyAction := ""

    saveButton := ""

    currentActionTextControl := ""

    activeObjectsRegistry := ""

    arrayOfKeyNames := Array()

    controller := ""

    __New(activeObjectsRegistry, arrayOfKeyNames){
        super.__New()

        this.activeObjectsRegistry := activeObjectsRegistry
        this.arrayOfKeyNames := arrayOfKeyNames
    }

    CreateMain(controller, ownerHwnd := ""){
        this.controller := controller

        this.opt("+Resize +MinSize600x560")
        this.opt("+Owner" ownerHwnd)
        this.createCurrentHotkeyControl()
        this.createCurrentActionControl()
        this.createButtons()
        this.Show()
    }

    createCurrentHotkeyControl(){
        this.currentHotkeyTextControl := this.Add("Text", "r4", "Hotkey: `n")
        this.updateHotkeyText()
    }

    createCurrentActionControl(){
        this.currentActionTextControl := this.Add("Text", " ", "Action: `n")
        this.updateActionText()
    }

    createButtons(){
        this.createChangeButtons()
        this.createFinalizationButtons()
    }

    createChangeButtons(){
        buttonToChangeOriginalHotkey := this.AddButton("Default w80 xm", "Change Hotkey")
        buttonToChangeOriginalHotkey.onEvent("Click", (*) => this.controller.changeOriginalHotkey())
        
        buttonToChangeOriginalAction := this.AddButton("Default w80", "Change Action")
        buttonToChangeOriginalAction.onEvent("Click", (*) => this.controller.changeOriginalAction())
    }

    createFinalizationButtons(){
        this.saveButton := this.AddButton("Default w80", "Save+Done")
        this.saveButton.onEvent("Click", (*) => this.controller.NotifyListenersSave())
        this.cancelButton := this.AddButton("Default w80", "Cancel+Done")
        this.cancelButton.onEvent("Click", (*) => this.Destroy())
        this.deleteButton := this.AddButton("Default w80", "Delete+Done")
    }
    
    updateHotkeyText(){
        newHotkey := this.controller.GetHotkeyFriendly()
        this.currentHotkeyTextControl.Value := ("Hotkey: `n" . newHotkey)

        if (this.controller.getOriginalHotkeyFriendly() != this.controller.GetHotkeyFriendly()){
            this.currentHotkeyTextControl.SetFont("s10 cBlue")
        }
        else{
            this.SetColors()
            ; this.currentHotkeyTextControl.SetFont("s10 cRed")
        }

        GuiSizeChanger.SetTextAndResize(this.currentHotkeyTextControl, this.currentHotkeyTextControl.Value )
    }

    updateActionText(){
        newAction := this.controller.GetActionFriendly()
        this.currentActionTextControl.Value := ("Action: `n" . newAction)

        if (this.controller.getOriginalActionFriendly() != this.controller.GetActionFriendly()){
            this.currentActionTextControl.SetFont("s10 cBlue")
        }
        else{
            this.SetColors()
            ; this.currentActionTextControl.SetFont("s10 cRed")
        }

        GuiSizeChanger.SetTextAndResize(this.currentActionTextControl, this.currentActionTextControl.Value )
    }
}
