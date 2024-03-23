#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiSizeChanger>
#Include <UserInterface\Main\Util\DomainSpecificGui>

class HotKeyConfigurationView extends DomainSpecificGui{


    currentHotkeyTextControl := ""
    currentActionTextControl := ""

    controller := ""
    model := ""

    __New(ownerHwnd := ""){
        super.__New("+Resize +MinSize300x280 " . "+Owner" ownerHwnd, "Hotkey Configuration")
    }

    CreateMain(controller){
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
    
    ; TODO updateHotkeyText and UpdateActionText are very similar, can be refactored
    updateHotkeyText(){
        this.currentHotkeyTextControl.Value := ("Hotkey: `n" . this.model.GetHotkeyFriendly())

        if (this.model.getOriginalHotkey() != this.model.GetHotkey()){
            this.currentHotkeyTextControl.SetFont("s10 cGreen")
        }
        else{
            this.SetColors()
        }

        GuiSizeChanger.SetTextAndResize(this.currentHotkeyTextControl, this.currentHotkeyTextControl.Value )
    }

    updateActionText(){
        this.currentActionTextControl.Value := ("Action: `n" . this.model.GetActionFriendly())

        if (this.model.getOriginalActionFriendly() != this.model.GetActionFriendly()){
            this.currentActionTextControl.SetFont("s10 cGreen")
        }
        else{
            this.SetColors()
        }

        GuiSizeChanger.SetTextAndResize(this.currentActionTextControl, this.currentActionTextControl.Value )
    }
}
