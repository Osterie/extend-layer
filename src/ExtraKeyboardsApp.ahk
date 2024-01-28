#Requires AutoHotkey v2.0
#Include ".\UserInterface\ExtraKeyboardsAppgui.ahk"
; #Include ".\Main.ahk"

; |--------------------------------------------------|
; |------------------- OPTIMIZATIONS ----------------|
; |--------------------------------------------------|

#SingleInstance Force ; skips the dialog box and replaces the old instance automatically
A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
KeyHistory 0
ListLines(False)
SetKeyDelay(-1, -1)
SetMouseDelay(-1)
SetDefaultMouseSpeed(0)
SetWinDelay(-1)
SetControlDelay(-1)
SetWorkingDir(A_ScriptDir)
ProcessSetPriority "High"
; Not changing SendMode defaults it to "input", which makes hotkeys super mega terrible (super)
SendMode "Event"


Class ExtraKeyboardsApp{
    
    UserInterface := ""
    MainScript := ""

    __New(jsonObject, activeObjectsRegistry,  keyboardLayersInfoRegister){

        pathToExistingProfiles := "..\config\UserProfiles"
        pathToPresetProfiles := "..\config\PresetProfiles"
        pathToMetaFile := "..\config\meta.ini"
        pathToMainScript := A_ScriptDir "\..\src\Main.ahk"
        pathToEmptyProfile := "..\config\EmptyProfile"
        this.UserInterface := ExtraKeyboardsAppgui(pathToExistingProfiles, pathToPresetProfiles, pathToMetaFile, pathToMainScript, pathToEmptyProfile, jsonObject, activeObjectsRegistry, keyboardLayersInfoRegister)
    }

    Start(){
        this.UserInterface.CreateMain()
    }

    getExtraKeyboardsAppgui(){
        return this.UserInterface
    }
}