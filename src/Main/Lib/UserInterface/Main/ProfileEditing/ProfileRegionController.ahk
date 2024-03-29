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
        ; Guard condition
        msgbox(profileToAdd)
        msgbox(profileName)
        if (this.ExistingProfilesManager.hasFolder(profileName)){
            msgbox("Failed to add profile. A profile with the given name already exists")
            return
        }
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

    ; TODO this methods is way too long..
    doImportProfile(){
        selectedFilePath := FileSelect("D", , "Choose a location to save profile",)
        ; Guard condition
        if selectedFilePath = ""{
            ; Canceled
            return
        }
        if (!this.profileIsValid(selectedFilePath)){
            msgbox("The folder you selected is not a valid profile.")
            return
        }
        try{
            folderName := this.getEndOfPath(selectedFilePath)
            if (this.ExistingProfilesManager.CopyFolderToNewLocation(selectedFilePath, FilePaths.GetPathToProfiles() . "/" . folderName, folderName)){
                msgbox("Successfully imported profile " . folderName)
                this.view.UpdateProfilesDropDownMenu()
            }
            else{
                msgbox("Failed to import profile, perhaps a profile with the given name already exists")
            }
        }
        catch Error as e{
            MsgBox("Failed to import profile")
        }
    }

    ; TODO create a helper class for this
    getEndOfPath(path){
        parts := StrSplit(path, "\")
        return parts[parts.length]
    }

    ; TODO create a helper class for this
    profileIsValid(profilePath){
        validProfile := false
        filesToBeFound := 2
        amountOfFilesToLookFor := 2
        Loop Files (profilePath . "\*"){
            subFolderName := A_LoopFileName
            if (subFolderName = "Keyboards.json" || subFolderName = "ClassObjects.ini"){
                filesToBeFound--
            }
            amountOfFilesToLookFor -= 1
            if (amountOfFilesToLookFor = 0){
                break
            }
        }
        if (filesToBeFound = 0){
            validProfile := true
        }
        else{
            validProfile := false
        }
        return validProfile
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