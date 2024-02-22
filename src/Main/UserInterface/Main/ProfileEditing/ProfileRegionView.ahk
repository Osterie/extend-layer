#Requires AutoHotkey v2.0


class ProfileRegionView{

    ; Gui part
    profilesDropDownMenu := ""

    controller := ""

    CreateView(guiObject, controller){

        this.controller := controller

        guiObject.Add("Text", , "Current Profile:")

        profiles := controller.getProfiles()
        currentProfileIndex := controller.getCurrentProfileIndex()
        this.profilesDropDownMenu := this.createProfilesDropDownMenu(guiObject, profiles, currentProfileIndex)
        
        this.profilesDropDownMenu.OnEvent("Change", ObjBindMethod(controller, "HandleProfileChangedEvent"))
        

        editProfilesButton := guiObject.Add("Button", "Default w80 ym+1", "Edit profiles")
        addProfileButton := guiObject.Add("Button", "Default w80 ym+1", "Add profile")
        importProfileButton := guiObject.Add("Button", "Default w80 ym+1", "Import profile")
        exportProfileButton := guiObject.Add("Button", "Default w80 ym+1", "Export profile")
        

        editProfilesButton.OnEvent("Click", (*) =>  ObjBindMethod(controller, "HandleEditProfilesEvent")())
        ; addProfileButton.OnEvent("Click", (*) =>  ObjBindMethod(controller, "HandleAddProfileEvent")())
        ; importProfileButton.OnEvent("Click", (*) =>  ObjBindMethod(controller, "HandleImportProfileEvent")())
        ; exportProfileButton.OnEvent("Click", (*) =>  ObjBindMethod(controller, "HandleExportProfileEvent")())

              
        guiObject.Show()
    }

    UpdateProfilesDropDownMenu(){
        this.profilesDropDownMenu.Delete()
        this.profilesDropDownMenu.Add(this.controller.getProfiles())
        this.profilesDropDownMenu.Value := this.controller.getCurrentProfileIndex()
    }


    CreateProfilesDropDownMenu(guiObject, profiles, profileIndex){
        
        ; If for some reason a profile is not selected, then select the first one.
        if (profileIndex == -1)
        {
            msgbox("error, profile not found, selecting first existing profile")

            ; Creates a drop down list of all the profiles, and sets the current profile to the active profile
            profilesDropDownMenu := guiObject.Add("DropDownList", "ym+1 Choose" . profileIndex, profiles)
            profilesDropDownMenu.Value := 1
        }
        else{
            ; Creates a drop down list of all the profiles, and sets the current profile to the active profile
            profilesDropDownMenu := guiObject.Add("DropDownList", "ym+1 Choose" . profileIndex, profiles)
        }

        return profilesDropDownMenu
    }

    getProfilesDropDownMenu(){
        return this.profilesDropDownMenu
    }
}