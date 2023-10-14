; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
; I found two ways to make a hotkey which excecutes a class method:
; way1 := OnScreenWriter.ToggleShowKeysPressed.Bind(OnScreenWriter)
; way2 := ObjBindMethod(OnScreenWriter, "ToggleShowKeysPressed")
; HotKey OnScreenWriterHotkey, way1
; HotKey OnScreenWriterHotkey, way2

; CloseTabsToTheRight := ObjBindMethod(WebSearcher, "CloseTabsToTheRight")
; CloseTabsToTheRightHotkey := IniRead("Config.ini", "Hotkeys", "CloseTabsToTheRight") ; Default key is ^!W
; Hotkey(CloseTabsToTheRightHotkey, CloseTabsToTheRight)

#Requires Autohotkey v2.0
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

; |--------------------------------------------------|
; |------------------- OPTIMIZATIONS ----------------|
; |--------------------------------------------------|

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

; *checkout https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/win_key_to_show_taskbar.ahk
; *show taskbar when holding windows key, could test for a week and see if it is faster or slower....
; *might be bad since i cant show which app to quick switch to. Might not be an issue

; *try and explore how to turn on battery-saver. however seems impossible

; ?make it possible to easily create more or remove shortcuts for keyboard overlays, a simple gui/menu to add/remove filepaths/text, 

; !Add a shortcut to copy a piece of the screen and have it as a moveable image

; ?the input reader in KeysPressedGui can probably be made into its own class. It can be used to read input from the user, and then do something with it.

; *Make a function/class or something to find and navigate to an open chrome tab. Open a dialog box or something, write the name of / partial name of the tab you
; *want to go to, then each tab is checked if it contains the name given and so on (obvious what to do next)

; *maybe make it possible to save stuff on the second layer also (the ctrl+s shortcut)

; *Maybe have a way to recognize who is using the computer, if for example the mouse is clicked 10 times or something in a minute, then disable keyboard and mouse, and turn screen dark, maybe off? could be dangerous

; *Make a method in monitor class for adding a transparent black layer over the screen, to be used as a screen dimmer.

; !FUTURE make a simple version which is just the first layer, can be used when main not working

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

; add gui to show current power mode, auto switch for screen darkner and such maybe?

; TODO FUTURE: possible to integrate with real life appliances, for example to control lights in rooms, a third layer could be created for this
; TODO: automatically slowly change gamma values for fun...

; TODO: a shortcut to turn the screen black(which alredy exists), but randomly change rgb values and then black. (so it looks like it is glitching.) Maybe have it connected to if mouse is used or clicked or something, maybe a certain keypress
; todo: text which converges and is mirrored along the middle cool effect only... used as a screensaver or something

; Layers and keyboard overlay could possibly be used in a class, since they work for the same thing, the layers.

; |-----------------------------------|
; |------------HOTSTRINGS-------------|
; |-----------------------------------|

::]d::  ; This hotstring replaces "]d" with the current date and time via the statement below.
{
    Send FormatTime(, "d.M.yyyy")  ; It will look like 9/1/2005 3:53 PM
}

name := IniRead("PrivateConfig.ini", "PrivateInfo", "Name")
eMail := IniRead("PrivateConfig.ini", "PrivateInfo", "Email")

Hotstring "::agb", StrReplace(name, "Ã¸", "ø")
Hotstring "::a@", eMail



; |-------------------------------------------|
; |----------- OBJECT CREATION ---------------|
; |-------------------------------------------|

; This is used to read ini files, and create hotkeys from them
StartupConfigurator := Configurator("Config.ini", "DefaultConfig.ini")

; Allows opening cmd pathed to the current file location for vs code and file explorer.
commandPromptDefaultPath := IniRead("Config.ini", "CommandPrompt", "DefaultPath")
CommandPrompt := CommandPromptOpener(commandPromptDefaultPath)

; Allows navigating the file explorer and opening the file explorer pathed to a given file location
FileExplorer := FileExplorerNavigator()

