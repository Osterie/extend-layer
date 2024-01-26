﻿; AUTHOR: Adrian Gjøsund Bjørge
; Github: https://github.com/Osterie

; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
#Requires Autohotkey v2.0

#Include ".\ExtraKeyboardsApp.ahk"
#Include ".\library\IODevices\DeviceManager.ahk"
#Include ".\library\IODevices\ComputerInputController.ahk"
#Include ".\library\IODevices\Monitor.ahk"
#Include ".\library\IODevices\Mouse.ahk"
#Include ".\library\Clock\CountdownGUI.ahk"
#Include ".\library\LayerIndication\LayerIndicatorController.ahk"
#Include ".\library\BatteryAndPower\BatteryController.ahk"
#Include ".\library\Privacy\ScreenPrivacyController.ahk"
#Include ".\library\KeysPressedGui.ahk"
#Include ".\library\Navigation\WebNavigation\WebNavigator.ahk"
#Include ".\library\KeyboardOverlay\KeyboardOverlay.ahk"
#Include ".\library\CommandPromptOpener.ahk"
#Include ".\library\Navigation\FileNavigation\FileExplorerNavigator.ahk"
#Include ".\library\KeyboardOverlay\KeyboardOverlayRegistry.ahk"
#Include ".\library\ProcessManager.ahk"
#Include ".\library\MetaInfoStorage\ObjectRegistry.ahk"
#Include ".\library\Configuration\StartupConfiguration\MainStartupConfigurator.ahk"
#Include ".\library\Privacy\UnauthorizedUseDetector.ahk"

#Include ".\library\MetaInfoStorage\ObjectInfo.ahk"
#Include ".\library\MetaInfoStorage\MethodInfo.ahk"
#Include ".\library\MetaInfoStorage\MethodRegistry.ahk"

#Include ".\library\JsonParsing\JXON\JXON.ahk"

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

