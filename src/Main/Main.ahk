; AUTHOR: Adrian Gjøsund Bjørge
; Github: https://github.com/Osterie

; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
#Requires Autohotkey v2.0

#Include "<UserInterface\ExtraKeyboardsApp>"

#Include <Util\StartupConfiguration\ObjectRegistryInitializer>

#Include <Util\MetaInfo\MetaInfoReading\KeyNamesReader>
#Include <Util\MetaInfo\MetaInfoReading\ObjectsJsonReader>
#Include <Util\MetaInfo\MetaInfoReading\KeyboardLayersInfoJsonReader>

#Include <Util\MetaInfo\MetaInfoStorage\Objects\ObjectRegistry>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>

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

    layersInformation := ""

    ObjectRegister := ObjectRegistry()
    KeyboardLayersInfoRegister := KeyboardLayersInfoRegistry()
    StartupConfigurator := ""

    keyNames := ""

    __New(){

    }

    ; Main method used to start the script.
    Start(){
        try{
            this.RunLogicalStartup()
            this.RunAppGui()
        }
        catch Error as e{
            MsgBox("Error in running startup: " e.Message)
            this.RunAppGui()
        }
    }

    RunLogicalStartup(){
        ; this.UpdatePathsToInfo()
        this.InitializeMetaInfo()
        this.RunMainStartup()
    }

    UpdatePathsToInfo(){
        try{
            ; Try to read the information for the current profile.
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
            this.layersInformation := jxon_load(&keyboardSettingsString)
        }
        catch{
            ; Unable to read information for the current profile, so we use default to an empty profile.
            FilePaths.SetCurrentProfile("Empty")
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
            this.layersInformation := jxon_load(&keyboardSettingsString)
        }
    }

    InitializeMetaInfo(){
        this.InitializeObjectRegistry()
        this.ReadKeyboardLayersInfoForCurrentProfile()
        this.ReadKeyNamesFromTxtFile()
    }

    RunMainStartup(enableHotkeys := true){
        this.InitializeMainStartupConfigurator()
        this.ReadAndMakeKeyboardOverlays()
        this.InitializeHotkeysForAllLayers(enableHotkeys)
    }

    InitializeMainStartupConfigurator(){
        ; This is used to read ini files, and create hotkeys from them
        this.StartupConfigurator := MainStartupConfigurator(this.KeyboardLayersInfoRegister, this.ObjectRegister)
    }
    
    ReadAndMakeKeyboardOverlays(){
        ; Reads and initializes all keyboard overlays, based on how they are created in the ini file
        this.StartupConfigurator.ReadAllKeyboardOverlays()
    }

    InitializeHotkeysForAllLayers(enableHotkeys := true){
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

    InitializeObjectRegistry(){
        objectRegisterInitializer := ObjectRegistryInitializer()
        objectRegisterInitializer.InitializeObjectRegistry()
        this.ObjectRegister := objectRegisterInitializer.GetObjectRegistry()
    }

    ReadKeyboardLayersInfoForCurrentProfile(){
        JsonReaderForKeyboardLayersInfo := KeyboardLayersInfoJsonReader()
        JsonReaderForKeyboardLayersInfo.ReadKeyboardLayersInfoForCurrentProfile()
        this.KeyboardLayersInfoRegister := JsonReaderForKeyboardLayersInfo.getKeyboardLayersInfoRegister()
    }

    ReadKeyNamesFromTxtFile(){
        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(FilePaths.GetPathToKeyNames(), "rw" , "UTF-8")
        this.keyNames := keyNamesFileObjReader.ReadKeyNamesFromTextFileObject(fileObjectOfKeyNames).GetKeyNames()

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