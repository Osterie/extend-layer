#Requires AutoHotkey v2.0

#Include <UserInterface\Main\Util\DomainSpecificGui>

class AddProfilesView extends DomainSpecificGui{

    controller := ""

    __New(ownerHwnd := ""){
        Super.__New("+Resize +MinSize320x240", "Add Profile")
        this.SetOwner(ownerHwnd)
    }

    CreateView(controller, profiles){

        this.controller := controller

        this.Add("Text", , "Selected Profile:")
        customProfilesDropDownMenu := this.Add("DropDownList", "ym+1 Choose1", profiles)


        this.Add("Text", "ym+1", "Name of profile to add:")
        profileNameField := this.Add("Edit", "r1 ym+1", "")
        addProfileButton := this.Add("Button", "Default w80 ym+1", "Add profile")

        addProfileButton.OnEvent("Click", (*) => this.controller.HandleAddProfileConfirmedEvent(customProfilesDropDownMenu.Text, profileNameField.Text))
        
        cancelButton := this.Add("Button", "Default w80 ym+1", "Cancel")
        cancelButton.OnEvent("Click", (*) => this.Destroy())
        
        this.Show()
    }
}