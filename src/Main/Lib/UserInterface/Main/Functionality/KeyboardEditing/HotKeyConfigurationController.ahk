#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterView.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterView.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationController{

    model := ""
    view := ""

    saveEventSubscribers := Array()
    deleteEventSubscribers := Array()

    __New(model, view){
        this.model := model
        this.view := view
    }

    changeHotkey(whatToChange){
        this.view.hide()

        availableKeyNames := this.model.GetAvailableKeyNames()
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
            this.changeOriginalHotkey(availableKeyNames, originalHotkey)
        }
        else if (whatToChange == "action"){
            activeObjectsRegistry := this.model.GetActiveObjectsRegistry()
            this.changeOriginalAction(activeObjectsRegistry, availableKeyNames, action)
        }

        WinWait("HotkeyCrafterGui")
        WinWaitClose
        this.view.Show()

    }

    changeOriginalHotkey(availableKeyNames, originalHotkey){
        hotkeyCrafterView_ := HotkeyCrafterView(this)
        hotkeyCrafterView_.create(originalHotkey)
        hotkeyCrafterView_.CreateButtons()
        hotkeyCrafterView_.SetInformativeTopText("Original Hotkey: " . originalHotkey)

        hotkeyCrafterView_.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent"))
        hotkeyCrafterView_.Show()
    }

    changeOriginalAction(activeObjectsRegistry, availableKeyNames, action){
        ActionCrafterView_ := ActionCrafterView(this)
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
        this.model.SetHotkeyKey(newHotkeyKey)
        this.view.updateHotkeyText()
        this.view.Show()

    }

    saveButtonClickedForActionChangeEvent(newAction){
        
        if (newAction.getMethodName() != ""){
            this.model.SetHotkeyAction(newAction)
            this.view.updateActionText()
        }
        else{
            this.model.SetHotkeyAction(newAction)
            this.view.updateActionText()
        }
        
        this.view.Show()
    }

    GetModel(){
        return this.model
    }

    GetAvailableKeyNames(){
        return this.model.GetAvailableKeyNames()
    }

    GetActiveObjectsRegistry(){
        return this.model.GetActiveObjectsRegistry()
    }

}


