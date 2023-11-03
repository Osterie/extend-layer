#Requires AutoHotkey v2.0
#Include ".\UserInterface\ExtraKeyboardsAppgui.ahk"

Class ExtraKeyboardsApp{
    
    UserInterface := ""
    __New(){
        pathToExistingProfiles := "..\config\UserProfiles"
        pathToPresetProfiles := "..\config\PresetProfiles"
        pathToMetaFile := "..\config\meta.ini"
        pathToMainScript := A_ScriptDir "\..\src\Main.ahk"
        this.UserInterface := ExtraKeyboardsAppgui(pathToExistingProfiles, pathToPresetProfiles, pathToMetaFile, pathToMainScript)
    }


    Start(){
        this.UserInterface.CreateMain()
    }
}

app := ExtraKeyboardsApp()
app.Start()