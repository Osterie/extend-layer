#Requires AutoHotkey v2.0

#Include ".\editprofiles\EditorView.ahk"
#Include ".\addprofiles\AddProfileDialog.ahk"
#Include ".\ProfileImporter.ahk"
#Include ".\ProfileExporter.ahk"

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

    ; Used to import profiles
    ProfileImporter_ := ""
    ; Used to export profiles
    ProfileExporter_ := ""


    __New(view){
        this.view := view 

        this.ExistingProfilesManager := FolderManager()
        this.PresetProfilesManager := FolderManager()

        this.PresetProfilesManager.addSubFoldersToRegistryFromFolder(FilePaths.GetPathToPresetProfiles())
        this.PresetProfilesManager.addFolderToRegistry("EmptyProfile", FilePaths.GetPathToEmptyProfile())
        this.ExistingProfilesManager.addSubFoldersToRegistryFromFolder(FilePaths.GetPathToProfiles())

        this.ProfileImporter_ := ProfileImporter(this.ExistingProfilesManager)
        this.ProfileExporter_ := ProfileExporter(this.ExistingProfilesManager)

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

    doImportProfile(){
        this.ProfileImporter_.importProfile()
        this.view.UpdateProfilesDropDownMenu()
    }

    doExportProfile(){
        this.ProfileExporter_.exportProfile()
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