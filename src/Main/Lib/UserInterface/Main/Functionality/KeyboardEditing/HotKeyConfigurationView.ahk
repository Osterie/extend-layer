#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationView{

    mainGui := ""

    manuallyCreatHotkeyElement := ""
    addWinKeyAsModifierElement := ""
    currentHotkeyTextControl := ""

    hotkeyElement := ""
    originalHotkey := ""

    originalHotkeyAction := ""
    currentHotkeyAction := ""
    currentHotkeyActionFormatted := ""

    saveButton := ""

    currentActionTextControl := ""

    activeObjectsRegistry := ""

    arrayOfKeyNames := Array()

    controller := ""

    __New(activeObjectsRegistry, arrayOfKeyNames){
        this.activeObjectsRegistry := activeObjectsRegistry
        this.arrayOfKeyNames := arrayOfKeyNames
    }

    CreateMain(controller){
        this.controller := controller

        this.originalHotkey := this.controller.GetHotkeyFriendly()

        this.originalHotkeyAction := this.controller.GetActionFriendly()
        this.currentHotkeyActionFormatted := this.controller.GetActionFriendly()

        this.mainGui := Gui()
        this.mainGui.opt("+Resize +MinSize600x560")
        this.createCurrentHotkeyControl()
        this.createCurrentActionControl()
        this.createButtons()
        this.mainGui.Show()
    }

    createCurrentHotkeyControl(){
        this.currentHotkeyTextControl := this.mainGui.AddText("r4", "Hotkey: `n")
        this.updateHotkeyText()
    }

    createCurrentActionControl(){
        this.currentActionTextControl := this.mainGui.AddText(" ", "Action: `n")
        this.updateActionText()
    }

    createButtons(){
        this.createChangeButtons()
        this.createFinalizationButtons()
    }

    createChangeButtons(){
        buttonToChangeOriginalHotkey := this.mainGui.AddButton("Default w80 xm", "Change Hotkey")
        buttonToChangeOriginalHotkey.onEvent("Click", (*) => this.controller.changeOriginalHotkey())
        
        buttonToChangeOriginalAction := this.mainGui.AddButton("Default w80", "Change Action")
        buttonToChangeOriginalAction.onEvent("Click", (*) => this.controller.changeOriginalAction())
    }

    createFinalizationButtons(){
        this.saveButton := this.mainGui.AddButton("Default w80", "Save+Done")
        this.saveButton.onEvent("Click", (*) => this.controller.NotifyListenersSave())
        this.cancelButton := this.mainGui.AddButton("Default w80", "Cancel+Done")
        this.cancelButton.onEvent("Click", (*) => this.mainGui.Destroy())
        this.deleteButton := this.mainGui.AddButton("Default w80", "Delete+Done")
    }
    
    updateHotkeyText(){
        newHotkey := this.controller.GetHotkeyFriendly()
        this.currentHotkeyTextControl.Value := ("Hotkey: `n" . newHotkey)

        if (this.controller.getOriginalHotkeyFriendly() != this.controller.GetHotkeyFriendly()){
            this.currentHotkeyTextControl.SetFont("s10 cBlue")
        }
        else{
            this.currentHotkeyTextControl.SetFont("s10 cBlack")
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
            this.currentActionTextControl.SetFont("s10 cBlack")
        }

        GuiSizeChanger.SetTextAndResize(this.currentActionTextControl, this.currentActionTextControl.Value )
    }

    Show(){
        this.mainGui.Show()
    }

    hide(){
        this.mainGui.Hide()
    }

    destroy(){
        this.mainGui.Destroy()
    }
}
