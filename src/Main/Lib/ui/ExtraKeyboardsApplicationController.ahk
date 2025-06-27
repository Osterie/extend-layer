#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>
#Include "Main\Functionality\ActionSettings\SettingsEditorDialog.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfiguration.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationController.ahk"
#Include "Main\Functionality\KeyboardEditing\HotkeyConfigurator.ahk"
#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotKeyInfo>

#Include <ui\ExtraKeyboards>

#Include <Updater\UpdateDialog>

Class ExtraKeyboardsApplicationController{

    view := ""
    ExtraKeyboards := ExtraKeyboards()

    ExitAppOnGuiClose := false
    MainScript := ""

    __New(view, MainScript){
        this.view := view
        this.ExitAppOnGuiClose := FilePaths.GetCloseScriptOnGuiClose()
        this.MainScript := MainScript
    }

    HandleProfileChangedEvent(newProfileName){
        ; TODO this should probably be changed? it is sort of heavy to basically restart the entire program when changing profiles.
        FilePaths.SetCurrentProfile(newProfileName)
        ; this.mainScript.start()
        ; TODO is there a better solution?
        Run(A_ScriptDir "\Main.ahk")
        this.view.destroy()
    }

    HandleupdateAvailableClicked(){
        UpdateDialog_ := UpdateDialog()
        UpdateDialog_.show()
    }

    DoLayerSelected(currentLayer){
        this.ShowHotkeysForLayer(currentLayer)
        this.View.UpdateConfigurationButtons()
    }

    ShowHotkeysForLayer(currentLayer){
        
        this.ExtraKeyboards.SetCurrentLayer(currentLayer)
        this.view.UpdateHotkeys()
    }

    ; TODO make sure user cant create multiple popups?
    ; TODO change name for this...
    DoAddOrEditHotkey(hotkeyBuild := ""){

        layerInformation := this.GetCurrentLayerInfo()

        if (Type(layerInformation) == "HotkeyLayer"){
            hotkeyInformation := HotKeyInfo()
    
            ; TODO find a better way than this...
            if (hotkeyBuild = "KeyCombo" || hotkeyBuild = ""){

            }
            else{
                hotkeyInformation := this.ExtraKeyboards.GetHotkeyInfoForCurrentLayer(hotkeyBuild)
            }
            this.CreatePopupForHotkeys(hotkeyInformation)
        }
        else if (Type(layerInformation) == "KeyboardOverlayLayer"){
            ; TODO implement
            ; popupForConfiguringHotkey.CreatePopupForKeyboardOverlayInfo()
        }

        WinWaitClose("Hotkey Configuration" , , 1000)
        ; else if (WinWaitActive("Keyboard Overlay Configuration" , , 1000)){
        ;     WinWaitClose()
        ; }
        try{
            this.view.UpdateHotkeys()
        }
        catch Error as e{
            ; The main gui was probably closed
        }

    }

    ; TODO move to view?
    CreatePopupForHotkeys(hotkeyInformation){
        popupForConfiguringHotkeyModel := HotkeyConfigurator(hotkeyInformation)
        popupForConfiguringHotkey := HotKeyConfiguration("+Resize +MinSize300x280", this.GetHwnd())
        popupForConfiguringHotkeyController := HotKeyConfigurationController(popupForConfiguringHotkeyModel, popupForConfiguringHotkey)
        popupForConfiguringHotkey.createMain(popupForConfiguringHotkeyController)

        popupForConfiguringHotkey.getHwnd()
        
        
        popupForConfiguringHotkeyController.subscribeToSaveEvent(ObjBindMethod(this, "AddOrChangeHotkey"))
        popupForConfiguringHotkeyController.subscribeToDeleteEvent(ObjBindMethod(this, "deleteHotkey"))
    }

    ShowSettingsForAction(functionName){
        this.ExtraKeyboards.SetCurrentFunction(functionName)
        this.view.UpdateSettingsForActions()
    }

    HandleFunctionSettingClicked(settingName){
        if (settingName != ""){
            currentFunctionSettings := this.ExtraKeyboards.GetCurrentFunction()
            selectedSetting := this.ExtraKeyboards.getActionSettingsForCurrentAction().getActionSetting(settingName)
    
            editorForActionSettings := SettingsEditorDialog(this.getHwnd())
            editorForActionSettings.CreateControls(selectedSetting)
            editorForActionSettings.DisableSettingNameEdit()
            editorForActionSettings.SubscribeToSaveEvent(ObjBindMethod(this, "SettingsEditorDialogSaveButtonEvent", currentFunctionSettings))
    
            editorForActionSettings.show()

            WinWaitClose("Settings Editor Dialog" , , 1000)
    
            this.MainScript.runLogicalStartup()

            try{
                this.view.UpdateSettingsForActions()
            }
            catch Error as e{
                ; The main gui was probably closed
            }
        }
    }

    SettingsEditorDialogSaveButtonEvent(actionName, ActionSetting){
        this.ExtraKeyboards.ChangeFunctionSetting(actionName, ActionSetting)
    }

    AddOrChangeHotkey(hotkeyInformation, originalHotkeyKey){
        newHotkeyKey := hotkeyInformation.getHotkeyName()

        ; If it does not exist, add it
        ; TODO this is bad, how the heck does EKAPGC know the default values is NONE?
        ; Add
        if (originalHotkeyKey = ""){
            if (hotkeyInformation.actionIsSet() AND hotkeyInformation.getHotkeyName() != ""){
                try{
                    this.MainScript.setHotkeysForAllLayers(false) ;TODO can this be moved to a better location?
                    this.ExtraKeyboards.addHotkey(hotkeyInformation)
                }
                catch Error as e{
                    msgbox("Could not add hotkey. " . e.Message)
                }
            }
            else {
                msgbox("Please select a hotkey and an action")
            }
        } ; Change
        else{
            try{
                this.MainScript.setHotkeysForAllLayers(false) ;TODO can this be moved to a better location?
                this.ExtraKeyboards.changeHotkey(originalHotkeyKey, newHotkeyKey, hotkeyInformation)
            }
            catch Error as e{
                msgbox("Could not modify hotkey. " . e.Message)
            }
        }
        this.MainScript.runLogicalStartup()
    }

    UpdateGuiSettings(){
        this.ExitAppOnGuiClose := FilePaths.GetCloseScriptOnGuiClose()
    }

    DoDestroy(){
        if (this.ExitAppOnGuiClose){
            ExitApp
        }
    }

    deleteHotkey(hotkeyKey){
        try{
            this.MainScript.setHotkeysForAllLayers(false)
            this.ExtraKeyboards.deleteHotkey(hotkeyKey)
            msgbox("Deleted hotkey")
        }
        catch Error as e{
            this.MainScript.setHotkeysForAllLayers(false)
            msgbox("Could not delete hotkey. " . e.Message)
        }
        this.view.UpdateHotkeys()
        this.view.ChangeConfigurationButtonsStatus(1)
        this.MainScript.runLogicalStartup()
    }

    getActionSettings(){
        return this.ExtraKeyboards.getActionSettingsForCurrentActionAsArray()
    }

    GetHotkeys(){
        return this.ExtraKeyboards.GetFriendlyHotkeysForCurrentLayer()
    }

    GetCurrentLayer(){
        return this.ExtraKeyboards.GetCurrentLayer()
    }

    GetKeyboardLayerIdentifiers(){
        return this.ExtraKeyboards.GetKeyboardLayerIdentifiers()
    }
    
    GetCurrentLayerInfo(){
        return this.ExtraKeyboards.GetCurrentLayerInfo()
    }

    getActionGroupNames(){
        return this.ExtraKeyboards.getActionGroupNames()
    }

    GetHwnd(){
        return this.view.GetHwnd()
    }
}
