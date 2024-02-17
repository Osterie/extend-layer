#Requires AutoHotkey v2.0

; TODO move inifilereader to meta info reading

; #Include <JsonParsing\JXON\JXON>
#Include "Main\util\ListViewFromIniFileContent.ahk"
#Include <FoldersAndFiles\IniFileReader>

#Include "Main\ProfileEditing\ProfileButtons.ahk"
#Include "Main\util\TreeViewMaker.ahk"
#Include "Main\util\ListViewMaker.ahk"
#Include "Main\Functionality\Keyboard\KeyboardEditing\HotKeyConfigurationPopup.ahk"
#Include "Main\util\GuiColorsChanger.ahk"


#Include <FoldersAndFiles\FolderManager>
#Include <JsonParsing\JsonFormatter\JsonFormatter>

; TODO have a hotkey which sends a given key(or hotkey) after a given delay.
; TODO could also have a hotkey/key which is excecuted if a loud enough sound is caught by the mic.

; TODO make it possible for the user to add own ahk scripts to the program, and then use them as functions. 

Class ExtraKeyboardsAppGui{

    ; Used to create the gui
    ExtraKeyboardsAppGui := ""
    ; Used to manage the preset user profiles, the user is only allowed to add a preset profile as a new profile
    PresetProfilesManager := ""
    ; Used to manage the existing user profiles, the user is allowed to edit, delete, and add new profiles
    ExistingProfilesManager := ""
    ; A constant which is the path to the preset profiles

    PATH_TO_EMPTY_PROFILE := ""
    PATH_TO_PRESET_PROFILES := ""
    PATH_TO_EXISTING_PROFILES := ""
    PATH_TO_META_FILE := ""

    currentProfile := ""
    currentProfileIndex := ""

    ; Gui part
    profilesDropDownMenu := ""

    keyboardLayerIdentifiers := ""
    activeObjectsRegistry := ""
    keyboardLayersInfoRegister := ""

    MainScript := ""

    currentLayer := ""

    keyNames := ""


    __New(pathToExistingProfiles, pathToPresetProfiles, pathToMetaFile, pathToMainScript, pathToEmptyProfile, keyboardLayerIdentifiers, activeObjectsRegistry, keyboardLayersInfoRegister, mainScript, keyNames){
        this.MainScript := mainScript
        
        this.keyNames := keyNames
        
        this.ExistingProfilesManager := FolderManager()
        this.PresetProfilesManager := FolderManager()

        this.activeObjectsRegistry := activeObjectsRegistry
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister
        this.keyboardLayerIdentifiers := keyboardLayerIdentifiers

        this.PATH_TO_EXISTING_PROFILES := pathToExistingProfiles
        this.PATH_TO_PRESET_PROFILES := pathToPresetProfiles
        this.PresetProfilesManager.addSubFoldersToRegistryFromFolder(this.PATH_TO_PRESET_PROFILES)
        this.ExistingProfilesManager.addSubFoldersToRegistryFromFolder(this.PATH_TO_EXISTING_PROFILES)

        this.PATH_TO_META_FILE := pathToMetaFile

        ; this.PATH_TO_EMPTY_PROFILE := pathToEmptyProfile

        this.currentProfile := iniRead(this.PATH_TO_META_FILE, "General", "activeUserProfile")

        

        ; this.currentProfileIndex := this.ExistingProfilesManager.getFirstFoundFolderIndex(this.currentProfile)

    }

    CreateMain(){

        this.ExtraKeyboardsAppGui := Gui("+Resize +MinSize920x480", "Extra Keyboards App")
        this.ExtraKeyboardsAppGui.BackColor := "051336"
        this.ExtraKeyboardsAppGui.SetFont("c6688cc Bold")

        this.profileButtonsObject := ProfileButtons(this.PATH_TO_EXISTING_PROFILES, this.PATH_TO_META_FILE)
        this.profileButtonsObject.createProfileSettingsForGui(this.ExtraKeyboardsAppGui)
        this.profileButtonsObject.addProfileChangedEvent(ObjBindMethod(this, "eventProfileChanged"))


        ; TODO move somewhere else...
        pathToKeyboardsJsonFile := this.PATH_TO_EXISTING_PROFILES . "\" . this.profileButtonsObject.getProfilesDropDownMenu().Text . "\Keyboards.json"
        pathToObjectsIniFile := this.PATH_TO_EXISTING_PROFILES . "\" . this.profileButtonsObject.getProfilesDropDownMenu().Text . "\ClassObjects.ini"

        fileReader := IniFileReader()
        functionsNames := fileReader.ReadSectionNamesToArray(pathToObjectsIniFile)

        this.CreateTabs(pathToKeyboardsJsonFile, functionsNames, this.keyboardLayerIdentifiers, pathToObjectsIniFile)
        
        this.setColors()
        
        ; Create gui in the top left corner of the screen
        this.ExtraKeyboardsAppGui.Show("x0 y0")
    }

    eventProfileChanged(*){
        ; TODO this should probably be changed? it is sort of heavy to basically restart the entire program when changing profiles.
        this.mainScript.RunMainStartup(false)
        this.mainScript.RunLogicalStartup()
        this.mainScript.RunAppGui()
        this.ExtraKeyboardsAppGui.Destroy()
    }

    CreateTabs(pathToKeyboardsJsonFile, functionsNames, jsonFileContents, pathToObjectsIniFile){
        
        Tab := this.ExtraKeyboardsAppGui.AddTab3("yp+40 xm", ["Keyboards","Change Functions Settings","Documentation"])
        Tab.UseTab(1)

        this.CreateKeyboardsTab(pathToKeyboardsJsonFile, functionsNames, jsonFileContents, pathToObjectsIniFile)

        Tab.UseTab(2)
        this.CreateFunctionSettingsTab(functionsNames, pathToObjectsIniFile)


        Tab.UseTab(3)
        this.CreateDocumentationTab()

        Tab.UseTab(0) ; subsequently-added controls will not belong to the tab control.
    }

    CreateKeyboardsTab(pathToKeyboardsJsonFile, functionsNames, jsonFileContents, pathToObjectsIniFile){

        keyboardLayoutChanger := TreeViewMaker()
        keyboardLayoutChanger.createElementsForGui(this.ExtraKeyboardsAppGui, jsonFileContents)
        ; TODO use this.jsonwhatever ...
        
        listViewControl := ListViewMaker()
        listViewControl.CreateListView(this.ExtraKeyboardsAppGui, ["KeyCombo","Action"])
        
        keyboardLayoutChanger.AddEventAction("ItemSelect", ObjBindMethod(this, "TreeViewElementSelectedEvent", listViewControl))


        doubleClickEvent := ObjBindMethod(this, "ListViewElementDoubleClickedEvent", keyboardLayoutChanger)
        listViewControl.AddEventAction("DoubleClick", doubleClickEvent)
    }

    TreeViewElementSelectedEvent(listViewControl, treeViewElement, treeViewElementSelectedItemID){
        this.currentLayer := treeViewElement.GetText(treeViewElementSelectedItemID)

        itemsToShowForListView := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.currentLayer)
        hotkeysForLayer := itemsToShowForListView.getFriendlyHotkeyActionPairValues()

        listViewControl.SetNewListViewItems(hotkeysForLayer)
    }

    ListViewElementDoubleClickedEvent(treeView, listView, item){
        currentLayerIdentifier := treeView.GetSelectionText()

        keyboardInformation := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(currentLayerIdentifier)

        hotkeyBuild := listView.GetText(item, 1)
        this.newHotkey := hotkeyBuild
        this.originalHotkey := hotkeyBuild
        hotkeyAction := listView.GetText(item, 2)

        popupForConfiguringHotkey := HotKeyConfigurationPopup(this.activeObjectsRegistry, this.keyNames)
        if (Type(keyboardInformation) == "HotkeysRegistry"){
            popupForConfiguringHotkey.CreatePopupForHotkeyRegistry(keyboardInformation, item, hotkeyBuild, hotkeyAction)
            
        }
        else if (Type(keyboardInformation) == "KeyboardOverlayInfo"){
            popupForConfiguringHotkey.CreatePopupForKeyboardOverlayInfo(keyboardInformation, item)
        }

        saveButtonEvent := ObjBindMethod(this, "HotKeyConfigurationPopupSaveEvent", popupForConfiguringHotkey)
        popupForConfiguringHotkey.addSaveButtonClickedEvent(saveButtonEvent)

        cancelButtonEvent := ObjBindMethod(this, "popupCancelButtonClickEvent")
        popupForConfiguringHotkey.addCancelButtonClickedEvent(cancelButtonEvent)

        
    }

    ; NOTE, info has no info for button clicks, which this is for.
    HotKeyConfigurationPopupSaveEvent(popupForConfiguringHotkey, info, buttonClicked){
        
        originalHotkey := popupForConfiguringHotkey.getOriginalHotkey()
        newHotkey := popupForConfiguringHotkey.getHotkey()
        newAction := popupForConfiguringHotkey.getAction()

                ; TODO now i must update the json file with the new hotkey if it is valid...

        ; TODO keyboardLayersInfoRegister change a hotkey, turn into a json file, and then change the existing json file

        this.keyboardLayersInfoRegister.ChangeHotkey(this.currentLayer, originalHotkey, newHotkey)

        ; TODO perhaps a else with some information here
        if (newAction != ""){
            this.keyboardLayersInfoRegister.ChangeAction(this.currentLayer, originalHotkey, newAction)
        }

        toJsonReader := KeyboadLayersInfoClassObjectReader()
        toJsonReader.ReadObjectToJson(this.keyboardLayersInfoRegister)
        jsonObject := toJsonReader.getJsonObject()

        currentProfileName := iniRead(this.PATH_TO_META_FILE, "General", "activeUserProfile")
        pathToCurrentProfile := this.PATH_TO_EXISTING_PROFILES . "\" . currentProfileName

        
        formatterForJson := JsonFormatter()
        jsonString := formatterForJson.FormatJsonObject(jsonObject)
        FileRecycle(pathToCurrentProfile . "\Keyboards.json")
        FileAppend(jsonString, pathToCurrentProfile . "\Keyboards.json", "UTF-8")
        this.MainScript.RunLogicalStartup()

        
        popupForConfiguringHotkey.Destroy()
    }

    CreateFunctionSettingsTab(functionsNames, iniFilePath){

        functionsNamesTreeView := TreeViewMaker()
        functionsNamesTreeView.createElementsForGui(this.ExtraKeyboardsAppGui, functionsNames)
        
        functionSettings := ListViewFromIniFileContent()
        functionSettings.CreateListView(this.ExtraKeyboardsAppGui, ["Setting","Value"], iniFilePath)
        
        ShowFunctionSettingsForFunction := ObjBindMethod(functionSettings, "SetNewListViewItemsByLayerIdentifier", iniFilePath)
        functionsNamesTreeView.AddEventAction("ItemSelect", ShowFunctionSettingsForFunction)

    }

    CreateDocumentationTab(){
        this.ExtraKeyboardsAppGui.Add("Edit", "vMyEdit r20")  ; r20 means 20 rows tall.
    }

    setColors(){
        controlColor := "060621"
        textColor := "6688FF"
        GuiColorsChanger.setControlsColor(this.ExtraKeyboardsAppGui, controlColor)
        GuiColorsChanger.setControlsTextColor(this.ExtraKeyboardsAppGui, textColor)
        GuiColorsChanger.DwmSetCaptionColor(this.ExtraKeyboardsAppGui, 0x300f45) ; color is in RGB format
        GuiColorsChanger.DwmSetTextColor(this.ExtraKeyboardsAppGui, 0x27eaf1)
    }
}
