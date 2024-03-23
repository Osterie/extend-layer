#Requires AutoHotkey v2.0

#Include <UserInterface\Main\Util\DomainSpecificGui>

class AddProfilesView extends DomainSpecificGui{

    addProfileButton := ""

    __New(ownerHwnd := ""){
        Super.__New("+Resize +MinSize320x240", "Add Profile")
        this.SetOwner(ownerHwnd)
    }

    CreateView(controller, profiles){

        this.Add("Text", , "Selected Profile:")
        customProfilesDropDownMenu := this.Add("DropDownList", "ym+1 Choose1", profiles)

        this.Add("Text", "ym+1", "Name of profile to add:")
        profileNameField := this.Add("Edit", "r1 ym+1", "")
        profileNameField.OnEvent("Change", (*) => this.HandleInputFieldChange(profileNameField.Text))

        this.addProfileButton := this.Add("Button", "Default w80 ym+1", "Add profile")
        this.addProfileButton.OnEvent("Click", (*) => controller.HandleAddProfileConfirmedEvent(customProfilesDropDownMenu.Text, profileNameField.Text))
        this.DisableAddProfileButton()


        cancelButton := this.Add("Button", "Default w80 ym+1", "Cancel")
        cancelButton.OnEvent("Click", (*) => this.Destroy())
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