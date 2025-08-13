#Requires AutoHotkey v2.0

#Include <ui\Util\DomainSpecificGui>

; TODO refactor
class AddProfileDialog extends DomainSpecificGui{

    addProfileButton := ""
    profileAddedSubscribers := ""

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

        this.Add("Text", "w150 ym", "Name of profile to add:")
        this.profileNameField := this.Add("Edit", "r1 xp yp+25", "")
        this.profileNameField.OnEvent("Change", (*) => this.HandleInputFieldChange(this.profileNameField.Text))


        this.addProfileButton := this.Add("Button", "Default w80 xp yp+50", "Add profile")
        this.addProfileButton.OnEvent("Click", (*) => this.NotifyListenersProfileAdded())
        this.DisableAddProfileButton()

        cancelButton := this.Add("Button", "Default w80 yp ", "Cancel")
        cancelButton.OnEvent("Click", (*) => this.destroy())
    }

    SubscribeToProfileAddedEvent(event){
        this.profileAddedSubscribers.Push(event)
    }

    NotifyListenersProfileAdded(){
        Loop this.profileAddedSubscribers.Length{
            this.profileAddedSubscribers[A_Index](this.customProfilesDropDownMenu.Text, this.profileNameField.Text)
        }
        this.destroy()
    }

    ; CreateView(controller, profiles){

    ;     this.Add("Text", "w150" , "Selected Profile:         ")

    ;     customProfilesDropDownMenu := this.Add("DropDownList", "yp Choose1", profiles)

    ;     this.Add("Text", "w150 xm yp+50", "Name of profile to add:")
    ;     profileNameField := this.Add("Edit", "r1 yp", "")
    ;     profileNameField.OnEvent("Change", (*) => this.HandleInputFieldChange(profileNameField.Text))


    ;     this.addProfileButton := this.Add("Button", "Default w80 xp yp+50", "Add profile")
    ;     this.addProfileButton.OnEvent("Click", (*) => controller.HandleAddProfileConfirmedEvent(customProfilesDropDownMenu.Text, profileNameField.Text))
    ;     this.DisableAddProfileButton()

    ;     cancelButton := this.Add("Button", "Default w80 yp ", "Cancel")
    ;     cancelButton.OnEvent("Click", (*) => this.destroy())
    ; }

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


}