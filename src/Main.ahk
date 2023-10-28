; TODO add great documentation for this script, and make it easy to understand and learn for others or for myself in the future
; AUTHOR: Adrian Gjøsund Bjørge
; Github: https://github.com/Osterie

; TODO; perhaps powershell scripts should be in assets, or maybe they should be in the script itself, since you can run powershell scripts directrly from ahk...

; TODO: places where lists and such are returned, return an iterator instead

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
; Not changing SendMode defaults it to "input", which makes hotkeys super mega terrible (super   ø)
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

; |---------------------------------------------------|
; |------------------ TO-DO LIST ---------------------|
; |---------------------------------------------------|
; !add a priority rating for all the todos, using !, ?, and *

; ! .ini file. Should have settings for guis, like this:
; [Notepad]
; Width=580
; Height=290
; X=1335
; Y=225
; Surface=168200

; [Paint]
; Width=820
; Height=1058
; X=1100
; Y=1200
; Surface=867560



; * Could make it possible to write anywhere on screen.


; !TODO make it possible for user to create macros, use the macro creater you have worked on to do this maybe

; !Future, for other users or just for good practice, make the script more easily understandable and learnable for others.
; !do this by creating a meny or gui or markdown file or all of the above! which contains enough information for a decent understanding

; ?Show battery percentage on screen hide, can be combined with keep pc awake to see when pc is done charging

; ?a shortcut, which when enabled reads whatever the user is writing, and when they hit enter, it is searched for in the browser

;? checkout: https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/ctrl_caps_as_case_change.ahk
;? link about goes to script which can set text to uppercase, lowercase and more

;? checkout: https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/in-line-calculator/in-line%20calculator.ahk
;? could use calculator anywehre with script above. 

;! checkout: https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/move-inactive-window-alt-leftclick/MoveInactiveWin.ahk
;! move window without activating it. so the window can be moved from anywhere, without being activated

;! checkout: https://www.autohotkey.com/docs/v1/scripts/#EasyWindowDrag 
;! move a window from anywhere, can be combined with "move window without activating it" so the window can be moved from anywhere, without being activated

; ?make it possible to easily create more or remove shortcuts for keyboard overlays, a simple gui/menu to add/remove filepaths/text, 

; !Add a shortcut to copy a piece of the screen and have it as a moveable image

; ?the input reader in KeysPressedGui can probably be made into its own class. It can be used to read input from the user, and then do something with it.

; *Make a function/class or something to find and navigate to an open chrome tab. Open a dialog box or something, write the name of / partial name of the tab you
; *want to go to, then each tab is checked if it contains the name given and so on (obvious what to do next)

; *maybe make it possible to save stuff on the second layer also (the ctrl+s shortcut)

; *Maybe have a way to recognize who is using the computer, if for example the mouse is clicked 10 times or something in a minute, then disable keyboard and mouse, and turn screen dark, maybe off? could be dangerous

; *Make a method in monitor class for adding a transparent black layer over the screen, to be used as a screen dimmer.

; !FUTURE make a simple version which is just the main layer, can be used when main not working

; todo: would be possible to have some hotkeys that open a gui where several options are chosen from.
; for example for changing performance mode, a dropdown menu for high, normal, low performance nad such can be chosen.
; There are many possibilities...

; todo: keep awake for a while, like 30min can be changed in settings 
; Todo; add guis for more stuff, like power mode.

; todo; In the future, possible to add a button which opens a gui user interface where values can be changed, for 
; example, the step to go when changing red, green, blue gamma values, and so on, brightness...
; Ability to also disable keybidnds, and for these settings to be remembered in a file, which can be read and its content put through a function/class method which understands the content
; This gui can also be used to toggle "beginner mode" or something (which is not created yet).
; This would allow the user to for example show an onscreen keyboard ovelay which shows what every keyboard key does, making this script usable for more people.
; In the gui it should also be possible to switch which keys do what, since people have diffenet keyboards.
; The keyboard overlay should maybe make it possible to hover over a key, or hold/press ctrl or something to show which key on the keyboard to press to activate that special key.
; Make it possible to not have gui showing which layer is active (silent running mode or whatever something cool) also an option to not turn on the light for capslock

; TODO:keyboard overlay classes, make then read a file which contains information about how the overlay should look
; for a new row, write something to indicate a new row.

