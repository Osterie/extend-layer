#Requires AutoHotkey v2.0

#Include <ui\Util\DomainSpecificGui>

class EditorView extends DomainSpecificGui{

    controller := ""
    profilesToEditDropDownMenu := ""

    __New(ownerHwnd := ""){
        Super.__New("+Resize +MinSize320x240", "Profiles Editor")
        this.SetOwner(ownerHwnd)
    }

    CreateView(controller){

        this.controller := controller
        
        this.Add("Text", , "Selected Profile:")

        this.profilesToEditDropDownMenu := this.Add("DropDownList", "ym Choose" . controller.GetCurrentProfileIndex(), controller.GetProfiles())

        renameProfileButton := this.Add("Button", "Default w80 xm+1", "Change profile name")
        renameProfileButton.OnEvent("Click", (*) => this.CreateRenameProfileInputBox())
    
        deleteProfileButton := this.Add("Button", "w80 xm+1", "Delete profile")
        deleteProfileButton.OnEvent("Click", (*) => this.CreateDeleteProfileInputBox())
        this.Show()
    }
    
    ; TODO pretty identical to createdeleteprofielinputbox
    CreateRenameProfileInputBox(){
        profileToRename := this.profilesToEditDropDownMenu.Text
        inputPrompt := InputBox("Please write the new name for the profile! `n Original profile name: " . profileToRename, "Change name of profile",, profileToRename)
        this.controller.HandleRenameProfile(profileToRename, inputPrompt)
    } 

    CreateDeleteProfileInputBox(){
        profileToDelete := this.profilesToEditDropDownMenu.Text
        inputPrompt := InputBox("Are you sure you want to delete the profile named '" . profileToDelete .  "'? Deleted profiles cannot be resuscitated. Type yes to confirm", "Delete profile",, profileToDelete)
        this.controller.doDeleteProfile(profileToDelete, inputPrompt)
    }

    UpdateProfilesDropDownMenu(){
        profiles := this.controller.getProfiles()
        currentProfileIndex := this.controller.getCurrentProfileIndex()
        this.profilesToEditDropDownMenu.Delete()
        this.profilesToEditDropDownMenu.Add(profiles)
        try{
            this.profilesToEditDropDownMenu.Value := currentProfileIndex
        }
    }
}