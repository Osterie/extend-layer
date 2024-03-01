#Requires AutoHotkey v2.0

class EditorView{

    controller := ""
    model := ""

    editProfilesGui := ""
    profilesToEditDropDownMenu := ""

    CreateView(controller, model){

        this.controller := controller
        this.model := model
        
        this.editProfilesGui := Gui("+Resize +MinSize320x240")
        this.editProfilesGui.Add("Text", , "Selected Profile:")

        this.profilesToEditDropDownMenu := this.editProfilesGui.Add("DropDownList", "ym Choose" . model.GetCurrentProfileIndex(), model.GetProfiles())
        this.profilesToEditDropDownMenu.OnEvent("Change", (*) => ObjBindMethod(model, "SetCurrentProfile", this.profilesToEditDropDownMenu.Text)())

        renameProfileButton := this.editProfilesGui.Add("Button", "Default w80 xm+1", "Change profile name")
        renameProfileButton.OnEvent("Click", (*) => ObjBindMethod(this.controller, "HandleRenameProfileButtonClickEvent")())
    
        deleteProfileButton := this.editProfilesGui.Add("Button", "Default w80 xm+1", "Delete profile")
        deleteProfileButton.OnEvent("Click", (*) => ObjBindMethod(this.controller, "HandleDeleteProfileButtonClickEvent")())
    
        this.editProfilesGui.Show()
    }
    
    CreateRenameProfileInputBox(){
        inputPrompt := InputBox("Please write the new name for the profile!", "Edit object value",, this.model.getCurrentProfile())
        this.controller.HandleRenameProfile(this.model.getCurrentProfile(), inputPrompt)
    } 

    CreateDeleteProfileInputBox(){
        inputPrompt := InputBox("Are you sure you want to delete this profile? Deleted profiles cannot be resuscitated. Type yes to confirm", "Edit object value",, this.model.getCurrentProfile())
        this.controller.HandleDeleteProfile(inputPrompt)
    }

    UpdateProfilesDropDownMenu(){
        profiles := this.model.getProfiles()
        currentProfileIndex := this.model.getCurrentProfileIndex()
        this.profilesToEditDropDownMenu.Delete()
        this.profilesToEditDropDownMenu.Add(profiles)
        try{
            this.profilesToEditDropDownMenu.Value := currentProfileIndex
        }
        
    }
    
}