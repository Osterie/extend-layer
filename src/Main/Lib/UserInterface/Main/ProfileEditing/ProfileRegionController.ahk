#Requires AutoHotkey v2.0

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

        this.model.setCurrentProfile(profileSelected)
        this.callback()
    }

    HandleEditProfilesEvent(*){
        this.CreateEditorView()
    }

    CreateEditorView(){
        this.editModel := EditorModel(this.getProfiles(), this.getCurrentProfile())
        this.editView := EditorView()
        this.editView.CreateView(this, this.editModel)
    }

    HandleRenameProfileButtonClickEvent(){
        this.editView.CreateRenameProfileInputBox()
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
                this.editModel.SetProfiles(this.model.getProfiles())
                this.view.UpdateProfilesDropDownMenu()
                this.editView.UpdateProfilesDropDownMenu()
                msgbox("Successfully renamed profile to " . inputPrompt.Value)
            }
        }
    }

    HandleDeleteProfileButtonClickEvent(){
        this.editView.CreateDeleteProfileInputBox()
    }

    HandleDeleteProfile(inputPrompt){
        if inputPrompt.Result = "Cancel"{
            msgbox("Cancelled deleting profile")
            ; Do nothing
        }
        else if (StrLower(inputPrompt.Value) = "yes"){
            profileToDelete := this.editModel.getCurrentProfile()
            if (this.model.deleteProfile(profileToDelete)){
                this.editModel.SetProfiles(this.model.getProfiles())
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

    HandleAddProfileEvent(){
        this.addprofileView := AddProfilesView()
        this.addprofileView.CreateView(this, this.model)
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
}