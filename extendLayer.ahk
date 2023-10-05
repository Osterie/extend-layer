; [^ = Ctrl] [+ = Shift] [! = Alt] [# = WinK]
#Requires Autohotkey v2.0
#Include ".\library\CountdownGUI.ahk"
#Include ".\library\library.ahk"
#Include ".\library\MonitorController.ahk"
#Include ".\library\LayerIndicatorController.ahk"
#Include ".\library\BatteryController.ahk"
#Include ".\library\PrivacyGUIController.ahk"
#Include ".\library\ComputerInputController.ahk"
#Include ".\library\KeysPressedGui.ahk"
#Include ".\library\WebNavigator.ahk"
#Include ".\library\KeyboardOverlay.ahk"
#Include ".\library\DeviceController.ahk"

; |-----------------------------------------------------|
; |---------------------- OPTIMIZATIONS ----------------|
; |-----------------------------------------------------|

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
; Not changing SendMode defaults it to "input", which makes hotkeys super mega terrible
SendMode "Event"

; |-----------------------------------------------------------|
; |----- Runs AHK script as Admin ----------------------------|
; |----- Allows Excecuting Powershell Scripts ----------------|
; |----- Also makes it possible to run powercfg and such -----|
; |-----------------------------------------------------------|

if (not A_IsAdmin){
	Run("*RunAs `"" A_ScriptFullPath "`"") ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.
}

; |---------------------------------------------------|
; |-------------- TO-DO LIST -------------------------|
; |---------------------------------------------------|
; !add a priority rating for all the todos, using !, ?, and *

; Fixme: bug with second layer, showing wrong text, easay fix probably.

; Add a quick search for chat-gpt

; a shortcut, which when enabled reads whatever the user is writing, and when they hit enter, it is searched for in the browser

; add a shortcut for enabling/disabling the script. there is probably a built in function/method or whaterver for this already, Suspend.

; checkout: https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/ctrl_caps_as_case_change.ahk
; link about goes to script which can set text to uppercase, lowercase and more

; checkout: https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/in-line-calculator/in-line%20calculator.ahk
; could use calculator anywehre with script above

; checkout: https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/move-inactive-window-alt-leftclick/MoveInactiveWin.ahk
; move window without activating it. "move window without activating it" so the window can be moved from anywhere, without being activated

; checkout: https://www.autohotkey.com/docs/v1/scripts/#EasyWindowDrag 
; move a window from anywhere, can be combined with "move window without activating it" so the window can be moved from anywhere, without being activated

; checkout https://github.com/GorvGoyl/Autohotkey-Scripts-Windows/blob/master/win_key_to_show_taskbar.ahk
; show taskbar when holding windows key, could test for a week and see if it is faster or slower....
; might be bad since i cant show which app to quick switch to. Might not be an issue

; add a way to navigate a level back in file explorer, but try first to find a shortcut to do so.

; FIXME fix WebNavigator

; try and explore how to turn on battery-saver. however seems impossible

; Perhaps it would be a good idea for a shortcuts to file explorer. (made general so it works when file paths are changed and such.)
; The idea would be you could hold ctrl on the first layer, and an overlay would show what key to press to go to which path in the file explorer.

; Make a function/class or something to find a tab. Open a dialog box or something, write the name of / partial name of the tab you
; want to go to, then each tab is checked if it contains the name given and so on (obvious what to do next)


; https://github.com/ilirb/ahk-scripts/blob/master/Commands/_Functions.ahk
; Win+C open a CMD at the current path.
; Ctrl+Win+C open CMD from everywhere, no need to be in Windows Explorer.


; Make it possible to change contrast.

; Make num lock do the same as capslock (layer changer)

; make a simple version which is just the first layer, can be used when main not working

; todo: would be possible to have some hotkeys that open a gui where several options are chosen from.
; for example for changing performance mode, a dropdown menu for high, normal, low performance nad such can be chosen.
; There are many possibilities...

; todo; create function/methods for "toggleValues(value1, value2, defaultValue)"

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

; TODO: to make those keyboard overlay classes only one class and more genereal, make then read a file which contains information about how the overlay should look
; for a new row, write something to indicate a new row.

; TODO; able to restart a wireless router? check here and search: https://github.com/shajul/Autohotkey/blob/master/Scriplets/Wireless_Router_Restart.ahk

; TODO; powershell is slow. is there an alternative? can it be made faster? can it be used without opening the terminal view at all?

; TODO; Add some tooltip or something which shows when script is launced

; TODO; have a timer show up when screen is about to go to sleep? probably worthless since it dimmens before turning off.

; TODO: create a class called keyboard registry or something, connect keyboard class to keyboard overlay class also.
; TODO; auto search for the copied text shortcut. (first layer obvs)

; TODO: in lib.ahk, there are two very similiar classes, use inheritance or whatever, take arguments, do something to reuse code, ugly now

; TODO; create a seperate script to log how much power is being used? maybe make this a method for the Battery class, and a seperate class for batteryLogger which is an object which will be used in Battery class

; TODO: connect/disconnect airpods,

; TODO: change background of the keyboard overlay keys for disabling/enabling to have green/red background based on if it is on or off
; TODO: keyboard overlay for disabling/enabling devices should maybe use images instead of text?

; TODO: i believe the promt which apperas when a powerhsell script runs can be hidden

; TODO make it possible to switch performance mode, add gui to show current mode, auto switch for screen darkner and such

; TODO FUTURE: possible to integrate with real life appliances, for example to control lights in rooms, a third layer could be created for this
; TODO: automatically slowly change gamma values for fun...

; TODO: the scroll wheel shortcut should probably only scroll once, not twice.

; TODO: a shortcut to turn the screen black(which alredy exists), but randomly change rgb values and then black. (so it looks like it is glitching.) Maybe have it connected to if mouse is used or clicked or something, maybe a certain keypress
; todo: text which conveges and is mirrored along the middle

; |-------------------------------------------|
; |----------- OBJECT CREATION ---------------|
; |-------------------------------------------|



; Allows to write on the screen in a textarea
OnScreenWriter := KeysPressedGui()
OnScreenWriter.CreateGUI()

; Enables / disables input (mouse or keyboard)
ComputerInput := ComputerInputController()

; Used to hide screen and parts of the screen
privacyController := PrivacyGUIController()
privacyController.CreateGui()
privacyController.ChangeCountdown(3,0)

; ------------------FIIIIIXXX--------------------------
; TODO this is a pretty bad way to do this... 

DeviceManipulator := DeviceController()
DeviceManipulator.UpdateDevicesActionToToggle()

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

UrlNavigator := WebNavigator()
blackboardLoginImages := ["\imageSearchImages\feideBlackboardMaximized.png", "\imageSearchImages\feideBlackboardMinimized.png"]
jupyterHubLoginImages := ["\imageSearchImages\jupyterHubMaximized.png", "\imageSearchImages\jupyterHubMinimized.png"]


; ----Ensures consistency------
SetCapsLockState("off")

; |------------------------------|
; |----------Hotkeys-------------|
; |------------------------------|
; TODO add for when !Capslock and #Capslock is pressed and handle the situation accrodingly since it now is buggy
; since they do not have their own hotwkeys and handling.
; changes the layer to 0 if it is not zero, or 1 if it is zero
CapsLock::{ 
    layers.toggleLayerIndicator(1)
    activeLayer := layers.getActiveLayer()

    if (activeLayer == 0){
        ; hides layers which are not the active layer
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
        ; FirstKeyboardOverlayInstance.HideGui()
        ; SecondKeyboardOverlayInstance.ShowGui()
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
            ; FirstKeyboardOverlayInstance.ShowGui()
            SecondKeyboardOverlay.HideGui()

            ; SecondKeyboardOverlayInstance.HideGui()
        }
        else if (newActiveLayer == 2){
            ; SecondKeyboardOverlayInstance.ShowGui()
            SecondKeyboardOverlay.ShowGui()

            ; FirstKeyboardOverlayInstance.HideGui()
            FirstKeyboardOverlay.HideGui()
        }
    }
}

; Shows gui which can be written in to help classmates/colleagues or whatever
#0:: OnScreenWriter.ToggleShowKeysPressed() 

;close tabs to the right
^!w::{ 
    ComputerInput.BlockKeyboard()
    Send("\^l{F6}{AppsKey}{Up}{Enter}")
    Send("+{F6 2}") ;go back to body of page 
    ComputerInput.UnBlockKeyboard()
} 

; Works as Alt f4
^q:: Send("!{f4}")

; |------------------------------|
; |-----------Layers-------------|
; |------------------------------|


#HotIf GetKeyState("CapsLock","T") && layers.getActiveLayer() == 1

    ~Shift::{ 
        FirstKeyboardOverlay.ShowGui()
        ; FirstKeyboardOverlayInstance.ShowGui()
    } 

    Shift up::{ 
        SecondKeyboardOverlay.HideGui()

        ; SecondKeyboardOverlayInstance.HideGui()
        ; FirstKeyboardOverlayInstance.HideGui()
        FirstKeyboardOverlay.HideGui()
    } 
    ; Go to study plan (from current week to end of first semester currently)
    +1::UrlNavigator.LoginToSite("https://tp.educloud.no/ntnu/timeplan/?id[]=38726&type=student&weekTo=52&ar=2023&" , blackboardLoginImages, 3000, true) 

    ; Go to blackboard
    +2::UrlNavigator.OpenUrl("https://ntnu.blackboard.com/ultra/course")

    ; Go to programming 1
    +3::UrlNavigator.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_39969_1/cl/outline" , blackboardLoginImages, 3000, true) 

    ; Go to team class
    +4::UrlNavigator.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_39995_1/cl/outline" , blackboardLoginImages, 3000, true) 

    ; Go to Math
    +5::UrlNavigator.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_44996_1/cl/outline" , blackboardLoginImages, 3000, true) 
    
    ; Go to programming and numeric safety stuff...
    +6::UrlNavigator.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_43055_1/cl/outline" , blackboardLoginImages, 3000, true) 

    ; Go to jupyterhub
    +7::UrlNavigator.LoginToSite("https://inga1002.apps.stack.it.ntnu.no/user/adriangb/lab" , jupyterHubLoginImages, 4000, false) 

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
    t:: SearchHighlitedOrClipboard()

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
    l:: Right

#HotIf

#HotIf GetKeyState("CapsLock","T") && layers.getActiveLayer() == 2 

    ; Shows second keyboard overlay when shift is held down
    ~Shift::{
        SecondKeyboardOverlay.ShowGui()
        ; SecondKeyboardOverlayInstance.ShowGui()
        KeyWait("Shift")
    } 

    ; Hides second keyboard overlay (and first just in case)
    Shift up::{
        FirstKeyboardOverlay.HideGui()
        SecondKeyboardOverlay.HideGui()

        ; FirstKeyboardOverlayInstance.HideGui()
        ; SecondKeyboardOverlayInstance.HideGui()
    } 

    ; Toggles touch-screen
    +1::{ 
        ; TODO the run should be in the class that handles keyboard overlay, make more classes and such
        SecondKeyboardOverlay.ToggleState("TouchScreen")
        DeviceManipulator.ToggleTouchScreenToggle()
        ; RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-touch-screen.exe")
    } 

    ; Toggles camera
    +2::{ 
        SecondKeyboardOverlay.ToggleState("Camera")
        DeviceManipulator.ToggleCameraToggle()
        ; RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-hd-camera.exe")
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

#HotIf ; End:)

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000