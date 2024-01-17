; AUTHOR: Adrian Gjøsund Bjørge
; Github: https://github.com/Osterie

; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
#Requires Autohotkey v2.0
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
#Include ".\library\ObjectRegistry.ahk"
#Include ".\library\Configuration\StartupConfiguration\MainStartupConfigurator.ahk"
#Include ".\library\Privacy\UnauthorizedUseDetector.ahk"

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


; |-------------------------------------------|
; |----------- OBJECT CREATION ---------------|
; |-------------------------------------------|

Class Main{

    __New(){


    }

    Start(){


    }
}

currentProfile := iniRead("..\config\meta.ini", "General", "activeUserProfile")

ObjectRegister := ObjectRegistry()

; Used to control mouse actions, and disable/enable mouse
MouseInstance := Mouse()
; Sets the click speed of the auto clicker
mouseCps := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "Mouse", "AutoClickerClickCps")
MouseInstance.SetAutoClickerClickCps(mouseCps)
; Adds the mouse object to the registry
ObjectRegister.AddObject("MouseInstance", MouseInstance)

KeyboardInstance := Keyboard()
ObjectRegister.AddObject("KeyboardInstance", KeyboardInstance)



ProcessManagerInstance := ProcessManager()
ObjectRegister.AddObject("ProcessManagerInstance", ProcessManagerInstance)

; Allows opening cmd pathed to the current file location for vs code and file explorer.
commandPromptDefaultPath := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "CommandPrompt", "DefaultPath")
CommandPrompt := CommandPromptOpener(commandPromptDefaultPath)
ObjectRegister.AddObject("CommandPrompt", CommandPrompt)

; Allows navigating the file explorer and opening the file explorer pathed to a given file location
FileExplorer := FileExplorerNavigator()
ObjectRegister.AddObject("FileExplorer", FileExplorer)

; Allows to write on the screen in a textarea
OnScreenWriter := KeysPressedGui()
OnScreenWriter.CreateGUI()
ObjectRegister.AddObject("OnScreenWriter", OnScreenWriter)

; Enables / disables input (mouse or keyboard)
ComputerInput := ComputerInputController()
ObjectRegister.AddObject("ComputerInput", ComputerInput)

; Used to hide screen and parts of the screen
PrivacyController := ScreenPrivacyController()
PrivacyController.CreateGui()
; Sets the countdown for the screen hider to 3 minutes. (change to your screen sleep time)
; This shows a countdown on the screen, and when it reaches 0, the screen goes to sleep
monitorSleepTimeMinutes := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "PrivacyController", "MonitorSleepTimeMinutes")
PrivacyController.ChangeCountdown(monitorSleepTimeMinutes,0)

ObjectRegister.AddObject("PrivacyController", PrivacyController)

; Used to get the states of devices, like if bluetooth and such is enabled, also able to disable/enable these devices
DeviceManipulator := DeviceManager()
; launches a powershell script which gets the states of some devices, like if the mouse is enabled.
; Having this activated will slow down the startup of the script significantly.
; !DeviceManipulator.UpdateDevicesActionToToggle()
ObjectRegister.AddObject("DeviceManipulator", DeviceManipulator)


; Used to change brightness and gamma settings of the monitor
MonitorInstance := Monitor()
ObjectRegister.AddObject("MonitorInstance", MonitorInstance)

; Used to switch between power saver mode and normal power mode (does not work as expected currently, percentage to switch to power saver is changed, but power saver is never turned on...)
powerSaverModeGUID := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "Battery", "PowerSaverModeGUID")
defaultPowerModeGUID := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "Battery", "DefaultPowerModeGUID")
Battery := BatteryController(50, 50)
Battery.setPowerSaverModeGUID(powerSaverModeGUID)
Battery.setDefaultPowerModeGUID(defaultPowerModeGUID)
; Battery.ActivateNormalPowerMode()
ObjectRegister.AddObject("Battery", Battery)

; Used to search for stuff in the browser, translate, and excecute shortcues like close tabs to the right in browser
chatGptLoadTime := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "WebNavigator", "chatGptLoadTime")
WebSearcher := WebNavigator()
WebSearcher.SetChatGptLoadTime(chatGptLoadTime)
ObjectRegister.AddObject("WebSearcher", WebSearcher)


UnautorizedUserDetector := UnauthorizedUseDetector()
ObjectRegister.AddObject("UnautorizedUserDetector", UnautorizedUserDetector)

lockComputerOnTaskBarClick := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "UnauthorizedUseDetector", "lockComputerOnTaskBarClick")

if (lockComputerOnTaskBarClick = "true"){
    UnautorizedUserDetector.ActivateLockComputerOnTaskBarClick()
}
else{
    UnautorizedUserDetector.DisableLockComputerOnTaskBarClick()
}


; |---------------------------------|
; |-------Keyboard Overlays---------|
; |---------------------------------|
; TODO should be done in ini file and such
; |----------Main layer------------|

; Shows an on screen overlay for the main keyboard layer which shows which urls can be went to using the number keys
SecondaryLayerKeyboardOverlay1 := KeyboardOverlay()
SecondaryLayerKeyboardOverlay1.CreateGui()
ObjectRegister.AddObject("SecondaryLayerKeyboardOverlay1", SecondaryLayerKeyboardOverlay1)

; Shows an on screen overlay for the SecondaryLayer keyboard layer which shows which file explorer paths can be went to using the number keys
SecondaryLayerKeyboardOverlay2 := KeyboardOverlay()
SecondaryLayerKeyboardOverlay2.CreateGui()
ObjectRegister.AddObject("SecondaryLayerKeyboardOverlay2", SecondaryLayerKeyboardOverlay2)

