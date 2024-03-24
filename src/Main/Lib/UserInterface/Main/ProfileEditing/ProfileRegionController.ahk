#Requires AutoHotkey v2.0

#Include ".\EditProfiles\EditorView.ahk"
#Include ".\AddProfiles\AddProfileDialog.ahk"

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FolderManager>

class ProfileRegionController{

    model := ""
    view := ""

    editView := ""


    addprofileView := ""

    __New(model, view){
        this.model := model
        this.view := view 
    }

    CreateView(guiObject){
        this.view.CreateView(guiObject, this)
    }

    GetProfiles(){
        return this.model.getProfiles()
    }

    GetCurrentProfileIndex(){
        return this.model.getCurrentProfileIndex()
    }

    GetCurrentProfile(){
        return this.model.getCurrentProfile()
    }

    doOpenEditProfileView(){
        this.editView := EditorView(this.GetHwnd())
        this.editView.CreateView(this)
    }

    HandleRenameProfile(profileToRename, inputPrompt){
        if inputPrompt.Result = "Cancel"{
            msgbox("Cancelled renaming profile")
            ; Do nothing
        }
        else if(inputPrompt.Value = ""){
            msgbox("No new name for profile given, cancelling")
            ; Do Nothing
        }
        else{
            if(this.model.renameProfile(profileToRename, inputPrompt.Value)){
                this.view.UpdateProfilesDropDownMenu()
                this.editView.UpdateProfilesDropDownMenu()
                msgbox("Successfully renamed profile to " . inputPrompt.Value)
            }
        }
    }

    HandleDeleteProfile(profileToDelete, inputPrompt){
        if inputPrompt.Result = "Cancel"{
            msgbox("Cancelled deleting profile")
            ; Do nothing
        }
        else if (StrLower(inputPrompt.Value) = "yes"){
            if (this.model.deleteProfile(profileToDelete)){
                this.view.UpdateProfilesDropDownMenu()
                this.editView.UpdateProfilesDropDownMenu()
                msgbox("Successfully deleted profile " . profileToDelete)
            }
            else{
                msgbox("Failed to delete profile " . profileToDelete)
            }
        }
        else if(inputPrompt.Value != "yes"){
            msgbox("You did not write 'yes', profile not deleted")
        }
    }

    doOpenAddProfileDialog(){
        this.addprofileView := AddProfileDialog(this.GetHwnd())
        this.addprofileView.CreateView(this.model.GetPresetProfiles())
        this.addProfileView.SubscribeToProfileAddedEvent(ObjBindMethod(this, "HandleAddProfileConfirmedEvent"))
        this.addprofileView.Show()
    }

    HandleAddProfileConfirmedEvent(profileToAdd, profileName){
        if (this.model.addProfile(profileToAdd, profileName)){
            this.view.UpdateProfilesDropDownMenu()
            this.addprofileView.Destroy()
            msgbox("Successfully added profile " . profileName)
        }
        else{
            msgbox("Failed to add profile, perhaps a profile with the given name already exists")
        }
    }

    UpdateProfileDropDownMenu(){
        this.view.Delete()
        this.view.Add(this.ExistingProfilesManager.getFolderNames())
        this.view.Choose(this.currentProfile)
    }

    GetHwnd(){
        return this.view.GetHwnd()
    }
}



; ; Used to manage the preset user profiles, the user is only allowed to add a preset profile as a new profile
; PresetProfilesManager := ""
; ; Used to manage the existing user profiles, the user is allowed to edit, delete, and add new profiles
; ExistingProfilesManager := ""
; ; A constant which is the path to the preset profiles

; ; TODO dont need these
; PATH_TO_EMPTY_PROFILE := ""
; PATH_TO_PRESET_PROFILES := ""
; PATH_TO_EXISTING_PROFILES := ""
; PATH_TO_META_FILE := ""
; currentProfile := ""
; ; Gui part
; profilesDropDownMenu := ""

; profiles := ""

; guiObject := ""


