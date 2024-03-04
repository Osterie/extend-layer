﻿; AUTHOR: Adrian Gjøsund Bjørge
; Github: https://github.com/Osterie

; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
#Requires Autohotkey v2.0

#Include "<UserInterface\ExtraKeyboardsApp>"
#Include <Util\KeysPressedGui>
#Include <Actions\ProcessManager>
#Include <Actions\CommandPromptOpener>
#Include <Actions\Clock\CountdownDisplay>
#Include <Actions\IODevices\Mouse>
#Include <Actions\IODevices\Monitor>
#Include <Actions\IODevices\DeviceManager>
#Include <Actions\IODevices\ComputerInputController>
#Include <Actions\Privacy\ScreenPrivacyController>
#Include <Actions\Privacy\UnauthorizedUseDetector>
#Include <Actions\BatteryAndPower\BatteryController>
#Include <Util\KeyboardOverlay\KeyboardOverlay>
#Include <Util\KeyboardOverlay\KeyboardOverlayRegistry>
#Include <Actions\Navigation\WebNavigation\WebNavigator>
#Include <Actions\Navigation\FileNavigation\FileExplorerNavigator>
#Include <LayerIndication\LayerIndicatorController>
#Include <Util\StartupConfiguration\MainStartupConfigurator>

#Include <Util\MetaInfo\MetaInfoReading\ObjectsJsonReader>
#Include <Util\MetaInfo\MetaInfoReading\KeyboardLayersInfoJsonReader>
#Include <Util\MetaInfo\MetaInfoReading\KeyboadLayersInfoClassObjectReader>
#Include <Util\MetaInfo\MetaInfoReading\KeyNamesReader>



#Include <Util\MetaInfo\MetaInfoStorage\Objects\MethodInfo>
#Include <Util\MetaInfo\MetaInfoStorage\Objects\ObjectInfo>
#Include <Util\MetaInfo\MetaInfoStorage\Objects\MethodRegistry>
#Include <Util\MetaInfo\MetaInfoStorage\Objects\ObjectRegistry>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>

#Include <Util\JsonParsing\JXON\JXON>

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


; |-------------------------------------------|
; |----------- OBJECT CREATION ---------------|
; |-------------------------------------------|