; TODO; able to restart a wireless router? check here and search: https://github.com/shajul/Autohotkey/blob/master/Scriplets/Wireless_Router_Restart.ahk

; TODO; powershell is slow. is there an alternative? can it be made faster? can it be used without opening the terminal view at all?

; TODO; create a seperate script to log how much power is being used? maybe make this a method for the Battery class, and a seperate class for batteryLogger which is an object which will be used in Battery class

; TODO: connect/disconnect airpods,

; TODO: change background of the keyboard overlay keys for disabling/enabling to have green/red background based on if it is on or off
; TODO: keyboard overlay for disabling/enabling devices should maybe use images instead of text?
; having images instead would also allow for better code readability and intuitivity and such.
; because instead of powershell giving "enable" or "disable" they could return "on" or "off" and according to these the images changes

; TODO: i believe the promt which apperas when a powerhsell script runs can be hidden

; TODO: for the keyboard overlays, if the amount of columns goes over an amount (set by user or chosen by me, f.ex 10 or 30% screen width)
; then the columns should be placed below eachother instead of next to eachother

; add gui to show current power mode, auto switch for screen darkner and such maybe?

; TODO FUTURE: possible to integrate with real life appliances, for example to control lights in rooms, a third layer could be created for this
; TODO: automatically slowly change gamma values for fun...

; TODO: a shortcut to turn the screen black(which alredy exists), but randomly change rgb values and then black. (so it looks like it is glitching.) Maybe have it connected to if mouse is used or clicked or something, maybe a certain keypress
; todo: text which converges and is mirrored along the middle cool effect only... used as a screensaver or something

; Layers and keyboard overlay could possibly be used in a class, since they work for the same thing, the layers.

; TODO; create a website for this program. it should have pages for stuff such as "classes and methods", which explain which classes there are and how to use them. i.e which methods they have and what parameteres they take

