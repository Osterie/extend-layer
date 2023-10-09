; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
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


; |--------------------------------------------------|
; |------------------- OPTIMIZATIONS ----------------|
; |--------------------------------------------------|

A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
; KeyHistory 0

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

; !Future, for other users or just for good practice, make the script more easily understandable and learnable for others.
; !do this by creating a meny or gui or markdown file or all of the above! which contains enough information for a decent understanding

; ?a shortcut, which when enabled reads whatever the user is writing, and when they hit enter, it is searched for in the browser

;? checkout: https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/ctrl_caps_as_case_change.ahk
;? link about goes to script which can set text to uppercase, lowercase and more

;? checkout: https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/in-line-calculator/in-line%20calculator.ahk
;? could use calculator anywehre with script above. 

;! checkout: https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/move-inactive-window-alt-leftclick/MoveInactiveWin.ahk
;! move window without activating it. "move window without activating it" so the window can be moved from anywhere, without being activated

;! checkout: https://www.autohotkey.com/docs/v1/scripts/#EasyWindowDrag 
;! move a window from anywhere, can be combined with "move window without activating it" so the window can be moved from anywhere, without being activated

; *checkout https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/win_key_to_show_taskbar.ahk
; *show taskbar when holding windows key, could test for a week and see if it is faster or slower....
; *might be bad since i cant show which app to quick switch to. Might not be an issue

; ?add a way to navigate a level back in file explorer(look up, i think it exists), but try first to find a shortcut to do so.

; *try and explore how to turn on battery-saver. however seems impossible

; ?Perhaps it would be a good idea for a shortcuts to file explorer. (made general so it works when file paths are changed and such.)
; ?The idea would be you could hold ctrl on the first layer, and an overlay would show what key to press to go to which path in the file explorer.
; ?To expand upon this idea, it would be possible to easily create more or remove shortcuts, a simple gui/menu to add/remove filepaths, 
; ?and have it possible to open file explore to choose the folder you want to jump to for the shortcut

; *Make a function/class or something to find and navigat to an open chrome tab. Open a dialog box or something, write the name of / partial name of the tab you
; *want to go to, then each tab is checked if it contains the name given and so on (obvious what to do next)

; *maybe make it possible to save stuff on the second layer also (the ctrl+s shortcut)

; DONE
; //https://github.com/ilirb/ahk-scripts/blob/master/Commands/_Functions.ahk
; //Win+C open a CMD at the current path.
; //Ctrl+Win+C open CMD from everywhere, no need to be in Windows Explorer.

; //add another windows key to the right side of the keyboard

; *Maybe have a way to recognize who is using the computer, if for example the mouse is clicked 10 times or something in a minute, then disable keyboard and mouse, and turn screen dark, maybe off? could be dangerous

; *Make a method in monitor class for adding a transparent black layer over the screen, to be used as a screen dimmer.

; !FUTURE make a simple version which is just the first layer, can be used when main not working

; todo: would be possible to have some hotkeys that open a gui where several options are chosen from.
; for example for changing performance mode, a dropdown menu for high, normal, low performance nad such can be chosen.
; There are many possibilities...

; todo: keep awake for a while, like 30min can be changed in settinsg
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

; TODO: i believe the promt which apperas when a powerhsell script runs can be hidden

; TODO make it possible to switch performance mode, add gui to show current mode, auto switch for screen darkner and such

; TODO FUTURE: possible to integrate with real life appliances, for example to control lights in rooms, a third layer could be created for this
; TODO: automatically slowly change gamma values for fun...

; TODO: a shortcut to turn the screen black(which alredy exists), but randomly change rgb values and then black. (so it looks like it is glitching.) Maybe have it connected to if mouse is used or clicked or something, maybe a certain keypress
; todo: text which conveges and is mirrored along the middle

; Layers and keyboard overlay could possibly be used in a class, since they work for the same thing, the layers.

; |-------------------------------------------|
; |----------- OBJECT CREATION ---------------|
; |-------------------------------------------|

