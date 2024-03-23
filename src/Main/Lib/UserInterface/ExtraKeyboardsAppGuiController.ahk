#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JsonFormatter\JsonFormatter>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include "Main\Functionality\ActionSettings\SettingsEditorDialog.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationView.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationController.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationModel.ahk"

; #Include <Util\MetaInfo\MetaInfoStorage\Settings\Setting>

Class ExtraKeyboardsAppGuiController{

    MainScript := ""

    __New(model, view, MainScript){
        this.view := view
        this.model := model
        
        this.MainScript := MainScript
    }

    HandleProfileChangedEvent(){
        ; TODO this should probably be changed? it is sort of heavy to basically restart the entire program when changing profiles.
        this.mainScript.Start()
        this.view.Destroy()
    }

    ShowHotkeysForLayer(currentLayer){
        
        this.model.SetCurrentLayer(currentLayer)
        this.view.UpdateHotkeys()
    }

    ; TODO make sure user cant create multiple popups?
    EditHotkey(listView, indexOfKeyToEdit){

        hotkeyInformation := HotkeyInfo()

        ; hotkeyInformation
        if (indexOfKeyToEdit = 0){
            ; this.CreatePopupForHotkeys(hotkeyInformation)
        }
        else{
            hotkeyBuild := listView.GetText(indexOfKeyToEdit, 1)
            hotkeyInformation := this.model.GetHotkeyInfoForCurrentLayer(hotkeyBuild)
        }

        layerInformation := this.GetCurrentLayerInfo()

        if (Type(layerInformation) == "HotkeysRegistry"){
            this.CreatePopupForHotkeys(hotkeyInformation)
        }
        else if (Type(layerInformation) == "KeyboardOverlayInfo"){
            ; TODO implement
            ; popupForConfiguringHotkey.CreatePopupForKeyboardOverlayInfo()
        }

        WinWaitClose("Hotkey Configuration" , , 1000)
        ; else if (WinWaitActive("Keyboard Overlay Configuration" , , 1000)){
        ;     WinWaitClose()
        ; }
        this.view.UpdateHotkeys()

    }

    ; TODO move to view?
    CreatePopupForHotkeys(hotkeyInformation){
        popupForConfiguringHotkeyModel := HotKeyConfigurationModel(this.GetActiveObjectsRegistry(), this.GetKeyNames(), hotkeyInformation)
        popupForConfiguringHotkey := HotKeyConfigurationView(this.GetHwnd())
        popupForConfiguringHotkeyController := HotKeyConfigurationController(popupForConfiguringHotkeyModel, popupForConfiguringHotkey)
        popupForConfiguringHotkey.CreateMain(popupForConfiguringHotkeyController)

        popupForConfiguringHotkey.getHwnd()
        
        
        popupForConfiguringHotkeyController.subscribeToSaveEvent(ObjBindMethod(this, "changeHotkeys"))
        popupForConfiguringHotkeyController.subscribeToDeleteEvent(ObjBindMethod(this, "deleteHotkey"))
    }

    ShowSettingsForAction(functionName){
        this.model.SetCurrentFunction(functionName)
        this.view.UpdateSettingsForActions()
    }

    HandleSettingClicked(settingName){
        if (settingName != ""){
            currentFunctionSettings := this.model.GetCurrentFunction()
            selectedSetting := this.model.GetSettingsForCurrentAction().GetSetting(settingName)
    
            editorForActionSettings := SettingsEditorDialog()
            editorForActionSettings.CreateControls(selectedSetting)
            editorForActionSettings.DisableSettingNameEdit()
            editorForActionSettings.SubscribeToSaveEvent(ObjBindMethod(this, "SettingsEditorDialogSaveButtonEvent", currentFunctionSettings))
    
            WinWaitClose("Settings Editor Dialog" , , 1000)
    
            this.view.UpdateSettingsForActions()
        }
    }

    SettingsEditorDialogSaveButtonEvent(currentFunctionSettings, setting){
        this.model.ChangeFunctionSetting(setting, currentFunctionSettings)
    }

    ChangeHotkeys(hotkeyInformation, originalHotkeyKey){
        newHotkeyKey := hotkeyInformation.getHotkeyName()


        ; If it does not exist, add it
        ; TODO this is bad, how the heck does EKAPGC know the default values is NONE?
        if (originalHotkeyKey = ""){
            try{
                hotkeyInformation.changeHotkey(newHotkeyKey)
                this.model.AddHotkey(hotkeyInformation)
            }
            catch Error as e{
                msgbox("Could not add hotkey. " . e.Message)
            }
        }
        else{
            try{
                this.model.ChangeHotkey(originalHotkeyKey, newHotkeyKey, hotkeyInformation)
                msgbox("Changed hotkey")
            }
            catch Error as e{
                msgbox("Could not modify hotkey. " . e.Message)
            }
        }

        this.MainScript.RunLogicalStartup()
    }

    DeleteHotkey(hotkeyKey){
        try{
            this.model.DeleteHotkey(hotkeyKey)
            msgbox("Deleted hotkey")
        }
        catch Error as e{
            msgbox("Could not delete hotkey. " . e.Message)
        }
        this.MainScript.RunLogicalStartup()
    }

    GetSettings(){
        return this.model.GetSettingsForCurrentActionAsArray()
    }

    GetHotkeys(){
        return this.model.GetFriendlyHotkeysForCurrentLayer()
    }

    GetPathToCurrentSettings(){
        return this.model.GetPathToCurrentSettings()
    }

    GetCurrentLayer(){
        return this.model.GetCurrentLayer()
    }

    GetKeyboardLayerIdentifiers(){
        return this.model.GetKeyboardLayerIdentifiers()
    }
    
    GetCurrentLayerInfo(){
        return this.model.GetCurrentLayerInfo()
    }

    GetActiveObjectsRegistry(){
        return this.model.GetActiveObjectsRegistry()
    }

    GetKeyNames(){
        return this.model.GetKeyNames()
    }

    GetActionNames(){
        return this.model.GetActionNames()
    }

    GetHwnd(){
        return this.view.GetHwnd()
    }
}