Class Main{

    keyboardSettingsJsonObject := ""

    Objects := Map()
    ObjectRegister := ObjectRegistry()
    KeyboardLayersInfoRegister := KeyboardLayersInfoRegistry()
    StartupConfigurator := ""
    app := ""

    keyboardLayerIdentifiers := []

    keyNames := ""

    __New(){


    }

    ; Main method used to start the script.
    Start(){
        try{
            this.RunLogicalStartup()
            this.RunAppGui()
        }
        catch ValueError as e{
            this.ReadObjectsInformationFromJson()
            this.RunAppGui()
        }
    }

    RunLogicalStartup(){
        this.UpdatePathsToInfo()
        this.InitializeMetaInfo()
        this.RunMainStartup()
    }

    UpdatePathsToInfo(){
        try{
            ; Try to read the information for the current profile.
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
            this.keyboardSettingsJsonObject := jxon_load(&keyboardSettingsString)
        }
        catch{
            ; Unable to read information for the current profile, so we use default to an empty profile.
            FilePaths.SetCurrentProfile("Empty")
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
            this.keyboardSettingsJsonObject := jxon_load(&keyboardSettingsString)
        }
    }

    InitializeMetaInfo(){
        this.Objects := Map()
        this.ObjectRegister := ObjectRegistry()
        
        this.InitializeObjectsForKeybinds()
        this.InitializeObjectsForKeyboardOverlays()
        this.ReadObjectsInformationFromJson()
        this.ReadKeyboardLayersInfoFromJson()
        this.ReadKeyNamesFromTxtFile()
    }

    RunMainStartup(enableHotkeys := true){
        this.InitializeMainStartupConfigurator()
        this.ReadAndMakeKeyboardOverlays()
        this.InitializeHotkeysForAllLayers(enableHotkeys)
    }

    InitializeMainStartupConfigurator(){
        ; This is used to read ini files, and create hotkeys from them
        this.StartupConfigurator := MainStartupConfigurator(this.keyboardSettingsJsonObject, this.ObjectRegister)
    }
    
    ReadAndMakeKeyboardOverlays(){
        ; Reads and initializes all keyboard overlays, based on how they are created in the ini file
        this.StartupConfigurator.ReadAllKeyboardOverlays()
    }

    InitializeHotkeysForAllLayers(enableHotkeys := true){
        this.StartupConfigurator.CreateGlobalHotkeysForAllKeyboardOverlays()
        this.StartupConfigurator.ReadKeysToNewActionsBySection("GlobalLayer", enableHotkeys)
        
        layers := this.getLayerIndicatorController()
        HotIf "MainScript.getLayerIndicatorController().getActiveLayer() == 0"
            ; Reads and initializes all the hotkeys for the normal keyboard layer, based on how they are created in the ini file
            this.StartupConfigurator.ReadKeysToNewActionsBySection("NormalLayer", enableHotkeys)
        HotIf
        
        HotIf "MainScript.getLayerIndicatorController().getActiveLayer() == 1"
            this.StartupConfigurator.ReadKeysToNewActionsBySection("SecondaryLayer", enableHotkeys)
        HotIf
        
        HotIf "MainScript.getLayerIndicatorController().getActiveLayer() == 2"
            this.StartupConfigurator.ReadKeysToNewActionsBySection("TertiaryLayer", enableHotkeys)
        HotIf

    }

    InitializeObjectsForKeybinds(){
        ; Used to control mouse actions, and disable/enable mouse
        MouseInstance := Mouse()
        ; Sets the click speed of the auto clicker
        ; TODO Instead, perhaps the field should be initialized in the Mouse class, and then the value should be set in the Mouse class
        mouseCps := IniRead(FilePaths.GetPathToCurrentSettings(), "Mouse", "AutoClickerClickCps")
        MouseInstance.SetAutoClickerClickCps(mouseCps)
        this.Objects["MouseInstance"] := MouseInstance


        KeyboardInstance := Keyboard()
        this.Objects["KeyboardInstance"] := KeyboardInstance


        ProcessManagerInstance := ProcessManager()
        this.Objects["ProcessManagerInstance"] := ProcessManagerInstance


        ; Allows opening cmd pathed to the current file location for vs code and file explorer.
        commandPromptDefaultPath := IniRead(FilePaths.GetPathToCurrentSettings(), "CommandPrompt", "DefaultPath")
        CommandPrompt := CommandPromptOpener(commandPromptDefaultPath)
        this.Objects["CommandPrompt"] := CommandPrompt


        ; Allows navigating the file explorer and opening the file explorer pathed to a given file location
        FileExplorer := FileExplorerNavigator()
        this.Objects["FileExplorer"] := FileExplorer


        ; Allows to write on the screen in a textarea
        OnScreenWriter := KeysPressedGui()
        OnScreenWriter.CreateGUI()
        this.Objects["OnScreenWriter"] := OnScreenWriter


        ; Enables / disables input (mouse or keyboard)
        ComputerInput := ComputerInputController()
        this.Objects["ComputerInput"] := ComputerInput


        ; Used to hide screen and parts of the screen
        PrivacyController := ScreenPrivacyController()
        PrivacyController.CreateGui()
        ; Sets the countdown for the screen hider to 3 minutes. (change to your screen sleep time)
        ; This shows a countdown on the screen, and when it reaches 0, the screen goes to sleep
        monitorSleepTimeMinutes := IniRead(FilePaths.GetPathToCurrentSettings(), "PrivacyController", "MonitorSleepTimeMinutes")
        PrivacyController.ChangeCountdown(monitorSleepTimeMinutes,0)
        this.Objects["PrivacyController"] := PrivacyController

        ; Used to get the states of devices, like if bluetooth and such is enabled, also able to disable/enable these devices
        DeviceManipulator := DeviceManager()
        ; launches a powershell script which gets the states of some devices, like if the mouse is enabled.
        ; Having this activated will slow down the startup of the script significantly.
        ; !DeviceManipulator.UpdateDevicesActionToToggle()
        this.Objects["DeviceManipulator"] := DeviceManipulator


        ; Used to change brightness and gamma settings of the monitor
        MonitorInstance := Monitor()
        this.Objects["MonitorInstance"] := MonitorInstance

        ; Used to switch between power saver mode and normal power mode (does not work as expected currently, percentage to switch to power saver is changed, but power saver is never turned on...)
        powerSaverModeGUID := IniRead(FilePaths.GetPathToCurrentSettings(), "Battery", "PowerSaverModeGUID")
        defaultPowerModeGUID := IniRead(FilePaths.GetPathToCurrentSettings(), "Battery", "DefaultPowerModeGUID")
        Battery := BatteryController(50, 50)
        Battery.setPowerSaverModeGUID(powerSaverModeGUID)
        Battery.setDefaultPowerModeGUID(defaultPowerModeGUID)
        ; Battery.ActivateNormalPowerMode()
        this.Objects["Battery"] := Battery

        ; Used to search for stuff in the browser, translate, and excecute shortcues like close tabs to the right in browser
        chatGptLoadTime := IniRead(FilePaths.GetPathToCurrentSettings(), "WebNavigator", "chatGptLoadTime")
        WebSearcher := WebNavigator()
        WebSearcher.SetChatGptLoadTime(chatGptLoadTime)
        this.Objects["WebSearcher"] := WebSearcher


        UnautorizedUserDetector := UnauthorizedUseDetector()
        this.Objects["UnautorizedUserDetector"] := UnautorizedUserDetector

        lockComputerOnTaskBarClick := IniRead(FilePaths.GetPathToCurrentSettings(), "UnauthorizedUseDetector", "lockComputerOnTaskBarClick")

        if (lockComputerOnTaskBarClick = "true"){
            UnautorizedUserDetector.ActivateLockComputerOnTaskBarClick()
        }
        else{
            UnautorizedUserDetector.DisableLockComputerOnTaskBarClick()
        }
    }

    ; TODO in the future fix...
    InitializeObjectsForKeyboardOverlays(){

        ; |---------------------------------|
        ; |-------Keyboard Overlays---------|
        ; |---------------------------------|

        ; |----------Main layer------------|

        ; TODO this is shit...

        ; Shows an on screen overlay for the main keyboard layer which shows which urls can be went to using the number keys
        SecondaryLayerKeyboardOverlay1 := KeyboardOverlay()
        SecondaryLayerKeyboardOverlay1.CreateGui()
        this.Objects["SecondaryLayerKeyboardOverlay1"] := SecondaryLayerKeyboardOverlay1

        ; Shows an on screen overlay for the SecondaryLayer keyboard layer which shows which file explorer paths can be went to using the number keys
        SecondaryLayerKeyboardOverlay2 := KeyboardOverlay()
        SecondaryLayerKeyboardOverlay2.CreateGui()
        this.Objects["SecondaryLayerKeyboardOverlay2"] := SecondaryLayerKeyboardOverlay2

        ; |----------Second layer-----------|

        ; Shows an on screen overlay for the main keyboard layer which shows which number keys to press to enable/disable devices
        TertiaryLayerKeyboardOverlay1 := KeyboardOverlay()
        TertiaryLayerKeyboardOverlay1.CreateGui()

        ; |---------Overlay registry--------|

        OverlayRegistry := KeyboardOverlayRegistry()
        OverlayRegistry.addKeyboardOverlay(TertiaryLayerKeyboardOverlay1, "TertiaryLayerKeyboardOverlay1")
        this.Objects["OverlayRegistry"] := OverlayRegistry

        ; |------------Layer indicators------------|

        ; Used to switch the active layer
        layers := LayerIndicatorController()
        layers.addLayerIndicator(1, "Green")
        layers.addLayerIndicator(2, "Red")

        this.Objects["layers"] := layers
    }

    ReadObjectsInformationFromJson(){
        JsonReaderForObjects := ObjectsJsonReader(FilePaths.GetObjectInfo(), this.Objects)
        this.ObjectRegister := JsonReaderForObjects.ReadObjectsFromJson()
    }

    ReadKeyboardLayersInfoFromJson(){
        JsonReaderForKeyboardLayersInfo := KeyboardLayersInfoJsonReader(FilePaths.GetPathToCurrentKeyboardLayout())
        JsonReaderForKeyboardLayersInfo.ReadKeyboardLayersInfoFromJson()
        this.KeyboardLayersInfoRegister := JsonReaderForKeyboardLayersInfo.getKeyboardLayersInfoRegister()
        this.keyboardLayerIdentifiers := this.KeyboardLayersInfoRegister.getLayerIdentifiers()
    }

    ReadKeyNamesFromTxtFile(){
        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(FilePaths.GetPathToKeyNames(), "rw" , "UTF-8")
        this.keyNames := keyNamesFileObjReader.ReadKeyNamesFromTextFileObject(fileObjectOfKeyNames).GetKeyNames()

    }

    RunAppGui(){
        this.app := ExtraKeyboardsApp(this.keyboardLayerIdentifiers, this.ObjectRegister, this.KeyboardLayersInfoRegister, this, this.keyNames)
        this.app.Start()
    }

    getStartupConfigurator(){
        return this.StartupConfigurator
    }

    getLayerIndicatorController(){
        return this.ObjectRegister.GetObjectInfo("layers").GetObjectInstance()
    }
}


#SuspendExempt
^!s::Suspend  ; Ctrl+Alt+S
#SuspendExempt False

MainScript := Main()
MainScript.Start()

#HotIf MainScript.getLayerIndicatorController().getActiveLayer() == 0

#HotIf

#HotIf MainScript.getLayerIndicatorController().getActiveLayer() == 1
#HotIf

#HotIf MainScript.getLayerIndicatorController().getActiveLayer() == 2 
    ; ; Shows key history, used for debugging
    ; b:: KeyHistory
#HotIf

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000
