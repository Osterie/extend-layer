#Requires AutoHotkey v2.0

class EditorController{

    model := ""
    view := ""

    __New(model, view){
        this.model := model
        this.view := view 
    }

    CreateView(){
        profiles := this.getProfiles()
        currentProfileIndex := this.getCurrentProfileIndex()
        this.view.CreateView(this, profiles, currentProfileIndex)
    }

    HandleRenameProfileEvent(dropDownList, *){
        profileSelected := dropDownList.Text
        profileSelectedIndex := dropDownList.Value
        this.model.setCurrentProfile(profileSelected, profileSelectedIndex)
        this.view.RenameProfile(this.getCurrentProfile())
    }



    getProfiles(){
        return this.model.getProfiles()
    }
    
    getCurrentProfileIndex(){
        return this.model.getCurrentProfileIndex()
    }

    getCurrentProfile(){
        return this.model.getCurrentProfile()
    }
}