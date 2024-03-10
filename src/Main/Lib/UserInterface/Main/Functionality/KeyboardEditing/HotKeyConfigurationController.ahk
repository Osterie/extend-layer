#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationController{

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
    deleteButton := ""

    undoDeletionButton := ""
    hotkeyDeleted := false
    actionDeleted := false

    currentActionTextControl := ""

    activeObjectsRegistry := ""

    arrayOfKeyNames := Array()

    model := ""
    view := ""

    __New(model, view){
        this.model := model
        this.view := view
    }

    CreatePopupForHotkeyRegistry(hotkeyCommand, hotkeyAction){

        this.originalHotkey := hotkeyCommand
        this.currentHotkeyFormatted := hotkeyCommand

        this.originalHotkeyAction := hotkeyAction
        this.currentHotkeyActionFormatted := hotkeyAction

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

    changeOriginalHotkey(){
        this.view.hide()


        ; TODO, controller, view, model for HotkeyCrafterGui, talk to the controller and wait for either save, cancel or delete.
        ; Be notified by the controller when one of these actions occure and take appropriate action (here in this controller.)
        hotkeyCrafter := HotkeyCrafterGui(this.currentHotkeyFormatted, this.arrayOfKeyNames)
        hotkeySavedEventAction := ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent", hotkeyCrafter)
        hotkeyCrafter.addSaveButtonClickEventAction(hotkeySavedEventAction)

        hotkeyCrafterClosedEvent := ObjBindMethod(this, "cancelButtonClickedForCrafterEvent", hotkeyCrafter)
        hotkeyCrafter.addCloseEventAction(hotkeyCrafterClosedEvent)
        hotkeyCrafter.addCancelButtonClickEventAction(hotkeyCrafterClosedEvent)

        ; hotkeyDeleteEventAction := ObjBindMethod(this, "deleteButtonClickedForHotkeyChangeEvent", hotkeyCrafter)
        ; hotkeyCrafter.addDeleteButtonClickEventAction(hotkeyDeleteEventAction)

        hotkeyCrafter.Show()
    }

    changeOriginalAction(){
        this.view.Hide()

        activeObjectsRegistry := this.model.GetActiveObjectsRegistry()
        arrayOfKeyNames := this.model.GetArrayOfKeyNames()
        hotkeyInfo := this.model.GetHotkeyInfo()


        actionCrafter := ActionCrafterGui(hotkeyInfo, arrayOfKeyNames, activeObjectsRegistry)
        actionSavedEventAction := ObjBindMethod(this, "saveButtonClickedForActionChangeEvent", actionCrafter)
        actionCrafter.addSaveButtonClickEventAction(actionSavedEventAction)

        actionCrafterClosedEvent := ObjBindMethod(this, "cancelButtonClickedForCrafterEvent", actionCrafter)
        actionCrafter.addCloseEventAction(actionCrafterClosedEvent)
        actionCrafter.addCancelButtonClickEventAction(actionCrafterClosedEvent)

        ; hotkeyDeleteEventAction := ObjBindMethod(this, "deleteButtonClickedForActionChangeEvent", actionCrafter)
        ; actionCrafter.addDeleteButtonClickEventAction(hotkeyDeleteEventAction)

        actionCrafter.Show()
    }

    addSaveButtonClickedEvent(event){
        this.saveButton.onEvent("Click", event)
    }


    undoDeletionButtonClickedEvent(){
        this.model.setHotkeyDeletedStatus(false)
        this.view.hideUndoDeletionButton() 
        this.view.setCurrentHotkeyText(this.GetHotkeyFriendly())
        this.view.setCurrentActionText(this.GetActionFriendly())
    }

    cancelButtonClickedForCrafterEvent(hotkeyCrafter, *){
        hotkeyCrafter.Destroy()
        this.view.Show()
    }

    saveButtonClickedForHotkeyChangeEvent(hotkeyCrafter, savedButton, idk){
        
        ; this.hotkeyDeleted := false
        this.view.hideUndoDeletionButton()
        msgbox(hotkeyCrafter.getNewHotkey())
        newHotkey := HotkeyFormatConverter.convertToFriendlyHotkeyName(hotkeyCrafter.getNewHotkey(), " + ")
        this.setCurrentHotkeyText(newHotkey)
        
        hotkeyCrafter.Destroy()
        this.mainGui.Show()

    }

    saveButtonClickedForActionChangeEvent(actionCrafter, savedButton, idk){
        
        this.model.setHotkeyDeletedStatus(false)
        this.view.hideUndoDeletionButton()

        newAction := actionCrafter.getNewAction()

        if (newAction.getMethodName() != ""){
            this.model.SetHotkeyInfo(newAction)
            this.view.setCurrentActionText(newAction.toString())
        }
        
        actionCrafter.Destroy()
        
        this.view.Show()
    }

    deleteButtonClickedForHotkeyChangeEvent(hotkeyCrafter, savedButton, idk){
        
        this.hotkeyDeleted := true
        this.undoDeletionButton.Opt("Hidden0")

        this.setCurrentHotkeyText(this.currentHotkeyFormatted)
        
        hotkeyCrafter.Destroy()
        this.mainGui.Show()
    }

    deleteButtonClickedForActionChangeEvent(actionCrafter, savedButton, idk){
        
        this.model.setHotkeyDeletedStatus(true)
        this.view.ShowUndoDeletionButton()

        actionCrafter.Destroy()
        this.view.Show()
    }

    CreateHotKeyMaker(){
        manuallyCreateHotkeyCheckbox := this.mainGui.Add("CheckBox", , "Manually create hotkey")
        manuallyCreateHotkeyCheckbox.onEvent("Click", (*) => this.manuallyCreateHotkeyCheckboxClickEvent(manuallyCreateHotkeyCheckbox))

        this.hotkeyElement := this.mainGui.Add("Hotkey", )
        this.manuallyCreatHotkeyElement := this.mainGui.Add("Edit", "xm w300 h20", this.currentHotkeyFormatted)
        this.manuallyCreatHotkeyElement.Opt("Hidden1")

        this.addWinKeyAsModifierElement := this.mainGui.Add("CheckBox",, "Add win key as modifier")

    }

    manuallyCreateHotkeyCheckboxClickEvent(checkbox){
        if (checkbox.Value == 1){
            ; on, manually create hotkey
            this.hotkeyElement.Opt("Hidden1")
            this.manuallyCreatHotkeyElement.Opt("Hidden0")
            if (this.addWinKeyAsModifierElement.Value == 1){
                this.manuallyCreatHotkeyElement.Value := "#"    
            }
            this.addWinKeyAsModifierElement.Opt("Hidden1")
            this.manuallyCreatHotkeyElement.Value .= this.hotkeyElement.Value


        }
        else{
            ; off create hotkey by pressing keys
            this.hotkeyElement.Opt("Hidden0")
            this.addWinKeyAsModifierElement.Opt("Hidden0")
            this.manuallyCreatHotkeyElement.Opt("Hidden1")

        }
    }

    setCurrentHotkeyText(newHotkey){
        this.currentHotkeyFormatted := newHotkey
        this.currentHotkeyTextControl.Value := ("Hotkey: `n" . newHotkey)

        if (this.hotkeyDeleted = true){
            this.currentHotkeyTextControl.SetFont("s10 cRed")
        }
        else if (this.originalHotkey != newHotkey){
            this.currentHotkeyTextControl.SetFont("s10 cBlue")
        }
        else{
            this.currentHotkeyTextControl.SetFont("s10 cBlack")
        }

        GuiSizeChanger.SetTextAndResize(this.currentHotkeyTextControl, this.currentHotkeyTextControl.Value )
    }

    setCurrentActionText(newAction){
        this.currentActionTextControl.Value := ("Action: `n" . newAction)

        if (this.actionDeleted = true){
            this.currentActionTextControl.SetFont("s10 cRed")
        }
        else if (this.originalHotkeyAction != newAction){
            this.currentActionTextControl.SetFont("s10 cBlue")
        }
        else{
            this.currentActionTextControl.SetFont("s10 cBlack")
        }

        GuiSizeChanger.SetTextAndResize(this.currentActionTextControl, this.currentActionTextControl.Value )
    }

    ; getHotkey(){
    ;     hotkeyToReturn := ""
    ;     if (this.hotkeyDeleted != true){
    ;         hotkeyToReturn := HotkeyFormatConverter.convertFromFriendlyName(this.currentHotkeyFormatted)
    ;     }
    ;     else{
    ;         hotkeyToReturn := ""
    ;     }
    ;     return hotkeyToReturn
    ; }

    ; getAction(){
    ;     actionToReturn := ""
    ;     if (this.actionDeleted != true){
    ;         actionToReturn := this.currentHotkeyAction
    ;     }

    ;     return actionToReturn
    ; }

    destroy(){
        this.mainGui.Destroy()
    }


    SetAction(action){
        this.model.SetHotkeyInfo(action)
    }

    GetHotkeyFriendly(){
        return this.model.GetHotkeyFriendly()
    }

    GetActionFriendly(){
        return this.model.GetActionFriendly()
    }

    GetOriginalHotkey(){
        return this.model.GetOriginalHotkey()
    }

    GetOriginalAction(){
        return this.model.GetOriginalAction()
    }
}


