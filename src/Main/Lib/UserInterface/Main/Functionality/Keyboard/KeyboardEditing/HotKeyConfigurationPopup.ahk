#Requires AutoHotkey v2.0


#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Util\HotkeyFormatConverter>


class HotKeyConfigurationPopup{

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

    __New(activeObjectsRegistry, arrayOfKeyNames){
        this.activeObjectsRegistry := activeObjectsRegistry
        this.arrayOfKeyNames := arrayOfKeyNames
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

    createButtons(){
        this.undoDeletionButton := this.mainGui.AddButton("Default w80 ym", "Undo deletion")
        this.undoDeletionButton.onEvent("Click", (*) => this.undoDeletionButtonClickedEvent())
        this.undoDeletionButton.Opt("Hidden1")

        this.createChangeButtons()
        this.createFinalizationButtons()
    }

    createChangeButtons(){
        buttonToChangeOriginalHotkey := this.mainGui.AddButton("Default w80 xm", "Change Hotkey")
        buttonToChangeOriginalHotkey.onEvent("Click", (*) => this.buttonToChangeOriginalHotkeyClickedEvent())
        
        buttonToChangeOriginalAction := this.mainGui.AddButton("Default w80", "Change Action")
        buttonToChangeOriginalAction.onEvent("Click", (*) => this.buttonToChangeOriginalActionClickedEvent())
    }

    createFinalizationButtons(){
        this.saveButton := this.mainGui.AddButton("Default w80", "Save+Done")
        this.cancelButton := this.mainGui.AddButton("Default w80", "Cancel+Done")
        this.cancelButton.onEvent("Click", (*) => this.mainGui.Destroy())
        this.deleteButton := this.mainGui.AddButton("Default w80", "Delete+Done")
    }

    buttonToChangeOriginalHotkeyClickedEvent(){
        this.mainGui.Hide()

        hotkeyCrafter := HotkeyCrafterGui(this.currentHotkeyFormatted, this.arrayOfKeyNames)
        hotkeySavedEventAction := ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent", hotkeyCrafter)
        hotkeyCrafter.addSaveButtonClickEventAction(hotkeySavedEventAction)

        hotkeyCrafterClosedEvent := ObjBindMethod(this, "cancelButtonClickedForCrafterEvent", hotkeyCrafter)
        hotkeyCrafter.addCloseEventAction(hotkeyCrafterClosedEvent)
        hotkeyCrafter.addCancelButtonClickEventAction(hotkeyCrafterClosedEvent)

        hotkeyDeleteEventAction := ObjBindMethod(this, "deleteButtonClickedForHotkeyChangeEvent", hotkeyCrafter)
        hotkeyCrafter.addDeleteButtonClickEventAction(hotkeyDeleteEventAction)

        hotkeyCrafter.Show()
    }

    buttonToChangeOriginalActionClickedEvent(){
        this.mainGui.Hide()

        actionCrafter := ActionCrafterGui(this.currentHotkeyActionFormatted, this.arrayOfKeyNames, this.activeObjectsRegistry, this.currentHotkeyFormatted)
        actionSavedEventAction := ObjBindMethod(this, "saveButtonClickedForActionChangeEvent", actionCrafter)
        actionCrafter.addSaveButtonClickEventAction(actionSavedEventAction)

        actionCrafterClosedEvent := ObjBindMethod(this, "cancelButtonClickedForCrafterEvent", actionCrafter)
        actionCrafter.addCloseEventAction(actionCrafterClosedEvent)
        actionCrafter.addCancelButtonClickEventAction(actionCrafterClosedEvent)

        hotkeyDeleteEventAction := ObjBindMethod(this, "deleteButtonClickedForActionChangeEvent", actionCrafter)
        actionCrafter.addDeleteButtonClickEventAction(hotkeyDeleteEventAction)

        actionCrafter.Show()
    }

    addSaveButtonClickedEvent(event){
        this.saveButton.onEvent("Click", event)
    }


    undoDeletionButtonClickedEvent(){
        this.hotkeyDeleted := false
        this.undoDeletionButton.Opt("Hidden1")
        this.setCurrentHotkeyText(this.currentHotkeyFormatted)
    }

    cancelButtonClickedForCrafterEvent(hotkeyCrafter, *){
        hotkeyCrafter.Destroy()
        this.mainGui.Show()
    }

    saveButtonClickedForHotkeyChangeEvent(hotkeyCrafter, savedButton, idk){
        
        this.hotkeyDeleted := false
        this.undoDeletionButton.Opt("Hidden1")

        newHotkey := HotkeyFormatConverter.convertToFriendlyHotkeyName(hotkeyCrafter.getNewHotkey(), " + ")
        this.setCurrentHotkeyText(newHotkey)
        
        hotkeyCrafter.Destroy()
        this.mainGui.Show()

    }

    saveButtonClickedForActionChangeEvent(actionCrafter, savedButton, idk){
        
        this.actionDeleted := false
        this.undoDeletionButton.Opt("Hidden1")

        newAction := actionCrafter.getNewAction()
        this.setCurrentActionText(newAction.toString())

        ; TODO perhaps remove this line
        this.currentHotkeyAction := newAction

        
        actionCrafter.Destroy()
        this.mainGui.Show()
    }

    deleteButtonClickedForHotkeyChangeEvent(hotkeyCrafter, savedButton, idk){
        
        this.hotkeyDeleted := true
        this.undoDeletionButton.Opt("Hidden0")

        this.setCurrentHotkeyText(this.currentHotkeyFormatted)
        
        hotkeyCrafter.Destroy()
        this.mainGui.Show()
    }

    deleteButtonClickedForActionChangeEvent(actionCrafter, savedButton, idk){
        
        this.actionDeleted := true
        this.undoDeletionButton.Opt("Hidden0")

        actionCrafter.Destroy()
        this.mainGui.Show()
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

    getOriginalHotkey(){
        return HotkeyFormatConverter.convertFromFriendlyName(this.originalHotkey) 
    }

    getHotkey(){
        hotkeyToReturn := ""
        if (this.hotkeyDeleted != true){
            hotkeyToReturn := HotkeyFormatConverter.convertFromFriendlyName(this.currentHotkeyFormatted)
        }
        else{
            hotkeyToReturn := ""
        }
        return hotkeyToReturn
    }

    getAction(){
        actionToReturn := ""
        if (this.actionDeleted != true){
            actionToReturn := this.currentHotkeyAction
        }

        return actionToReturn
    }

    destroy(){
        this.mainGui.Destroy()
    }
}
