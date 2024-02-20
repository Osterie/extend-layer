#Requires AutoHotkey v2.0

class EditorView{

    CreateView(controller, profiles, currentProfileIndex){
        
        editProfilesGui := Gui("+Resize +MinSize320x240")
        editProfilesGui.Add("Text", , "Selected Profile:")
        profilesToEditDropDownMenu := editProfilesGui.Add("DropDownList", "ym Choose" . currentProfileIndex, profiles)
        
        renameProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Change profile name")

        renameProfileButton.OnEvent("Click", ObjBindMethod(controller, "HandleRenameProfileButtonClickEvent", profilesToEditDropDownMenu, this))
    
        ; deleteProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Delete profile")
        ; deleteProfileButton.OnEvent("Click", (*) =>
        ;     this.DeleteProfile(profilesToEditDropDownMenu)
        ; )
    
        editProfilesGui.Show()
    }
    
    CreateRenameProfileInputBox(controller, currentProfile){
        inputPrompt := InputBox("Please write the new name for the profile!", "Edit object value",, currentProfile)
        
        controller.RenameProfile(inputPrompt)
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