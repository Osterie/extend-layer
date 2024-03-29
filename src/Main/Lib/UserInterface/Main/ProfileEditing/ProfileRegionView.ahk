#Requires AutoHotkey v2.0


class ProfileRegionView{

    ; Gui part
    profilesDropDownMenu := ""

    controller := ""

    profileChangedEventSubscribers := Array()

    guiHwnd := ""

    CreateView(guiObject, controller){

        this.controller := controller

        guiObject.Add("Text", , "Current Profile:")

        profiles := controller.getProfiles()
        currentProfileIndex := controller.getCurrentProfileIndex()
        this.profilesDropDownMenu := this.createProfilesDropDownMenu(guiObject, profiles, currentProfileIndex)
        
        this.profilesDropDownMenu.OnEvent("Change", (*) => this.NotifyListenersProfileChanged(this.profilesDropDownMenu.Text))


        editProfilesButton := guiObject.Add("Button", "Default w80 ym+1", "Edit profiles")
        addProfileButton := guiObject.Add("Button", "Default w80 ym+1", "Add profile")
        importProfileButton := guiObject.Add("Button", "Default w80 ym+1", "Import profile")
        exportProfileButton := guiObject.Add("Button", "Default w80 ym+1", "Export profile")
        

        editProfilesButton.OnEvent("Click", (*) =>  ObjBindMethod(controller, "doOpenEditProfileView")())
        addProfileButton.OnEvent("Click", (*) =>  ObjBindMethod(controller, "doOpenAddProfileDialog")())
        importProfileButton.OnEvent("Click", (*) =>  ObjBindMethod(controller, "doImportProfile")())
        exportProfileButton.OnEvent("Click", (*) =>  ObjBindMethod(controller, "doExportProfile")())

        this.guiHwnd := guiObject.GetHwnd()
              
        guiObject.Show()
    }

    NotifyListenersProfileChanged(newProfileName){
        for (event in this.profileChangedEventSubscribers){
            event(newProfileName)
        }
    }

    SubscribeToProfileChangedEvent(event){
        this.profileChangedEventSubscribers.Push(event)
    }

    UpdateProfilesDropDownMenu(){
        this.profilesDropDownMenu.Delete()
        this.profilesDropDownMenu.Add(this.controller.getProfiles())
        try{
            this.profilesDropDownMenu.Value := this.controller.getCurrentProfileIndex()
        }
    }

    CreateProfilesDropDownMenu(guiObject, profiles, profileIndex){
        
        ; If for some reason a profile is not selected, then select the first one.
        if (profileIndex == -1)
        {
            msgbox("error, profile not found, selecting first existing profile")

            ; Creates a drop down list of all the profiles, and sets the current profile to the active profile
            profilesDropDownMenu := guiObject.Add("DropDownList", "ym+1 Choose" . profileIndex, profiles)

            if(profiles.Length != 0){
                profilesDropDownMenu.Value := 1
            }
        }
        else{
            ; Creates a drop down list of all the profiles, and sets the current profile to the active profile
            profilesDropDownMenu := guiObject.Add("DropDownList", "ym+1 Choose" . profileIndex, profiles)
        }

        return profilesDropDownMenu
    }

    GetHwnd(){
        return this.guiHwnd
    }
}