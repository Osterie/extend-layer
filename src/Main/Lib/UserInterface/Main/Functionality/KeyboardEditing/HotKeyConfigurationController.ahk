#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterView.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterView.ahk"
#Include ".\KeyChanging\HotkeyCrafterController.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationController{

    model := ""
    view := ""


    

    saveEventSubscribers := Array()
    deleteEventSubscribers := Array()

    hotkeyCrafterController_ := ""

    __New(model, view){
        this.model := model
        this.view := view
        this.hotkeyCrafterController_ := HotkeyCrafterController(this.GetActiveObjectsRegistry())
    }

    changeHotkey(whatToChange){
        this.view.hide()

        hotkeyInfo := this.model.GetHotkeyInfo()
        if (hotkeyInfo != ""){
            originalHotkey := hotkeyInfo.getFriendlyHotkeyName()
            action := hotkeyInfo.toString()
        }
        else{
            originalHotkey := "NONE"
            action := "NONE"
        }

        whatToChange := StrLower(whatToChange)
        if (whatToChange == "hotkey"){
            this.changeOriginalHotkey(originalHotkey)
        }
        else if (whatToChange == "action"){
            this.changeOriginalAction(action)
        }

        WinWait("HotkeyCrafterGui")
        WinWaitClose
        this.view.Show()

    }

    changeOriginalHotkey(originalHotkey){
        
        hotkeyCrafterView_ := HotkeyCrafterView(this.hotkeyCrafterController_)
        
        hotkeyCrafterView_.create(originalHotkey)
        hotkeyCrafterView_.CreateButtons()
        hotkeyCrafterView_.SetInformativeTopText("Original Hotkey: " . originalHotkey)

        hotkeyCrafterView_.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent"))
        hotkeyCrafterView_.Show()
    }

    ; TODO remove first parameter
    changeOriginalAction(action){
        ActionCrafterView_ := ActionCrafterView(this.hotkeyCrafterController_)
        this.hotkeyCrafterController_.AddActionCrafterView(ActionCrafterView_)

        ActionCrafterView_.create(action)
        ActionCrafterView_.CreateButtons()
        ActionCrafterView_.SetInformativeTopText("Original Action: " . action)

        ActionCrafterView_.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForActionChangeEvent"))
        ActionCrafterView_.Show()
    }

    subscribeToSaveEvent(event){
        this.saveEventSubscribers.Push(event)
    }

    NotifyListenersSave(){
        for index, event in this.saveEventSubscribers
        {
            event(this.model.getHotkeyInfo(), this.model.getOriginalHotkey())
        }
        this.view.destroy()
    }

    SubscribeToDeleteEvent(event){
        this.deleteEventSubscribers.Push(event)
    }

    NotifyListenersDelete(){
        for index, event in this.deleteEventSubscribers
        {
            event(this.model.getOriginalHotkey())
        }
        this.view.destroy()
    }

    saveButtonClickedForHotkeyChangeEvent(newHotkey){
        newHotkeyKey := newHotkey.getNewHotkeyModifiers()
        newHotkeyKey .= newHotkey.getNewHotkeyName()

        ; this.hotkeyCrafterController_.ChangeHotkey(this.model.GetHotkeyInfo(), newHotkey)
        this.model.SetHotkeyKey(newHotkeyKey)
        this.view.updateHotkeyText()
        this.view.Show()
    }

    saveButtonClickedForActionChangeEvent(newAction){
        
        this.model.SetHotkeyAction(newAction)
        this.view.updateActionText()
        ; if (newAction.getMethodName() != ""){
        ; }
        ; else{
        ;     this.model.SetHotkeyAction(newAction)
        ;     this.view.updateActionText()
        ; }
        
        this.view.Show()
    }

    GetModel(){
        return this.model
    }

    GetActiveObjectsRegistry(){
        return this.model.GetActiveObjectsRegistry()
    }

}


