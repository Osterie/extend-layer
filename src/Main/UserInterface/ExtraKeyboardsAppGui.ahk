#Requires AutoHotkey v2.0


#Include <JsonParsing\JXON\JXON>
#Include "Main\util\ListViewFromIniFileContent.ahk"
#Include "Main\ProfileEditing\ProfileButtons.ahk"
#Include "Main\Functionality\Keyboard\TreeViewForLayers.ahk"
#Include "Main\Functionality\Keyboard\ListViewForHotkeys.ahk"
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

    jsonFileConents := ""
    activeObjectsRegistry := ""
    keyboardLayersInfoRegister := ""

    MainScript := ""

    currentLayer := ""

    keyNames := ""


    __New(pathToExistingProfiles, pathToPresetProfiles, pathToMetaFile, pathToMainScript, pathToEmptyProfile, jsonFileConents, activeObjectsRegistry, keyboardLayersInfoRegister, mainScript, keyNames){
        this.MainScript := mainScript
        
        this.keyNames := keyNames
        
        this.ExistingProfilesManager := FolderManager()
        this.PresetProfilesManager := FolderManager()

        this.activeObjectsRegistry := activeObjectsRegistry
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister
        this.jsonFileConents := jsonFileConents

        this.PATH_TO_EXISTING_PROFILES := pathToExistingProfiles
        this.PATH_TO_PRESET_PROFILES := pathToPresetProfiles
        this.PresetProfilesManager.addSubFoldersToRegistryFromFolder(this.PATH_TO_PRESET_PROFILES)
        this.ExistingProfilesManager.addSubFoldersToRegistryFromFolder(this.PATH_TO_EXISTING_PROFILES)

        this.PATH_TO_META_FILE := pathToMetaFile

        ; this.PATH_TO_MAIN_SCRIPT := pathToMainScript

        ; this.PATH_TO_EMPTY_PROFILE := pathToEmptyProfile

        this.currentProfile := iniRead(this.PATH_TO_META_FILE, "General", "activeUserProfile")

        

        ; this.currentProfileIndex := this.ExistingProfilesManager.getFirstFoundFolderIndex(this.currentProfile)

    }

    CreateMain(){

        this.ExtraKeyboardsAppGui := Gui()
        this.ExtraKeyboardsAppGui.Opt("+Resize +MinSize920x480")
        this.ExtraKeyboardsAppGui.Add("Text", , "Current Profile:")

        this.profileButtonsObject := ProfileButtons(this.PATH_TO_EXISTING_PROFILES, this.PATH_TO_META_FILE)
        this.profileButtonsObject.createProfileSettingsForGui(this.ExtraKeyboardsAppGui)
        
        ; TODO move somewhere else...
        pathToKeyboardsJsonFile := this.PATH_TO_EXISTING_PROFILES . "\" . this.profileButtonsObject.getProfilesDropDownMenu().Text . "\Keyboards.json"
        pathToObjectsIniFile := this.PATH_TO_EXISTING_PROFILES . "\" . this.profileButtonsObject.getProfilesDropDownMenu().Text . "\ClassObjects.ini"


        this.CreateTabs(pathToKeyboardsJsonFile, pathToObjectsIniFile, this.jsonFileConents)
        
        
        ; Create gui in the top left corner of the screen
        this.ExtraKeyboardsAppGui.Show("x0 y0")
    }

    getProfileButtonsObject(){
        return this.profileButtonsObject
    }

    CreateDocumentationTab(){
        this.ExtraKeyboardsAppGui.Add("Edit", "vMyEdit r20")  ; r20 means 20 rows tall.
    }

    CreateTabs(pathToKeyboardsJsonFile, pathToObjectsIniFile, jsonFileContents){
        
        Tab := this.ExtraKeyboardsAppGui.AddTab3("ys+20 xm", ["Keyboards","Change Functions Settings","Documentation"])
        Tab.UseTab(1)

        keyboardLayoutChanger := TreeViewForLayers()
        keyboardLayoutChanger.createElementsForGui(this.ExtraKeyboardsAppGui, jsonFileContents)
        ; TODO use this.jsonwhatever ...
        
        
        listViewElement := ListViewForHotkeys(this.activeObjectsRegistry, jsonFileContents, this.keyboardLayersInfoRegister, this.keyNames)
        listViewElement.CreateListView(this.ExtraKeyboardsAppGui, ["KeyCombo","Action"])
        
        
        keyboardLayoutChanger.AddEventAction("ItemSelect", ObjBindMethod(this, "TreeViewElementClickedEvent", listViewElement))


        saveEvent := ObjBindMethod(this, "hotkeySavedEvent", listViewElement)
        listViewElement.setHotkeySavedEvent(saveEvent)


        ; this.CreateTreeViewWithAssociatedListViewFromJsonObject(jsonFileConents)

        Tab.UseTab(2)
        this.CreateTreeViewWithAssociatedListViewFromIniFile(pathToObjectsIniFile)


        Tab.UseTab(3)
        this.CreateDocumentationTab()

        Tab.UseTab(0)  ; i.e. subsequently-added controls will not belong to the tab control.
    }

    TreeViewElementClickedEvent(listViewElement, treeViewElement, treeViewElementSelectedItemID){

        this.currentLayer := treeViewElement.GetText(treeViewElementSelectedItemID)
        ; this.currentHotkey := 
        listViewElement.SetNewListViewItemsByIniFileSection(treeViewElement, treeViewElementSelectedItemID)

    }

    ; TODO change name of this method to reflect that it (maybe) changes both hotkey and action...
    hotkeySavedEvent(listViewElement, *){
        ; TODO now i must update the json file with the new hotkey if it is valid...

        ; TODO keyboardLayersInfoRegister change a hotkey, turn into a json file, and then change the existing json file

        oldHotkey := HotkeyFormatConverter.convertFromFriendlyName(listViewElement.getOriginalHotkey())
        newHotkey := listViewElement.getNewHotkey()
        newAction := listViewElement.getNewAction()

        this.keyboardLayersInfoRegister.ChangeHotkey(this.currentLayer, oldHotkey, newHotKey)
        this.keyboardLayersInfoRegister.ChangeAction(this.currentLayer, oldHotkey, newAction)



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

        
        listViewElement.getPopup().Destroy()
    }

    actionSavedEvent(listViewElement, *){
        ; ; TODO now i must update the json file with the new hotkey if it is valid...

        ; ; TODO keyboardLayersInfoRegister change a hotkey, turn into a json file, and then change the existing json file

        ; oldHotkey := HotkeyFormatConverter.convertFromFriendlyName(listViewElement.getOriginalHotkey())
        ; newHotkey := listViewElement.getNewHotkey()

        ; this.keyboardLayersInfoRegister.ChangeHotkey(this.currentLayer, oldHotkey, newHotKey)

        ; toJsonReader := KeyboadLayersInfoClassObjectReader()
        ; toJsonReader.ReadObjectToJson(this.keyboardLayersInfoRegister)
        ; jsonObject := toJsonReader.getJsonObject()

        ; currentProfileName := iniRead(this.PATH_TO_META_FILE, "General", "activeUserProfile")
        ; pathToCurrentProfile := this.PATH_TO_EXISTING_PROFILES . "\" . currentProfileName

        
        ; formatterForJson := JsonFormatter()
        ; jsonString := formatterForJson.FormatJsonObject(jsonObject)
        ; FileRecycle(pathToCurrentProfile . "\Keyboards.json")
        ; FileAppend(jsonString, pathToCurrentProfile . "\Keyboards.json", "UTF-8")
        ; this.MainScript.RunLogicalStartup()

        
        ; listViewElement.getPopup().Destroy() 
    }

    CreateTreeViewWithAssociatedListViewFromIniFile(iniFilePath){
        treeViewElement := TreeViewFromIniFile(iniFilePath)
        treeViewElement.CreateTreeView(this.ExtraKeyboardsAppGui)
        
        listViewElement := ListViewFromIniFileContent()
        listViewElement.CreateListView(this.ExtraKeyboardsAppGui, ["Key","Value"], iniFilePath)
        
        CreateListViewItems := ObjBindMethod(listViewElement, "SetNewListViewItemsByIniFileSection", iniFilePath)
        treeViewElement.AddEventAction("ItemSelect", CreateListViewItems)

    }
}