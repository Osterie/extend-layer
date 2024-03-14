#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>
#Include <UserInterface\Main\Util\DomainSpecificGui>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationView extends DomainSpecificGui{


    currentHotkeyTextControl := ""
    currentActionTextControl := ""

    controller := ""

    __New(){
        super.__New()
    }

    CreateMain(controller, ownerHwnd := ""){
        this.controller := controller

        this.opt("+Resize +MinSize300x280")
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
        buttonToChangeOriginalHotkey := this.AddButton("Default w100 xm", "Change Hotkey")
        buttonToChangeOriginalHotkey.onEvent("Click", (*) => this.controller.changeHotkey("Hotkey"))
        
        buttonToChangeOriginalAction := this.AddButton("Default w100", "Change Action")
        buttonToChangeOriginalAction.onEvent("Click", (*) => this.controller.changeHotkey("Action"))
    }

    createFinalizationButtons(){
        saveButton := this.AddButton("Default w100", "Save+Done")
        saveButton.onEvent("Click", (*) => this.controller.NotifyListenersSave())
        cancelButton := this.AddButton("Default w100", "Cancel+Done")
        cancelButton.onEvent("Click", (*) => this.Destroy())
        deleteButton := this.AddButton("Default w100", "Delete+Done")
        deleteButton.onEvent("Click", (*) => this.controller.NotifyListenersDelete())
    }
    
    updateHotkeyText(){
        newHotkey := this.controller.GetHotkeyFriendly()
        this.currentHotkeyTextControl.Value := ("Hotkey: `n" . newHotkey)

        if (this.controller.getOriginalHotkeyFriendly() != this.controller.GetHotkeyFriendly()){
            this.currentHotkeyTextControl.SetFont("s10 cGreen")
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
            this.currentActionTextControl.SetFont("s10 cGreen")
        }
        else{
            this.SetColors()
            ; this.currentActionTextControl.SetFont("s10 cRed")
        }

        GuiSizeChanger.SetTextAndResize(this.currentActionTextControl, this.currentActionTextControl.Value )
    }
}
