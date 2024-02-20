#Requires AutoHotkey v2.0

#Include <FoldersAndFiles\FolderManager>

class ProfileRegionModel{

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

    profiles := ""

    guiObject := ""


    __New(guiObject, pathToMetaFile, pathToExistingProfiles){

        this.guiObject := guiObject
        ; this.jsonFileConents := jsonFileConents
        this.PATH_TO_META_FILE := pathToMetaFile
        this.PATH_TO_EXISTING_PROFILES := pathToExistingProfiles

        ; this.PATH_TO_MAIN_SCRIPT := pathToMainScript

        ; this.PATH_TO_EMPTY_PROFILE := pathToEmptyProfile


        this.ExistingProfilesManager := FolderManager()
        this.PresetProfilesManager := FolderManager()

        this.PresetProfilesManager.addSubFoldersToRegistryFromFolder(this.PATH_TO_PRESET_PROFILES)
        this.ExistingProfilesManager.addSubFoldersToRegistryFromFolder(this.PATH_TO_EXISTING_PROFILES)

        this.currentProfile := iniRead(this.PATH_TO_META_FILE, "General", "activeUserProfile")
        this.currentProfileIndex := this.ExistingProfilesManager.getFirstFoundFolderIndex(this.currentProfile)

        this.profiles := this.ExistingProfilesManager.getFolderNames()


    }

    updateProfiles(){
        this.profiles := this.ExistingProfilesManager.getFolderNames()
    }

    getGuiObject(){
        return this.guiObject
    }

    getProfiles(){
        return this.profiles
    }

    setCurrentProfile(profileName, profileIndex){
        this.currentProfile := profileName
        this.currentProfileIndex := profileIndex
    }

    renameProfile(currentProfileName, newProfileName){
        renamedSuccesfully := false
        
        if (this.ExistingProfilesManager.RenameFolder(currentProfileName, newProfileName)){
            renamedSuccesfully := true
            this.updateProfiles()
        }
        else{
            msgbox("failed to change profile name, perhaps name already exists or illegal characters were used.")
            renamedSuccesfully := false
        }
        return renamedSuccesfully
    }

    getCurrentProfile(){
        return this.currentProfile
    }

    getCurrentProfileIndex(){
        return this.ExistingProfilesManager.getFirstFoundFolderIndex(this.currentProfile)
    }

    getPathToMetaFile(){
        return this.PATH_TO_META_FILE
    }

    hasProfile(profileName){
        hasProfile := false
        Loop this.profiles.Length{
            if (this.profiles[A_Index] = profileName){
                hasProfile := true
            }
        }
        return hasProfile
    }

    UpdateProfileDropDownMenu(guiObject){
        guiObject.Delete()
        guiObject.Add(this.ExistingProfilesManager.getFolderNames())
        guiObject.Choose(this.currentProfile)
    }



    ; ProfileChangedFromDropDownMenuEvent(profilesDropDownMenu){
    ;     iniWrite(profilesDropDownMenu.Text, this.PATH_TO_META_FILE, "General", "activeUserProfile")
    ; }



    
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
                this.ProfileChangedFromDropDownMenuEvent(profilesDropDownMenu)
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



}