; Allows opening cmd pathed to the current file location for vs code and file explorer.
CommandPrompt := CommandPromptOpener("C:\Users\adria\")

; Allows to write on the screen in a textarea
OnScreenWriter := KeysPressedGui()
OnScreenWriter.CreateGUI()

; Enables / disables input (mouse or keyboard)
; TODO make ComputerInputController enable/disable key class be able to take a key or a key scancode
ComputerInput := ComputerInputController()

; Used to hide screen and parts of the screen
privacyController := PrivacyGUIController()
privacyController.CreateGui()
privacyController.ChangeCountdown(3,0)

; Used to get the states of devices, like if bluetooth and such is enabled, also able to disable/enable these devices
DeviceManipulator := DeviceController()
; DeviceManipulator.UpdateDevicesActionToToggle()

; Shows an on screen overlay for the first keyboard layer which shows which urls can be went to using the number keys
FirstKeyboardOverlay := KeyboardOverlay()
FirstKeyboardOverlay.CreateGui()
FirstKeyboardOverlay.AddStaticColumn("1", "Time Table")
FirstKeyboardOverlay.AddStaticColumn("2", "Black Board")
FirstKeyboardOverlay.AddStaticColumn("3", "Prog 1")
FirstKeyboardOverlay.AddStaticColumn("4", "Team")
FirstKeyboardOverlay.AddStaticColumn("5", "Math")
FirstKeyboardOverlay.AddStaticColumn("6", "Prog Num Sec")
FirstKeyboardOverlay.AddStaticColumn("7", "Jupyter Hub")
FirstKeyboardOverlay.AddStaticColumn("8", "")
FirstKeyboardOverlay.AddStaticColumn("9", "")
FirstKeyboardOverlay.AddStaticColumn("0", "")

; Shows an on screen overlay for the first keyboard layer which shows which number keys to press to enable/disable devices
SecondKeyboardOverlay := KeyboardOverlay()
SecondKeyboardOverlay.CreateGui()
SecondKeyboardOverlay.AddColumnToggleValue("1", "Touch Screen", DeviceManipulator.GetTouchScreenActionToToggle())
SecondKeyboardOverlay.AddColumnToggleValue("2", "Camera", DeviceManipulator.GetCameraActionToToggle())
SecondKeyboardOverlay.AddColumnToggleValue("3", "Blue tooth", DeviceManipulator.GetBluetoothActionToToggle())
SecondKeyboardOverlay.AddColumnToggleValue("4", "Touch Pad", DeviceManipulator.GetTouchPadActionToToggle())

; Used to switch the active layer
layers := LayerIndicatorController()
layers.addLayerIndicator(1, "Green")
layers.addLayerIndicator(2, "Red")

; Used to change brightness and gamma settings of the monitor
Monitor := MonitorController()

; Used to switch between power saver mode and normal power mode (does not work as expected currently, percentage to switch to power saver is changed, but power saver is never turned on...)
Battery := BatteryController(50, 50)
Battery.setPowerSaverModeGUID("a1841308-3541-4fab-bc81-f71556f20b4a")
Battery.setDefaultPowerModeGUID("8759706d-706b-4c22-b2ec-f91e1ef6ed38")
Battery.ActivateNormalPowerMode()

WebSearcher := WebNavigator()
blackboardLoginImages := ["\imageSearchImages\feideBlackboardMaximized.png", "\imageSearchImages\feideBlackboardMinimized.png"]
jupyterHubLoginImages := ["\imageSearchImages\jupyterHubMaximized.png", "\imageSearchImages\jupyterHubMinimized.png"]


; ----Ensures consistency------
SetCapsLockState("off")
SetNumLockState("off")

; |------------------------------|
; |----------Hotkeys-------------|
; |------------------------------|
; TODO add for when !Capslock and #Capslock is pressed and handle the situation accrodingly since it now is buggy
; since they do not have their own hotwkeys and handling.
; changes the layer to 0 if it is not zero, or 1 if it is zero

NumLock::
CapsLock::{ 
    layers.toggleLayerIndicator(1)
    activeLayer := layers.getActiveLayer()

    if (activeLayer == 0){
        ; hides layers wh ich are not the active layer
        layers.hideInactiveLayers()
        ; toggles capslock
        SetCapsLockState("off")
    }
    else{
        ; shows the active layer (which should be layer 1)
        layers.showLayerIndicator(layers.getActiveLayer())
        ; hides layers which are not the acrive layer
        layers.hideInactiveLayers()
        ; toggles capslock
        SetCapsLockState("on")
    }
}

+CapsLock:: {

    activeLayer := layers.getActiveLayer()
    
    if (activeLayer == 0){
        layers.setCurrentLayerIndicator(2)
        layers.showLayerIndicator(2)

        FirstKeyboardOverlay.HideGui()
        SecondKeyboardOverlay.ShowGui()

        SetCapsLockState("on")

    }
    else{

        layers.cycleExtraLayerIndicators()

        newActiveLayer := layers.getActiveLayer()
        layers.showLayerIndicator(newActiveLayer)
        layers.hideInactiveLayers()

        if (newActiveLayer == 1){
            FirstKeyboardOverlay.ShowGui()
            SecondKeyboardOverlay.HideGui()
        }
        else if (newActiveLayer == 2){
            SecondKeyboardOverlay.ShowGui()
            FirstKeyboardOverlay.HideGui()
        }
    }
}

; Shows gui which can be written in to help classmates/colleagues or whatever
#0:: OnScreenWriter.ToggleShowKeysPressed() 

;close tabs to the right
^!w::{ 
    Sleep(500)
    ComputerInput.BlockKeyboard()
    try{
        WebSearcher.CloseTabsToTheRight()
    }
    ComputerInput.UnBlockKeyboard()
} 

; used as an emergency exitapp, since the script is not always easy to exit
+f2::
^f2::
!f2::
#f2::
f2::ExitApp

; Works as Alt f4
^q:: Send("!{f4}")

#c:: CommandPrompt.OpenCmdPathedToCurrentLocation()

; Used to suspend script, suspending the script means noen of its functionalities are active.
; Pressing the same key combination again enables the script again
#SuspendExempt
^!s::Suspend  ; Ctrl+Alt+S
#SuspendExempt False

; |------------------------------|
; |-----------Layers-------------|
; |------------------------------|

#HotIf GetKeyState("CapsLock","T") && layers.getActiveLayer() == 1

    ; Shows first keyboard overlay when a modifier is held down
    ~Shift:: FirstKeyboardOverlay.ShowGui() 

    Shift up::{ 
        SecondKeyboardOverlay.HideGui()
        FirstKeyboardOverlay.HideGui()
    }
    
    ; Go to study plan (from current week to end of first semester currently)
    +1::WebSearcher.OpenUrl("https://tp.educloud.no/ntnu/timeplan/?id[]=38726&type=student&weekTo=52&ar=2023&" , blackboardLoginImages, 3000, true) 

    ; Go to blackboard
    +2::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/course" , blackboardLoginImages, 3000, false) 

    ; Go to programming 1
    +3::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_39969_1/cl/outline" , blackboardLoginImages, 3000, true) 

    ; Go to team class
    +4::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_39995_1/cl/outline" , blackboardLoginImages, 3000, true) 

    ; Go to Math
    +5::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_44996_1/cl/outline" , blackboardLoginImages, 3000, true) 
    
    ; Go to programming and numeric safety stuff...
    +6::WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_43055_1/cl/outline" , blackboardLoginImages, 3000, true) 

    ; Go to jupyterhub
    +7::WebSearcher.LoginToSite("https://inga1002.apps.stack.it.ntnu.no/user/adriangb/lab" , jupyterHubLoginImages, 4000, false) 

    ; Alt gr held down works like holding down the windows key
    LControl & RAlt:: {
        Send("{LWin Down}")
        ComputerInput.DisableKey2("#Capslock")
        keywait("RAlt")
    }

    ; When Alt gr is released, the windows key is no longer active
    LControl & RAlt up:: {
        Send("{LWin Up}")
        ComputerInput.EnableKey2("#Capslock")
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

    ; opens a new tab in chrome which searches for the highlited content, if not content is highlighted, clipboard content is sent.
    t:: WebSearcher.LookUpHighlitedTextOrClipboardContent()
    +t:: WebSearcher.AskChatGptAboutHighligtedTextOrClipboardContent(3000)

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

    <:: MouseMove((A_ScreenWidth//2), (A_ScreenHeight//2))
    g:: AppsKey
    m:: Click()
    
    ,:: F6

    i:: Up
    j:: Left
    k:: Down
    $l:: Right

#HotIf



#HotIf GetKeyState("CapsLock","T") && layers.getActiveLayer() == 2 

    b::KeyHistory
    
    ; Shows second keyboard overlay when shift is held down
    ~Shift:: SecondKeyboardOverlay.ShowGui() 

    ; Hides second keyboard overlay (and first just in case)
    Shift up::{
        FirstKeyboardOverlay.HideGui()
        SecondKeyboardOverlay.HideGui()
    } 

    ; Toggles touch-screen
    +1::{ 
        ; TODO the run should be in the class that handles keyboard overlay, make more classes and such
        SecondKeyboardOverlay.ToggleState("TouchScreen")
        DeviceManipulator.ToggleTouchScreenToggle()
    } 

    ; Toggles camera
    +2::{ 
        SecondKeyboardOverlay.ToggleState("Camera")
        DeviceManipulator.ToggleCameraToggle()
    } 

    ; Toggles bluetooth
    +3::{ 
        SecondKeyboardOverlay.ToggleState("Bluetooth")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-bluetooth.exe")
    } 

    ; Toggles touchpad
    +4::{ 
        SecondKeyboardOverlay.ToggleState("TouchPad")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-touchpad.exe")
    } 

    ; Hides screen
    a:: privacyController.HideScreen()

    ; Hides window
    s:: privacyController.HideWindow()

    ; Hides tabs
    d:: privacyController.HideTabs()

    ; Hides GUI
    f:: privacyController.HideGui()

    ; Blocks input from keyboard and mouse, can be deactivated with Home + End
    Home:: ComputerInput.BlockAllInput()
    
    ; Re-Enables input
    Home & End:: ComputerInput.UnBlockAllInput()

    ; Switches power saver on, or off(wont turn off if Battery is 50% or lower)
    p:: Battery.TogglePowerSaverMode()

    ; Switches brightness to 100 or 50
    u:: Monitor.ToggleHighestBrightness() 
    
    ; Switches brightness to 0 or 50
    j:: Monitor.ToggleLowestBrightness() 

    ; Switches gamma values (r, g, b) to 256,256,256 or 128,128,128
    o:: Monitor.ToggleHighestGamma() 

    ; Switches gamma values (r, g, b) to 0,0,0 or 128,128,128
    i:: Monitor.ToggleLowestGamma()     

    k:: Monitor.CycleRed(63, 255) 

    l:: Monitor.CycleGreen(63, 255)
    
    ø:: Monitor.CycleBlue(63, 255)

    Esc:: ExitApp()

#HotIf

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000