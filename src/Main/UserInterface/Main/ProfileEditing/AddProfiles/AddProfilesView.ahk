#Requires AutoHotkey v2.0

class AddProfilesView{

    controller := ""
    addProfileGui := ""

    CreateView(controller, model){

        this.controller := controller
        this.model := model

        this.addProfileGui := Gui("+Resize +MinSize320x240")
        
        this.addProfileGui.Add("Text", , "Selected Profile:")
        customProfilesDropDownMenu := this.addProfileGui.Add("DropDownList", "ym+1 Choose1", this.model.getPresetProfiles())


        this.addProfileGui.Add("Text", "ym+1", "Name of profile to add:")
        profileNameField := this.addProfileGui.Add("Edit", "r1 ym+1", "")
        addProfileButton := this.addProfileGui.Add("Button", "Default w80 ym+1", "Add profile")

        addProfileButton.OnEvent("Click", (*) => this.controller.HandleAddProfileConfirmedEvent(customProfilesDropDownMenu.Text, profileNameField.Text))
        
        cancelButton := this.addProfileGui.Add("Button", "Default w80 ym+1", "Cancel")
        cancelButton.OnEvent("Click", (*) => this.addProfileGui.Destroy())
        
        this.addProfileGui.Show()
    }
    
    Destroy(){
        this.addProfileGui.Destroy()
    }
}