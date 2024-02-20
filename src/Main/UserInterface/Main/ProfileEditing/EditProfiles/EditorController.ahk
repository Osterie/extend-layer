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

    HandleRenameProfileButtonClickEvent(dropDownList, *){
        profileSelected := dropDownList.Text
        profileSelectedIndex := dropDownList.Value
        this.model.setCurrentProfile(profileSelected, profileSelectedIndex)
        this.view.CreateRenameProfileInputBox(this, this.getCurrentProfile())
    }

    RenameProfile(inputPrompt){
        if inputPrompt.Result = "Cancel"{
            ; Do nothing
        }
        else if(inputPrompt.Value = ""){
            ; Do Nothing
        }
        else{
    
            this.model.renameProfile(this.getCurrentProfile(), inputPrompt.Value)
        }
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