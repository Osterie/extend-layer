#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JsonFormatter\JsonFormatter>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include "Main\Functionality\ActionSettings\SettingsEditor.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationView.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationController.ahk"
#Include "Main\Functionality\KeyboardEditing\HotKeyConfigurationModel.ahk"

Class ExtraKeyboardsAppGuiController{

    MainScript := ""
    keyboardLayersInfoRegister := ""

    __New(model, view, keyboardLayersInfoRegister, MainScript){
        this.view := view
        this.model := model
        
        this.MainScript := MainScript
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister

    }

    HandleProfileChangedEvent(*){
        ; TODO this should probably be changed? it is sort of heavy to basically restart the entire program when changing profiles.
        this.mainScript.Start()
        this.view.Destroy()
    }

    HandleKeyboardLayerSelected(listViewControl, treeViewElement, treeViewElementSelectedItemID){
        currentLayer := treeViewElement.GetText(treeViewElementSelectedItemID)
        
        this.model.SetCurrentLayer(currentLayer)
        hotkeysForLayer := this.model.GetFriendlyHotkeysForCurrentLayer()

        listViewControl.SetNewListViewItems(hotkeysForLayer)
    }

    ; TODO make sure user cant create multiple popups
    HandleKeyComboActionDoubleClickedEvent(listView, indexOfKeyToEdit){

        layerInformation := this.GetCurrentLayerInfo()

        if (Type(layerInformation) == "HotkeysRegistry"){
            if (indexOfKeyToEdit == 0){
                hotkeyBuild := "NONE"
                hotkeyAction := "NONE"
            }
            else{
                hotkeyBuild := listView.GetText(indexOfKeyToEdit, 1)
                hotkeyInfo := this.model.GetHotkeyInfoForLayer(this.GetCurrentLayer(), hotkeyBuild)
                hotkeyAction := listView.GetText(indexOfKeyToEdit, 2)
            }
            this.CreatePopupForHotkeys(hotkeyInfo)
        }
        else if (Type(layerInformation) == "KeyboardOverlayInfo"){
            ; TODO implement
            ; popupForConfiguringHotkey.CreatePopupForKeyboardOverlayInfo()
        }
    }

    ; TODO move to view
    CreatePopupForHotkeys(hotkeyInfo){
        popupForConfiguringHotkeyModel := HotKeyConfigurationModel(this.GetActiveObjectsRegistry(), this.GetKeyNames(), hotkeyInfo)
        popupForConfiguringHotkey := HotKeyConfigurationView(this.GetActiveObjectsRegistry(), this.GetKeyNames())
        popupForConfiguringHotkeyController := HotKeyConfigurationController(popupForConfiguringHotkeyModel, popupForConfiguringHotkey)
        popupForConfiguringHotkey.CreateMain(popupForConfiguringHotkeyController)
        
        
        popupForConfiguringHotkeyController.subscribeToSaveEvent(ObjBindMethod(this, "changeHotkeys"))

        ; TODO add delete button event.
    }


    changeHotkeys(hotkeyInfo, originalHotkeyKey){
        hotkeyKey := hotkeyInfo.getHotkeyName()

        if (originalHotkeyKey = "NONE"){
            try{
                hotkeyInfo.changeHotkey(hotkeyKey)
                this.model.AddHotkey(hotkeyInfo)
            }
            catch Error as e{
                msgbox("Could not add hotkey. " . e.Message)
            }
        }
        else{
            try{
                this.model.ChangeHotkey(originalHotkeyKey, hotkeyKey, hotkeyInfo)
            }
            catch Error as e{
                msgbox("Could not modify hotkey. " . e.Message)
            }
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

        editorForActionSettings := SettingsEditor()
        editorForActionSettings.CreateControls(settingName, settingValue)
        editorForActionSettings.DisableSettingNameEdit()
        editorForActionSettings.addSaveButtonEvent("Click", ObjBindMethod(this, "SettingsEditorSaveButtonEvent", editorForActionSettings, currentFunctionSettings))
    }

    SettingsEditorSaveButtonEvent(editorForActionSettings, currentFunctionSettings, *){
        settingName := editorForActionSettings.GetSetting()
        settingValue := editorForActionSettings.GetSettingValue()
        this.model.ChangeFunctionSetting(settingName, settingValue, currentFunctionSettings)
        editorForActionSettings.Destroy()
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
}
