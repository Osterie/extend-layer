; [^ = Ctrl] [+ = Shift] [! = Alt] [# = WinK]
#Requires Autohotkey v2.0
#Include ".\library\CountdownGUI.ahk"
#Include ".\library\library.ahk"
#Include ".\library\Monitor.ahk"
#Include ".\library\LayerIndicatorController.ahk"
#Include ".\library\BatteryController.ahk"
#Include ".\library\PrivacyGUIController.ahk"
#Include ".\library\InputController.ahk"

;---------------------- OPTIMIZATIONS ------------------

; DllCall("Sleep", "UInt", 1) ;I just slept exactly 1ms!

A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
KeyHistory 0
ListLines(False)
SetKeyDelay(-1, -1)
SetMouseDelay(-1)
SetDefaultMouseSpeed(0)
SetWinDelay(-1)
SetControlDelay(-1)

;--------------------- Runs AHK script as Admin, allows excecution scripts which require admin privilleges -------------------

SetWorkingDir(A_ScriptDir)
if not A_IsAdmin
	Run("*RunAs `"" A_ScriptFullPath "`"") ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.


; -------------- TO-DO LIST -------------------------

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

; TODO: to make those keyboard overlay classes only one class and more genereal, make then read a file which contains information about how the overlay should look
; for a new row, write something to indicate a new row.

; TODO; able to restart a wireless router? check here and search: https://github.com/shajul/Autohotkey/blob/master/Scriplets/Wireless_Router_Restart.ahk

; TODO; powershell is slow. is there an alternative? can it be made faster? can it be used without opening the terminal view at all?

; TODO; Add some tooltip or something which shows when script is launced

; TODO; have a timer show up when screen is about to go to sleep? probably worthless since it dimmens before turning off.

; TODO: create a class called keyboard registry or something, connect keyboard class to keyboard overlay class also.
; TODO; auto search for the copied text shortcut. (first layer obvs)

; TODO: in lib.ahk, there are two very similiar classes, use inheritance or whatever, take arguments, do something to reuse code, ugly now

; TODO; create a seperate script to log how much power is being used? maybe make this a method for the battery class, and a seperate class for batteryLogger which is an object which will be used in battery class

; // TODO: scrape assignemtns and add to keyboard overlay? which also has link to it and color showing if it is completed or not

; TODO: connect/disconnect airpods,

;// Cant check battery temp TODO: show warning when computer gets too hot!! show temperature also

; TODO: change background of the keyboard overlay keys for disabling/enabling to have green/red background based on if it is on or off
; TODO: keyboard overlay for disabling/enabling devices should maybe use images instead of text?

; TODO: i believe the promt which apperas when a powerhsell script runs can be hidden

; TODO when screen darkened show battery percentage and maybe a countdown to sleep? maybe even make sleep impossible when screen darkened
; TODO make it possible to switch performance mode, add gui to show current mode, auto switch for screen darkner and such

; TODO FUTURE: possible to integrate with real life appliances, for example to control lights in rooms, a third layer could be created for this
; TODO: automatically slowly change gamma values for fun...

; TODO: the scroll wheel shortcut should probably only scroll once, not twice.

; TODO: a shortcut to turn the screen black(which alredy exists), but randomly change rgb values and then black. (so it looks like it is glitching.) Maybe have it connected to if mouse is used or clicked or something, maybe a certain keypress
; todo: text which conveges and is mirrored along the middle

; ----------- OBJECT CREATION ---------------

; Enables / disables input (mouse or keyboard)
Input := InputController()

; Used to hide screen and parts of the screen
privacyController := PrivacyGUIController()
privacyController.CreateGui()
privacyController.ChangeCountdown(3,0)

; Shows an on screen overlay for the first keyboard layer which shows which urls can be went to using the number keys
FirstKeyboardOverlayInstance := FirstKeyboardOverlay()
FirstKeyboardOverlayInstance.CreateKeyboardOverlay()


; TODO this is a pretty bad way to do this... 
; Shows an on screen overlay for the first keyboard layer which shows which number keys to press to enable/disable devices
SecondKeyboardOverlayInstance := SecondKeyboardOverlay()
SecondKeyboardOverlayInstance.CreateKeyboardOverlay()

; Used to switch the active layer
layers := LayerIndicatorController()
layers.addLayerIndicator(1, "Green")
layers.addLayerIndicator(2, "Red")

; Used to change brightness and gamma settings of the monitor
MonitorInstance := Monitor()

; Used to switch between power saver mdoe and normal power mode
battery := BatteryController(50, 50)
battery.setPowerSaverModeGUID("a1841308-3541-4fab-bc81-f71556f20b4a")
battery.setDefaultPowerModeGUID("8759706d-706b-4c22-b2ec-f91e1ef6ed38")
battery.ActivateNormalPowerMode()


; ----Ensures consistency------
; turns off CapsLock
SetCapsLockState("off")

#HotIf GetKeyState("CapsLock","T") && layers.getActiveLayer() == 1

    ~Shift::{ 
        FirstKeyboardOverlayInstance.ShowGui()
    } 

    Shift up::{ 
        SecondKeyboardOverlayInstance.HideGui()
        FirstKeyboardOverlayInstance.HideGui()
    } 
    ; Go to study plan (from current week to end of first semester currently)
    +1::{ 
        Run("chrome.exe `"https://tp.educloud.no/ntnu/timeplan/?id[]=38726&type=student&weekTo=52&ar=2023&`"")
    } 

    ; Go to blackboard
    +2::{ 
        Run("chrome.exe `"https://ntnu.blackboard.com/ultra/course`"")
        Sleep(4000)
    }

    ; Go to programming 1
    +3::{ 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_39969_1/cl/outline")
    } 

    ; Go to team class
    +4::{ 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_39995_1/cl/outline")
    } 

    ; Go to Math
    +5::{ 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_44996_1/cl/outline")
    } 
    
    ; Go to programming and numeric safety stuff...
    +6::{ 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_43055_1/cl/outline")
    } 

    ; Go to jupyterhub
    +7::{ 
        Run("chrome.exe `"https://inga1002.apps.stack.it.ntnu.no/user/adriangb/lab`"")
        Sleep(2000)
        LoginToJupyterHub()
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

    m:: Click()
    ,:: F6
    <:: MouseMove((A_ScreenWidth//2), (A_ScreenHeight//2))

    g:: AppsKey
    i:: Up
    j:: Left
    k:: Down
    l:: Right

#HotIf

#HotIf GetKeyState("CapsLock","T") && layers.getActiveLayer() == 2 


    ; Shows second keyboard overlay when shift is held down
    ~Shift::{ 
        SecondKeyboardOverlayInstance.ShowGui()
        KeyWait("Shift")
    } 

    ; Hides second keyboard overlay (and first just in case)
    Shift up::{ 
        FirstKeyboardOverlayInstance.HideGui()
        SecondKeyboardOverlayInstance.HideGui()
    } 

    ; Toggles touch-screen
    +1::{ 
        ; TODO the run should be in the class that handles keyboard overlay, make more classes and such
        SecondKeyboardOverlayInstance.ChangeState("Touch-Screen")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-touch-screen.exe")
    } 

    ; Toggles camera
    +2::{ 
        SecondKeyboardOverlayInstance.ChangeState("Camera")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-hd-camera.exe")
    } 

    ; Toggles bluetooth
    +3::{ 
        SecondKeyboardOverlayInstance.ChangeState("Bluetooth")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-bluetooth.exe")
    } 

    ; Toggles touchpad
    +4::{ 
        SecondKeyboardOverlayInstance.ChangeState("Touchpad")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-touchpad.exe")
    } 

    ; Hides screen
    a:: {
        privacyController.HideScreen()
    }

    ; Hides window
    s::{
        privacyController.HideWindow()
    }
    ; Hides tabs
    d:: {
        privacyController.HideTabs()
    }

    ; Hides GUI
    f:: {
        privacyController.HideGui()
    }

    ; Blocks input from keyboard and mouse, can be deactivated with Home + End
    Home::{
        Input.BlockAllInput()
    }
    
    ; Re-Enables input
    Home & End::{
        Input.UnBlockAllInput()
    }


    ; Switches power saver on, or off(wont turn off if battery is 50% or lower)
    p::{
        battery.TogglePowerSaverMode()
    }

    ; Switches brightness to 100 or 50
    u:: MonitorInstance.ToggleHighestBrightness() 
    ; Switches brightness to 0 or 50
    j:: MonitorInstance.ToggleLowestBrightness() 

    ; Switches gamma values (r, g, b) to 256,256,256 or 128,128,128
    o:: MonitorInstance.ToggleHighestGamma() 

    ; Switches gamma values (r, g, b) to 0,0,0 or 128,128,128
    i:: MonitorInstance.ToggleLowestGamma()     

    k:: MonitorInstance.CycleRed(63, 255) 

    l:: MonitorInstance.CycleGreen(63, 255)
    
    ø:: MonitorInstance.CycleBlue(63, 255)

    Esc:: ExitApp()

#HotIf ; End:)

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

        FirstKeyboardOverlayInstance.HideGui()
        SecondKeyboardOverlayInstance.ShowGui()

        SetCapsLockState("on")

    }
    else{

        layers.cycleExtraLayerIndicators()

        newActiveLayer := layers.getActiveLayer()
        layers.showLayerIndicator(newActiveLayer)
        layers.hideInactiveLayers()

        if (newActiveLayer == 1){
            FirstKeyboardOverlayInstance.ShowGui()
            SecondKeyboardOverlayInstance.HideGui()
        }
        else if (newActiveLayer == 2){
            SecondKeyboardOverlayInstance.ShowGui()
            FirstKeyboardOverlayInstance.HideGui()
        }
    }
} 

; -----------Show Keys Pressed (make into function or something?) or class? class can have create method and destroy method idk...---------
;------------- Second layer ctrl + 0 (^0) shortcut, shows a gui which can be written text into.------------

toggleKeysGUI := 0

; fixme only create when going to use
GUIshowKeysPressed := Gui()
; GUIshowKeysPressed.new() ; Create a new GUI
GUIshowKeysPressed.Opt("-Caption +AlwaysOnTop +Owner +LastFound")
GUIshowKeysPressed.BackColor := "EEAA99"
GUIshowKeysPressed.SetFont("s20 w70 q4", "Times New Roman")
showKeysPressedControl := GUIshowKeysPressed.AddText(, "")


; TODO: make class
; Shows gui which can be written in to help classmates/colleagues or whatever
#0:: { 
    global  
    toggleKeysGUI := ToggleValue(toggleKeysGUI, 1, 0, 0)
    if (toggleKeysGUI){
        ; TODO can maybe reduce number of lines in this function?
        CreateHotkey(showKeysPressedControl)
        GUIshowKeysPressed.Show()
    }
    else {
        DisableHotKeys()
        SetTextAndResize(showKeysPressedControl, "")
        GUIshowKeysPressed.Hide()
    }
} 

;close tabs to the right
^!w::{ 
    Input.BlockKeyboard()
    Send("\^l{F6}{AppsKey}{Up}{Enter}")
    Send("+{F6 2}") ;go back to body of page 
    Input.UnBlockKeyboard()
}  

ToolTip "Script enabled!"
SetTimer () => ToolTip(), -2000