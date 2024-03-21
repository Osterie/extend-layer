#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JsonFormatter\JsonFormatter>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include "Main\Functionality\ActionSettings\SettingsEditorDialog.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationView.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationController.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationModel.ahk"

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

    ShowHotkeysForLayer(listViewControl, treeViewElement, treeViewElementSelectedItemID){
        currentLayer := treeViewElement.GetText(treeViewElementSelectedItemID)
        
        this.model.SetCurrentLayer(currentLayer)
        hotkeysForLayer := this.model.GetFriendlyHotkeysForCurrentLayer()

        listViewControl.SetNewListViewItems(hotkeysForLayer)
    }

    ; TODO make sure user cant create multiple popups?
    EditHotkey(listView, indexOfKeyToEdit){

        if (indexOfKeyToEdit = 0){
            emptyHotkeyInformation := HotkeyInfo()
            this.CreatePopupForHotkeys(emptyHotkeyInformation)
        }
        else{

            layerInformation := this.GetCurrentLayerInfo()
    
            if (Type(layerInformation) == "HotkeysRegistry"){
                hotkeyBuild := listView.GetText(indexOfKeyToEdit, 1)
                hotkeyInformation := this.model.GetHotkeyInfoForCurrentLayer(hotkeyBuild)
                ; hotkeyAction := listView.GetText(indexOfKeyToEdit, 2)
                this.CreatePopupForHotkeys(hotkeyInformation)
            }
            else if (Type(layerInformation) == "KeyboardOverlayInfo"){
                ; TODO implement
                ; popupForConfiguringHotkey.CreatePopupForKeyboardOverlayInfo()
            }
        }
    }

    ; TODO move to view
    CreatePopupForHotkeys(hotkeyInformation){
        popupForConfiguringHotkeyModel := HotKeyConfigurationModel(this.GetActiveObjectsRegistry(), this.GetKeyNames(), hotkeyInformation)
        popupForConfiguringHotkey := HotKeyConfigurationView(this.GetHwnd())
        popupForConfiguringHotkeyController := HotKeyConfigurationController(popupForConfiguringHotkeyModel, popupForConfiguringHotkey)
        popupForConfiguringHotkey.CreateMain(popupForConfiguringHotkeyController)
        
        
        popupForConfiguringHotkeyController.subscribeToSaveEvent(ObjBindMethod(this, "changeHotkeys"))
        popupForConfiguringHotkeyController.subscribeToDeleteEvent(ObjBindMethod(this, "deleteHotkey"))

        ; TODO add delete button event.
    }

    changeHotkeys(hotkeyInformation, originalHotkeyKey){
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

    deleteHotkey(hotkeyKey){
        try{
            this.model.DeleteHotkey(hotkeyKey)
            msgbox("Deleted hotkey")
        }
        catch Error as e{
            msgbox("Could not delete hotkey. " . e.Message)
        }
        this.MainScript.RunLogicalStartup()
    }

    HandleFunctionFromTreeViewSelected(listViewControl, treeViewElement, treeViewElementSelectedItemID){
        functionName := treeViewElement.GetText(treeViewElementSelectedItemID)
        listViewControl.SetNewListViewItems(this.model.GetSettingsForFunction(functionName))
    }

    HandleSettingClicked(functionsNamesTreeView, listView, rowNumber){
        currentFunctionSettings := functionsNamesTreeView.GetSelectionText()

        settingName := listView.GetText(rowNumber, 1)
        settingValue := listView.GetText(rowNumber, 2)

        editorForActionSettings := SettingsEditorDialog()
        editorForActionSettings.CreateControls(settingName, settingValue)
        editorForActionSettings.DisableSettingNameEdit()
        editorForActionSettings.SubscribeToSaveEvent(ObjBindMethod(this, "SettingsEditorDialogSaveButtonEvent", currentFunctionSettings))
    }

    SettingsEditorDialogSaveButtonEvent(currentFunctionSettings, settingName, settingValue){
        this.model.ChangeFunctionSetting(settingName, settingValue, currentFunctionSettings)
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

    GetFunctionNames(){
        return this.model.GetFunctionNames()
    }

    GetHwnd(){
        return this.view.GetHwnd()
    }
}
