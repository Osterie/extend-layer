#Requires AutoHotkey v2.0

#Include ".\EditProfiles\EditorView.ahk"
#Include ".\AddProfiles\AddProfilesView.ahk"

class ProfileRegionController{

    currentProfile := ""
    currentProfileIndex := ""

    ; Gui part
    profilesDropDownMenu := ""

    model := ""
    view := ""

    editView := ""


    addprofileView := ""

    __New(model, view){
        this.model := model
        this.view := view 
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
    }

    HandleEditProfilesEvent(*){
        this.CreateEditorView()
    }

    CreateEditorView(){
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

    HandleDeleteProfileButtonClickEvent(){
        this.editView.CreateDeleteProfileInputBox()
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

    HandleAddProfileEvent(){
        this.addprofileView := AddProfilesView(this.GetHwnd())
        this.addprofileView.CreateView(this, this.model.GetPresetProfiles())
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

    GetHwnd(){
        return this.model.getGuiObject().GetHwnd()
    }
}