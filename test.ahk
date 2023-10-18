#Requires AutoHotkey v2.0

#Include ".\library\CountdownGUI.ahk"
#Include ".\library\MonitorController.ahk"
#Include ".\library\LayerIndicatorController.ahk"
#Include ".\library\BatteryController.ahk"
#Include ".\library\PrivacyGUIController.ahk"
#Include ".\library\ComputerInputController.ahk"
#Include ".\library\KeysPressedGui.ahk"
#Include ".\library\WebNavigator.ahk"
#Include ".\library\KeyboardOverlay.ahk"
#Include ".\library\DeviceController.ahk"
#Include ".\library\CommandPromptOpener.ahk"
#Include ".\library\FileExplorerNavigator.ahk"
#Include ".\library\Configurator.ahk"
#Include ".\library\KeyboardOverlayRegistry.ahk"
#Include ".\library\ApplicationManipulator.ahk"
#Include ".\library\Mouse.ahk"
#Include ".\library\ObjectRegistry.ahk"


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
; Not changing SendMode defaults it to "input", which makes hotkeys super mega terrible (super   ø)
SendMode "Event"

; THIS SHOULD BE AT TOP!

ObjectRegister := ObjectRegistry()

MouseInstance := Mouse()
ObjectRegister.AddObject("MouseInstance", MouseInstance)

ApplicationManipulatorInstance := ApplicationManipulator()
ObjectRegister.AddObject("ApplicationManipulatorInstance", ApplicationManipulatorInstance)


; Allows opening cmd pathed to the current file location for vs code and file explorer.
commandPromptDefaultPath := IniRead("Config.ini", "CommandPrompt", "DefaultPath")
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
privacyController := PrivacyGUIController()
privacyController.CreateGui()
; Sets the countdown for the screen hider to 3 minutes. (change to your screen sleep time)
; This shows a countdown on the screen, and when it reaches 0, the screen goes to sleep
; TODO probably should create a setting for this in ini file
privacyController.ChangeCountdown(3,0)
ObjectRegister.AddObject("privacyController", privacyController)

; Used to get the states of devices, like if bluetooth and such is enabled, also able to disable/enable these devices
DeviceManipulator := DeviceController()
; launches a powershell script which gets the states of some devices, like if the mouse is enabled.
; Having this activated will slow down the startup of the script significantly.
; !DeviceManipulator.UpdateDevicesActionToToggle()
ObjectRegister.AddObject("DeviceManipulator", DeviceManipulator)


; Used to change brightness and gamma settings of the monitor
Monitor := MonitorController()
ObjectRegister.AddObject("Monitor", Monitor)

; Used to switch between power saver mode and normal power mode (does not work as expected currently, percentage to switch to power saver is changed, but power saver is never turned on...)
powerSaverModeGUID := IniRead("Config.ini", "Battery", "PowerSaverModeGUID")
defaultPowerModeGUID := IniRead("Config.ini", "Battery", "DefaultPowerModeGUID")
Battery := BatteryController(50, 50)
Battery.setPowerSaverModeGUID(powerSaverModeGUID)
Battery.setDefaultPowerModeGUID(defaultPowerModeGUID)
Battery.ActivateNormalPowerMode()
ObjectRegister.AddObject("Battery", Battery)

; Used to search for stuff in the browser, translate, and excecute shortcues like close tabs to the right in browser
WebSearcher := WebNavigator()
chatGptLoadTime := IniRead("Config.ini", "WebNavigator", "chatGptLoadTime")
WebSearcher.SetChatGptLoadTime(chatGptLoadTime)
ObjectRegister.AddObject("WebSearcher", WebSearcher)


Class Tester{
    name := "Tester"
    age := 20

    printName(){
        MsgBox(this.name)
    }
    setName(name){
        this.name := name
    }
    getName(){
        return this.name
    }
    CloseTabsToTheRight(){
        MsgBox("CloseTabsToTheRight")
    }
}


SendKeyDown(key, modifiers){
    Send("{blind}" . modifiers . "{" . key . " Down}")
}

SendKeyUp(key, modifiers){
    Send("{blind}{" . key . " Up}")                                                           
}

SendModifierKey(key, modifiers){
    Send("{blind}" . modifiers . "{" . key . "}")
}

; IniWrite "this is a new value", "Config.ini", "Test", "key"

test := Map()
test["key"] := "value"

for k, v in test
    MsgBox k "=" v



; TODO REQUIREMENTS:
; - true and false have to be evalueted from the ini file. "true" and "false" must be turned into true and false (booleans)
; - Arrays with elements must be treated as such, if there is a "[" and a "]" after, then the contents are to be treated as elements in an array, and placed in an array.
; - Perhaps it should be possible to create varriables in the ini file? 
;      - they could be created by having "_" at the start and end. 
;      - this would make it possible to for example create an array of values, such as paths to image search images.
;      - Would look like this _BlackBoardLoginImages_ = ["\imageSearchImages\feideBlackboardMaximized.png", "\imageSearchImages\feideBlackboardMinimized.png"]
;      - this would then be read by maybe IniReader and treated as an array and stored in the configurater object somewhere... in an array. IniFileSavedVariables := [_BlackBoardLoginImages_, ...]

; True else strings should be evalueated (is that the right word) and be turned into booleans, from string, obviously.

*esc::ExitApp