;     __New(guiObject){

;         this.guiObject := guiObject
;         this.PATH_TO_META_FILE := FilePaths.GetPathToMetaFile()
;         this.PATH_TO_EXISTING_PROFILES := FilePaths.GetPathToProfiles()
;         this.PATH_TO_EMPTY_PROFILE := FilePaths.GetPathToEmptyProfile()
;         this.PATH_TO_PRESET_PROFILES := FilePaths.GetPathToPresetProfiles()


;         this.ExistingProfilesManager := FolderManager()
;         this.PresetProfilesManager := FolderManager()

;         this.PresetProfilesManager.addSubFoldersToRegistryFromFolder(this.PATH_TO_PRESET_PROFILES)
;         this.PresetProfilesManager.addFolderToRegistry("EmptyProfile", this.PATH_TO_EMPTY_PROFILE)
;         this.ExistingProfilesManager.addSubFoldersToRegistryFromFolder(this.PATH_TO_EXISTING_PROFILES)

;         this.currentProfile := iniRead(this.PATH_TO_META_FILE, "General", "activeUserProfile")

;         this.profiles := this.ExistingProfilesManager.getFolderNames()


;     }

;     updateProfiles(){
;         this.profiles := this.ExistingProfilesManager.getFolderNames()
;     }

;     getGuiObject(){
;         return this.guiObject
;     }

;     getProfiles(){
;         return this.profiles
;     }

;     getPresetProfiles(){
;         return this.PresetProfilesManager.getFolderNames()
;     }

;     getCurrentProfileIndex(){
;         currentProfileIndex := -1
;         Loop this.profiles.Length{
;             if (this.profiles[A_Index] = FilePaths.GetCurrentProfile()){
;                 currentProfileIndex := A_Index
;             }
;         }
;         return currentProfileIndex
;     }

;     renameProfile(profileName, newProfileName){
;         renamedSuccesfully := false
        
;         if (this.ExistingProfilesManager.RenameFolder(profileName, newProfileName)){
;             this.updateProfiles()
;             if (profileName = this.currentProfile){
;                 this.setCurrentProfile(newProfileName)
;             }

;             renamedSuccesfully := true
;         }
;         else{
;             msgbox("failed to change profile name, perhaps name already exists or illegal characters were used.")
;             renamedSuccesfully := false
;         }
;         return renamedSuccesfully
;     }

;     DeleteProfile(profileToDelete){

;         deletedProfile := false

;         if (this.ExistingProfilesManager.DeleteFolder(profileToDelete)){
;             ; Deleted profile succesfully
;             this.updateProfiles()
;             if (this.profiles.Length != 0){
;                 if (profileToDelete = this.currentProfile){
;                     this.setCurrentProfile(this.profiles[1])
;                 }
;             }

;             deletedProfile := true

;         }
;         else{
;             deletedProfile := false
;         }
;         return deletedProfile
;     }

;     AddProfile(profile, profileName){
;         profileAdded := false
;         if (this.hasProfile(profileName)){
;             profileAdded := false
;         }
;         else{
;             try{
;                 presetProfileName := profileName
;                 profilePath := this.PresetProfilesManager.getFolderPathByName(profile)
;                 this.ExistingProfilesManager.CopyFolderToNewLocation(profilePath, this.PATH_TO_EXISTING_PROFILES . "\" . profileName, profileName, profileName)
;                 profileAdded := true
;                 this.updateProfiles()
;             }
;             catch{
;                 profileAdded := false
;             }
;         }
;         return profileAdded
;     }

;     getCurrentProfile(){
;         return this.currentProfile
;     }


;     hasProfile(profileName){
;         hasProfile := false
;         Loop this.profiles.Length{
;             if (this.profiles[A_Index] = profileName){
;                 hasProfile := true
;             }
;         }
;         return hasProfile
;     }

;     UpdateProfileDropDownMenu(guiObject){
;         guiObject.Delete()
;         guiObject.Add(this.ExistingProfilesManager.getFolderNames())
;         guiObject.Choose(this.currentProfile)
;     }



;     ; ProfileChangedFromDropDownMenuEvent(profilesDropDownMenu){
;     ;     iniWrite(profilesDropDownMenu.Text, this.PATH_TO_META_FILE, "General", "activeUserProfile")
;     ; }



 
; }