; AUTHOR: Adrian Gjøsund Bjørge
; Github: https://github.com/Osterie

; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
#Requires Autohotkey v2.0

#Include <Prototyping\Array>
#Include <Prototyping\Map>

#Include <ui\ExtraKeyboardsApplicationLauncher>

#Include <Util\ExtendLayerInProtectedLocationDialog>

#Include <Shared\Logger>

#Include <Startup\ObjectRegistryInitializer>

#Include <Util\MetaInfo\MetaInfoReading\KeyboardLayersInfoJsonReader>

#Include <DataModels\Actions\ActionGroupRegistry>
#Include <Shared\FilePaths>

testFilePermissions(){
    testFile := A_ScriptDir . "\testFilePermissions.txt"

    ; This function is used to test if the script has the right permissions to read/write files.
    ; It will throw an error if it does not have the right permissions.
    try{
        if (FileExist(testFile)){
            FileDelete(testFile)
        }
        FileAppend("test", testFile)
        FileDelete(testFile)
    }
    catch Error as e{
        if (InStr(e.Message, "Access is denied")){
            if (!A_IsAdmin){
                ExtendLayerInProtectedLocationDialog_ := ExtendLayerInProtectedLocationDialog()
                ExtendLayerInProtectedLocationDialog_.show()
                WinWaitClose(ExtendLayerInProtectedLocationDialog_.GetHwnd())
                ExitApp
            }
            else{
                Logger.getInstance().logError("Error reading/writing file: " e.Message, e.File, e.Line)
            }
        }
        else{
            Logger.getInstance().logError("Error reading/writing file: " e.Message, e.File, e.Line)
        }
    }
}

testFilePermissions()


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



Class Main{

    StartupConfigurator := ""
    ActionGroupRegistry := ActionGroupRegistry()
    KeyboardLayersInfoRegister := KeyboardLayersInfoRegistry()

    scriptRunning := false

    __New(){
    }

    ; Main method used to start the script.
    Start(){
        try{
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
        if (this.scriptRunning){
            this.ActionGroupRegistry.destroyObjectInstances()
            this.SetHotkeysForAllLayers(false)
            this.StartupConfigurator := ""
            this.ActionGroupRegistry := ActionGroupRegistry()
            ; TODO probably needs to be destroyed...
            this.KeyboardLayersInfoRegister := KeyboardLayersInfoRegistry()
        }
        this.Initialize()
        this.RunMainStartup()
    }

    Initialize(){
        this.InitializeObjectRegistry()
        this.InitializeKeyboardLayersInfo()
        this.InitializeMainStartupConfigurator()
    }

    RunMainStartup(enableHotkeys := true){
        this.CreateKeyboardOverlays()
        this.SetHotkeysForAllLayers(enableHotkeys)
    }

    InitializeObjectRegistry(){
        objectRegisterInitializer := ObjectRegistryInitializer()
        objectRegisterInitializer.InitializeObjectRegistry()
        this.ActionGroupRegistry := objectRegisterInitializer.GetObjectRegistry()
    }

    InitializeKeyboardLayersInfo(){
        JsonReaderForKeyboardLayersInfo := KeyboardLayersInfoJsonReader()
        JsonReaderForKeyboardLayersInfo.ReadKeyboardLayersInfoForCurrentProfile()
        this.KeyboardLayersInfoRegister := JsonReaderForKeyboardLayersInfo.getKeyboardLayersInfoRegister()
    }

    InitializeMainStartupConfigurator(){
        ; This is used to read ini files, and create hotkeys from them
        this.StartupConfigurator := MainStartupConfigurator()

        this.StartupConfigurator.setInformation(this.KeyboardLayersInfoRegister, this.ActionGroupRegistry)
    }
    
    CreateKeyboardOverlays(){
        ; Reads and initializes all keyboard overlays, based on how they are created in the ini file
        this.StartupConfigurator.readAllKeyboardOverlays()
    }

    SetHotkeysForAllLayers(enableHotkeys := true){
        this.StartupConfigurator.createGlobalHotkeysForAllKeyboardOverlays()

        ; Reads and initializes all the hotkeys which are active for every keyboard layer.
        this.StartupConfigurator.initializeLayer(this.KeyboardLayersInfoRegister, this.ActionGroupRegistry,  "GlobalLayer", enableHotkeys)
        
        HotIf "MainScript.getLayerController().getActiveLayer() == 0"
            ; Reads and initializes all the hotkeys for the normal keyboard layer.
            this.StartupConfigurator.initializeLayer(this.KeyboardLayersInfoRegister, this.ActionGroupRegistry, "NormalLayer", enableHotkeys)
        HotIf
        
        HotIf "MainScript.getLayerController().getActiveLayer() == 1"
            ; Reads and initializes all the hotkeys for the second keyboard layer.
            this.StartupConfigurator.initializeLayer(this.KeyboardLayersInfoRegister, this.ActionGroupRegistry, "SecondaryLayer", enableHotkeys)
        HotIf
        
        HotIf "MainScript.getLayerController().getActiveLayer() == 2"
            ; Reads and initializes all the hotkeys for the third keyboard layer.
            this.StartupConfigurator.initializeLayer(this.KeyboardLayersInfoRegister, this.ActionGroupRegistry, "TertiaryLayer", enableHotkeys)
        HotIf
    }

    RunAppGui(){
        app := ExtraKeyboardsApplicationLauncher(this.ActionGroupRegistry, this.KeyboardLayersInfoRegister, this)
        app.Start()
    }

    getLayerController(){
        return this.ActionGroupRegistry.getActionGroup("layers").GetObjectInstance()
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

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000