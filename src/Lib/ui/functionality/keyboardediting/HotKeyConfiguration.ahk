#Requires AutoHotkey v2.0

#Include <ui\util\GuiSizeChanger>
#Include <ui\Util\DomainSpecificGui>

class HotKeyConfiguration extends DomainSpecificGui{


    currentHotkeyTextControl := ""
    currentActionTextControl := ""

    controller := ""
    model := ""

    __New(settings, ownerHwnd := ""){
        super.__New(settings, "Hotkey Configuration")
        this.setOwner(ownerHwnd)
    }

    createMain(controller){
        this.controller := controller
        this.model := controller.getModel()
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
        buttonToChangeOriginalHotkey := this.Add("Button", "w100 xm", "Set Hotkey")
        buttonToChangeOriginalHotkey.onEvent("Click", (*) => this.controller.changeHotkey("Hotkey"))
        
        buttonToChangeOriginalAction := this.Add("Button", "w100", "Set Action")
        buttonToChangeOriginalAction.onEvent("Click", (*) => this.controller.changeHotkey("Action"))
    }

    createFinalizationButtons(){
        saveButton := this.Add("Button", "Default w100", "Save+Done")
        saveButton.onEvent("Click", (*) => this.controller.NotifyListenersSave())
        
        cancelButton := this.Add("Button", "w100", "Cancel+Done")
        cancelButton.onEvent("Click", (*) => this.destroy())
        
        if (this.model.getOriginalHotkey() != ""){
            deleteButton := this.Add("Button", "w100", "Delete+Done")
            deleteButton.onEvent("Click", (*) => this.controller.NotifyListenersDelete())
        }
    }
    
    ; TODO updateHotkeyText and UpdateActionText are very similar, can be refactored
    updateHotkeyText(){
        this.currentHotkeyTextControl.Value := ("Hotkey: `n" . this.model.GetHotkeyFriendly())

        if (this.model.getOriginalHotkey() != this.model.GetHotkey()){
            this.currentHotkeyTextControl.SetFont("cGreen")
        }
        else{
            this.SetCurrentThemeFontColor()
        }

        GuiSizeChanger.SetTextAndResize(this.currentHotkeyTextControl, this.currentHotkeyTextControl.Value )
    }

    updateActionText(){
        this.currentActionTextControl.Value := ("Action: `n" . this.model.GetAction())

        if (this.model.getOriginalAction() != this.model.GetAction()){
            this.currentActionTextControl.SetFont("cGreen")
        }
        else{
            this.SetCurrentThemeFontColor()
        }

        GuiSizeChanger.SetTextAndResize(this.currentActionTextControl, this.currentActionTextControl.Value )
    }
}
