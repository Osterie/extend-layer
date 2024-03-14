#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationController{


    model := ""
    view := ""

    saveEventSubscribers := Array()

    __New(model, view){
        this.model := model
        this.view := view
    }

    changeHotkey(whatToChange){
        whatToChange := StrLower(whatToChange)
        this.view.hide()

        arrayOfKeyNames := this.model.GetArrayOfKeyNames()
        hotkeyInfo := this.model.GetHotkeyInfo()

        if (whatToChange == "hotkey"){
            this.changeOriginalHotkey(arrayOfKeyNames, hotkeyInfo)
        }
        else if (whatToChange == "action"){
            activeObjectsRegistry := this.model.GetActiveObjectsRegistry()
            this.changeOriginalAction(activeObjectsRegistry, arrayOfKeyNames, hotkeyInfo)
        }

        WinWait("HotkeyCrafterGui")
        WinWaitClose
        this.view.Show()

    }

    changeOriginalHotkey(arrayOfKeyNames, hotkeyInfo){
        hotkeyCrafter := HotkeyCrafterGui(hotkeyInfo, arrayOfKeyNames)
        hotkeyCrafter.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent", hotkeyCrafter))
        hotkeyCrafter.Show()
    }

    changeOriginalAction(activeObjectsRegistry, arrayOfKeyNames, hotkeyInfo){
        actionCrafter := ActionCrafterGui(hotkeyInfo, arrayOfKeyNames, activeObjectsRegistry)
        actionCrafter.addSaveButtonClickEventAction(ObjBindMethod(this, "saveButtonClickedForActionChangeEvent", actionCrafter))
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

    saveButtonClickedForHotkeyChangeEvent(hotkeyCrafter, newHotkeyKey){

        this.SetHotkeyKey(newHotkeyKey)
        this.view.updateHotkeyText()
        hotkeyCrafter.Destroy()
        
        this.view.Show()

    }

    saveButtonClickedForActionChangeEvent(actionCrafter, savedButton, idk){
        
        newAction := actionCrafter.getNewAction()

        if (newAction.getMethodName() != ""){
            this.model.SetHotkeyInfo(newAction)
            this.view.updateActionText()
        }
        
        actionCrafter.Destroy()
        
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


