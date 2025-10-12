#Requires AutoHotkey v2.0

#Include <ui\Util\DomainSpecificGui>

#Include <Infrastructure\Repositories\ExtendLayerProfileRepository>

; TODO refactor
class AddProfileDialog extends DomainSpecificGui{

    addProfileButton := ""
    profileAddedSubscribers := ""

    profileDescriptionInput := ""
    ExtendLayerProfileRepository := ExtendLayerProfileRepository(false)

    customProfilesDropDownMenu := ""
    profileNameField := ""

    __New(ownerHwnd := ""){
        this.profileAddedSubscribers := Array()
        Super.__New("+Resize", "Add Profile")
        this.SetFont("s10")
        this.SetOwner(ownerHwnd)
    }

    CreateView(profiles){

        this.Add("Text", "w150" , "Selected Profile:         ")
        this.customProfilesDropDownMenu := this.Add("DropDownList", "xp yp+25 Choose1", profiles)
        this.customProfilesDropDownMenu.OnEvent("Change", (*) => this.updateDescriptionInput())

        profileDescriptionInputLabel := this.Add("Text", "xp yp+50", "Profile Description:")
        this.profileDescriptionInput := this.Add("Edit", "xp w300 h200", this.ExtendLayerProfileRepository.getProfile(this.getProfileName()).getDescription())


        this.Add("Text", "w180 ym", "Name of profile to add:")
        this.profileNameField := this.Add("Edit", "r1 w180 xp yp+25", "")
        this.profileNameField.OnEvent("Change", (*) => this.HandleInputFieldChange(this.profileNameField.Text))

        this.addProfileButton := this.Add("Button", "Default w90 xp yp+50", "Add profile")
        this.addProfileButton.OnEvent("Click", (*) => this.addProfile())
        this.DisableAddProfileButton()

        cancelButton := this.Add("Button", "w90 yp ", "Cancel")
        cancelButton.OnEvent("Click", (*) => this.destroy())
    }

    SubscribeToProfileAddedEvent(event){
        this.profileAddedSubscribers.Push(event)
    }

    addProfile(){
        profile := this.getCurrentProfile()
        profile.setDescription(this.getDescription())
        Loop this.profileAddedSubscribers.Length{
            this.profileAddedSubscribers[A_Index](profile, this.getUserChosenProfileName())
        }
        this.destroy()
    }

    CreateSelectedProfileRegion(){
        
    }

    HandleInputFieldChange(profileNameFieldText){
        if (profileNameFieldText != ""){
            this.EnableAddProfileButton()
        } else {
            this.DisableAddProfileButton()
        }
    }

    DisableAddProfileButton(){
        this.addProfileButton.Opt("+Disabled")
    }

    EnableAddProfileButton(){
        this.addProfileButton.Opt("-Disabled")
    }
    
    getProfileName(){
        return this.customProfilesDropDownMenu.Text
    }

    getUserChosenProfileName(){
        return this.profileNameField.Text
    }

    getDescription(){
        return this.profileDescriptionInput.Text
    }

    getCurrentProfile(){
        return this.ExtendLayerProfileRepository.getProfile(this.getProfileName())
    }

    updateDescriptionInput() {
        profile := this.getCurrentProfile()
        this.profileDescriptionInput.Text := profile.getDescription()
    }
}