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

    changeOriginalHotkey(){
        this.view.hide()

        arrayOfKeyNames := this.model.GetArrayOfKeyNames()
        hotkeyInfo := this.model.GetHotkeyInfo()

        ; TODO, controller, view, model for HotkeyCrafterGui, talk to the controller and wait for either save, cancel or delete.
        ; Be notified by the controller when one of these actions occure and take appropriate action (here in this controller.)
        hotkeyCrafter := HotkeyCrafterGui(hotkeyInfo, arrayOfKeyNames)
        hotkeyCrafter.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent", hotkeyCrafter))

        hotkeyCrafterClosedEvent := ObjBindMethod(this, "cancelButtonClickedForCrafterEvent", hotkeyCrafter)
        hotkeyCrafter.addCloseEventAction(hotkeyCrafterClosedEvent)
        hotkeyCrafter.addCancelButtonClickEventAction(hotkeyCrafterClosedEvent)

        hotkeyCrafter.Show()

        WinWait("HotkeyCrafterGui")
        WinWaitClose
        
        
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


