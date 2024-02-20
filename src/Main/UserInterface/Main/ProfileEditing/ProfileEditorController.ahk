#Requires AutoHotkey v2.0

#Include <FoldersAndFiles\FolderManager>

#Include ".\EditProfiles\EditorController.ahk"
#Include ".\EditProfiles\EditorModel.ahk"
#Include ".\EditProfiles\EditorView.ahk"

class ProfileEditorController{

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

    model := ""
    view := ""
    callback := ""

    __New(model, view, callback){
        this.model := model
        this.view := view 
        this.callback := callback
    }

    CreateView(){
        guiObject := this.model.getGuiObject()
        this.view.CreateView(guiObject, this)
    }

    GetProfiles(){
        return this.model.getProfiles()
    }

    GetCurrentProfileIndex(){
        return this.model.getCurrentProfileIndex()
    }

    HandleProfileChangedEvent(dropDownList, *){
        profileSelected := dropDownList.Text
        profileSelectedIndex := dropDownList.Value
        this.UpdateModelProfileValues(profileSelected, profileSelectedIndex)

        this.WriteToFileCurrentProfile(profileSelected)
        this.callback()
    }

    UpdateModelProfileValues(profile, profileIndex){
        this.model.setCurrentProfile(profile, profileIndex)
    }

    WriteToFileCurrentProfile(currentProfile){
        PATH_TO_META_FILE := this.model.getPathToMetaFile()
        ; TODO perhaps create a class for writing to these sorts of files, so i dont have the "General" and "activeUserProfile" part here.
        iniWrite(currentProfile, PATH_TO_META_FILE, "General", "activeUserProfile")
    }

    HandleEditProfilesEvent(*){
        editModel := EditorModel(this.GetProfiles(), this.GetCurrentProfileIndex())
        editView := EditorView()
        editController := EditorController(editModel, editView)
        editController.CreateView()
    }


    EditProfiles(*){
        
        editProfilesGui := Gui()
    
        editProfilesGui.OnEvent("Close", (*) => editProfilesGui.Destroy())
    
        editProfilesGui.Opt("+Resize +MinSize320x240")
        editProfilesGui.Add("Text", , "Selected Profile:")
        ; profilesToEditDropDownMenu := editProfilesGui.Add("DropDownList", "ym Choose" . this.currentProfileIndex, this.ExistingProfilesManager.getFolderNames())
        
        ; ; TODO bug with change profile name or something, changes user.
        ; renameProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Change profile name")

        ; renameProfileButton.OnEvent("Click", (*) => 
            
        ;     this.RenameProfile(profilesToEditDropDownMenu.Text)
        ;     this.UpdateProfileDropDownMenu(profilesToEditDropDownMenu)
        ;     this.UpdateProfileDropDownMenu(this.profilesDropDownMenu)
    
        ; )
    
        ; ; TODO should ask the user if they are really sure they want to delete the profile
        ; deleteProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Delete profile")
        ; deleteProfileButton.OnEvent("Click", (*) =>
        ;     this.DeleteProfile(profilesToEditDropDownMenu)
        ; )
    
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
        guiObject.Choose(this.currentProfile)
    }

}