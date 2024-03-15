#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
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
        whatToChange := StrLower(whatToChange)
        this.view.hide()

        arrayOfKeyNames := this.model.GetArrayOfKeyNames()
        hotkeyInfo := this.model.GetHotkeyInfo()
        if (hotkeyInfo != ""){
            originalHotkey := hotkeyInfo.getFriendlyHotkeyName()
            action := hotkeyInfo.toString()
        }
        else{
            originalHotkey := "NONE"
            action := "NONE"
        }

        if (whatToChange == "hotkey"){
            this.changeOriginalHotkey(arrayOfKeyNames, originalHotkey)
        }
        else if (whatToChange == "action"){
            activeObjectsRegistry := this.model.GetActiveObjectsRegistry()
            this.changeOriginalAction(activeObjectsRegistry, arrayOfKeyNames, action)
        }

        WinWait("HotkeyCrafterGui")
        WinWaitClose
        this.view.Show()

    }

    changeOriginalHotkey(arrayOfKeyNames, originalHotkey){
        hotkeyCrafter := HotkeyCrafterGui(originalHotkey, arrayOfKeyNames)
        hotkeyCrafter.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent", hotkeyCrafter))
        hotkeyCrafter.Show()
    }

    changeOriginalAction(activeObjectsRegistry, arrayOfKeyNames, action){
        actionCrafter := ActionCrafterGui(action, arrayOfKeyNames, activeObjectsRegistry)
        actionCrafter.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForActionChangeEvent"))
        actionCrafter.Show()
    }

    cancelButtonClickedForCrafterEvent(hotkeyCrafter, *){
        hotkeyCrafter.Destroy()
        this.view.Show()
    }

    subscribeToSaveEvent(event){
        this.saveEventSubscribers.Push(event)
    }

    NotifyListenersSave(){
        for index, event in this.saveEventSubscribers
        {
            event(this.getHotkeyInfo(), this.getOriginalHotkey())
        }
        this.view.destroy()
    }

    SubscribeToDeleteEvent(event){
        this.deleteEventSubscribers.Push(event)
    }

    NotifyListenersDelete(){
        for index, event in this.deleteEventSubscribers
        {
            event(this.getOriginalHotkey())
        }
        this.view.destroy()
    }

    saveButtonClickedForHotkeyChangeEvent(hotkeyCrafter, newHotkeyKey){

        this.SetHotkeyKey(newHotkeyKey)
        this.view.updateHotkeyText()
        hotkeyCrafter.Destroy()
        
        this.view.Show()

    }

    saveButtonClickedForActionChangeEvent(newAction){
        
        msgbox(newAction)
        if (newAction.getMethodName() != ""){
            this.model.SetHotkeyInfo(newAction)
            this.view.updateActionText()
        }
        
        this.view.Show()
    }

    SetHotkeyKey(newHotkeyKey){
        this.model.SetHotkeyKey(newHotkeyKey)
    }

    SetHotkeyAction(action){
        this.model.SetHotkeyAction(action)
    }

    GetHotkeyInfo(){
        return this.model.GetHotkeyInfo()
    }

    GetHotkeyFriendly(){
        return this.model.GetHotkeyFriendly()
    }

    GetActionFriendly(){
        return this.model.GetActionFriendly()
    }

    getOriginalHotkeyFriendly(){
        return this.model.GetOriginalHotkeyFriendly()
    }

    getOriginalHotkey(){
        return this.model.GetOriginalHotkey()
    }

    GetOriginalActionFriendly(){
        return this.model.GetOriginalActionFriendly()
    }
}


