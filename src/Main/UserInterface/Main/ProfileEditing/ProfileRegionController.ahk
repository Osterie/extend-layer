#Requires AutoHotkey v2.0

#Include <FoldersAndFiles\FolderManager>

#Include ".\EditProfiles\EditorView.ahk"
#Include ".\EditProfiles\EditorModel.ahk"
#Include ".\AddProfiles\AddProfilesView.ahk"

class ProfileRegionController{

    ; Used to manage the preset user profiles, the user is only allowed to add a preset profile as a new profile
    PresetProfilesManager := ""
    ; Used to manage the existing user profiles, the user is allowed to edit, delete, and add new profiles
    ExistingProfilesManager := ""
    ; A constant which is the path to the preset profiles

    currentProfile := ""
    currentProfileIndex := ""

    ; Gui part
    profilesDropDownMenu := ""

    model := ""
    view := ""
    callback := ""


    editView := ""
    editModel := ""


    addprofileView := ""
    addprofileModel := ""

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

    HandleRenameProfileButtonClickEvent(){
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
            this.view.UpdateProfilesDropDownMenu()
            this.editView.UpdateProfilesDropDownMenu()
        }
    }

    HandleDeleteProfileButtonClickEvent(){
        this.editView.CreateDeleteProfileInputBox()
    }

    HandleDeleteProfile(inputPrompt){
        if inputPrompt.Result = "Cancel"{
            ; Do nothing
        }
        else if(inputPrompt.Value = ""){
            ; Do Nothing
        }
        else if (StrLower(inputPrompt.Value) = "yes"){
    
            this.model.deleteProfile(this.editModel.getCurrentProfile())
            this.editModel.SetProfiles(this.model.getProfiles())
            this.view.UpdateProfilesDropDownMenu()
            this.editView.UpdateProfilesDropDownMenu()
        }
    }

    HandleAddProfileEvent(){
        this.addprofileView := AddProfilesView()
        this.addprofileView.CreateView(this, this.model)
    }

    HandleAddProfileConfirmedEvent(profileToAdd, profileName){
        if (this.model.addProfile(profileToAdd, profileName)){
            this.addprofileView.Destroy()
        }
        else{
            msgbox("Failed to add profile, perhaps a profile with the given name already exists")
        }

    }
}