; |----------Second layer-----------|

; Shows an on screen overlay for the main keyboard layer which shows which number keys to press to enable/disable devices
TertiaryLayerKeyboardOverlay1 := KeyboardOverlay()
TertiaryLayerKeyboardOverlay1.CreateGui()
TertiaryLayerKeyboardOverlay1.AddColumnToggleValue("1", "Touch Screen", DeviceManipulator.GetTouchScreenActionToToggle())
TertiaryLayerKeyboardOverlay1.AddColumnToggleValue("2", "Camera", DeviceManipulator.GetCameraActionToToggle())
TertiaryLayerKeyboardOverlay1.AddColumnToggleValue("3", "Blue tooth", DeviceManipulator.GetBluetoothActionToToggle())
TertiaryLayerKeyboardOverlay1.AddColumnToggleValue("4", "Touch Pad", DeviceManipulator.GetTouchPadActionToToggle())

; |---------Overlay registry--------|

OverlayRegistry := KeyboardOverlayRegistry()
OverlayRegistry.addKeyboardOverlay(TertiaryLayerKeyboardOverlay1, "TertiaryLayerKeyboardOverlay1")
ObjectRegister.AddObject("OverlayRegistry", OverlayRegistry)

; |------------Layer indicators------------|

; Used to switch the active layer
layers := LayerIndicatorController()
layers.addLayerIndicator(1, "Green")
layers.addLayerIndicator(2, "Red")

; |----------------------------------|
; |--------Startup Configurator------|
; |----------------------------------|

; This is used to read ini files, and create hotkeys from them
StartupConfigurator := MainStartupConfigurator("../config/UserProfiles/" . currentProfile, ObjectRegister)

; Reads and initializes all keyboard overlays, based on how they are created in the ini file
StartupConfigurator.ReadAllKeyboardOverlays()

; |-----------------------------------|
; |----------Layer switchers----------|
; |-----------------------------------|

; changes the layer to 0 if it is not zero, or 1 if it is zero
NumLock::
CapsLock:: layers.toggleLayerIndicator(1)

; Changes the layer to 2 if it is zero, and then cycles through the layers if it is not zero
+NumLock::
+CapsLock:: {

    ; layers.CycleLayers(2)

    activeLayer := layers.getActiveLayer()
    
    if (activeLayer == 0){
        layers.showLayerIndicator(2)
    }
    else{

        layers.cycleLayerIndicators()
        newActiveLayer := layers.getActiveLayer()
        layers.showLayerIndicator(newActiveLayer)
        layers.hideInactiveLayers()
    }
}

; Used to suspend script, suspending the script means noen of its functionalities are active.
; Pressing the same key combination again enables the script again
; SuspendExempt means this hotkey will not be suspended when the script is suspended.
; Since this hotkey suspends the script it is important that it is not suspended itself.
#SuspendExempt
^!s:: ProcessManagerInstance.SuspendActiveAutohotkeyScript()  ; Ctrl+Alt+S
#SuspendExempt False


; |------------------------------|
; |-----------Layers-------------|
; |------------------------------|

; LButton::{
;     MsgBox("The active window's class is " WinGetClass("A"))
; }


; LButton::{
;     Send("{LButton Down}")
;     try{
;         WinWait("A")
;         if (WinGetClass("A") == "Shell_TrayWnd"){
;             Sleep(100)
;             DllCall("LockWorkStation")
;         }
;     }
;     catch{
;         ToolTip "Error something wrong!"
;         SetTimer () => ToolTip(), -3000
;     }
; }

; LButton Up::{
;     Send("{LButton Up}")
; }

#HotIf layers.getActiveLayer() == 0
#HotIf

HotIf "layers.getActiveLayer() == 0"
    ; Reads and initializes all the hotkeys for the normal keyboard layer, based on how they are created in the ini file
    StartupConfigurator.ReadKeysToNewActionsBySection("NormalLayer")
HotIf

#HotIf layers.getActiveLayer() == 1
#HotIf


HotIf "layers.getActiveLayer() == 1"
    
    StartupConfigurator.ReadKeysToNewActionsBySection("SecondaryLayer")

HotIf

#HotIf layers.getActiveLayer() == 2 

    ; Shows second keyboard overlay when shift is held down
    ~Shift:: OverlayRegistry.showKeyboardOverlay("TertiaryLayerKeyboardOverlay1") ;SecondKeyboardOverlayDevices.ShowGui() 

    ; Hides second keyboard overlay (and main just in case)
    Shift up:: OverlayRegistry.hideAllLayers() 

    ; Toggles touch-screen
    +1::{ 
        TertiaryLayerKeyboardOverlay1.ToggleState("TouchScreen")
        DeviceManipulator.ToggleTouchScreen()
    } 

    ; Toggles camera
    +2::{ 
        TertiaryLayerKeyboardOverlay1.ToggleState("Camera")
        DeviceManipulator.ToggleCamera()
    } 

    ; Toggles bluetooth
    +3::{ 
        TertiaryLayerKeyboardOverlay1.ToggleState("Bluetooth")
        DeviceManipulator.ToggleBluetooth()
    } 

    ; Toggles touchpad
    +4::{ 
        TertiaryLayerKeyboardOverlay1.ToggleState("TouchPad")
        DeviceManipulator.ToggleTouchPad()
    }

    ; Shows key history, used for debugging
    b:: KeyHistory

#HotIf

HotIf "layers.getActiveLayer() == 2"
    
    StartupConfigurator.ReadKeysToNewActionsBySection("TertiaryLayer")

HotIf

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000