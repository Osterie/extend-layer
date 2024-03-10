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

    currentActionTextControl := ""

    activeObjectsRegistry := ""

    arrayOfKeyNames := Array()

    model := ""
    view := ""

    __New(model, view){
        this.model := model
        this.view := view
    }

    changeOriginalHotkey(){
        this.view.hide()

        arrayOfKeyNames := this.model.GetArrayOfKeyNames()
        hotkeyInfo := this.model.GetHotkeyInfo()

        ; TODO, controller, view, model for HotkeyCrafterGui, talk to the controller and wait for either save, cancel or delete.
        ; Be notified by the controller when one of these actions occure and take appropriate action (here in this controller.)
        hotkeyCrafter := HotkeyCrafterGui(hotkeyInfo, arrayOfKeyNames)
        hotkeySavedEventAction := ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent", hotkeyCrafter)
        hotkeyCrafter.addSaveButtonClickEventAction(hotkeySavedEventAction)

        hotkeyCrafterClosedEvent := ObjBindMethod(this, "cancelButtonClickedForCrafterEvent", hotkeyCrafter)
        hotkeyCrafter.addCloseEventAction(hotkeyCrafterClosedEvent)
        hotkeyCrafter.addCancelButtonClickEventAction(hotkeyCrafterClosedEvent)

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

        actionCrafter.Show()
    }


    cancelButtonClickedForCrafterEvent(hotkeyCrafter, *){
        hotkeyCrafter.Destroy()
        this.view.Show()
    }

    saveButtonClickedForHotkeyChangeEvent(hotkeyCrafter, savedButton, idk){
        
        newHotkey := HotkeyFormatConverter.convertToFriendlyHotkeyName(hotkeyCrafter.getNewHotkey(), " + ")
        this.setCurrentHotkeyText(newHotkey)
        
        hotkeyCrafter.Destroy()
        this.mainGui.Show()

    }

    saveButtonClickedForActionChangeEvent(actionCrafter, savedButton, idk){
        
        newAction := actionCrafter.getNewAction()

        if (newAction.getMethodName() != ""){
            this.model.SetHotkeyInfo(newAction)
            this.view.setCurrentActionText(newAction.toString())
        }
        
        actionCrafter.Destroy()
        
        this.view.Show()
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