; Allows to write on the screen in a textarea
OnScreenWriter := KeysPressedGui()
OnScreenWriter.CreateGUI()

; Enables / disables input (mouse or keyboard)
ComputerInput := ComputerInputController()

; Used to hide screen and parts of the screen
privacyController := PrivacyGUIController()
privacyController.CreateGui()
; Sets the countdown for the screen hider to 3 minutes. (change to your screen sleep time)
; This shows a countdown on the screen, and when it reaches 0, the screen goes to sleep
; TODO probably should create a setting for this in ini file
privacyController.ChangeCountdown(3,0)

; Used to get the states of devices, like if bluetooth and such is enabled, also able to disable/enable these devices
DeviceManipulator := DeviceController()
; launches a powershell script which gets the states of some devices, like if the mouse is enabled.
; Having this activated will slow down the startup of the script significantly.
; !DeviceManipulator.UpdateDevicesActionToToggle()

; Shows an on screen overlay for the first keyboard layer which shows which urls can be went to using the number keys
FirstKeyboardOverlayWebsites := KeyboardOverlay()
FirstKeyboardOverlayWebsites.CreateGui()


; FirstKeyboardOverlayWebsites.AddStaticColumn("9", "")
; FirstKeyboardOverlayWebsites.AddStaticColumn("0", "")

; Shows an on screen overlay for the first keyboard layer which shows which file explorer paths can be went to using the number keys
FirstKeyboardOverlayFileExplorer := KeyboardOverlay()
FirstKeyboardOverlayFileExplorer.CreateGui()
FirstKeyboardOverlayFileExplorer.AddStaticColumn("1", "Root")
FirstKeyboardOverlayFileExplorer.AddStaticColumn("2", "Adrian")
FirstKeyboardOverlayFileExplorer.AddStaticColumn("3", "Github")
FirstKeyboardOverlayFileExplorer.AddStaticColumn("4", "Down loads")
FirstKeyboardOverlayFileExplorer.AddStaticColumn("5", "School")
FirstKeyboardOverlayFileExplorer.AddStaticColumn("6", "Mappe")
; FirstKeyboardOverlayFileExplorer.AddStaticColumn("7", "")
; FirstKeyboardOverlayFileExplorer.AddStaticColumn("8", "")
; FirstKeyboardOverlayFileExplorer.AddStaticColumn("9", "")
; FirstKeyboardOverlayFileExplorer.AddStaticColumn("0", "")


; Shows an on screen overlay for the first keyboard layer which shows which number keys to press to enable/disable devices
SecondKeyboardOverlayDevices := KeyboardOverlay()
SecondKeyboardOverlayDevices.CreateGui()
SecondKeyboardOverlayDevices.AddColumnToggleValue("1", "Touch Screen", DeviceManipulator.GetTouchScreenActionToToggle())
SecondKeyboardOverlayDevices.AddColumnToggleValue("2", "Camera", DeviceManipulator.GetCameraActionToToggle())
SecondKeyboardOverlayDevices.AddColumnToggleValue("3", "Blue tooth", DeviceManipulator.GetBluetoothActionToToggle())
SecondKeyboardOverlayDevices.AddColumnToggleValue("4", "Touch Pad", DeviceManipulator.GetTouchPadActionToToggle())


OverlayRegistry := KeyboardOverlayRegistry()
OverlayRegistry.addKeyboardOverlay(FirstKeyboardOverlayWebsites)
OverlayRegistry.addKeyboardOverlay(FirstKeyboardOverlayFileExplorer)
OverlayRegistry.addKeyboardOverlay(SecondKeyboardOverlayDevices)

; Used to switch the active layer
layers := LayerIndicatorController()
layers.addLayerIndicator(1, "Green")
layers.addLayerIndicator(2, "Red")

; Used to change brightness and gamma settings of the monitor
Monitor := MonitorController()

