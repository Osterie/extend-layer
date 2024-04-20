#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafter.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafter.ahk"
#Include ".\KeyChanging\HotkeyCrafterController.ahk"
#Include <ui\Main\util\GuiSizeChanger>

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

        originalAction := ""
        originalHotkey := ""

        hotkeyInfo := this.model.GetHotkeyInfo()
        if (hotkeyInfo != ""){
            originalHotkey := hotkeyInfo.getFriendlyHotkeyName()
            originalAction := hotkeyInfo.toString()
        }

        whatToChange := StrLower(whatToChange)
        if (whatToChange == "hotkey"){
            this.changeOriginalHotkey(originalHotkey)
        }
        else if (whatToChange == "action"){
            this.changeOriginalAction(originalAction)
        }

        WinWait("HotkeyCrafterGui")
        WinWaitClose
        this.view.Show()

    }

    changeOriginalHotkey(originalHotkey := "NO HOTKEY"){
        if (originalHotkey = ""){
            originalHotkey := "NO HOTKEY"
        }

        hotkeyCrafterView_ := HotkeyCrafter(this.hotkeyCrafterController_)
        
        hotkeyCrafterView_.create(originalHotkey)
        hotkeyCrafterView_.CreateButtons()
        hotkeyCrafterView_.SetInformativeTopText("Original Hotkey: " . originalHotkey)

        hotkeyCrafterView_.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForHotkeyChangeEvent"))
        hotkeyCrafterView_.Show()
    }

    changeOriginalAction(originalAction := "NO ACTION"){
        if (originalAction = ""){
            originalAction := "NO ACTION"
        }
        ActionCrafter_ := ActionCrafter(this.hotkeyCrafterController_)
        this.hotkeyCrafterController_.AddActionCrafter(ActionCrafter_)

        ActionCrafter_.create()
        ActionCrafter_.CreateButtons()
        ActionCrafter_.SetInformativeTopText("Original Action: " . originalAction)

        ActionCrafter_.subscribeToSaveEvent(ObjBindMethod(this, "saveButtonClickedForActionChangeEvent"))
        ActionCrafter_.Show()
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