; TODO; is it possible to instantly send backticks? i.e. `

; |-----------------------------------|
; |------------HOTSTRINGS-------------|
; |-----------------------------------|

; This hotstring replaces "]d" with the current date and time via the statement below.
:*:]d::{
    Send(FormatTime(, "d.M.yyyy"))  ; It will look like 13.7.2005
}

name := IniRead("../config/privateConfig.ini", "PrivateInfo", "Name")
eMail := IniRead("../config/privateConfig.ini", "PrivateInfo", "Email")

Hotstring( "::agb", StrReplace(name, "Ã¸", "ø"))
Hotstring( "::a@", eMail)

; |-------------------------------------------|
; |----------- OBJECT CREATION ---------------|
; |-------------------------------------------|

; THIS SHOULD BE AT TOP!


ObjectRegister := ObjectRegistry()

MouseInstance := Mouse()
ObjectRegister.AddObject("MouseInstance", MouseInstance)

ProcessManagerInstance := ProcessManager()
ObjectRegister.AddObject("ProcessManagerInstance", ProcessManagerInstance)


; Allows opening cmd pathed to the current file location for vs code and file explorer.
commandPromptDefaultPath := IniRead("../config/UserProfiles/Profile1/ClassObjects.ini", "CommandPrompt", "DefaultPath")
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
monitorSleepTimeMinutes := IniRead("../config/UserProfiles/Profile1/ClassObjects.ini", "PrivacyController", "MonitorSleepTimeMinutes")
PrivacyController.ChangeCountdown(monitorSleepTimeMinutes,0)

ObjectRegister.AddObject("PrivacyController", PrivacyController)



; GUIPrivacyBox := ""
; minutes := 3
; seconds := 0
; GUICountdown := CountdownGUI(3,0)


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
powerSaverModeGUID := IniRead("../config/UserProfiles/Profile1/ClassObjects.ini", "Battery", "PowerSaverModeGUID")
defaultPowerModeGUID := IniRead("../config/UserProfiles/Profile1/ClassObjects.ini", "Battery", "DefaultPowerModeGUID")
Battery := BatteryController(50, 50)
Battery.setPowerSaverModeGUID(powerSaverModeGUID)
Battery.setDefaultPowerModeGUID(defaultPowerModeGUID)
; Battery.ActivateNormalPowerMode()
ObjectRegister.AddObject("Battery", Battery)

; Used to search for stuff in the browser, translate, and excecute shortcues like close tabs to the right in browser
chatGptLoadTime := IniRead("../config/UserProfiles/Profile1/ClassObjects.ini", "WebNavigator", "chatGptLoadTime")
WebSearcher := WebNavigator()
WebSearcher.SetChatGptLoadTime(chatGptLoadTime)
ObjectRegister.AddObject("WebSearcher", WebSearcher)

; |---------------------------------|
; |-------Keyboard Overlays---------|
; |---------------------------------|

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
; OverlayRegistry.addKeyboardOverlay(SecondaryLayerKeyboardOverlay1)
; OverlayRegistry.addKeyboardOverlay(SecondaryLayerKeyboardOverlay2)
; OverlayRegistry.addKeyboardOverlay(TertiaryLayerKeyboardOverlay1)
ObjectRegister.AddObject("OverlayRegistry", OverlayRegistry)


; ObjectAndProperties = [{object: [property: value, property: value, property: value]}]



; |------------Layer indicators------------|

; Used to switch the active layer
layers := LayerIndicatorController()
layers.addLayerIndicator(1, "Green")
layers.addLayerIndicator(2, "Red")

; |----------------------------------|
; |--------Startup Configurator------|
; |----------------------------------|

; This is used to read ini files, and create hotkeys from them
; StartupConfigurator := Configurator("../config/UserProfiles/Profile1/ClassObjects.ini", ObjectRegister)
; StartupConfigurator := MainStartupConfigurator("../config/UserProfiles/Profile1/ClassObjects.ini", ObjectRegister)
; TODO this should not path to profile1, but rathre the active profile which is chosen in the gui portion of the application
StartupConfigurator := MainStartupConfigurator("../config/UserProfiles/Profile1", ObjectRegister)

StartupConfigurator.ReadAllKeyboardOverlays()

; Is used to initialize all hotkeys, if hotkeys are changed by the user, these changes are stored in the ../config/config.ini file.
; This file is then read by StartupConfigurator and the default hotkeys are changed accordingly
; StartupConfigurator.InitializeAllDefaultKeysToFunctions("PrimaryLayer-Functions")
; StartupConfigurator.ReadKeyboardOverlaySection(SecondaryLayerKeyboardOverlay1, "SecondaryLayerKeyboardOverlay1") 
; StartupConfigurator.ReadKeyboardOverlaySection(SecondaryLayerKeyboardOverlay2, "SecondaryLayerKeyboardOverlay2") 


StartupConfigurator.ReadKeysToFunctionsBySection("PrimaryLayer-Functions")

; StartupConfigurator.ReadAllKeyboardOverlays()

; |-------------------------------------------|
; |------------Ensures consistency------------|
; |-------------------------------------------|

SetCapsLockState("off")
SetNumLockState("off")

; |------------------------------|
; |------Hotkeys (OBSOLETE)------|
; |------------------------------|

; |-----------------------------------|
; |----------Layer switchers----------|
; |-----------------------------------|

; changes the layer to 0 if it is not zero, or 1 if it is zero
NumLock::
CapsLock:: layers.toggleLayerIndicator(1)

; Changes the layer to 2 if it is zero, and then cycles through the layers if it is not zero
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

#HotIf layers.getActiveLayer() == 1

#HotIf


HotIf "layers.getActiveLayer() == 1"
    
    StartupConfigurator.ReadKeysToNewActionsBySection("SecondaryLayer")

HotIf

#HotIf layers.getActiveLayer() == 2 

    ; Shows second keyboard overlay when shift is held down
    ~Shift:: OverlayRegistry.showKeyboardOverlay(TertiaryLayerKeyboardOverlay1) ;SecondKeyboardOverlayDevices.ShowGui() 

    ; Hides second keyboard overlay (and main just in case)
    Shift up:: OverlayRegistry.hideAllLayers() 

    ; Toggles touch-screen
    +1::{ 
        TertiaryLayerKeyboardOverlay1.ToggleState("TouchScreen")
        DeviceManipulator.ToggleTouchScreenToggle()
    } 

    ; Toggles camera
    +2::{ 
        TertiaryLayerKeyboardOverlay1.ToggleState("Camera")
        DeviceManipulator.ToggleCameraToggle()
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
    ; b:: KeyHistory

#HotIf

HotIf "layers.getActiveLayer() == 2"
    
    StartupConfigurator.ReadKeysToNewActionsBySection("TertiaryLayer")

HotIf

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000