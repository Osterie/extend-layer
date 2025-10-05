#Requires AutoHotkey v2.0

#Include <ui\functionality\ActionSettingsDialog>
#Include <ui\functionality\KeyboardEditing\HotKeyConfiguration>
#Include <ui\functionality\KeyboardEditing\HotKeyConfigurationController>
#Include <ui\functionality\KeyboardEditing\HotkeyConfigurator>
#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotKeyInfo>

#Include <ui\ExtraKeyboards>

#Include <Shared\FilePaths>
#Include <Shared\Logger>
#Include <Shared\MetaInfo>

#Include <Updater\UpdateDialog>

Class ExtraKeyboardsApplicationController{

    Logger := Logger.getInstance()

    view := ""
    ExtraKeyboards := ""

    ExitAppOnGuiClose := false
    MainScript := ""

    __New(view, MainScript){
        this.view := view
        this.ExtraKeyboards := ExtraKeyboards(MainScript)
        this.ExitAppOnGuiClose := MetaInfo.getCloseScriptOnGuiClose()
        this.MainScript := MainScript
    }

    HandleProfileChangedEvent(newProfileName){
        ; TODO this should probably be changed? it is sort of heavy to basically restart the entire program when changing profiles.
        MetaInfo.setCurrentProfile(newProfileName)
        ; this.mainScript.start()
        ; TODO is there a better solution?
        Run(A_ScriptDir "\Main.ahk")
        ; this.view.destroy()
        ExitApp
    }

    ; TODO rename.
    HandleupdateAvailableClicked(){
        try{
            UpdateDialog_ := UpdateDialog()
            UpdateDialog_.show()
        }
        catch NetworkError as e{
            this.Logger.logError("Network error occurred while checking for updates: " e.message, e.file, e.line)
            MsgBox("Network error occurred while checking for updates: " e.message)
        }
        catch Error as e{
            this.Logger.logError("An error occurred while checking for updates: " e.message, e.file, e.line)
            MsgBox("An error occurred while checking for updates: " e.message)
        }
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
    
            editorForActionSettings := ActionSettingsDialog(this.getHwnd())
            editorForActionSettings.CreateControls(selectedSetting)
            editorForActionSettings.DisableSettingNameEdit()
            editorForActionSettings.SubscribeToSaveEvent(ObjBindMethod(this, "ActionSettingsDialogSaveButtonEvent", currentFunctionSettings))
    
            editorForActionSettings.show()
        }
    }

    ActionSettingsDialogSaveButtonEvent(actionName, ActionSetting){
        this.ExtraKeyboards.changeActionSetting(actionName, ActionSetting)
        try{
            this.view.UpdateSettingsForActions()
            }
        catch Error as e{
            ; TODO log error?
            ; The main gui was probably closed
        }
    }

    ; TODO change! seperate methods.
    AddOrChangeHotkey(hotkeyInformation, originalHotkeyKey){
        newHotkeyKey := hotkeyInformation.getHotkeyName()

        ; If it does not exist, add it
        ; TODO this is bad.
        ; Add
        if (originalHotkeyKey = ""){
            if (hotkeyInformation.actionIsSet() AND hotkeyInformation.getHotkeyName() != ""){
                try{
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
                this.ExtraKeyboards.changeHotkey(originalHotkeyKey, newHotkeyKey, hotkeyInformation)
            }
            catch Error as e{
                msgbox("Could not modify hotkey. " . e.Message)
            }
        }
        this.view.UpdateHotkeys()
    }

    deleteHotkey(hotkeyKey){
        try{
            this.ExtraKeyboards.deleteHotkey(hotkeyKey)
        }
        catch Error as e{
            msgbox("Could not delete hotkey. " . e.Message)
        }
        this.view.UpdateHotkeys()
        this.view.ChangeConfigurationButtonsStatus(1)
        ; this.MainScript.restartProfile()
    }

    UpdateGuiSettings(){
        this.ExitAppOnGuiClose := MetaInfo.getCloseScriptOnGuiClose()
    }

    DoDestroy(){
        if (this.ExitAppOnGuiClose){
            ExitApp
        }
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