; Used to switch between power saver mode and normal power mode (does not work as expected currently, percentage to switch to power saver is changed, but power saver is never turned on...)
powerSaverModeGUID := IniRead("Config.ini", "Battery", "PowerSaverModeGUID")
defaultPowerModeGUID := IniRead("Config.ini", "Battery", "DefaultPowerModeGUID")
Battery := BatteryController(50, 50)
Battery.setPowerSaverModeGUID(powerSaverModeGUID)
Battery.setDefaultPowerModeGUID(defaultPowerModeGUID)
Battery.ActivateNormalPowerMode()

; Used to search for stuff in the browser, translate, and excecute shortcues like close tabs to the right in browser
WebSearcher := WebNavigator()
; paths to urls of images used to click login buttons
blackboardLoginImages := ["\imageSearchImages\feideBlackboardMaximized.png", "\imageSearchImages\feideBlackboardMinimized.png"]
jupyterHubLoginImages := ["\imageSearchImages\jupyterHubMaximized.png", "\imageSearchImages\jupyterHubMinimized.png"]

; |-------------------------------------------|
; |------------Ensures consistency------------|
; |-------------------------------------------|
SetCapsLockState("off")
SetNumLockState("off")

; |------------------------------|
; |----------Hotkeys-------------|
; |------------------------------|

; changes the layer to 0 if it is not zero, or 1 if it is zero
NumLock::
CapsLock::{ 
    ; if capslock is on, turn it off
    if (GetKeyState("CapsLock", "T") == 1){
        SetCapsLockState("off")
    }
    layers.toggleLayerIndicator(1)
}

; Changes the layer to 2 if it is zero, and then cycles through the layers if it is not zero
+CapsLock:: {

    activeLayer := layers.getActiveLayer()
    
    if (activeLayer == 0){
        layers.showLayerIndicator(2)
    }
    else{

        layers.cycleExtraLayerIndicators()

        newActiveLayer := layers.getActiveLayer()
        layers.showLayerIndicator(newActiveLayer)
        layers.hideInactiveLayers()

        if (newActiveLayer == 1){
            OverlayRegistry.showKeyboardOverlay(FirstKeyboardOverlayWebsites)
        }
        else if (newActiveLayer == 2){
            OverlayRegistry.showKeyboardOverlay(SecondKeyboardOverlayDevices)
        }
    }
}

; Is used to initialize all hotkeys, if hotkeys are changed by the user, these changes are stored in the Config.ini file.
; This file is then read by StartupConfigurator and the default hotkeys are changed accordingly
StartupConfigurator.InitializeAllHotkeys("Hotkeys")

; Shows/hides gui which can be written in to help classmates/colleagues or whatever
#0:: OnScreenWriter.ToggleShowKeysPressed()

; close tabs to the right
^!w:: WebSearcher.CloseTabsToTheRight() 

; Works as Alt f4
^q:: Send("!{f4}")

; press f2 + any modifier to exit script
; used as an emergency exitapp, since the script may have bugs which make it hard to exit.
*f2::ExitApp

; Win+C Opens a command prompt at the current location
#c:: CommandPrompt.OpenCmdPathedToCurrentLocation()

; Used to suspend script, suspending the script means noen of its functionalities are active.
; Pressing the same key combination again enables the script again
; SuspendExempt means this hotkey will not be suspended when the script is suspended.
; Since this hotkey suspends the script it is important that it is not suspended itself.
#SuspendExempt
; Even though all hotkeys should be initialized, this is necessary becaues the hotkey to suspend the
; script is required to be suspend exempt.
StartupConfigurator.InitializeHotkey("Hotkeys", "SuspendScript", "^!s")
^!s::Suspend  ; Ctrl+Alt+S
#SuspendExempt False

; |------------------------------|
; |-----------Layers-------------|
; |------------------------------|

