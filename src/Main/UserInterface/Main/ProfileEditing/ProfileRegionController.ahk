#Requires AutoHotkey v2.0

#Include <FoldersAndFiles\FolderManager>

#Include ".\EditProfiles\EditorView.ahk"
#Include ".\EditProfiles\EditorModel.ahk"

class ProfileRegionController{

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


    editView := ""
    editModel := ""

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

    GetCurrentProfile(){
        return this.model.getCurrentProfile()
    }

    HandleProfileChangedEvent(dropDownList, *){
        profileSelected := dropDownList.Text
        profileSelectedIndex := dropDownList.Value

        this.model.setCurrentProfile(profileSelected, profileSelectedIndex)
        this.callback()
    }

    HandleEditProfilesEvent(*){
        this.CreateEditorView()
    }

    CreateEditorView(){
        profiles := this.getProfiles()
        currentProfileIndex := this.getCurrentProfileIndex()
    
        this.editModel := EditorModel(profiles, currentProfileIndex)
        this.editView := EditorView()
        this.editView.CreateView(this, this.editModel)
    }

    HandleRenameProfileButtonClickEvent(*){
        this.editView.CreateRenameProfileInputBox()
    }

    HandleRenameProfile(profileToRename, inputPrompt){
        if inputPrompt.Result = "Cancel"{
            ; Do nothing
        }
        else if(inputPrompt.Value = ""){
            ; Do Nothing
        }
        else{
            this.model.renameProfile(profileToRename, inputPrompt.Value)
            this.editModel.SetProfiles(this.model.getProfiles())
            this.view.UpdateProfilesDropDownMenu(this)
            this.editView.UpdateProfilesDropDownMenu()
        }
    }

    HandleDeleteProfile(profilesDropDownMenu){
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


}