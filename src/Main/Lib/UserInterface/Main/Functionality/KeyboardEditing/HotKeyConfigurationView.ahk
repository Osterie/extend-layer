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
    currentHotkeyFormatted := ""

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
        this.currentHotkeyFormatted := this.controller.GetHotkeyFriendly()

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
        this.currentHotkeyTextControl := this.mainGui.AddText("r4", "Hotkey: `n" . this.currentHotkeyFormatted)
        this.setCurrentHotkeyText(this.currentHotkeyFormatted)
    }

    createCurrentActionControl(){
        this.currentActionTextControl := this.mainGui.AddText(" ", "Action: `n" . this.currentHotkeyActionFormatted)
        this.setCurrentActionText(this.currentHotkeyActionFormatted)
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
        this.cancelButton := this.mainGui.AddButton("Default w80", "Cancel+Done")
        this.cancelButton.onEvent("Click", (*) => this.mainGui.Destroy())
        this.deleteButton := this.mainGui.AddButton("Default w80", "Delete+Done")
    }
    
    setCurrentHotkeyText(newHotkey){
        this.currentHotkeyFormatted := newHotkey
        this.currentHotkeyTextControl.Value := ("Hotkey: `n" . newHotkey)

        if (this.originalHotkey != newHotkey){
            this.currentHotkeyTextControl.SetFont("s10 cBlue")
        }
        else{
            this.currentHotkeyTextControl.SetFont("s10 cBlack")
        }

        GuiSizeChanger.SetTextAndResize(this.currentHotkeyTextControl, this.currentHotkeyTextControl.Value )
    }

    setCurrentActionText(newAction){
        this.currentActionTextControl.Value := ("Action: `n" . newAction)

        if (this.controller.getOriginalAction() != this.controller.GetActionFriendly()){
            this.currentActionTextControl.SetFont("s10 cBlue")
        }
        else{
            this.currentActionTextControl.SetFont("s10 cBlack")
        }

        GuiSizeChanger.SetTextAndResize(this.currentActionTextControl, this.currentActionTextControl.Value )
    }

    ; getOriginalHotkey(){
    ;     return HotkeyFormatConverter.convertFromFriendlyName(this.originalHotkey) 
    ; }

    ; getHotkey(){
    ;     hotkeyToReturn := ""
    ;     hotkeyToReturn := HotkeyFormatConverter.convertFromFriendlyName(this.currentHotkeyFormatted)
    ;     return hotkeyToReturn
    ; }

    ; getAction(){
    ;     actionToReturn := ""
    ;     actionToReturn := this.currentHotkeyAction

    ;     return actionToReturn
    ; }

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
