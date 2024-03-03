#Requires AutoHotkey v2.0

; TODO move inifilereader to meta info reading

; #Include <JsonParsing\JXON\JXON>
#Include <FoldersAndFiles\IniFileReader>

#Include "Main\Functionality\ActionSettings\SettingsEditor.ahk"

#Include "Main\ProfileEditing\ProfileButtons.ahk"
#Include "Main\ProfileEditing\ProfileRegionModel.ahk"
#Include "Main\ProfileEditing\ProfileRegionView.ahk"
#Include "Main\ProfileEditing\ProfileRegionController.ahk"
#Include "Main\util\TreeViewMaker.ahk"
#Include "Main\util\ListViewMaker.ahk"
#Include "Main\Functionality\Keyboard\KeyboardEditing\HotKeyConfigurationPopup.ahk"
#Include "Main\util\GuiColorsChanger.ahk"


#Include "<MetaInfo\MetaInfoStorage\Files\FilePaths>"

#Include <FoldersAndFiles\FolderManager>
#Include <JsonParsing\JsonFormatter\JsonFormatter>

; TODO have a hotkey which sends a given key(or hotkey) after a given delay.
; TODO could also have a hotkey/key which is excecuted if a loud enough sound is caught by the mic.

; TODO make it possible for the user to add own ahk scripts to the program, and then use them as functions. 

Class ExtraKeyboardsAppGuiController{

    ; Used to create the gui
    ExtraKeyboardsAppGui := ""

    keyboardLayersInfoRegister := ""

    MainScript := ""

    keyNames := ""

    pathToObjectsIniFile := ""


    __New(model, view, keyboardLayersInfoRegister, MainScript, keyNames){
        this.view := view
        this.model := model
        
        this.MainScript := MainScript
        
        this.keyNames := keyNames
        
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister

    }


    GetFunctionNames(){
        return this.model.GetFunctionNames()
    }

    CreateProfileEditor(){
        profileModel := ProfileRegionModel(this.ExtraKeyboardsAppGui)
        profileView := ProfileRegionView()
        profileController := ProfileRegionController(profileModel, profileView, ObjBindMethod(this, "eventProfileChanged"))
        profileController.CreateView()
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

    CreatePopupForHotkeys(hotkeyBuild, hotkeyAction){
        popupForConfiguringHotkey := HotKeyConfigurationPopup(this.GetActiveObjectsRegistry(), this.GetKeyNames())
        popupForConfiguringHotkey.CreatePopupForHotkeyRegistry(hotkeyBuild, hotkeyAction)
        saveButtonEvent := ObjBindMethod(this, "HotKeyConfigurationPopupSaveEvent", popupForConfiguringHotkey)
        popupForConfiguringHotkey.addSaveButtonClickedEvent(saveButtonEvent)

        ; TODO add delete button event.
    }


    ; NOTE, info has no info for button clicks, which this is for.
    HotKeyConfigurationPopupSaveEvent(popupForConfiguringHotkey, info, buttonClicked){
        
        originalHotkey := popupForConfiguringHotkey.getOriginalHotkey()
        newHotkey := popupForConfiguringHotkey.getHotkey()
        newAction := popupForConfiguringHotkey.getAction()

        ; TODO now i must update the json file with the new hotkey if it is valid...
        ; TODO keyboardLayersInfoRegister change a hotkey, turn into a json file, and then change the existing json file

        this.keyboardLayersInfoRegister.ChangeHotkey(this.GetCurrentLayer(), originalHotkey, newHotkey)

        ; TODO perhaps a else with some information here
        if (newAction != ""){
            this.keyboardLayersInfoRegister.ChangeAction(this.GetCurrentLayer(), originalHotkey, newAction)
        }

        ; TODO create a method for this.
        toJsonReader := KeyboadLayersInfoClassObjectReader()
        toJsonReader.ReadObjectToJson(this.keyboardLayersInfoRegister)
        jsonObject := toJsonReader.getJsonObject()

        currentProfileName := iniRead(FilePaths.GetPathToMetaFile(), "General", "activeUserProfile")

        pathToCurrentProfile := FilePaths.GetPathToProfiles() . "\" . currentProfileName

        
        formatterForJson := JsonFormatter()
        jsonString := formatterForJson.FormatJsonObject(jsonObject)
        FileRecycle(pathToCurrentProfile . "\Keyboards.json")
        FileAppend(jsonString, pathToCurrentProfile . "\Keyboards.json", "UTF-8")
        this.MainScript.RunLogicalStartup()
        
        popupForConfiguringHotkey.Destroy()
    }

    HandleFunctionFromTreeViewSelected(listViewControl, treeViewElement, treeViewElementSelectedItemID){
        functionName := treeViewElement.GetText(treeViewElementSelectedItemID)
        listViewControl.SetNewListViewItems(this.model.GetSettingsForFunction(functionName))
    }

    CreateFunctionSettingsEditor(functionsNamesTreeView, listView, rowNumber){
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

    CreateDocumentationTab(){
        this.ExtraKeyboardsAppGui.Add("Edit", "vMyEdit r20")  ; r20 means 20 rows tall.
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
}
