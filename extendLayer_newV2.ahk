; [^ = Ctrl] [+ = Shift] [! = Alt] [# = WinK]
#Requires Autohotkey v2.0
#Include ".\library\CountdownGUI_newV2.ahk"
#Include ".\library\library_newV2.ahk"
#Include ".\library\Monitor_newV2.ahk"
#Include ".\library\LayerIndicatorController_newV2.ahk"

;---------------------- OPTIMIZATIONS ------------------
; 
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

; todo; In the future, possible to add a button which opens a gui user interface where values can be changed, for 
; example, the step to go when changing red, green, blue gamma values, and so on, brightness...


; TODO: to make those keyboard overlay classes only one class and more genereal, make then read a file which contains information about how the overlay should look
; for a new row, write something to indicate a new row.

; FIXME; when switching layer, the layer overlay should also swithc...
; FIXME; bug, sometimes gui is shown at the lowest layer (not prioritised to show over all other apps) dont know why, but perhaps has something to do with reduced windows appereance.
; FIXME: bug, when second layer is turned on first, when shift is held down the ovelay is not shown. Fix by showing overlay when shift+Capslock is first pressed and whatever.
; TODO; able to restart a wireless router? check here and search: https://github.com/shajul/Autohotkey/blob/master/Scriplets/Wireless_Router_Restart.ahk

; TODO; should be possible to have gui over taskbar, since screen hider is over the taskbar...
; TODO; powershell is slow. is there an alternative? can it be made faster? can it be used without opening the terminal view at all?
; TODO; timer that counts down until screen turns dark, and for computer goes to sleep.

; Add some tooltip or something which shows when script is aunced

; TODO; have a timer show up when screen is about to go to sleep? probably worthless since it dimmens before turning off.

; TODO: create a class called keyboard registry or something, connect keyboard class to keyboard overlay class also.
; TODO; auto search for the copied text shortcut. (first layer obvs)

; TODO: in lib.ahk, there are two very similiar classes, use inheritance or whatever, take arguments, do something to reuse code, ugly now

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

; -----------Keyboard layers---------

GUIPrivacyBox := Gui()
GUIPrivacyBox.Opt("-Caption +AlwaysOnTop +Owner +LastFound")
GUIPrivacyBox.BackColor := "Black"

FirstKeyboardOverlayInstance := FirstKeyboardOverlay()
FirstKeyboardOverlayInstance.CreateKeyboardOverlay()

SecondKeyboardOverlayInstance := SecondKeyboardOverlay()
SecondKeyboardOverlayInstance.CreateKeyboardOverlay()

; screenSleepCountdown := new ClockDisplay(3,0)
; storedSecond := A_Sec
; countdownCanceled := false

; ----------------------------------

layers := LayerIndicatorController()
layers.addLayerIndicator(1, "Green")
layers.addLayerIndicator(2, "Red")

MonitorInstance := Monitor()

; ----Ensures consistency------

SetCapsLockState("off")

; --------------


GUICountdown := CountdownGUI(3,3)
; GUICountdown.createGui()

#HotIf GetKeyState("CapsLock","T") && layers.getActiveLayer() == 1

    ~Shift::{ 
        FirstKeyboardOverlayInstance.ShowGui()
        KeyWait("Shift")
    return
    } 

    Shift up::{ 
        SecondKeyboardOverlayInstance.HideGui()
        FirstKeyboardOverlayInstance.HideGui()
    return
    } 
    ; Go to study plan (from current week to end of first semester currently)
    +1::{ 
        Run("chrome.exe `"https://tp.educloud.no/ntnu/timeplan/?id[]=38726&type=student&weekTo=52&ar=2023&`"")
    Return
    } 

    ; Go to blackboard
    +2::{ 
        Run("chrome.exe `"https://ntnu.blackboard.com/ultra/course`"")
        Sleep(4000)
    Return
    }

    ; Go to programming 1
    +3::{ 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_39969_1/cl/outline")
    Return
    } 

    ; Go to team class
    +4::{ 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_39995_1/cl/outline")
    Return
    } 

    ; Go to Math
    +5::{ 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_44996_1/cl/outline")
    Return
    } 
    
    ; Go to programming and numeric safety stuff...
    +6::{ 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_43055_1/cl/outline")
    Return
    } 

    ; Go to jupyterhub
    +7::{ 
        Run("chrome.exe `"https://inga1002.apps.stack.it.ntnu.no/user/adriangb/lab`"")
        Sleep(2000)
        LoginToJupyterHub()
    Return
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
    
    ; Shows second keyboard overlay
    ~Shift::{ 
        SecondKeyboardOverlayInstance.ShowGui()
        KeyWait("Shift")
    return
    } 
    ; Hides second keyboard overlay (and first just in case)
    Shift up::{ 
        FirstKeyboardOverlayInstance.HideGui()
        SecondKeyboardOverlayInstance.HideGui()
    return
    } 
    ; Toggles touch-screen
    +1::{ 
        SecondKeyboardOverlayInstance.ChangeState("Touch-Screen")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-touch-screen.exe")
    Return
    } 
    ; Toggles camera
    +2::{ 
        SecondKeyboardOverlayInstance.ChangeState("Camera")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-hd-camera.exe")
    Return
    } 
    ; Toggles bluetooth
    +3::{ 
        SecondKeyboardOverlayInstance.ChangeState("Bluetooth")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-bluetooth.exe")
    Return
    } 
    ; Toggles touchpad
    +4::{ 
        SecondKeyboardOverlayInstance.ChangeState("Touchpad")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-touchpad.exe")
    Return
    } 
    ; Hides screen
    a:: {
        GUIPrivacyBox.Show("x0 y0 w" . A_ScreenWidth . " h" . A_ScreenHeight . " NoActivate")
        GUICountdown.setCountdown(3,3)
        GUICountdown.createGui()
        GUICountdown.showGui()
        GUICountdown.startCountdown()
    Return
    }

    ; Hides window
    s::{
        GUICountdown.stopCountdown()
        GUICountdown.destroyGui()
        WinGetPos(&X, &Y, &Width, &Height, "A")
        guiWidth := Width*0.7
        guiHeight := Height*0.7
        GUIPrivacyBox.Show("x" . X . " y" . Y . " w" . guiWidth . " h" . guiHeight . " NoActivate")
    Return
    }
    ; Hides tabs
    d:: {
        GUICountdown.stopCountdown()
        GUICountdown.destroyGui()
        Title := WinGetTitle("A")
        If (InStr(Title, "Google Chrome") || InStr(Title, "Mozilla Firefox") || InStr(Title, "Edge")){
            WinGetPos(&X, &Y, &Width, &Height, "A")
            guiWidth := Width*0.55
            GUIPrivacyBox.Show("x" . X . " y" . Y . " w" . guiWidth . " h40 NoActivate")
        }

        Else If (InStr(Title, "Visual Studio")){
            WinGetPos(&X, &Y, &Width, &Height, "A")
            guiX := (X*1)+60
            guiY := (Y*1)+45
            guiWidth := Width*0.66
            GUIPrivacyBox.Show("x" . guiX . " y" . guiY . " w" . guiWidth . " h40 NoActivate")
        }
    Return
    }

    ; Hides GUI
    f:: {
        GUIPrivacyBox.Hide()
        GUICountdown.stopCountdown()
        GUICountdown.destroyGui()
    Return
    }

    ; Blocks input from keyboard and mouse, can be deactivated using pipe (|)
    ; FIXME does not work
    q:: {
        BlockInput("On")
        BlockInput("MouseMove")
        Suspend(true)
    Return
    }

    ; If input is blocked (q has been pressed while in second layer), it can be enabled again.
    $|::{
        #SuspendExempt
        BlockInput("Off")
        BlockInput("MouseMoveOff")
        Suspend(false)
    Return
    } 

    ; Switches power saver on, or off(wont turn off if battery is 50% or lower)
    p::{
        ; Turns on power saver by setting it to turn on when under 100% charge
        ; Run, powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 100
        ; Returns power saver settings to default (at <= 50%)
        ; Run, powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 50
    }

    ; Switches brightness to 100 or 50
    u::{ 
        brightness := MonitorInstance.GetCurrentBrightness()
        if (brightness == 100){
            MonitorInstance.SetBrightness(50)
        }
        else{
            MonitorInstance.SetBrightness(100)
        }
    Return
    } 
    ; Switches brightness to 0 or 50
    j::{ 
        brightness := MonitorInstance.GetCurrentBrightness()
        if (brightness == 0){
            MonitorInstance.SetBrightness(50)
        }
        else{
            MonitorInstance.SetBrightness(0)
        }
    Return
    } 
    ; Switches gamma values (r, g, b) to 0,0,0 or 128,128,128
    i::{ 
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp[1]
        green := gammaRamp[2]
        blue := gammaRamp[3]

        if ( (red + green + blue) == 0 ){
            MonitorInstance.SetGamma(128, 128, 128)
        }
        else{
            MonitorInstance.SetGamma(0, 0, 0)
        }
    Return 
    } 
    ; Switches gamma values (r, g, b) to 256,256,256 or 128,128,128
    o::{ 
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp[1]
        green := gammaRamp[2]
        blue := gammaRamp[3]

        if ( (red + green + blue) < 255*3 ){
            MonitorInstance.SetGamma(255, 255, 255) 
        }
        else{
            MonitorInstance.SetGamma(128, 128, 128)
        }
    Return
    } 

    k::{ 
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp.Get(1)
        red := CycleValue(red, 127, 255)
        green := gammaRamp.Get(2)
        blue := gammaRamp.Get(3)

        MonitorInstance.SetGamma(red, green, blue)
    Return
    } 

    l::{ 
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp.Get(1)
        green := gammaRamp.Get(2)
        green := CycleValue(green, 127, 255)
        blue := gammaRamp.Get(3)

        MonitorInstance.SetGamma(red, green, blue)
    Return
    } 
    
    ø::{ 
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp.Get(1)
        green := gammaRamp.Get(2)
        blue := gammaRamp.Get(3)
        blue := CycleValue(blue, 127, 255)

        MonitorInstance.SetGamma(red, green, blue)
    Return
    }

    Esc::    ExitApp()

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
Return
} 

+CapsLock:: { 
    activeLayer := layers.getActiveLayer()
    
    if (activeLayer == 0){
        layers.setCurrentLayerIndicator(2)
        layers.showLayerIndicator(2)
        SetCapsLockState("on")
    }
    else{
        layers.cycleExtraLayerIndicators()
        layers.showLayerIndicator(layers.getActiveLayer())
        layers.hideInactiveLayers()
    }
Return
} 

; FIXME does not always work
 ;close tabs to the right
^!w::{ 
    Sleep(500)
    Send("+{F6}")
    ; Send("{F6}")
    Send("{AppsKey}")
    Send("{Up}")
    Send("{Enter}")
    ; Send("\^l{F6}{AppsKey}{Up}{Enter}")
    ; Send("+{F6 2}") ;go back to body of page 
Return
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
Return 
} 


