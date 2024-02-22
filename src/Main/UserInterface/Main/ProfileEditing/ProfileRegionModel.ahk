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
        this.PATH_TO_META_FILE := pathToMetaFile
        this.PATH_TO_EXISTING_PROFILES := pathToExistingProfiles
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
        iniWrite(this.currentProfile, this.PATH_TO_META_FILE, "General", "activeUserProfile")
    }

    renameProfile(profileName, newProfileName){
        renamedSuccesfully := false
        
        if (this.ExistingProfilesManager.RenameFolder(profileName, newProfileName)){
            if (profileName = this.currentProfile){
                this.setCurrentProfile(newProfileName, this.ExistingProfilesManager.getFirstFoundFolderIndex(newProfileName))
            }

            this.updateProfiles()
            renamedSuccesfully := true
        }
        else{
            msgbox("failed to change profile name, perhaps name already exists or illegal characters were used.")
            renamedSuccesfully := false
        }
        return renamedSuccesfully
    }

    DeleteProfile(profileToDelete){
        if (this.ExistingProfilesManager.DeleteFolder(profileToDelete)){
            ; Deleted profile succesfully
            if (profileToDelete = this.currentProfile){
                this.setCurrentProfile(this.profiles[1], 1)
            }
        }
        else{
            msgbox("failed to delete profile")
        }
    }

    getCurrentProfile(){
        return this.currentProfile
    }

    getCurrentProfileIndex(){
        return this.currentProfileIndex
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



 
}