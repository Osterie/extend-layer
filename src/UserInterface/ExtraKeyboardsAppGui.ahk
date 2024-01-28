#Requires AutoHotkey v2.0

#Include ".\TreeViewFromIniFile.ahk"
#Include ".\ProfileButtons.ahk"
#Include ".\KeyboardLayerChanging.ahk"
#Include ".\ListViewMaker.ahk"
; #Include ".\TreeViewFromJsonFile.ahk"
; #Include ".\ListViewFromJsonObject.ahk"
#Include ".\ListViewFromIniFileContent.ahk"
#Include "..\library\FoldersAndFiles\FolderManager.ahk"

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


    __New(pathToExistingProfiles, pathToPresetProfiles, pathToMetaFile, pathToMainScript, pathToEmptyProfile, jsonFileConents, activeObjectsRegistry, keyboardLayersInfoRegister){
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

        this.PATH_TO_MAIN_SCRIPT := pathToMainScript

        this.PATH_TO_EMPTY_PROFILE := pathToEmptyProfile

        this.currentProfile := iniRead(this.PATH_TO_META_FILE, "General", "activeUserProfile")

        this.currentProfileIndex := this.ExistingProfilesManager.getFirstFoundFolderIndex(this.currentProfile)

    }

    CreateMain(){

        this.ExtraKeyboardsAppGui := Gui()
        this.ExtraKeyboardsAppGui.Opt("+Resize +MinSize640x480")
        this.ExtraKeyboardsAppGui.Add("Text", , "Current Profile:")

        this.profileButtonsObject := ProfileButtons(this.PATH_TO_EXISTING_PROFILES, this.PATH_TO_META_FILE)
        this.profileButtonsObject.createProfileSettingsForGui(this.ExtraKeyboardsAppGui)
        
        ; TODO move somewhere else...
        pathToKeyboardsJsonFile := this.PATH_TO_EXISTING_PROFILES . "\" . this.profileButtonsObject.getProfilesDropDownMenu().Text . "\Keyboards.json"
        pathToObjectsIniFile := this.PATH_TO_EXISTING_PROFILES . "\" . this.profileButtonsObject.getProfilesDropDownMenu().Text . "\ClassObjects.ini"


        this.CreateTabs(pathToKeyboardsJsonFile, pathToObjectsIniFile, this.jsonFileConents)
        
        
        this.ExtraKeyboardsAppGui.Show()
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

        keyboardLayoutChanger := KeyboardLayerChanging()
        keyboardLayoutChanger.createElementsForGui(this.ExtraKeyboardsAppGui, jsonFileContents)
        ; TODO use this.jsonwhatever ...
        
        
        listViewElement := ListViewMaker(this.activeObjectsRegistry, jsonFileContents, this.keyboardLayersInfoRegister)
        listViewElement.CreateListView(this.ExtraKeyboardsAppGui, ["KeyCombo","Action"])
        
        CreateListViewItems := ObjBindMethod(listViewElement, "SetNewListViewItemsByIniFileSection")
        keyboardLayoutChanger.AddEventAction("ItemSelect", CreateListViewItems)



        ; this.CreateTreeViewWithAssociatedListViewFromJsonObject(jsonFileConents)

        Tab.UseTab(2)
        this.CreateTreeViewWithAssociatedListViewFromIniFile(pathToObjectsIniFile)


        Tab.UseTab(3)
        this.CreateDocumentationTab()

        Tab.UseTab(0)  ; i.e. subsequently-added controls will not belong to the tab control.
    }

    ; CreateTreeViewWithAssociatedListViewFromJsonObject(jsonFileConents){
    ;     treeViewElement := TreeViewFromJsonFile(jsonFileConents)
    ;     treeViewElement.CreateTreeView(this.ExtraKeyboardsAppGui)
        
    ;     listViewElement := ListViewFromJsonObject(jsonFileConents)
    ;     listViewElement.CreateListView(this.ExtraKeyboardsAppGui, ["Key","Value"])
        
    ;     CreateListViewItems := ObjBindMethod(listViewElement, "SetNewListViewItemsByIniFileSection")
    ;     treeViewElement.AddEventAction("ItemSelect", CreateListViewItems)
    ; }

    CreateTreeViewWithAssociatedListViewFromIniFile(iniFilePath){
        treeViewElement := TreeViewFromIniFile(iniFilePath)
        treeViewElement.CreateTreeView(this.ExtraKeyboardsAppGui)
        
        listViewElement := ListViewFromIniFileContent()
        listViewElement.CreateListView(this.ExtraKeyboardsAppGui, ["Key","Value"], iniFilePath)
        
        CreateListViewItems := ObjBindMethod(listViewElement, "SetNewListViewItemsByIniFileSection", iniFilePath)
        treeViewElement.AddEventAction("ItemSelect", CreateListViewItems)

    }
}