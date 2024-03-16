#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterView.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterView.ahk"
#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterModel.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterModel.ahk"
#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterController.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterController.ahk"
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

        whatToChange := StrLower(whatToChange)
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
        hotkeyCrafterController_ := HotkeyCrafterController()
        hotkeyCrafterModel_ := HotkeyCrafterModel(arrayOfKeyNames)
        hotkeyCrafterView_ := HotkeyCrafterView(hotkeyCrafterModel_)

        hotkeyCrafterView_.create(originalHotkey)
        ; hotkeyCrafter := HotkeyCrafterGui()
        ; hotkeyCrafter.Create(originalHotkey, arrayOfKeyNames)
        hotkeyCrafterView_.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent"))
        hotkeyCrafterView_.Show()
    }

    changeOriginalAction(activeObjectsRegistry, arrayOfKeyNames, action){
        actionCrafter := ActionCrafterGui(action, arrayOfKeyNames, activeObjectsRegistry)
        actionCrafter.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForActionChangeEvent"))
        actionCrafter.Show()
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
}


