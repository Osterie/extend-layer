#Requires AutoHotkey v2.0

#Include <ui\Util\DomainSpecificGui>

#Include <Infrastructure\Repositories\ExtendLayerProfileRepository>
#Include <Infrastructure\Services\ExtendLayerProfileService>

class EditProfileDialog extends DomainSpecificGui{

    controller := ""
    profilesToEditDropDownMenu := ""
    profileDescriptionInput := ""
    ExtendLayerProfileRepository := ExtendLayerProfileRepository()
    ExtendLayerProfileService := ExtendLayerProfileService()

    __New(ownerHwnd := ""){
        Super.__New("+Resize +MinSize320x240", "Profiles Editor")
        this.SetOwner(ownerHwnd)
    }

    CreateView(controller){

        this.controller := controller
        
        this.Add("Text", "Section", "Selected Profile:")
        this.profilesToEditDropDownMenu := this.Add("DropDownList", "ym Choose" . controller.getCurrentProfileIndex(), controller.getProfiles())
        this.profilesToEditDropDownMenu.OnEvent("Change", (*) => this.updateDescriptionInput())
        
        profileDescriptionInputLabel := this.Add("Text", "xp", "Profile Description:")
        this.profileDescriptionInput := this.Add("Edit", "xp w300 h100", this.ExtendLayerProfileRepository.getProfile(this.getProfileName()).getDescription())
        
        renameProfileButton := this.Add("Button", "Default w80 xs ys+25", "Change profile name")
        renameProfileButton.OnEvent("Click", (*) => this.CreateRenameProfileInputBox())
        
        deleteProfileButton := this.Add("Button", "w80 xs yp+40", "Delete profile")
        deleteProfileButton.OnEvent("Click", (*) => this.CreateDeleteProfileInputBox())
        
        updateProfileDescriptionButton := this.Add("Button", "w80 xs yp+25", "Update description")
        updateProfileDescriptionButton.OnEvent("Click", (*) => this.updateProfileDescription())

        this.Show()
    }
    
    ; TODO pretty identical to createdeleteprofielinputbox
    CreateRenameProfileInputBox(){
        profileToRename := this.getProfileName()
        inputPrompt := InputBox("Please write the new name for the profile! `n Original profile name: " . profileToRename, "Change name of profile",, profileToRename)
        this.controller.HandleRenameProfile(profileToRename, inputPrompt)
    } 

    CreateDeleteProfileInputBox(){
        profileToDelete := this.getProfileName()
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

    updateDescriptionInput() {
        profile := this.getCurrentProfile()
        this.profileDescriptionInput.Text := profile.getDescription()
    }

    getCurrentProfile(){
        return this.ExtendLayerProfileRepository.getProfile(this.getProfileName())
    }

    getProfileName(){
        return this.profilesToEditDropDownMenu.Text
    }

    getDescription(){
        return this.profileDescriptionInput.Text
    }

    updateProfileDescription(){
        profile := this.getCurrentProfile()
        this.ExtendLayerProfileService.setDescription(profile, this.getDescription())

        ToolTip "Description updated!"
        SetTimer () => ToolTip(), -3000

    }
}