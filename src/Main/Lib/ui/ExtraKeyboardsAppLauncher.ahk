#Requires AutoHotkey v2.0
#Include <ui\ExtraKeyboardsAppGui>
#Include <ui\ExtraKeyboardsAppguiController>
#Include <ui\ExtraKeyboardsAppguiModel>

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


Class ExtraKeyboardsAppLauncher{
    
    UserInterface := ""

    __New(activeObjectsRegistry, keyboardLayersInfoRegister, mainScript){
        this.Model := ExtraKeyboardsAppGuiModel(activeObjectsRegistry, keyboardLayersInfoRegister)
        this.UserInterface := ExtraKeyboardsAppGui()
        this.Controller := ExtraKeyboardsAppGuiController(this.Model, this.UserInterface, mainScript)
    }

    Start(){
        this.UserInterface.CreateMain(this.Controller)
    }

    getExtraKeyboardsAppgui(){
        return this.UserInterface
    }
}