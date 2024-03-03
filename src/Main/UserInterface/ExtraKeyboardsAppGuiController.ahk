#Requires AutoHotkey v2.0

#Include "Main\Functionality\ActionSettings\SettingsEditor.ahk"

#Include "Main\Functionality\Keyboard\KeyboardEditing\HotKeyConfigurationPopup.ahk"

#Include "<MetaInfo\MetaInfoStorage\Files\FilePaths>"

#Include <JsonParsing\JsonFormatter\JsonFormatter>

; TODO have a hotkey which sends a given key(or hotkey) after a given delay.
; TODO could also have a hotkey/key which is excecuted if a loud enough sound is caught by the mic.

; TODO make it possible for the user to add own ahk scripts to the program, and then use them as functions. 

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
            hotkeyBuild := listView.GetText(indexOfKeyToEdit, 1)
            hotkeyAction := listView.GetText(indexOfKeyToEdit, 2)
            this.CreatePopupForHotkeys(hotkeyBuild, hotkeyAction)
        }
        else if (Type(layerInformation) == "KeyboardOverlayInfo"){
            ; TODO implement
            ; popupForConfiguringHotkey.CreatePopupForKeyboardOverlayInfo()
        }
    }

    ; TODO move to view
    CreatePopupForHotkeys(hotkeyBuild, hotkeyAction){
        popupForConfiguringHotkey := HotKeyConfigurationPopup(this.GetActiveObjectsRegistry(), this.GetKeyNames())
        popupForConfiguringHotkey.CreatePopupForHotkeyRegistry(hotkeyBuild, hotkeyAction)
        saveButtonEvent := ObjBindMethod(this, "HotKeyConfigurationPopupSaveEvent", popupForConfiguringHotkey)
        popupForConfiguringHotkey.addSaveButtonClickedEvent(saveButtonEvent)

        ; TODO add delete button event.
    }


    HotKeyConfigurationPopupSaveEvent(popupForConfiguringHotkey, *){
        
        originalHotkey := popupForConfiguringHotkey.getOriginalHotkey()
        newHotkey := popupForConfiguringHotkey.getHotkey()
        newAction := popupForConfiguringHotkey.getAction()

        this.model.ChangeHotkey(originalHotkey, newHotkey, newAction)

        this.MainScript.RunLogicalStartup()
        
        popupForConfiguringHotkey.Destroy()
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