#HotIf layers.getActiveLayer() == 1


    ; Shows first keyboard overlay for websites when a shift is held down
    ~Shift:: OverlayRegistry.showKeyboardOverlay(FirstKeyboardOverlayWebsites) ;FirstKeyboardOverlayWebsites.ShowGui() 

    ; Shows first keyboard overlay for file explorer when a shift is held down
    ~Ctrl::  OverlayRegistry.showKeyboardOverlay(FirstKeyboardOverlayFileExplorer)  ;FirstKeyboardOverlayFileExplorer.ShowGui()

    ; Hides first keyboard overlay for file explorer 
    Ctrl up:: OverlayRegistry.hideKeyboardOverlay(FirstKeyboardOverlayFileExplorer) ;FirstKeyboardOverlayFileExplorer.HideGui()

    ; Hides first keyboard overlay for websites (and second overlay for devices just in case)
    Shift up:: OverlayRegistry.hideAllLayers()
    
    ; Go to study plan (from current week to end of first semester currently)
    +1::WebSearcher.OpenUrl("https://tp.educloud.no/ntnu/timeplan/?id[]=38726&type=student&weekTo=52&ar=2023&") 

    ; Go to blackboard
    +2::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/course" , blackboardLoginImages, 3000, false) 
    
    ; Go to programming 1, try to login if not logged in
    +3::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_39969_1/cl/outline" , blackboardLoginImages, 3000, true) 

    ; Go to team class, try to login if not logged in
    +4::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_39995_1/cl/outline" , blackboardLoginImages, 3000, true) 

    ; Go to Math, try to login if not logged in
    +5::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_44996_1/cl/outline" , blackboardLoginImages, 3000, true) 
    
    ; Go to programming, numeric and safety, try to login if not logged in
    +6::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_43055_1/cl/outline" , blackboardLoginImages, 3000, true) 

    ; Go to jupyterhub, try to login if not logged in
    +7::WebSearcher.LoginToSite("https://inga1002.apps.stack.it.ntnu.no/user/adriangb/lab" , jupyterHubLoginImages, 4000, false) 

    ; Go to capquiz
    +8::WebSearcher.OpenUrl("https://capquiz.math.ntnu.no/my/")
    
    ; opens the file explorer in the given location
    ^1:: FileExplorer.NavigateToFolder("C:\") 
    ^2:: FileExplorer.NavigateToFolder("C:\Users\adria")
    ^3:: FileExplorer.NavigateToFolder("C:\Users\adria\github")
    ^4:: FileExplorer.NavigateToFolder("C:\Users\adria\Downloads")
    ^5:: FileExplorer.NavigateToFolder("C:\Users\adria\github\University")
    ^6:: FileExplorer.NavigateToFolder("C:\Users\adria\github\University\Programmering 1\Mappe Vurdering\mappe-idata1003-traindispatchsystem-Osterie")

    ; Alt gr held down works like holding down the windows key
    LControl & RAlt:: {
        Send("{LWin Down}")
        ComputerInput.DisableKey("#Capslock")
        keywait("RAlt")
    }

    ; When Alt gr is released, the windows key is no longer active
    LControl & RAlt up:: {
        Send("{LWin Up}")
        ComputerInput.EnableKey("#Capslock")
    }

    q:: Esc
    å:: Esc
    
    a:: Alt
    d:: Shift
    f:: Ctrl
    n:: Tab

    w:: WheelUp
    s:: WheelDown

    e:: Browser_Back
    r:: Browser_Forward



    ; opens a new tab in chrome which searches for the highlited content, if no content is highlighted, clipboard content is sent.
    t:: WebSearcher.LookUpHighlitedTextOrClipboardContent()
    
    ; Searches in the same manner as above, but in a chat with GPT-3
    +t:: WebSearcher.AskChatGptAboutHighligtedTextOrClipboardContent(3000)
    
    ; Ctrl + t translates highlighted text or clipboard content from a detected language to english 
    ^t::{
        translatedText := WebSearcher.TranslateHighlightedTextOrClipboard("auto", "en")
        MsgBox(translatedText)
    }

    ; Ctrl Shift+ + t translates highlighted text or clipboard content from a detected language to norwegian
    ^+t::{
        translatedText := WebSearcher.TranslateHighlightedTextOrClipboard("auto", "no")
        MsgBox(translatedText)
    }

    ; Creates an input box, which when confirm or enter is pressed, searches the web for its contents
    b::{
        inputBoxWebSearch := InputBox("What would you like to search in the browser?", "Web search", "w150 h150")
        WebSearcher.SearchInBrowser(inputBoxWebSearch.Value)
    }

    y:: PgUp
    h:: PgDn

    u:: Home
    o:: End

    p:: Del
    ø:: BackSpace

    z:: ^z
    x:: ^x
    c:: ^c
    v:: ^v

    ; LeftClick
    m:: Click()
    ; RightClick
    g:: AppsKey
    ; Moves mouse to the center of the screen
    <:: MouseMove((A_ScreenWidth//2), (A_ScreenHeight//2))
    
    ,:: F6

    i:: Up
    j:: Left
    k:: Down
    l:: Right

#HotIf

HotIf "layers.getActiveLayer() == 1"
    Hotkey("r", "t")
    Hotkey("t", "off")
HotIf



#HotIf layers.getActiveLayer() == 2 

    ; Shows key history, used for debugging
    b::KeyHistory
    
    ; Shows second keyboard overlay when shift is held down
    ~Shift:: OverlayRegistry.showKeyboardOverlay(SecondKeyboardOverlayDevices) ;SecondKeyboardOverlayDevices.ShowGui() 

    ; Hides second keyboard overlay (and first just in case)
    Shift up:: OverlayRegistry.hideAllLayers() 

    ; Toggles touch-screen
    +1::{ 
        SecondKeyboardOverlayDevices.ToggleState("TouchScreen")
        DeviceManipulator.ToggleTouchScreenToggle()
    } 

    ; Toggles camera
    +2::{ 
        SecondKeyboardOverlayDevices.ToggleState("Camera")
        DeviceManipulator.ToggleCameraToggle()
    } 

    ; Toggles bluetooth
    +3::{ 
        SecondKeyboardOverlayDevices.ToggleState("Bluetooth")
        DeviceManipulator.ToggleBluetooth()
    } 

    ; Toggles touchpad
    +4::{ 
        SecondKeyboardOverlayDevices.ToggleState("TouchPad")
        DeviceManipulator.ToggleTouchPad()
    } 

    ; Hides screen
    a:: privacyController.HideScreen()

    ; Hides windows
    s:: privacyController.HideWindow()

    ; Hides tabs
    d:: privacyController.HideTabs()

    ; Hides the gui which is used to hide tabs, windows and the screen
    f:: privacyController.HideGui()

    ; Blocks input from keyboard and mouse, can be deactivated with Home + End
    Home:: ComputerInput.BlockAllInput()
    
    ; Re-Enables input
    Home & End:: ComputerInput.UnBlockAllInput()

    ; Switches power saver on, or off(wont turn off if Battery is 50% or lower)
    p:: Battery.TogglePowerSaverMode()

    ; Switches brightness to 100 or 50
    u:: Monitor.ToggleHighestBrightness() 
    
    ; ; Switches brightness to 0 or 50
    j:: Monitor.ToggleLowestBrightness() 

    ; Switches gamma values (r, g, b) to 256,256,256 or 128,128,128
    o:: Monitor.ToggleHighestGamma() 

    ; Switches gamma values (r, g, b) to 0,0,0 or 128,128,128
    i:: Monitor.ToggleLowestGamma()     

    ; Increases red by 63 until it reaches 255, then it starts over
    k:: Monitor.CycleRed(63, 255) 

    ; Increases green by 63 until it reaches 255, then it starts over
    l:: Monitor.CycleGreen(63, 255)
    
    ; Increases blue by 63 until it reaches 255, then it starts over
    ø:: Monitor.CycleBlue(63, 255)

    ; Closes script
    Esc:: ExitApp

#HotIf

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000