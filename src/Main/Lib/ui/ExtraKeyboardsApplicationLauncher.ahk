#Requires AutoHotkey v2.0
#Include <ui\ExtraKeyboardsApplication>
#Include <ui\ExtraKeyboardsApplicationController>
#Include <ui\ExtraKeyboardsApplicationModel>

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


Class ExtraKeyboardsApplicationLauncher{
    
    UserInterface := ""

    __New(activeObjectsRegistry, keyboardLayersInfoRegister, mainScript){
        this.Model := ExtraKeyboardsApplicationModel(activeObjectsRegistry, keyboardLayersInfoRegister)
        this.UserInterface := ExtraKeyboardsApplication()
        this.Controller := ExtraKeyboardsApplicationController(this.Model, this.UserInterface, mainScript)
    }

    Start(){
        this.UserInterface.CreateMain(this.Controller)
    }

    getExtraKeyboardsApplicationgui(){
        return this.UserInterface
    }
}