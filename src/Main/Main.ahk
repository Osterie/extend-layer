; AUTHOR: Adrian Gjøsund Bjørge
; Github: https://github.com/Osterie

; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
#Requires Autohotkey v2.0

#Include <Prototyping\Array>
#Include <Prototyping\Map>

#Include <Startup\MainStartupConfigurator>

#Include <Infrastructure\Repositories\ActionGroupsRepository>
#Include <Infrastructure\Repositories\ExtendLayerProfile\ExtendLayerProfileRepository>

#Include <Shared\Logger>
#Include <Shared\FilePaths>

#Include <Util\ExtendLayerInProtectedLocationDialog>

#Include <ui\ExtraKeyboardsApplicationLauncher>

testFilePermissions() {
    testFile := A_ScriptDir . "\testFilePermissions.txt"

    ; This function is used to test if the script has the right permissions to read/write files.
    ; It will throw an error if it does not have the right permissions.
    try {
        if (FileExist(testFile)) {
            FileDelete(testFile)
        }
        FileAppend("test", testFile)
        FileDelete(testFile)
    }
    catch Error as e {
        if (InStr(e.Message, "Access is denied")) {
            if (!A_IsAdmin) {
                ExtendLayerInProtectedLocationDialog_ := ExtendLayerInProtectedLocationDialog()
                ExtendLayerInProtectedLocationDialog_.show()
                WinWaitClose(ExtendLayerInProtectedLocationDialog_.GetHwnd())
                ExitApp
            }
            else {
                Logger.getInstance().logError("Error reading/writing file: " e.Message, e.File, e.Line)
            }
        }
        else {
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

class Main {

    StartupConfigurator := MainStartupConfigurator()
    ActionGroupsRepository := ActionGroupsRepository.getInstance()

    scriptRunning := false

    __New() {
    }

    ; Main method used to start the script.
    start() {
        try {
            this.runLogicalStartup()
        }
        catch Error as e {
            MsgBox("Error in running startup: " e.Message " " e.Line " " e.File " " e.Extra " " e.Stack " " e.What)
        }
        finally {
            this.runAppGui()
            this.scriptRunning := true
        }
    }

    runLogicalStartup() {
        if (this.scriptRunning) {
            this.setHotkeysForAllLayers(false)
            this.ActionGroupsRepository.reset()
            ExtendLayerProfileRepository.getInstance().load()
            this.StartupConfigurator := MainStartupConfigurator() ; Reinitialize the configurator to reset the state
            ; TODO probably needs to be destroyed...
        }
        this.runMainStartup()
    }

    runMainStartup(enableHotkeys := true) {
        this.setHotkeysForAllLayers(enableHotkeys)
    }

    setHotkeysForAllLayers(enableHotkeys := true) {
        this.StartupConfigurator.createGlobalHotkeysForAllKeyboardOverlays()

        ; Reads and initializes all the hotkeys which are active for every keyboard layer.
        this.StartupConfigurator.initializeLayer("GlobalLayer", enableHotkeys)

        HotIf "MainScript.getActiveLayer() == 0"
        ; Reads and initializes all the hotkeys for the normal keyboard layer.
        this.StartupConfigurator.initializeLayer("NormalLayer", enableHotkeys)
        HotIf

        HotIf "MainScript.getActiveLayer() == 1"
        ; Reads and initializes all the hotkeys for the second keyboard layer.
        this.StartupConfigurator.initializeLayer("SecondaryLayer", enableHotkeys)
        HotIf

        HotIf "MainScript.getActiveLayer() == 2"
        ; Reads and initializes all the hotkeys for the third keyboard layer.
        this.StartupConfigurator.initializeLayer("TertiaryLayer", enableHotkeys)
        HotIf
    }

    runAppGui() {
        app := ExtraKeyboardsApplicationLauncher(this)
        app.start()
    }

    getActiveLayer() {
        layerController := this.ActionGroupsRepository.getActionObjectInstance("layers")
        return layerController.getActiveLayer()
    }
}

#SuspendExempt
^!s:: Suspend  ; Ctrl+Alt+S
#SuspendExempt False

MainScript := Main()
MainScript.start()

; These are needed here so the HotIf statements can be used in the Main class
#HotIf MainScript.getActiveLayer() == 0
#HotIf

#HotIf MainScript.getActiveLayer() == 1
#HotIf

#HotIf MainScript.getActiveLayer() == 2
#HotIf

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000