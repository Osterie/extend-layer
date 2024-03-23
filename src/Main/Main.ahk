﻿; AUTHOR: Adrian Gjøsund Bjørge
; Github: https://github.com/Osterie

; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
#Requires Autohotkey v2.0

#Include <Prototyping\Array>
#Include <Prototyping\Map>

#Include "<UserInterface\ExtraKeyboardsApp>"

#Include <Util\StartupConfiguration\ObjectRegistryInitializer>

#Include <Util\MetaInfo\MetaInfoReading\KeyNamesReader>
#Include <Util\MetaInfo\MetaInfoReading\ObjectsJsonReader>
#Include <Util\MetaInfo\MetaInfoReading\KeyboardLayersInfoJsonReader>

#Include <Util\MetaInfo\MetaInfoStorage\Objects\ObjectRegistry>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>

#Include <Util\MetaInfo\MetaInfoReading\ActionSettingsReader>

; |--------------------------------------------------|
; |------------------- OPTIMIZATIONS ----------------|
; |--------------------------------------------------|

#SingleInstance Force ; skips the dialog box and replaces the old instance automatically
A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
KeyHistory 100
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

; |----------------------------------------------------------|
; |---------------- Runs AHK script as Admin ----------------|
; |----------- Allows Excecuting Powershell Scripts ---------|
; |----- Also makes it possible to run powercfg and such ----|
; |----------------------------------------------------------|

; if (not A_IsAdmin){
;     ; "*RunAs*" is an option for the Run() function to run a program as admin
; 	Run("*RunAs `"" A_ScriptFullPath "`"") 
; }

; ------------Global or whatever stusff----------------


Class Main{

    keyNames := ""
    StartupConfigurator := ""
    ObjectRegister := ObjectRegistry()
    KeyboardLayersInfoRegister := KeyboardLayersInfoRegistry()

    scriptRunning := false

    __New(){
    }

    ; Main method used to start the script.
    Start(){
        try{
            if (this.scriptRunning){
                this.SetHotkeysForAllLayers(false)
            }
            ; TODO check if script is already running
            ; TODO if script is already running, show a message box and exit
            this.RunLogicalStartup()
        }
        catch Error as e{
            MsgBox("Error in running startup: " e.Message " " e.Line " " e.File " " e.Extra " " e.Stack " " e.What)
        }
        finally{
            this.RunAppGui()
            this.scriptRunning := true
        }
    }

    RunLogicalStartup(){
        this.Initialize()
        this.RunMainStartup()
    }

    Initialize(){
        this.InitializeObjectRegistry()
        this.InitializeKeyboardLayersInfo()
        this.InitializeKeyNames()
        this.InitializeMainStartupConfigurator()
    }

    RunMainStartup(enableHotkeys := true){
        this.CreateKeyboardOverlays()
        this.SetHotkeysForAllLayers(enableHotkeys)
    }

    InitializeObjectRegistry(){
        objectRegisterInitializer := ObjectRegistryInitializer()
        objectRegisterInitializer.InitializeObjectRegistry()
        this.ObjectRegister := objectRegisterInitializer.GetObjectRegistry()
    }

    InitializeKeyboardLayersInfo(){
        JsonReaderForKeyboardLayersInfo := KeyboardLayersInfoJsonReader()
        JsonReaderForKeyboardLayersInfo.ReadKeyboardLayersInfoForCurrentProfile()
        this.KeyboardLayersInfoRegister := JsonReaderForKeyboardLayersInfo.getKeyboardLayersInfoRegister()
    }

    InitializeKeyNames(){
        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(FilePaths.GetPathToKeyNames(), "rw" , "UTF-8")
        this.keyNames := keyNamesFileObjReader.ReadKeyNamesFromTextFileObject(fileObjectOfKeyNames).GetKeyNames()
    }

    InitializeMainStartupConfigurator(){
        ; This is used to read ini files, and create hotkeys from them
        this.StartupConfigurator := MainStartupConfigurator()

        this.StartupConfigurator.SetInformation(this.KeyboardLayersInfoRegister, this.ObjectRegister)
    }
    
    CreateKeyboardOverlays(){
        ; Reads and initializes all keyboard overlays, based on how they are created in the ini file
        this.StartupConfigurator.ReadAllKeyboardOverlays()
    }

    SetHotkeysForAllLayers(enableHotkeys := true){
        this.StartupConfigurator.CreateGlobalHotkeysForAllKeyboardOverlays()

        ; Reads and initializes all the hotkeys which are active for every keyboard layer.
        this.StartupConfigurator.InitializeLayer("GlobalLayer", enableHotkeys)
        
        HotIf "MainScript.getLayerController().getActiveLayer() == 0"
            ; Reads and initializes all the hotkeys for the normal keyboard layer.
            this.StartupConfigurator.InitializeLayer("NormalLayer", enableHotkeys)
        HotIf
        
        HotIf "MainScript.getLayerController().getActiveLayer() == 1"
            ; Reads and initializes all the hotkeys for the second keyboard layer.
            this.StartupConfigurator.InitializeLayer("SecondaryLayer", enableHotkeys)
        HotIf
        
        HotIf "MainScript.getLayerController().getActiveLayer() == 2"
            ; Reads and initializes all the hotkeys for the third keyboard layer.
            this.StartupConfigurator.InitializeLayer("TertiaryLayer", enableHotkeys)
        HotIf
    }

    RunAppGui(){
        app := ExtraKeyboardsApp(this.ObjectRegister, this.KeyboardLayersInfoRegister, this, this.keyNames)
        app.Start()
    }

    getLayerController(){
        return this.ObjectRegister.GetObjectInfo("layers").GetObjectInstance()
    }
}


#SuspendExempt
^!s::Suspend  ; Ctrl+Alt+S
#SuspendExempt False

MainScript := Main()
MainScript.Start()

; These are needed here so the HotIf statements can be used in the Main class
#HotIf MainScript.getLayerController().getActiveLayer() == 0
#HotIf

#HotIf MainScript.getLayerController().getActiveLayer() == 1
#HotIf

#HotIf MainScript.getLayerController().getActiveLayer() == 2 
#HotIf

; Shows key history, used for debugging
; b:: KeyHistory

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000


IsRunning(Path) {
    SetTitleMatchMode 2
    DetectHiddenWindows 1
    return !!WinExist(Path)
}