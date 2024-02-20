#Requires AutoHotkey v2.0

class EditorView{

    CreateView(controller, profiles, currentProfileIndex){
        
        editProfilesGui := Gui("+Resize +MinSize320x240")
    
        ; editProfilesGui.OnEvent("Close", (*) => editProfilesGui.Destroy())
    
        editProfilesGui.Add("Text", , "Selected Profile:")
        profilesToEditDropDownMenu := editProfilesGui.Add("DropDownList", "ym Choose" . currentProfileIndex, profiles)
        
        ; TODO bug with change profile name or something, changes user.
        renameProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Change profile name")

        renameProfileButton.OnEvent("Click", ObjBindMethod(controller, "HandleRenameProfileEvent", profilesToEditDropDownMenu))
    
        ; TODO should ask the user if they are really sure they want to delete the profile
        deleteProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Delete profile")
        deleteProfileButton.OnEvent("Click", (*) =>
            this.DeleteProfile(profilesToEditDropDownMenu)
        )
    
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
    
}