if (not A_IsAdmin){
    ; "*RunAs*" is an option for the Run() function to run a program as admin
	Run("*RunAs `"" A_ScriptFullPath "`"") 
}

; |-----------------------------------|
; |------------HOTSTRINGS-------------|
; |-----------------------------------|
; TODO hotstrings should be in ini file and yeah

; This hotstring replaces "]d" with the current date and time via the statement below.
:*:]d::{
    Send(FormatTime(, "d.M.yyyy"))  ; It will look like 13.7.2005
}

; |-----------------------------------|
; |----------PRIVATE PERSONAL---------|
; |-----------------------------------|

name := IniRead("../config/privateConfig.ini", "PrivateInfo", "Name")
eMail := IniRead("../config/privateConfig.ini", "PrivateInfo", "Email")
password := IniRead("../config/privateConfig.ini", "PrivateInfo", "Password")

Hotstring( "::agb", StrReplace(name, "Ã¸", "ø"))
Hotstring( "::a@", eMail)
Hotstring("::@p", password)


; ------------Global or whatever stusff----------------




; |-------------------------------------------|
; |----------- OBJECT CREATION ---------------|
; |-------------------------------------------|

Class Main{

    PATH_TO_OBJECT_INFO := "..\config\ObjectInfo.json"
    PATH_TO_META_INI_FILE := "..\config\meta.ini"
    

    CURRENT_PROFILE_NAME := ""
    PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := ""
    PATH_TO_CURRENT_KEYBOARD_LAYOUT := ""

    jsonStringFunctionalityInformation := ""
    allClassesInformationJson := ""

    keyboardSettingsString := ""
    keyboardSettingsJsonObject := ""

    Objects := Map()
    ObjectRegister := ObjectRegistry()
    StartupConfigurator := ""
    app := ""

    __New(){


    }

    ; Main method used to start the script.
    Start(){
        this.RunLogicalStartup()
        ; this.RunAppGui()
    }

    RunLogicalStartup(*){
        this.UpdatePathsToInfo()
        this.InitializeMetaInfo()
        this.RunMainStartup()
    }

    UpdatePathsToInfo(){
        this.CURRENT_PROFILE_NAME := iniRead(this.PATH_TO_META_INI_FILE, "General", "activeUserProfile")
        this.PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := "../config/UserProfiles/" . this.CURRENT_PROFILE_NAME . "/ClassObjects.ini"
        this.PATH_TO_CURRENT_KEYBOARD_LAYOUT := "../config/UserProfiles/" . this.CURRENT_PROFILE_NAME . "\Keyboards.json"
    
        jsonStringFunctionalityInformation := FileRead(this.PATH_TO_OBJECT_INFO, "UTF-8")
        this.allClassesInformationJson := jxon_load(&jsonStringFunctionalityInformation)
    
        keyboardSettingsString := FileRead(this.PATH_TO_CURRENT_KEYBOARD_LAYOUT, "UTF-8")
        this.keyboardSettingsJsonObject := jxon_load(&keyboardSettingsString)
    }

    InitializeMetaInfo(){
        this.Objects := Map()
        this.ObjectRegister := ObjectRegistry()
        
        this.InitializeObjectsForKeybinds()
        this.InitializeObjectsForKeyboardOverlays()
        this.ReadObjectsInformationFromJson()
    }

    RunMainStartup(){
        this.InitializeMainStartupConfigurator()
        this.ReadAndMakeKeyboardOverlays()
        this.InitializeHotkeysForAllLayers()
    }

    InitializeMainStartupConfigurator(){
        ; This is used to read ini files, and create hotkeys from them
        this.StartupConfigurator := MainStartupConfigurator(this.keyboardSettingsJsonObject, this.ObjectRegister)
    }

    
    ReadAndMakeKeyboardOverlays(){
        ; Reads and initializes all keyboard overlays, based on how they are created in the ini file
        this.StartupConfigurator.ReadAllKeyboardOverlays()
    }

    InitializeHotkeysForAllLayers(){
        
        this.StartupConfigurator.ReadKeysToNewActionsBySection("GlobalLayer")
        this.StartupConfigurator.CreateGlobalHotkeysForAllKeyboardOverlays()
        
        layers := this.getLayerIndicatorController()
        
        HotIf "layers.getActiveLayer() == 0"
            ; Reads and initializes all the hotkeys for the normal keyboard layer, based on how they are created in the ini file
            this.StartupConfigurator.ReadKeysToNewActionsBySection("NormalLayer")
        HotIf
        
        HotIf "layers.getActiveLayer() == 1"
            this.StartupConfigurator.ReadKeysToNewActionsBySection("SecondaryLayer")
        HotIf
        
        
        HotIf "layers.getActiveLayer() == 2"
            this.StartupConfigurator.ReadKeysToNewActionsBySection("TertiaryLayer")
        HotIf
    }


    InitializeObjectsForKeybinds(){
        ; Used to control mouse actions, and disable/enable mouse
        MouseInstance := Mouse()
        ; Sets the click speed of the auto clicker
        mouseCps := IniRead(this.PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE, "Mouse", "AutoClickerClickCps")
        MouseInstance.SetAutoClickerClickCps(mouseCps)
        this.Objects["MouseInstance"] := MouseInstance


        KeyboardInstance := Keyboard()
        this.Objects["KeyboardInstance"] := KeyboardInstance


        ProcessManagerInstance := ProcessManager()
        this.Objects["ProcessManagerInstance"] := ProcessManagerInstance


        ; Allows opening cmd pathed to the current file location for vs code and file explorer.
        commandPromptDefaultPath := IniRead(this.PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE, "CommandPrompt", "DefaultPath")
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
        monitorSleepTimeMinutes := IniRead(this.PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE, "PrivacyController", "MonitorSleepTimeMinutes")
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
        powerSaverModeGUID := IniRead(this.PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE, "Battery", "PowerSaverModeGUID")
        defaultPowerModeGUID := IniRead(this.PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE, "Battery", "DefaultPowerModeGUID")
        Battery := BatteryController(50, 50)
        Battery.setPowerSaverModeGUID(powerSaverModeGUID)
        Battery.setDefaultPowerModeGUID(defaultPowerModeGUID)
        ; Battery.ActivateNormalPowerMode()
        this.Objects["Battery"] := Battery

        ; Used to search for stuff in the browser, translate, and excecute shortcues like close tabs to the right in browser
        chatGptLoadTime := IniRead(this.PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE, "WebNavigator", "chatGptLoadTime")
        WebSearcher := WebNavigator()
        WebSearcher.SetChatGptLoadTime(chatGptLoadTime)
        this.Objects["WebSearcher"] := WebSearcher


        UnautorizedUserDetector := UnauthorizedUseDetector()
        this.Objects["UnautorizedUserDetector"] := UnautorizedUserDetector

        ; lockComputerOnTaskBarClick := IniRead(this.PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE, "UnauthorizedUseDetector", "lockComputerOnTaskBarClick")

        ; if (lockComputerOnTaskBarClick = "true"){
        ;     UnautorizedUserDetector.ActivateLockComputerOnTaskBarClick()
        ; }
        ; else{
        ;     UnautorizedUserDetector.DisableLockComputerOnTaskBarClick()
        ; }
    }

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

        ; -----------Read JSON----------------

        ; TODO create a class for this and such....
        ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
        For ClassName , ClassInformation in this.allClassesInformationJson{
            
            ObjectName := ClassInformation["ObjectName"]
            className := ClassInformation["ClassName"]

            objectMethods := MethodRegistry()
            allMethodsOfClass := ClassInformation["Methods"]

            For MethodName, MethodInformation in allMethodsOfClass{
                
                methodDescription := MethodInformation["Description"]
                allMethodParameters := MethodInformation["Parameters"]
                methodInformation := MethodInfo(methodName, methodDescription)
                
                For ParameterName, ParameterInformation in allMethodParameters{
                    
                    parameterType := ParameterInformation["Type"]
                    parameterDescription := ParameterInformation["Description"]
                    methodInformation.addParameter(ParameterName, parameterDescription)
                }
                objectMethods.addMethod(MethodName, methodInformation)
            }

            ; Create the finished object
            ObjectInstance := this.Objects[ObjectName]
            objectInformation := ObjectInfo(ObjectName, ObjectInstance, objectMethods)

            ; Add the completed object to the registry.
            this.ObjectRegister.AddObject(ObjectName, objectInformation)
        }
    }

    RunAppGui(){

        this.app := ExtraKeyboardsApp(this.keyboardSettingsJsonObject)
        this.app.Start()

        refreshHotkeys := ObjBindMethod(this, "RunLogicalStartup")
        ; this.app.getExtraKeyboardsAppgui().getProfileButtonsObject().addProfileChangedEvent(refreshHotkeys)
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

ExtraKeyboardsAppGui2 := Gui()
ExtraKeyboardsAppGui2.Opt("+Resize +MinimizeBox ")
ExtraKeyboardsAppGui2.Add("Text", , "this is a test:")
ExtraKeyboardsAppGui2.Show()

MainScript := Main()
MainScript.Start()

layers := MainScript.getLayerIndicatorController()


#HotIf layers.getActiveLayer() == 0
#HotIf

#HotIf layers.getActiveLayer() == 1
#HotIf

#HotIf layers.getActiveLayer() == 2 
    ; ; Shows key history, used for debugging
    ; b:: KeyHistory
#HotIf

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000