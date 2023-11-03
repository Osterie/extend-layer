#Requires AutoHotkey v2.0
#Include ".\UserInterface\ExtraKeyboardsAppgui.ahk"

Class ExtraKeyboardsApp{
    
    UserInterface := ""
    __New(){
        pathToExistingProfiles := "..\config\UserProfiles"
        pathToPresetProfiles := "..\config\PresetProfiles"
        this.UserInterface := ExtraKeyboardsAppgui(pathToExistingProfiles, pathToPresetProfiles)
    }


    Start(){
        this.UserInterface.CreateMain()
    }
}