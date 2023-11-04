#Requires AutoHotkey v2.0

#Include ".\TreeViewFromIniFile.ahk"
#Include ".\ListViewFromIniFileContent.ahk"
#Include "..\library\FoldersAndFiles\IniFileReader.ahk"
#Include "..\library\FoldersAndFiles\FolderManager.ahk"

; TODO have a hotkey which sends a given key(or hotkey) after a given delay.
; TODO could also have a hotkey/key which is excecuted if a loud enough sound is caught by the mic.

; TODO make it possible for the user to add own ahk scripts to the program, and then use them as functions. 

Class ExtraKeyboardsAppGui{

    ; Used to read the contents of ini files
    IniFileRead := ""
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


    __New(pathToExistingProfiles, pathToPresetProfiles, pathToMetaFile, pathToMainScript, pathToEmptyProfile){
        this.IniFileRead := IniFileReader()
        this.ExistingProfilesManager := FolderManager()
        this.PresetProfilesManager := FolderManager()


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
        
        
        this.profilesDropDownMenu := this.createProfilesDropDownMenu()
        
        
        ; TODO when add profile is clicked, user can choose a pre made profile, or create their own from scratch
        editProfilesButton := this.ExtraKeyboardsAppGui.Add("Button", "Default w80 ym+1", "Edit profiles")
        addProfileButton := this.ExtraKeyboardsAppGui.Add("Button", "Default w80 ym+1", "Add profile")
        importProfileButton := this.ExtraKeyboardsAppGui.Add("Button", "Default w80 ym+1", "Import profile")
        exportProfileButton := this.ExtraKeyboardsAppGui.Add("Button", "Default w80 ym+1", "Export profile")
        

        editProfilesButton.OnEvent("Click", (*) =>  this.EditProfiles())
        addProfileButton.OnEvent("Click", (*) => this.AddProfile())
        importProfileButton.OnEvent("Click", (*) => this.ImportProfile())
        exportProfileButton.OnEvent("Click", (*) => this.exportProfile())
              
        
        pathToKeyboardsIniFile := this.PATH_TO_EXISTING_PROFILES . "\" . this.profilesDropDownMenu.Text . "\Keyboards.ini"
        pathToObjectsIniFile := this.PATH_TO_EXISTING_PROFILES . "\" . this.profilesDropDownMenu.Text . "\ClassObjects.ini"


        this.CreateTabs(pathToKeyboardsIniFile, pathToObjectsIniFile)
        
        
        this.ExtraKeyboardsAppGui.Show()
    }

    CreateProfilesDropDownMenu(){
        
        ; If for some reason a profile is not selected, then select the first one.
        if (this.currentProfileIndex == -1)
        {
            msgbox("error, profile not found, selecting first existing profile")

            ; Creates a drop down list of all the profiles, and sets the current profile to the active profile
            profilesDropDownMenu := this.ExtraKeyboardsAppGui.Add("DropDownList", "ym+1 Choose" . this.currentProfileIndex, this.ExistingProfilesManager.getFolderNames())
            profilesDropDownMenu.Value := 1
            this.currentProfile := profilesDropDownMenu.Text
        }
        else{
            ; Creates a drop down list of all the profiles, and sets the current profile to the active profile
            profilesDropDownMenu := this.ExtraKeyboardsAppGui.Add("DropDownList", "ym+1 Choose" . this.currentProfileIndex, this.ExistingProfilesManager.getFolderNames())
        }

        profilesDropDownMenu.OnEvent("Change", (*) => this.ProfileChangedFromDropDownMenuEvent(profilesDropDownMenu))
        
        return profilesDropDownMenu
    }

    ProfileChangedFromDropDownMenuEvent(profilesDropDownMenu){
        iniWrite(profilesDropDownMenu.Text, this.PATH_TO_META_FILE, "General", "activeUserProfile")
        ; TODO after changing profile, need to reload EVERYTHING, or perhaps not.
        Run("*RunAs " this.PATH_TO_MAIN_SCRIPT)
        ; todo do something else
        reload
    }

    CreateTabs(pathToKeyboardsIniFile, pathToObjectsIniFile){
        
        Tab := this.ExtraKeyboardsAppGui.AddTab3("ys+20 xm", ["Keyboards","Change Functions Settings","Documentation"])
        Tab.UseTab(1)

        this.CreateTreeViewWithAssociatedListViewFromIniFile(pathToKeyboardsIniFile)

        Tab.UseTab(2)
        this.CreateTreeViewWithAssociatedListViewFromIniFile(pathToObjectsIniFile)

        Tab.UseTab(3)
        this.CreateDocumentationTab()

        Tab.UseTab(0)  ; i.e. subsequently-added controls will not belong to the tab control.
    }

    CreateTreeViewWithAssociatedListViewFromIniFile(iniFilePath){
        treeViewElement := TreeViewFromIniFile(iniFilePath)
        treeViewElement.CreateTreeView(this.ExtraKeyboardsAppGui)
        
        listViewElement := ListViewFromIniFileContent()
        listViewElement.CreateListView(this.ExtraKeyboardsAppGui, ["Key","Value"], iniFilePath)
        
        CreateListViewItems := ObjBindMethod(listViewElement, "SetNewListViewItemsByIniFileSection", iniFilePath)
        treeViewElement.AddEventAction("ItemSelect", CreateListViewItems)

    }

    CreateDocumentationTab(){
        this.ExtraKeyboardsAppGui.Add("Edit", "vMyEdit r20")  ; r20 means 20 rows tall.
    }

    EditProfiles(*){
        
        editProfilesGui := Gui()
    
        editProfilesGui.OnEvent("Close", (*) => editProfilesGui.Destroy())
    
        editProfilesGui.Opt("+Resize +MinSize320x240")
        editProfilesGui.Add("Text", , "Selected Profile:")
        profilesToEditDropDownMenu := editProfilesGui.Add("DropDownList", "ym Choose" . this.currentProfileIndex, this.ExistingProfilesManager.getFolderNames())
        
        renameProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Change profile name")

        renameProfileButton.OnEvent("Click", (*) => 
            
            this.RenameProfile(profilesToEditDropDownMenu.Text)
            this.UpdateProfileDropDownMenu(profilesToEditDropDownMenu)
            this.UpdateProfileDropDownMenu(this.profilesDropDownMenu)
    
        )
    
        ; TODO should ask the user if they are really sure they want to delete the profile
        deleteProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Delete profile")
        deleteProfileButton.OnEvent("Click", (*) =>
            this.DeleteProfile(profilesToEditDropDownMenu)
        )
    
        editProfilesGui.Show()
    }
    
    RenameProfile(currentProfile){
        inputPrompt := InputBox("Please write the new name for the profile!", "Edit object value",, currentProfile)
    
        if inputPrompt.Result = "Cancel"{
            ; Do nothing
        }
        else if(inputPrompt.Value = ""){
            ; Do Nothing
        }
        else{
    
            if (this.ExistingProfilesManager.RenameFolder(currentProfile, inputPrompt.Value)){
                ; Changed profile name succesfully
                iniWrite(inputPrompt.Value, this.PATH_TO_META_FILE, "General", "activeUserProfile")
            }
            else{
                msgbox("failed to change profile name, perhaps name already exists or illegal characters were used.")
            }
        }
    } 
    
    DeleteProfile(profilesDropDownMenu){
        inputPrompt := InputBox("Are you sure you want to delete this profile? Deleted profiles cannot be resuscitated. Type yes to confirm", "Edit object value",, profilesDropDownMenu.Text)
    
        if inputPrompt.Result = "Cancel"{
            ; Do nothing
        }
        else if(inputPrompt.Value = ""){
            ; Do Nothing
        }
        else if (StrLower(inputPrompt.Value) = "yes"){
    
            if (this.ExistingProfilesManager.DeleteFolder(profilesDropDownMenu.Text)){
                ; Deleted profile succesfully
                iniWrite(inputPrompt.Value, this.PATH_TO_META_FILE, "General", "activeUserProfile")
                
                this.UpdateProfileDropDownMenu(this.profilesDropDownMenu)
                this.UpdateProfileDropDownMenu(profilesDropDownMenu)
            }
            else{
                msgbox("failed to delete profile")
            }
        }
    }
    
    AddProfile(){
        addProfileGui := Gui()
    
        addProfileGui.OnEvent("Close", (*) => addProfileGui.Destroy())
    
        addProfileGui.Opt("+Resize +MinSize320x240")
    
        addPresetProfileButton := addProfileGui.Add("Button", "Default w80 xm+1", "Add preset profile")
        addPresetProfileButton.OnEvent("Click", (*) => this.AddPresetProfile())
    
        addCustomProfileButton := addProfileGui.Add("Button", "Default w80 ym+1", "Add custom profile")
        addCustomProfileButton.OnEvent("Click", (*) => this.AddCustomProfile())
        
        addProfileGui.Show()
    }

    AddPresetProfile(){
        presetProfileAddingGui := Gui()
        presetProfileAddingGui.Opt("+Resize +MinSize160x120")
        presetProfileAddingGui.Add("Text", , "Selected Profile:")
        
        customProfilesDropDownMenu := presetProfileAddingGui.Add("DropDownList", "ym+1 Choose1", this.PresetProfilesManager.getFolderNames())
        addProfileButton := presetProfileAddingGui.Add("Button", "Default w80 ym+1", "Add profile")
        cancelButton := presetProfileAddingGui.Add("Button", "Default w80 ym+1", "Cancel")

        addProfileButton.onEvent("Click", (*) => 
            
            this.AddPresetProfileAddButtonClickedEvent(customProfilesDropDownMenu)
            presetProfileAddingGui.Destroy()

        )
        
        cancelButton.onEvent("Click", (*) => 
            presetProfileAddingGui.Destroy()
        )

        presetProfileAddingGui.Show()

    }

    AddPresetProfileAddButtonClickedEvent(dropDownMenuGui){
        presetProfileName := dropDownMenuGui.Text 
        presetProfilePath := this.PresetProfilesManager.getFolderPathByName(presetProfileName)

        this.ExistingProfilesManager.CopyFolderToNewLocation(presetProfilePath, this.PATH_TO_EXISTING_PROFILES . "\" . presetProfileName, presetProfileName, presetProfileName)
        this.UpdateProfileDropDownMenu(this.profilesDropDownMenu)
    }

    AddCustomProfileAddButtonClickedEvent(profileNameField){
        profileName := profileNameField.Text
        profilePath := this.PATH_TO_EXISTING_PROFILES . "\" . profileName

        try{
            this.ExistingProfilesManager.CopyFolderToNewLocation(this.PATH_TO_EMPTY_PROFILE, profilePath, "EmptyProfile", profileName)
            this.UpdateProfileDropDownMenu(this.profilesDropDownMenu)
        }
        catch{
            msgbox("failed to add profile, perhaps name already exists or illegal characters were used.")
        }
    }

    AddCustomProfile(){        
        
        customProfileAddingGui := Gui()
        customProfileAddingGui.Opt("+Resize +MinSize160x120")
        customProfileAddingGui.Add("Text", , "Selected Profile:")

        customProfileAddingGui.Add("Text", "ym+1", "Name of profile to add:")
        profileNameField := customProfileAddingGui.Add("Edit", "r1 ym+1", "")
        addProfileButton := customProfileAddingGui.Add("Button", "Default w80 ym+1", "Add profile")
        cancelButton := customProfileAddingGui.Add("Button", "Default w80 ym+1", "Cancel")

        addProfileButton.onEvent("Click", (*) => 
            
            this.AddCustomProfileAddButtonClickedEvent(profileNameField)
            customProfileAddingGui.Destroy()

        )
        
        cancelButton.onEvent("Click", (*) => 
            customProfileAddingGui.Destroy()
        )

        customProfileAddingGui.Show()
        
    }

    UpdateProfileDropDownMenu(guiObject){
        guiObject.Delete()
        guiObject.Add(this.ExistingProfilesManager.getFolderNames())
        guiObject.Choose(this.ExistingProfilesManager.getMostRecentlyAddedFolder())
    }
}