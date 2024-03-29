#Requires AutoHotkey v2.0

#Include ".\EditProfiles\EditorView.ahk"
#Include ".\AddProfiles\AddProfileDialog.ahk"

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FolderManager>

class ProfileRegionController{

    view := ""

    editView := ""


    addprofileView := ""

    ; Used to manage the preset user profiles, the user is only allowed to add a preset profile as a new profile
    PresetProfilesManager := ""
    ; Used to manage the existing user profiles, the user is allowed to edit, delete, and add new profiles
    ExistingProfilesManager := ""
    

    __New(view){
        this.view := view 

        this.ExistingProfilesManager := FolderManager()
        this.PresetProfilesManager := FolderManager()

        this.PresetProfilesManager.addSubFoldersToRegistryFromFolder(FilePaths.GetPathToPresetProfiles())
        this.PresetProfilesManager.addFolderToRegistry("EmptyProfile", FilePaths.GetPathToEmptyProfile())
        this.ExistingProfilesManager.addSubFoldersToRegistryFromFolder(FilePaths.GetPathToProfiles())

    }

    CreateView(guiObject){
        this.view.CreateView(guiObject, this)
    }

    GetProfiles(){
        return this.ExistingProfilesManager.getFolderNames()
    }
    
    getPresetProfiles(){
        return this.PresetProfilesManager.getFolderNames()
    }

    getCurrentProfileIndex(){
        currentProfileIndex := -1
        profiles := this.getProfiles()
        Loop profiles.Length{
            
            if (profiles[A_Index] = FilePaths.GetCurrentProfile()){
                currentProfileIndex := A_Index
            }
        }
        return currentProfileIndex
    }

    GetCurrentProfile(){
        return FilePaths.GetCurrentProfile()
    }

    doOpenEditProfileView(){
        this.editView := EditorView(this.GetHwnd())
        this.editView.CreateView(this)
    }

    HandleRenameProfile(profileToRename, inputPrompt){
        newProfileName := inputPrompt.Value
        inputPromptResult := inputPrompt.Result

        if (inputPromptResult = "Cancel"){
            msgbox("Cancelled renaming profile")
            ; Do nothing
        }
        else if(newProfileName = ""){
            msgbox("No new name for profile given, cancelling")
            ; Do Nothing
        }
        else{
            
            if(this.ExistingProfilesManager.RenameFolder(profileToRename, newProfileName )){
                FilePaths.SetCurrentProfile(newProfileName)
                this.view.UpdateProfilesDropDownMenu()
                this.editView.UpdateProfilesDropDownMenu()
                msgbox("Successfully renamed profile to " . newProfileName)
            }
            else{
                msgbox("failed to change profile name, perhaps name already exists or illegal characters were used.")
            }
        }
    }

    DoDeleteProfile(profileToDelete, inputPrompt){
        inputPromptResult := inputPrompt.Result


        if (inputPromptResult = "Cancel"){
            msgbox("Cancelled deleting profile")
            ; Do nothing
        }
        else if (StrLower(inputPrompt.Value) = "yes"){
            
            if (this.ExistingProfilesManager.DeleteFolder(profileToDelete)){
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
        this.addprofileView.CreateView(this.GetPresetProfiles())
        this.addProfileView.SubscribeToProfileAddedEvent(ObjBindMethod(this, "doAddProfile"))
        this.addprofileView.Show()
    }

    doAddProfile(profileToAdd, profileName){
        if (this.ExistingProfilesManager.hasFolder(profileName)){
            msgbox("Failed to add profile. A profile with the given name already exists")
        }
        else{
            try{
                profilePath := this.PresetProfilesManager.getFolderPathByName(profileToAdd)
                this.ExistingProfilesManager.CopyFolderToNewLocation(profilePath, FilePaths.GetPathToProfiles() . "/" . profileName, profileName)
                this.view.UpdateProfilesDropDownMenu()
                this.addprofileView.Destroy()
                msgbox("Successfully added profile " . profileName)
            }
            catch{
                msgbox("Failed to add profile, perhaps a profile with the given name already exists")
            }
        }
    }

    doImportProfile(){

        ; TODO check if the profile already exists
        ; TODO check if the profile has a keyboards.json and ClassObjects.ini file.
        selectedFilePath := FileSelect("D", , "Choose a location to save profile",)
        if selectedFilePath = ""{
            ; Canceled
        }
        else{
            try{
                filesFoundWhichShouldBeFound := 0
                amountOfFilesToFind := 2
                Loop Files (selectedFilePath . "\*"){
                    subFolderName := A_LoopFileName
                    if (subFolderName = "keyboards.json" || subFolderName = "ClassObjects.ini"){
                        filesFoundWhichShouldBeFound++
                    }
                    amountOfFilesToFind -= 1
                    if (amountOfFilesToFind = 0){
                        break
                    }
                }
                if (filesFoundWhichShouldBeFound := 2){
                    parts := StrSplit(selectedFilePath, "\")
                    folderName := parts[parts.length]
                    if (this.ExistingProfilesManager.CopyFolderToNewLocation(selectedFilePath, FilePaths.GetPathToProfiles() . "/" . folderName, folderName)){
                        msgbox("Successfully imported profile " . folderName)
                        this.view.UpdateProfilesDropDownMenu()
                    }
                    else{
                        msgbox("Failed to import profile, perhaps a profile with the given name already exists")
                    }
                }
                else{
                    msgbox("The folder you selected is not a valid profile.")
                }
            }
            catch Error as e{
                MsgBox("Failed to import rofile")
            }
        }
    }
    
    doExportProfile(){
        selectedFilePath := FileSelect("DS", , "Choose a location to save profile",)
        if selectedFilePath = ""{
            ; Canceled
        }
        else{
            
            try{
                profileName := FilePaths.GetCurrentProfile()
                profilePath := this.ExistingProfilesManager.getFolderPathByName(profileName)
                DirCopy(profilePath, selectedFilePath . "/" . profileName)
            }
            catch Error as e{
                MsgBox("Failed to export profile, perhaps because a folder of that name already exists in " . selectedFilePath)
            }
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