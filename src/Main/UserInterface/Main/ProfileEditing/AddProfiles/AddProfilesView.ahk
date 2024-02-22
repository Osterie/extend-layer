#Requires AutoHotkey v2.0

class AddProfilesView{

    controller := ""

    CreateView(controller, model){

        this.controller := controller
        this.model := model

        addProfileGui := Gui("+Resize +MinSize320x240")
        
        addProfileGui.Add("Text", , "Selected Profile:")
        customProfilesDropDownMenu := addProfileGui.Add("DropDownList", "ym+1 Choose1", this.model.getPresetProfiles())


        addProfileGui.Add("Text", "ym+1", "Name of profile to add:")
        profileNameField := addProfileGui.Add("Edit", "r1 ym+1", "")
        addProfileButton := addProfileGui.Add("Button", "Default w80 ym+1", "Add profile")
        
        cancelButton := addProfileGui.Add("Button", "Default w80 ym+1", "Cancel")
        cancelButton.OnEvent("Click", (*) => addProfileGui.Destroy())
        
        addProfileGui.Show()
    }
}