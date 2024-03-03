#Requires AutoHotkey v2.0
#Include ".\UserInterface\ExtraKeyboardsAppguiView.ahk"
#Include ".\UserInterface\ExtraKeyboardsAppguiController.ahk"
#Include ".\UserInterface\ExtraKeyboardsAppguiModel.ahk"
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

    __New(keyboardLayerIdentifiers, activeObjectsRegistry, keyboardLayersInfoRegister, mainScript, keyNames){
        this.MainScript := mainScript
        this.Model := ExtraKeyboardsAppGuiModel(keyboardLayerIdentifiers, activeObjectsRegistry, keyboardLayersInfoRegister, keyNames)
        this.UserInterface := ExtraKeyboardsAppGuiView()
        this.Controller := ExtraKeyboardsAppGuiController(this.Model, this.UserInterface, keyboardLayersInfoRegister, mainScript)
    }

    Start(){
        this.UserInterface.CreateMain(this.Controller)
    }

    getExtraKeyboardsAppgui(){
        return this.UserInterface
    }
}