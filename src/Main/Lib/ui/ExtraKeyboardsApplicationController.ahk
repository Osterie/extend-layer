#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JsonFormatter\JsonFormatter>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include "Main\Functionality\ActionSettings\SettingsEditorDialog.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfiguration.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationController.ahk"
#Include "Main\Functionality\KeyboardEditing\HotkeyConfigurator.ahk"

#Include <Util\StartupConfiguration\HotkeyInitializer>

Class ExtraKeyboardsApplicationController{

    MainScript := ""

    __New(ExtraKeyboards, view, MainScript){
        this.view := view
        this.ExtraKeyboards := ExtraKeyboards
        
        this.MainScript := MainScript
    }

    HandleProfileChangedEvent(newProfileName){
        ; TODO this should probably be changed? it is sort of heavy to basically restart the entire program when changing profiles.
        FilePaths.SetCurrentProfile(newProfileName)
        this.mainScript.Start()
        this.view.Destroy()
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

        if (Type(layerInformation) == "HotkeysRegistry"){
            hotkeyInformation := HotkeyInfo()
    
            ; TODO find a better way than this...
            if (hotkeyBuild = "KeyCombo" || hotkeyBuild = ""){

            }
            else{
                hotkeyInformation := this.ExtraKeyboards.GetHotkeyInfoForCurrentLayer(hotkeyBuild)
            }
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
        try{
            this.view.UpdateHotkeys()
        }
        catch Error as e{
            ; The main gui was probably closed
        }

    }

    ; TODO move to view?
    CreatePopupForHotkeys(hotkeyInformation){
        popupForConfiguringHotkeyModel := HotkeyConfigurator(this.GetActiveObjectsRegistry(), hotkeyInformation)
        popupForConfiguringHotkey := HotKeyConfiguration("+Resize +MinSize300x280", this.GetHwnd())
        popupForConfiguringHotkeyController := HotKeyConfigurationController(popupForConfiguringHotkeyModel, popupForConfiguringHotkey)
        popupForConfiguringHotkey.CreateMain(popupForConfiguringHotkeyController)

        popupForConfiguringHotkey.getHwnd()
        
        
        popupForConfiguringHotkeyController.subscribeToSaveEvent(ObjBindMethod(this, "AddOrChangeHotkey"))
        popupForConfiguringHotkeyController.subscribeToDeleteEvent(ObjBindMethod(this, "deleteHotkey"))
    }

    ShowSettingsForAction(functionName){
        this.ExtraKeyboards.SetCurrentFunction(functionName)
        this.view.UpdateSettingsForActions()
    }

    HandleSettingClicked(settingName){
        if (settingName != ""){
            currentFunctionSettings := this.ExtraKeyboards.GetCurrentFunction()
            selectedSetting := this.ExtraKeyboards.GetSettingsForCurrentAction().GetSetting(settingName)
    
            editorForActionSettings := SettingsEditorDialog(this.getHwnd())
            editorForActionSettings.CreateControls(selectedSetting)
            editorForActionSettings.DisableSettingNameEdit()
            editorForActionSettings.SubscribeToSaveEvent(ObjBindMethod(this, "SettingsEditorDialogSaveButtonEvent", currentFunctionSettings))
    
            editorForActionSettings.show()

            WinWaitClose("Settings Editor Dialog" , , 1000)
    
            this.MainScript.RunLogicalStartup()

            try{
                this.view.UpdateSettingsForActions()
            }
            catch Error as e{
                ; The main gui was probably closed
            }
        }
    }

    SettingsEditorDialogSaveButtonEvent(currentFunctionSettings, setting){
        this.ExtraKeyboards.ChangeFunctionSetting(setting, currentFunctionSettings)
    }

    AddOrChangeHotkey(hotkeyInformation, originalHotkeyKey){
        newHotkeyKey := hotkeyInformation.getHotkeyName()

        ; If it does not exist, add it
        ; TODO this is bad, how the heck does EKAPGC know the default values is NONE?
        ; Add
        if (originalHotkeyKey = ""){
            if (hotkeyInformation.actionIsSet() AND hotkeyInformation.getHotkeyName() != ""){
                try{
                    this.ExtraKeyboards.AddHotkey(hotkeyInformation)
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
                this.ExtraKeyboards.ChangeHotkey(originalHotkeyKey, newHotkeyKey, hotkeyInformation)
            }
            catch Error as e{
                msgbox("Could not modify hotkey. " . e.Message)
            }
        }
        this.MainScript.RunLogicalStartup()
    }

    DeleteHotkey(hotkeyKey){
        try{
            
            this.MainScript.SetHotkeysForAllLayers(false)
            this.ExtraKeyboards.DeleteHotkey(hotkeyKey)
            msgbox("Deleted hotkey")
        }
        catch Error as e{
            this.MainScript.SetHotkeysForAllLayers(false)
            msgbox("Could not delete hotkey. " . e.Message)
        }
        this.view.UpdateHotkeys()
        this.view.ChangeConfigurationButtonsStatus(1)
        this.MainScript.RunLogicalStartup()
    }

    GetSettings(){
        return this.ExtraKeyboards.GetSettingsForCurrentActionAsArray()
    }

    GetHotkeys(){
        return this.ExtraKeyboards.GetFriendlyHotkeysForCurrentLayer()
    }

    GetPathToCurrentSettings(){
        return this.ExtraKeyboards.GetPathToCurrentSettings()
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

    GetActiveObjectsRegistry(){
        return this.ExtraKeyboards.GetActiveObjectsRegistry()
    }

    GetActionNames(){
        return this.ExtraKeyboards.GetActionNames()
    }

    GetHwnd(){
        return this.view.GetHwnd()
    }
}
